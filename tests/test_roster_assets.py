"""Standard-library tests for deterministic original mesh/rig export."""
import importlib.util
import json
from pathlib import Path
import struct
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("roster", ROOT / "tools/build_roster.py")
roster = importlib.util.module_from_spec(spec)
spec.loader.exec_module(roster)


class RosterAssets(unittest.TestCase):
    def test_all_profiles_have_normalized_region_safe_weights(self):
        for key, profile in roster.PROFILES.items():
            with self.subTest(character=key):
                asset = roster.Asset(key, profile)
                asset.mesh()
                asset.validate()
                self.assertEqual(len(asset.joint_names), 42)
                self.assertGreater(len(asset.regions["torso"]), 100)
                # The previous x-based classifier incorrectly assigned waist to arm.
                for height in [.9, 1.08, 1.25, 1.4]:
                    joints, weights = asset.torso_w(height)
                    for joint, weight in zip(joints, weights):
                        if weight > 0:
                            self.assertIn(asset.joint_names[joint], ["Hips", "Spine", "Chest"])

    def test_model_quality_v3_has_dense_deformation_and_detail_regions(self):\n        signatures = set()\n        for key, profile in roster.PROFILES.items():\n            with self.subTest(character=key):\n                asset = roster.Asset(key, profile)\n                asset.mesh()\n                vertices = sum(len(part["v"]) for part in asset.parts.values())\n                triangles = sum(len(part["i"]) // 3 for part in asset.parts.values())\n                self.assertGreater(vertices, 3500)\n                self.assertGreater(triangles, 6000)\n                self.assertGreater(len(asset.regions.get("head", [])), 400)\n                self.assertGreater(len(asset.regions.get("hand", [])), 70)\n                self.assertGreater(len(asset.regions.get("finger", [])), 250)\n                self.assertGreater(len(asset.regions.get("torso", [])), 500)\n                # Silhouette signature catches accidental one-body reskins.\n                signatures.add((round(profile["width"],3),round(profile["depth"],3),round(profile["face"],3),profile["hair"]))\n        self.assertEqual(len(signatures), len(roster.PROFILES))\n\n    def test_exports_are_deterministic_and_complete(self):
        with tempfile.TemporaryDirectory() as directory:
            p1 = Path(directory) / "first.glb"
            p2 = Path(directory) / "second.glb"
            for path in (p1, p2):
                roster.Asset("cyraxx", roster.PROFILES["cyraxx"]).save(path)
            self.assertEqual(p1.read_bytes(), p2.read_bytes())
            content = p1.read_bytes()
            magic, version, size = struct.unpack_from("<4sII", content)
            self.assertEqual((magic, version, size), (b"glTF", 2, len(content)))
            length, kind = struct.unpack_from("<I4s", content, 12)
            self.assertEqual(kind, b"JSON")
            document = json.loads(content[20:20+length])
            self.assertEqual(len(document["animations"]), 25)
            for animation in document["animations"]:
                self.assertEqual(len(animation["channels"]), 42 * 2)
                targets = {(c["target"]["node"], c["target"]["path"]) for c in animation["channels"]}
                self.assertEqual(len(targets), 84)
            self.assertTrue(all("TEXCOORD_0" in p["attributes"] for p in document["meshes"][0]["primitives"]))
            self.assertEqual(len(document["images"]), 4)

    def test_committed_assets_match_manifest(self):
        import hashlib
        manifest = json.loads((ROOT / "assets/models/roster_manifest.json").read_text())
        self.assertEqual(len(manifest["entries"]), 9)
        checksums = set()
        for entry in manifest["entries"]:
            digest = hashlib.sha256((ROOT / "assets/models" / entry["file"]).read_bytes()).hexdigest()
            self.assertEqual(digest, entry["sha256"])
            checksums.add(digest)
        self.assertEqual(len(checksums), 9)


if __name__ == "__main__":
    unittest.main(verbosity=2)
