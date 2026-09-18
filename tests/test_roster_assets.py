"""Standard-library tests for deterministic meshes, palette conversion and rig safety."""
import hashlib
import importlib.util
import json
import math
from pathlib import Path
import struct
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
spec = importlib.util.spec_from_file_location("roster", ROOT / "tools/build_roster.py")
roster = importlib.util.module_from_spec(spec)
spec.loader.exec_module(roster)


class RosterAssets(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.assets = {}
        for key, profile in roster.PROFILES.items():
            asset = roster.Asset(key, profile)
            asset.mesh()
            cls.assets[key] = asset

    def test_all_profiles_have_normalized_region_safe_weights(self):
        for key, asset in self.assets.items():
            with self.subTest(character=key):
                asset.validate()
                self.assertEqual(len(asset.joint_names), 46)
                for height in [.9, 1.08, 1.25, 1.4]:
                    joints, weights = asset.torso_w(height)
                    for joint, weight in zip(joints, weights):
                        if weight > 0:
                            self.assertIn(asset.joint_names[joint], ["Hips", "Spine", "Chest"])

    def test_actual_geometry_has_detailed_regions_and_unique_silhouettes(self):
        signatures = set()
        for key, asset in self.assets.items():
            with self.subTest(character=key):
                # Floors detect accidentally reverting to the previous primitive
                # mesh, not visual quality. Test coordinates, not profile labels.
                for region, minimum in [("head",2000),("hand",300),("finger",1000),
                                         ("torso",700),("eyelid",500),("shoulder",300)]:
                    self.assertGreater(len(asset.regions.get(region, [])), minimum)
                torso = [asset.parts[m]["v"][i] for m,i in asset.regions["torso"]]
                signatures.add(tuple(round(max(v[k] for v in torso)-min(v[k] for v in torso),5) for k in (0,2)))
                for part in asset.parts.values():
                    self.assertEqual(len(part["n"]),len(part["v"]))
                    self.assertTrue(all(all(math.isfinite(c) for c in normal) for normal in part["n"]))
                    self.assertTrue(all(abs(sum(c*c for c in normal)-1)<1e-5 for normal in part["n"]))
        self.assertEqual(len(signatures),len(roster.PROFILES))

    def test_fingers_span_palm_width_and_thumb_is_medial(self):
        for key,asset in self.assets.items():
            with self.subTest(character=key):
                for side,sign in [("L",1),("R",-1)]:
                    pts=[asset.world[f"Finger{j}.{side}"] for j in range(4)]
                    self.assertGreater(max(v[0] for v in pts)-min(v[0] for v in pts),.07*asset.scale)
                    self.assertLess(max(v[2] for v in pts)-min(v[2] for v in pts),.005*asset.scale)
                    thumb=asset.world[f"Finger4.{side}"]
                    hand=asset.world[f"Hand.{side}"]
                    self.assertLess(sign*(thumb[0]-hand[0]),0)

    def test_gameplay_and_contact_landmarks_are_unchanged(self):
        for key,asset in self.assets.items():
            with self.subTest(character=key):
                w=asset.p["width"]
                expected={"Root":(0,0,0),"Hips":(0,.89,0),"Chest":(0,1.35,0),
                          "Head":(0,1.56,0),"UpperArm.L":(w+.055,1.39,0),
                          "Forearm.L":(w+.055,1.10,0),"Hand.L":(w+.055,.85,0),
                          "Foot.L":(w*.47,.115,0)}
                for name,point in expected.items():
                    self.assertEqual(asset.world[name],tuple(c*asset.scale for c in point))
                self.assertEqual(roster.DURATIONS["getup"],.60)
                self.assertEqual(roster.DURATIONS["throw_attacker"],1.10)

    def test_palette_factors_are_linear_but_embedded_textures_remain_srgb(self):
        self.assertAlmostEqual(roster.linear_color(.5),.21404114048,places=8)
        for key,asset in self.assets.items():
            skin=asset.doc["materials"][asset.mat["skin"]]["pbrMetallicRoughness"]
            self.assertEqual(skin["baseColorFactor"][:3],[roster.linear_color(c) for c in asset.p["skin"]])
            gear=asset.doc["materials"][asset.mat["gear"]]["pbrMetallicRoughness"]
            self.assertEqual(gear["baseColorFactor"],[1,1,1,1])
            self.assertIn("baseColorTexture",gear)

    def test_helpers_preserve_core_chains_and_own_knee_pads(self):
        for key, asset in self.assets.items():
            with self.subTest(character=key):
                self.assertEqual(list(asset.bones)[-4:], list(roster.DEFORM_JOINTS))
                for helper, driver in roster.DEFORM_JOINTS.items():
                    self.assertEqual(asset.parents[helper], asset.parents[driver])
                    self.assertEqual(asset.world[helper], asset.world[driver])
                for name, parent in [("Forearm.L","UpperArm.L"),("Hand.L","Forearm.L"),
                                     ("Shin.R","Thigh.R"),("Foot.R","Shin.R")]:
                    self.assertEqual(asset.parents[name],parent)
                for region in ["kneepad","pad_insert"]:
                    for material, index in asset.regions[region]:
                        part=asset.parts[material]
                        for bone,weight in zip(part["j"][index],part["w"][index]):
                            if weight>0:self.assertTrue(asset.joint_names[bone].startswith("DeformKnee."))

    def test_exports_are_deterministic_and_complete(self):
        with tempfile.TemporaryDirectory() as directory:
            p1,p2=Path(directory)/"first.glb",Path(directory)/"second.glb"
            for path in (p1,p2):
                roster.Asset("cyraxx",roster.PROFILES["cyraxx"]).save(path)
            self.assertEqual(p1.read_bytes(),p2.read_bytes())
            content=p1.read_bytes()
            self.assertEqual(struct.unpack_from("<4sII",content),(b"glTF",2,len(content)))
            length,kind=struct.unpack_from("<I4s",content,12)
            self.assertEqual(kind,b"JSON")
            document=json.loads(content[20:20+length])
            self.assertEqual(document["extras"]["schema_version"],4)
            self.assertEqual(len(document["animations"]),25)
            for animation in document["animations"]:
                targets={(c["target"]["node"],c["target"]["path"]) for c in animation["channels"]}
                self.assertEqual(len(targets),92)
                self.assertEqual(len(animation["channels"]),92)
            self.assertTrue(all("TEXCOORD_0" in p["attributes"] for p in document["meshes"][0]["primitives"]))
            self.assertEqual(len(document["images"]),10)
            self.assertTrue(document["extras"]["geometry_regions"]["eyelid"]>500)

    def test_reference_status_and_original_embedded_textures(self):
        from likeness_profiles import STUDIES
        source_count=0
        for key,asset in self.assets.items():
            status=STUDIES[key]['status']
            with self.subTest(character=key):
                if status=='source_attributed_study':
                    source_count+=1
                    self.assertTrue(STUDIES[key]['sources'])
                    self.assertIn('portrait_skin',asset.mat)
                    self.assertEqual(len(asset.doc['images']),8 if STUDIES[key]['hair']=='close_bald' else 10)
                    portrait=asset.doc['materials'][asset.mat['portrait_skin']]['pbrMetallicRoughness']
                    self.assertIn('baseColorTexture',portrait)
                    if STUDIES[key]['glasses']!='none':self.assertIn('glasses_frame',asset.regions)
                    if STUDIES[key]['hair']=='close_bald':self.assertNotIn('hair_cap',asset.regions)
                    if key=='cyraxx':self.assertNotIn('hat',asset.regions)
                else:
                    self.assertEqual(status,'needs_unambiguous_reference')
                    self.assertEqual(STUDIES[key]['sources'],[])
                    self.assertNotIn('portrait_skin',asset.mat)
                    self.assertEqual(len(asset.doc['images']),4)
                # Images are procedurally generated buffer data, never runtime URLs.
                for image in asset.doc['images']:
                    self.assertIn('bufferView',image)
                    self.assertNotIn('uri',image)
                for primitive in asset.doc['meshes'][0]['primitives']:
                    colors=asset.doc['accessors'][primitive['attributes']['COLOR_0']]
                    vertices=asset.doc['accessors'][primitive['attributes']['POSITION']]
                    self.assertEqual(colors['count'],vertices['count'])
                if key=='referee_cobra':self.assertEqual(len(asset.regions['halo']),717)
                else:self.assertNotIn('halo',asset.regions)
        self.assertEqual(source_count,9)

    def test_portrait_maps_and_tangent_frames(self):
        for key,asset in self.assets.items():
            with self.subTest(character=key):
                face=asset.doc['materials'][asset.mat['portrait_skin']]
                self.assertIn('normalTexture',face)
                self.assertIn('metallicRoughnessTexture',face['pbrMetallicRoughness'])
                self.assertIn('portrait_eye',asset.mat)
                for primitive,(material,part) in zip(asset.doc['meshes'][0]['primitives'],asset.parts.items()):
                    if 'normalTexture' not in asset.doc['materials'][material]:continue
                    self.assertIn('TANGENT',primitive['attributes'])
                    self.assertEqual(len(part['tangent']),len(part['v']))
                    for n,t in zip(part['n'],part['tangent']):
                        self.assertTrue(all(math.isfinite(c) for c in t))
                        self.assertAlmostEqual(sum(c*c for c in t[:3]),1.,places=5)
                        self.assertAlmostEqual(sum(x*y for x,y in zip(n,t[:3])),0.,places=5)
                        self.assertIn(t[3],[-1.,1.])
        # Every portrait remains a locally authored study, not runtime network IO.
        self.assertNotIn('urlopen',(ROOT/'tools/portrait_geometry.py').read_text())
        self.assertNotIn('urlopen',(ROOT/'tools/portrait_materials.py').read_text())

    def test_built_assets_match_manifest(self):
        manifest=json.loads((ROOT/"assets/models/roster_manifest.json").read_text())
        self.assertEqual(len(manifest["entries"]),9)
        checksums=set()
        for entry in manifest["entries"]:
            digest=hashlib.sha256((ROOT/"assets/models"/entry["file"]).read_bytes()).hexdigest()
            self.assertEqual(digest,entry["sha256"])
            checksums.add(digest)
        self.assertEqual(len(checksums),9)


if __name__=="__main__":
    unittest.main(verbosity=2)
