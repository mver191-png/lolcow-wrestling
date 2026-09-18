#!/usr/bin/env python3
"""Compile the integrated v3.1 roster with bend-preserving skin helpers.

roster_base.py retains the preceding v3 writer, base poses and palette. This
specialization adds four non-chain skin joints and refines only bend topology;
existing facial, hair, outfit, input and gameplay contracts stay unchanged.
Use roster_base.py separately to build the exact preceding art for A/B inspection.
"""
from __future__ import annotations
import argparse
import hashlib
import json
import math
import struct
from pathlib import Path
from roster_base import Asset as BaseAsset, PROFILES, DURATIONS, LOOPS
from roster_base import add, mul, smooth, quat, linear_color
from character_geometry import COSTUMES, _refine_sections

ROOT = Path(__file__).resolve().parents[1]
DEFORM_JOINTS = {"DeformElbow.L": "Forearm.L", "DeformElbow.R": "Forearm.R",
                 "DeformKnee.L": "Shin.L", "DeformKnee.R": "Shin.R"}

class Asset(BaseAsset):
    def __init__(self,key,profile):
        super().__init__(key,profile)
        self.doc["asset"]["generator"] = "Offline Mayhem model-quality compiler 3.1"

    def setup_rig(self):
        super().setup_rig()
        # Original 42 indices and IK parents remain unchanged. Helpers are
        # appended siblings of the lower limb, coincident with the actual joint.
        for helper, driver in DEFORM_JOINTS.items():
            self.bone(helper,self.parents[driver],mul(self.world[driver],1/self.scale))
            # Sibling bind data must coincide exactly; avoid a second scale
            # round-trip leaving tiny, platform-dependent differences.
            self.world[helper]=self.world[driver]
            self.doc["nodes"][self.bones[helper]]["translation"]=list(
                self.doc["nodes"][self.bones[driver]]["translation"])
        self.joint_names=list(self.bones)
        self.joint_index={name:i for i,name in enumerate(self.joint_names)}

    def loft(self,rings,material,weight,region,segments=24):
        if region in ("arm","leg"):
            rows=list(rings)
            if region=="arm":
                # Explicit crease ring, not a polycount-only subdivision.
                center=rows[0][0]
                rows.append(((center[0],1.10,center[2]),self.p["arm"]*.8074,self.p["arm"]*.8074*.90))
                rows.sort(key=lambda row:row[0][1])
            x,z=rows[0][0][0],rows[0][0][2]
            profile=[(c[1],rx,rz) for c,rx,rz in rows]
            rings=[((x,y,z),rx,rz) for y,rx,rz in _refine_sections(profile,3)]
        super().loft(rings,material,weight,region,segments)

    def ellipsoid(self,center,radii,material,bone,region="detail",segments=16,rings=10):
        if region in ("kneepad","pad_insert"):
            # Knee protection follows the bend center, not the full shin swing.
            side=bone.rsplit(".",1)[-1]
            front=.77 if region=="kneepad" else .94
            center=(center[0],.510,-self.p["leg"]*front)
            bone="DeformKnee."+side
        super().ellipsoid(center,radii,material,bone,region,segments,rings)

    def limb_w(self,side,y,arm):
        """Region-aware bend weights; joint ring follows a half-angle helper.

        At the crease, a single rigid helper avoids the LBS averaging that
        flattens an elbow. Adjacent rings taper back to the limb bones. Driver
        joints are siblings of the original lower bones, not changes to IK chains.
        """
        a,b,c=("UpperArm","Forearm","Hand") if arm else ("Thigh","Shin","Foot")
        joint,end=(1.10,.85) if arm else (.51,.115)
        helper=("DeformElbow." if arm else "DeformKnee.")+side
        extent=.095 if arm else .100
        if abs(y-joint)<=extent:
            blend=smooth(abs(y-joint)/extent)
            return self.weights(helper,(a if y>=joint else b)+"."+side,blend)
        if y>joint:return self.weights(a+"."+side)
        if y>end+.07:return self.weights(b+"."+side)
        return self.weights(b+"."+side,c+"."+side,smooth((end+.07-y)/.14))

    @staticmethod
    def rotation_sample(pose, bone):
        driver=DEFORM_JOINTS.get(bone)
        if not driver:return quat(*pose[0][bone])
        q=quat(*pose[0][driver])
        if q[3]<0:q=tuple(-v for v in q)
        half=(q[0],q[1],q[2],q[3]+1.)
        length=math.sqrt(sum(v*v for v in half))
        return tuple(v/length for v in half)

    def animations(self):
        for name,duration in DURATIONS.items():
            count=max(2,math.ceil(duration*30)+1); times=[duration*i/(count-1) for i in range(count)]
            poses=[self.pose(name,t,duration) for t in times]
            full_time=self.accessor(times,"SCALAR"); short_time=self.accessor([0.,duration],"SCALAR"); channels=[]; samplers=[]
            for bone in self.joint_names:
                rest=self.doc["nodes"][self.bones[bone]]["translation"]
                tracks=[("rotation","VEC4",[self.rotation_sample(pose, bone) for pose in poses]),("translation","VEC3",[add(rest,mul(pose[1][bone],self.scale)) for pose in poses])]
                for path,kind,values in tracks:
                    constant=all(all(abs(x-y)<1e-8 for x,y in zip(v,values[0])) for v in values)
                    output=self.accessor([values[0],values[-1]] if constant else values,kind)
                    samplers.append({"input":short_time if constant else full_time,"output":output,"interpolation":"LINEAR"})
                    channels.append({"sampler":len(samplers)-1,"target":{"node":self.bones[bone],"path":path}})
            self.doc["animations"].append({"name":name,"channels":channels,"samplers":samplers,"extras":{"loop":name in LOOPS,"impact_time":.60 if name.startswith("throw") else .13 if name=="strike" else None}})

    def validate(self):
        if len(self.bones)!=46 or any(n not in self.bones for n in DEFORM_JOINTS): raise ValueError("Invalid humanoid hierarchy")
        for part in self.parts.values():
            if not len(part["v"])==len(part["j"])==len(part["w"]): raise ValueError("Mismatched skin arrays")
            if not all(abs(sum(w)-1)<1e-6 and all(x>=0 for x in w) for w in part["w"]): raise ValueError("Unnormalized weights")
            if not all(all(math.isfinite(x) for x in v) for v in part["v"]): raise ValueError("Nonfinite vertices")
            if max(part["i"])>=len(part["v"]): raise ValueError("Invalid triangle index")
        forbidden={i for name,i in self.joint_index.items() if any(s in name for s in ["Arm","Hand","Finger","Clavicle"])}
        for material,index in self.regions["torso"]:
            part=self.parts[material]
            if not all(j not in forbidden or w<1e-6 for j,w in zip(part["j"][index],part["w"][index])): raise ValueError("Torso weights contaminated by arm bones")

    def save(self,path):
        self.mesh(); self.animations(); self.validate()
        self.doc["buffers"]=[{"byteLength":len(self.buf)}]
        self.doc["extras"]={"schema_version":4,"core_bones":42,"deformation_helpers":DEFORM_JOINTS,"character":self.key,"style":"original stylized ring interpretation","authoring_forward":"-Z","walk_speed":1.5*self.scale,"run_speed":4.2*self.scale,"rig_bones":len(self.bones),"grip_support":"runtime paired contact; skin intersection not certified", "costume":COSTUMES[self.key][0], "geometry_regions":{n:len(v) for n,v in self.regions.items()}}
        js=json.dumps(self.doc,separators=(",",":")).encode(); js+=b" "*((-len(js))%4)
        binary=bytes(self.buf); binary+=b"\0"*((-len(binary))%4)
        data=struct.pack("<4sII",b"glTF",2,28+len(js)+len(binary))+struct.pack("<I4s",len(js),b"JSON")+js+struct.pack("<I4s",len(binary),b"BIN\0")+binary
        path.parent.mkdir(parents=True,exist_ok=True); path.write_bytes(data)
        return {"file":path.name,"sha256":hashlib.sha256(data).hexdigest(),"bones":len(self.bones),"clips":len(self.doc["animations"]),"vertices":sum(len(p["v"]) for p in self.parts.values()),"triangles":sum(len(p["i"])//3 for p in self.parts.values()),"bytes":len(data),"visual_acceptance":"v3.1 integrated deformation; see docs/INTEGRATED_DEFORMATION.md"}

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--character",choices=PROFILES)
    parser.add_argument("--output",type=Path,default=ROOT/"assets/models")
    args=parser.parse_args()
    args.output.mkdir(parents=True,exist_ok=True)
    manifest_path=args.output/"roster_manifest.json"
    previous=json.loads(manifest_path.read_text()).get("entries",[]) if args.character and manifest_path.exists() else []
    results={entry["file"]:entry for entry in previous}
    for key in ([args.character] if args.character else PROFILES):
        result=Asset(key,PROFILES[key]).save(args.output/(key+".glb")); results[result["file"]]=result
        print(key,result["triangles"],"triangles",result["bones"],"bones",result["clips"],"clips")
    manifest_path.write_text(json.dumps({"generator":"tools/build_roster.py","original_assets":True,"entries":[results[key] for key in sorted(results)]},indent=2)+"\n")

if __name__=="__main__": main()
