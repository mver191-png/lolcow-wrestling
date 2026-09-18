#!/usr/bin/env python3
"""Compile original, region-weighted wrestling characters to self-contained glTF.

Python standard library only. Units are metres, Y up, -Z forward. The generated
GLBs can be edited in Blender. Anatomical regions, not global X thresholds, own
weights. Every animation samples every bone so poses cannot inherit stale tracks.
These are stylized fictional ring interpretations, not verified likeness scans.\nModel-quality v3 increases deformation topology and adds character-specific gear geometry while preserving the gameplay rig.
"""
from __future__ import annotations
import argparse
import hashlib
import json
import math
import struct
import zlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROFILES = {
    "tophiachu": dict(h=1.72, width=.43, depth=.31, arm=.135, leg=.175, skin=(.54,.34,.24), gear=(.32,.12,.48), trim=(.88,.61,.25), hair="curls", hair_color=(.09,.045,.025), face=1.12, role="heavy"),
    "cyraxx": dict(h=1.57, width=.26, depth=.18, arm=.086, leg=.108, skin=(.68,.48,.34), gear=(.14,.29,.22), trim=(.85,.78,.60), hair="beanie", hair_color=(.05,.043,.04), face=.86, role="light"),
    "novaonline": dict(h=1.86, width=.42, depth=.30, arm=.14, leg=.18, skin=(.74,.54,.41), gear=(.48,.075,.075), trim=(.88,.65,.22), hair="short", hair_color=(.16,.085,.04), face=1.10, role="heavy"),
    "candy_rooks": dict(h=1.68, width=.40, depth=.285, arm=.126, leg=.166, skin=(.76,.55,.42), gear=(.57,.22,.37), trim=(.91,.82,.70), hair="bun", hair_color=(.26,.13,.055), face=1.06, role="heavy"),
    "andy_ditch": dict(h=1.74, width=.445, depth=.32, arm=.142, leg=.18, skin=(.78,.57,.44), gear=(.15,.24,.41), trim=(.69,.73,.79), hair="short", hair_color=(.30,.18,.10), face=1.12, role="heavy"),
    "jupiter_the_hybrid": dict(h=1.80, width=.32, depth=.22, arm=.105, leg=.132, skin=(.67,.46,.33), gear=(.20,.10,.33), trim=(.70,.73,.81), hair="long", hair_color=(.065,.045,.07), face=.96, role="balanced"),
    "anacondasin": dict(h=1.67, width=.35, depth=.245, arm=.108, leg=.14, skin=(.65,.44,.31), gear=(.10,.31,.22), trim=(.78,.64,.22), hair="long", hair_color=(.08,.055,.035), face=1.0, role="balanced"),
    "daniel_larson": dict(h=1.80, width=.265, depth=.19, arm=.087, leg=.11, skin=(.74,.52,.38), gear=(.68,.28,.055), trim=(.21,.25,.30), hair="short", hair_color=(.30,.18,.085), face=.90, role="light"),
    "referee_cobra": dict(h=1.80, width=.30, depth=.21, arm=.102, leg=.13, skin=(.64,.44,.31), gear=(.78,.80,.79), trim=(.065,.07,.075), hair="long", hair_color=(.07,.035,.02), face=.94, role="referee"),
}
DURATIONS = {"idle":1.2, "walk":.9, "run":.6, "strike":.45, "knockdown":.6, "downed":1., "getup":.6, "block":.35, "reversal":.35, "grapple":.18, "throw_attacker":1.1, "throw_defender":1.1, "throw_leverage_attacker":1.1, "throw_leverage_defender":1.1, "pinning":1., "pinned":1., "submission_attacker":1., "submission_defender":1., "victory":1.5, "defeated":1., "hit_light":.22, "hit_heavy":.32, "kickout":.35, "ref_count":1.1, "ref_wave":.7}
LOOPS = {"idle", "walk", "run", "downed", "pinned", "submission_attacker", "submission_defender"}

def add(a, b): return tuple(x+y for x,y in zip(a,b))
def sub(a, b): return tuple(x-y for x,y in zip(a,b))
def mul(a, s): return tuple(x*s for x in a)
def dot(a, b): return sum(x*y for x,y in zip(a,b))
def cross(a, b): return (a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0])
def norm(v):
    d = math.sqrt(dot(v,v))
    return mul(v,1/d) if d>1e-9 else (0,1,0)
def smooth(t):
    t = max(0.,min(1.,t))
    return t*t*(3-2*t)
def quat(x=0.,y=0.,z=0.):
    cx,sx=math.cos(x/2),math.sin(x/2); cy,sy=math.cos(y/2),math.sin(y/2); cz,sz=math.cos(z/2),math.sin(z/2)
    return (sx*cy*cz-cx*sy*sz,cx*sy*cz+sx*cy*sz,cx*cy*sz-sx*sy*cz,cx*cy*cz+sx*sy*sz)
def png(width, height, pixels):
    def chunk(kind, data):
        return struct.pack(">I",len(data))+kind+data+struct.pack(">I",zlib.crc32(kind+data)&0xffffffff)
    scan=b"".join(b"\0"+bytes(pixels[y*width*3:(y+1)*width*3]) for y in range(height))
    return b"\x89PNG\r\n\x1a\n"+chunk(b"IHDR",struct.pack(">2I5B",width,height,8,2,0,0,0))+chunk(b"IDAT",zlib.compress(scan,9))+chunk(b"IEND",b"")

class Asset:
    def __init__(self,key,profile):
        self.key,self.p=key,profile
        self.scale=profile["h"]/1.8
        self.doc={"asset":{"version":"2.0","generator":"Offline Mayhem model-quality compiler 3.0"},"scene":0,"scenes":[{"nodes":[0]}],"nodes":[{"name":key,"children":[]}],"meshes":[],"materials":[],"bufferViews":[],"accessors":[],"animations":[],"skins":[],"images":[],"textures":[],"samplers":[{"magFilter":9729,"minFilter":9987,"wrapS":10497,"wrapT":10497}]}
        self.buf=bytearray(); self.bones={}; self.world={}; self.parents={}; self.parts={}; self.regions={}
        self.setup_rig(); self.materials()

    def view(self,data,target=None):
        self.buf.extend(b"\0"*((-len(self.buf))%4))
        view={"buffer":0,"byteOffset":len(self.buf),"byteLength":len(data)}
        if target: view["target"]=target
        self.buf.extend(data); self.doc["bufferViews"].append(view)
        return len(self.doc["bufferViews"])-1

    def accessor(self,values,kind="VEC3",component=5126,target=None):
        size={"SCALAR":1,"VEC2":2,"VEC3":3,"VEC4":4,"MAT4":16}[kind]
        flat=values if size==1 else [v for row in values for v in row]
        code={5126:"f",5123:"H",5125:"I"}[component]
        a={"bufferView":self.view(struct.pack("<"+code*len(flat),*flat),target),"componentType":component,"count":len(values),"type":kind}
        if component==5126 and kind in ("VEC3","SCALAR"):
            rows=[(v,) for v in values] if size==1 else values
            a["min"]=[min(r[i] for r in rows) for i in range(size)]
            a["max"]=[max(r[i] for r in rows) for i in range(size)]
        self.doc["accessors"].append(a)
        return len(self.doc["accessors"])-1

    def bone(self,name,parent,pos):
        pos=mul(pos,self.scale); idx=len(self.doc["nodes"])
        self.bones[name]=idx; self.world[name]=pos; self.parents[name]=parent
        self.doc["nodes"].append({"name":name,"translation":list(sub(pos,self.world[parent]) if parent else pos),"children":[]})
        self.doc["nodes"][self.bones[parent] if parent else 0]["children"].append(idx)

    def setup_rig(self):
        width=self.p["width"]; shoulder=width+.055
        for name,parent,pos in [("Root",None,(0,0,0)),("Hips","Root",(0,.89,0)),("Spine","Hips",(0,1.09,0)),("Chest","Spine",(0,1.35,0)),("Neck","Chest",(0,1.48,0)),("Head","Neck",(0,1.56,0))]:
            self.bone(name,parent,pos)
        for side,sign in [("L",1),("R",-1)]:
            for name,parent,pos in [("Clavicle","Chest",(sign*.12,1.40,0)),("UpperArm","Clavicle",(sign*shoulder,1.39,0)),("Forearm","UpperArm",(sign*shoulder,1.10,0)),("Hand","Forearm",(sign*shoulder,.85,0))]:
                self.bone(name+"."+side,parent if parent=="Chest" else parent+"."+side,pos)
            for finger in range(5):
                z=(finger-1.5)*.025; x=sign*shoulder
                if finger==4: x+=sign*.052; z=-.01
                self.bone(f"Finger{finger}.{side}","Hand."+side,(x,.765 if finger<4 else .805,z))
                self.bone(f"Finger{finger}Tip.{side}",f"Finger{finger}.{side}",(x,.715 if finger<4 else .770,z-.003))
            for name,parent,pos in [("Thigh","Hips",(sign*width*.47,.89,0)),("Shin","Thigh",(sign*width*.47,.51,0)),("Foot","Shin",(sign*width*.47,.115,0)),("Toe","Foot",(sign*width*.47,.045,-.19))]:
                self.bone(name+"."+side,parent if parent=="Hips" else parent+"."+side,pos)
        self.joint_names=list(self.bones)
        self.joint_index={name:i for i,name in enumerate(self.joint_names)}

    def weights(self,a,b=None,t=0.):
        if b is None: return [self.joint_index[a],0,0,0],[1.,0.,0.,0.]
        t=max(0.,min(1.,t))
        return [self.joint_index[a],self.joint_index[b],0,0],[1-t,t,0.,0.]

    def torso_w(self,y):
        if y<1.09: return self.weights("Hips","Spine",smooth((y-.88)/.21))
        return self.weights("Spine","Chest",smooth((y-1.09)/.26))

    def limb_w(self,side,y,arm):
        a,b,c=("UpperArm","Forearm","Hand") if arm else ("Thigh","Shin","Foot")
        joint,end=(1.10,.85) if arm else (.51,.115)
        if y>joint+.08: return self.weights(a+"."+side)
        if y>joint-.09: return self.weights(a+"."+side,b+"."+side,smooth((joint+.08-y)/.17))
        if y>end+.07: return self.weights(b+"."+side)
        return self.weights(b+"."+side,c+"."+side,smooth((end+.07-y)/.14))

    def material(self,name,color,rough=.7,texture=False,metal=0.,emission=None):
        m={"name":name,"pbrMetallicRoughness":{"baseColorFactor":[*color,1.],"metallicFactor":metal,"roughnessFactor":rough},"doubleSided":False}
        if texture:
            pixels=[]
            for y in range(96):
                for x in range(96):
                    weave=.94+.035*math.sin(x*math.pi/2)*math.sin(y*math.pi/2)+.018*math.sin(x*12.9898+y*78.233)
                    if self.p["role"]=="referee" and name=="gear": weave*=.10 if (x//12)%2 else 1.
                    pixels.extend(int(max(0,min(255,255*c*weave))) for c in color)
            self.doc["images"].append({"bufferView":self.view(png(96,96,pixels)),"mimeType":"image/png","name":name+"_woven"})
            self.doc["textures"].append({"sampler":0,"source":len(self.doc["images"])-1})
            m["pbrMetallicRoughness"]["baseColorFactor"]=[1,1,1,1]
            m["pbrMetallicRoughness"]["baseColorTexture"]={"index":len(self.doc["textures"])-1}
        if emission: m["emissiveFactor"]=list(emission)
        self.doc["materials"].append(m)
        return len(self.doc["materials"])-1

    def materials(self):
        p=self.p
        self.mat={"skin":self.material("skin",p["skin"],.62),"gear":self.material("gear",p["gear"],.82,True),"trim":self.material("trim",p["trim"],.45,True),"hair":self.material("hair",p["hair_color"],.88),"boots":self.material("boots",(.035,.045,.058),.48,True),"wrap":self.material("wrap",(.80,.79,.72),.9,True),"white":self.material("eyes",(.86,.83,.76),.30),"iris":self.material("iris",(.14,.095,.055),.33),"dark":self.material("pupil",(.009,.012,.014),.36),"mouth":self.material("lips",tuple(c*k for c,k in zip(p["skin"],(.80,.63,.60))),.61),"halo":self.material("halo",(.90,.62,.16),.35,False,.35,(.8,.48,.08))}

    def part(self,material):
        return self.parts.setdefault(self.mat[material],{k:[] for k in ("v","uv","n","j","w","i")})

    def loft(self,rings,material,weight,region,segments=24):
        """Build a UV-seamed loft with explicit region and normalized skin weights."""
        part=self.part(material); start=len(part["v"])
        for ri,(center,rx,rz) in enumerate(rings):
            for j in range(segments+1):
                a=math.tau*j/segments
                point=(center[0]+rx*math.cos(a),center[1],center[2]+rz*math.sin(a))
                bones,weights=weight(point,ri)
                part["v"].append(mul(point,self.scale)); part["uv"].append((j/segments,ri/max(1,len(rings)-1))); part["j"].append(bones); part["w"].append(weights)
        for r in range(len(rings)-1):
            for j in range(segments):
                a=start+r*(segments+1)+j; b=a+segments+1
                part["i"].extend([a,b,b+1,a,b+1,a+1])
        for ri,top in [(0,False),(len(rings)-1,True)]:
            center=rings[ri][0]; bones,weights=weight(center,ri); ci=len(part["v"])
            part["v"].append(mul(center,self.scale)); part["uv"].append((.5,.5)); part["j"].append(bones); part["w"].append(weights)
            for j in range(segments):
                a=start+ri*(segments+1)+j
                part["i"].extend([ci,a+1,a] if top else [ci,a,a+1])
        self.regions.setdefault(region,[]).extend((self.mat[material],i) for i in range(start,len(part["v"])))

    def ellipsoid(self,center,radii,material,bone,region="detail",segments=16,rings=10):
        rows=[]
        for i in range(rings+1):
            angle=-math.pi/2+math.pi*i/rings; scale=max(.015,math.cos(angle))
            rows.append(((center[0],center[1]+radii[1]*math.sin(angle),center[2]),radii[0]*scale,radii[2]*scale))
        self.loft(rows,material,lambda point,i:self.weights(bone),region,segments)

    def mesh(self):
        p=self.p; w=p["width"]; d=p["depth"]; sh=w+.055
        body=[(.80,.78,.83),(.88,.95,.98),(.98,1.04,1.03),(1.10,1.,1.08),(1.22,.95,1.),(1.34,1.03,.98),(1.42,.90,.82),(1.47,.36,.55)]
        self.loft([((0,y,0),w*rx,d*rz) for y,rx,rz in body],"gear",lambda pt,i:self.torso_w(pt[1]),"torso",32)
        for y,rx,rz in [(.86,.94,.99),(1.425,.84,.81)]:
            self.loft([((0,y-.015,0),w*rx+.006,d*rz+.006),((0,y+.015,0),w*rx+.006,d*rz+.006)],"trim",lambda pt,i:self.torso_w(pt[1]),"seam",32)
        self.loft([((0,1.45,0),.115,.105),((0,1.60,0),.105,.105)],"skin",lambda pt,i:self.weights("Neck","Head",smooth((pt[1]-1.49)/.09)),"neck")
        face=p["face"]; head=[(1.535,.095,.105),(1.565,.130,.135),(1.625,.175,.158),(1.68,.183,.165),(1.74,.171,.158),(1.81,.145,.133),(1.85,.075,.070)]
        self.loft([((0,y,-.007),rx*face,rz) for y,rx,rz in head],"skin",lambda pt,i:self.weights("Head"),"head",32)
        for sign in [-1,1]:
            self.ellipsoid((sign*.186*face,1.671,0),(.035,.063,.026),"skin","Head")
            self.ellipsoid((sign*.073*face,1.699,-.147),(.052,.029,.023),"white","Head",segments=18)
            self.ellipsoid((sign*.073*face,1.699,-.167),(.019,.021,.007),"iris","Head")
            self.ellipsoid((sign*.073*face,1.699,-.173),(.009,.013,.004),"dark","Head")
            self.ellipsoid((sign*.073*face-.006,1.707,-.176),(.003,.003,.002),"white","Head",segments=8,rings=6)
            self.ellipsoid((sign*.073*face,1.735,-.147),(.056,.012,.015),"hair","Head")
            self.ellipsoid((sign*.10*face,1.644,-.137),(.056,.036,.025),"skin","Head")
        self.ellipsoid((0,1.681,-.168),(.027,.050,.036),"skin","Head")
        self.ellipsoid((0,1.655,-.188),(.039,.023,.028),"skin","Head")
        self.ellipsoid((0,1.607,-.149),(.063,.013,.014),"mouth","Head")
        self.ellipsoid((0,1.606,-.160),(.052,.003,.003),"dark","Head",rings=6)
        for side,sign in [("L",1),("R",-1)]:
            arm=p["arm"]; leg=p["leg"]; x=sign*sh; lx=sign*w*.47
            self.loft([((x,y,0),arm*r,arm*r*.91) for y,r in [(.84,.62),(.94,.76),(1.07,.77),(1.11,.82),(1.20,1.02),(1.32,1.08),(1.40,.88)]],"skin",lambda pt,i,s=side:self.limb_w(s,pt[1],True),"arm",28)
            self.loft([((x,y,0),arm*.69,arm*.65) for y in [.855,.925]],"wrap",lambda pt,i,s=side:self.limb_w(s,pt[1],True),"wrap",20)
            self.loft([((x,y,-.010),rx,rz) for y,rx,rz in [(.755,.045,.027),(.785,.064,.035),(.815,.071,.039),(.842,.058,.034)]],"skin",lambda pt,i,s=side:self.weights("Hand."+s),"hand",20)\n            self.ellipsoid((x+sign*.050,.815,-.018),(.028,.040,.024),"skin","Hand."+side,"thumb_base",14,8)\n            for knuckle,zoff in enumerate([-.037,-.012,.013,.038]): self.ellipsoid((x+sign*.018,.775,zoff),(.015,.012,.014),"skin","Hand."+side,"knuckle",10,6)
            for j in range(5):
                bone=f"Finger{j}.{side}"; tip=f"Finger{j}Tip.{side}"; pos=mul(self.world[bone],1/self.scale); end=mul(self.world[tip],1/self.scale)
                self.loft([((end[0],end[1]-.035,end[2]-.007),.010,.011),(end,.012,.014),(pos,.013,.014)],"skin",lambda pt,i,a=bone,b=tip:self.weights(a,b,1. if i<1 else (.65 if i==1 else 0.)),"finger",12)
            self.loft([((lx,y,0),leg*r,leg*r*.95) for y,r in [(.30,.70),(.42,.68),(.51,.75),(.62,.90),(.76,1.02),(.88,1.02)]],"skin",lambda pt,i,s=side:self.limb_w(s,pt[1],False),"leg",30)
            self.loft([((lx,y,0),leg*r+.005,leg*r*.95+.005) for y,r in [(.63,.91),(.77,1.03),(.88,1.03)]],"gear",lambda pt,i,s=side:self.limb_w(s,pt[1],False),"shorts",24)
            self.ellipsoid((lx,.50,-leg*.70),(leg*.76,.082,.026),"boots","Shin."+side,"kneepad")
            self.loft([((lx,y,-.02),.105*leg/.14,rz) for y,rz in [(.055,.18),(.105,.17),(.18,.105),(.29,.103)]],"boots",lambda pt,i,s=side:self.weights("Foot."+s,"Shin."+s,smooth((pt[1]-.12)/.14)),"boot",24)
            self.ellipsoid((lx,.055,-.094),(.115*leg/.14,.037,.185),"boots","Foot."+side,"sole",20)
            for j in range(5): self.ellipsoid((lx,.15+j*.021,-.119),(.062,.004,.005),"trim","Foot."+side,"lacing",10,6)
        style=p["hair"]
        if style=="curls":
            for i in range(36):
                a=i*2.399963; y=1.72+.22*(i%7)/6; radius=.17+.034*math.sin(i*2)
                self.ellipsoid((math.cos(a)*radius*face,y,math.sin(a)*radius+.022),(.047,.050,.048),"hair","Head","hair",12,8)
        elif style=="beanie":
            self.loft([((0,y,0),rx*face,rz) for y,rx,rz in [(1.739,.19,.179),(1.79,.19,.17),(1.85,.155,.14),(1.89,.035,.035)]],"boots",lambda pt,i:self.weights("Head"),"hat",28)
            self.loft([((0,y,0),.194*face,.183) for y in [1.731,1.762]],"trim",lambda pt,i:self.weights("Head"),"hat_trim",28)
        else:
            self.ellipsoid((0,1.812,.025),(.174*face,.078,.152),"hair","Head","hair",24,12)
            if style in ("long","bun"):
                for sign in [-1,1]: self.ellipsoid((sign*.17*face,1.63,.05),(.045,.17,.12),"hair","Head","hair",16,10)
                self.ellipsoid((0,1.67,.116),(.158,.18,.063),"hair","Head","hair",20,10)
            if style=="bun": self.ellipsoid((0,1.84,.138),(.087,.075,.070),"hair","Head","hair")
        if p["role"]=="referee":
            for sign in [-1,1]:
                for y in [1.674,1.724]: self.ellipsoid((sign*.075,y,-.179),(.061,.005,.006),"dark","Head","glasses",12,6)
                for x in [sign*.020,sign*.128]: self.ellipsoid((x,1.699,-.179),(.005,.025,.006),"dark","Head","glasses",8,6)
            self.ellipsoid((0,1.584,-.105),(.096,.045,.065),"hair","Head","beard")
            part=self.part("halo"); start=len(part["v"]); segments=48
            for i in range(segments+1):
                a=i*math.tau/segments
                for j in range(9):
                    b=j*math.tau/8; radius=.245+.014*math.cos(b); point=(radius*math.cos(a),2.035+.014*math.sin(b),radius*math.sin(a))
                    bones,weights=self.weights("Head")
                    part["v"].append(mul(point,self.scale)); part["uv"].append((i/segments,j/8)); part["j"].append(bones); part["w"].append(weights)
            for i in range(segments):
                for j in range(8):
                    a=start+i*9+j; b=a+9; part["i"].extend([a,a+1,b+1,a,b+1,b])
        self.finish_mesh()

    def finish_mesh(self):
        primitives=[]
        for material,part in self.parts.items():
            normals=[(0.,0.,0.) for _ in part["v"]]
            for i in range(0,len(part["i"]),3):
                a,b,c=part["i"][i:i+3]; n=cross(sub(part["v"][b],part["v"][a]),sub(part["v"][c],part["v"][a]))
                for j in [a,b,c]: normals[j]=add(normals[j],n)
            groups={}
            for i,vertex in enumerate(part["v"]):
                key=tuple(round(x,6) for x in vertex); groups[key]=add(groups.get(key,(0,0,0)),normals[i])
            part["n"]=[norm(groups[tuple(round(x,6) for x in vertex)]) for vertex in part["v"]]
            attrs={key:self.accessor(part[k],kind,component,34962) for key,k,kind,component in [("POSITION","v","VEC3",5126),("NORMAL","n","VEC3",5126),("TEXCOORD_0","uv","VEC2",5126),("JOINTS_0","j","VEC4",5123),("WEIGHTS_0","w","VEC4",5126)]}
            primitives.append({"attributes":attrs,"indices":self.accessor(part["i"],"SCALAR",5125,34963),"material":material})
        self.doc["meshes"].append({"name":self.key+"_skinned","primitives":primitives})
        matrices=[]
        for name in self.joint_names:
            x,y,z=self.world[name]; matrices.append([1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,-x,-y,-z,1.])
        self.doc["skins"].append({"name":"HumanoidSkin","joints":[self.bones[n] for n in self.joint_names],"skeleton":self.bones["Root"],"inverseBindMatrices":self.accessor(matrices,"MAT4")})
        self.doc["nodes"][0]["children"].append(len(self.doc["nodes"]))
        self.doc["nodes"].append({"name":"Body","mesh":0,"skin":0})

    def pose(self,clip,t,duration):
        rotations={n:(0.,0.,0.) for n in self.joint_names}
        offsets={n:(0.,0.,0.) for n in self.joint_names}
        r,o=rotations,offsets; p=t/max(.001,duration)
        for side,sign in [("L",1),("R",-1)]:
            r["UpperArm."+side]=(.15,0,sign*.12); r["Forearm."+side]=(1.5,0,0)
            for j in range(5): r[f"Finger{j}.{side}"]=(.52,0,0); r[f"Finger{j}Tip.{side}"]=(.50,0,0)
        r["Chest"]=(.045,0,0); r["Head"]=(-.035,0,0)
        if clip=="idle":
            o["Hips"]=(0,.006*math.sin(math.tau*p),0)
            r["Chest"]=(.045+.015*math.sin(math.tau*p),.02*math.sin(math.tau*p),0)
        elif clip in ("walk","run"):
            speed=1.5 if clip=="walk" else 4.2; stance=.60 if clip=="walk" else .38
            o["Hips"]=(0,-.11+(.012 if clip=="walk" else .027)*math.sin(4*math.pi*p),0)
            for side,phase_offset in [("L",0),("R",.5)]:
                phase=(p+phase_offset)%1; travel=speed*duration*stance; start=-travel/2
                if phase<stance: z=start+travel*(phase/stance); height=.02
                else:
                    u=(phase-stance)/(1-stance); z=start+travel*(1-smooth(u)); height=.02+(.10 if clip=="walk" else .20)*math.sin(math.pi*u)
                dy=.89+o["Hips"][1]-(.115+height); a=.38; b=.395
                distance=max(.05,min(a+b-.001,math.hypot(dy,z)))
                knee=-math.acos(max(-1,min(1,(distance*distance-a*a-b*b)/(2*a*b))))
                hip=math.atan2(-z,dy)+math.acos(max(-1,min(1,(a*a+distance*distance-b*b)/(2*a*distance))))
                r["Thigh."+side]=(hip,0,0); r["Shin."+side]=(knee,0,0); r["Foot."+side]=(-hip-knee,0,0)
                r["UpperArm."+side]=(-.42*math.sin(math.tau*phase),0,.10 if side=="L" else -.10); r["Forearm."+side]=(.65,0,0)
            r["Chest"]=(-.08 if clip=="walk" else -.20,0,0)
        elif clip=="strike":
            attack=math.sin(math.pi*min(1,t/.27)) if t<.27 else 0
            r["UpperArm.R"]=(.2+1.32*attack,0,-.23); r["Forearm.R"]=(.35+.7*(1-attack),0,0); r["Chest"]=(.06,.24*attack,0)
            # A single committed strike: multi-hit gameplay is not falsely implied.
        elif clip in ("block","reversal","grapple"):
            q=smooth(min(1,t/.12)); r["UpperArm.L"]=(.5+q*.9,0,.15); r["UpperArm.R"]=(.5+q*.9,0,-.15)
            for side in ["L","R"]: r["Forearm."+side]=(1.15 if clip=="block" else .35,0,0)
        elif clip in ("hit_light","hit_heavy"):
            q=math.sin(math.pi*p); r["Chest"]=(-.23*q,.08*q,0); r["Head"]=(-.20*q,0,0)
        elif clip in ("throw_attacker","throw_leverage_attacker"):
            q=math.sin(math.pi*min(1,t/.60)); o["Hips"]=(0,-.065*q,0); r["Chest"]=(.16*q,0,0)
            for side in ["L","R"]: r["UpperArm."+side]=(.5+1.75*q,0,.14 if side=="L" else -.14); r["Forearm."+side]=(.48,0,0)
        elif clip in ("throw_defender","throw_leverage_defender"):
            # World lift belongs to Fighter; do not add a second positive-Y lift.
            q=smooth(min(1,t/.22)); r["Hips"]=(math.pi/2*q,0,0); o["Hips"]=(0,(-.70+.10*smooth((t-.40)/.20))*q,0)
            for side in ["L","R"]: r["UpperArm."+side]=(.18,0,.7 if side=="L" else -.7)
        elif clip in ("knockdown","downed","pinned","defeated","submission_defender","kickout"):
            q=smooth(min(1,t/.40)) if clip=="knockdown" else 1.
            r["Hips"]=(math.pi/2*q,0,0); o["Hips"]=(0,-.60*q,0); r["Chest"]=(0,0,0); r["Head"]=(0,0,0)
            if clip in ("pinned","submission_defender","kickout"):
                q=math.sin(t*9)*.045; r["Thigh.L"]=(.35+q,0,.1); r["Shin.L"]=(-.65,0,0); r["Thigh.R"]=(.22-q,0,-.1); r["Shin.R"]=(-.4,0,0)
            for side,sign in [("L",1),("R",-1)]: r["UpperArm."+side]=(0,0,sign*.6)
        elif clip=="getup":
            q=smooth(p); r["Hips"]=(math.pi/2*(1-q),0,.28*math.sin(math.pi*p)); o["Hips"]=(0,-.60*(1-q),0)
            r["UpperArm.L"]=(1.15*math.sin(math.pi*p),0,.5*(1-q)); r["Forearm.L"]=(.5*math.sin(math.pi*p),0,0)
            r["Thigh.R"]=(.75*math.sin(math.pi*p),0,0); r["Shin.R"]=(-1.3*math.sin(math.pi*p),0,0); r["Foot.R"]=(.55*math.sin(math.pi*p),0,0)
        elif clip=="pinning":
            o["Hips"]=(0,-.16,0); r["Hips"]=(-math.pi/2,0,0); r["Chest"]=(.12,0,0)
            r["Thigh.L"]=(-.4,0,.20); r["Thigh.R"]=(-.5,0,-.20); r["Shin.L"]=(.6,0,0); r["Shin.R"]=(.6,0,0)
            for side in ["L","R"]: r["UpperArm."+side]=(.9,0,.5 if side=="L" else -.5); r["Forearm."+side]=(.6,0,0)
        elif clip in ("submission_attacker","ref_count"):
            bend=1.20 if clip=="ref_count" else .80
            o["Hips"]=(0,-.39,0); r["Hips"]=(-bend,0,0); r["Chest"]=(-.18,0,0)
            for side in ["L","R"]:
                r["Thigh."+side]=(bend,0,0); r["Shin."+side]=(-math.pi/2,0,0); r["Foot."+side]=(math.pi/2,0,0)
                r["UpperArm."+side]=(bend+.18,0,0); r["Forearm."+side]=(0,0,0)
            if clip=="ref_count": r["UpperArm.R"]=(bend+.18-1.1*math.sin(math.pi*p),0,0)
        elif clip in ("victory","ref_wave"):
            for side,sign in [("L",1),("R",-1)]: r["UpperArm."+side]=(.3+2.45*smooth(p),0,sign*.25); r["Forearm."+side]=(.15,0,0)
        return r,o

    def animations(self):
        for name,duration in DURATIONS.items():
            count=max(2,math.ceil(duration*30)+1); times=[duration*i/(count-1) for i in range(count)]
            poses=[self.pose(name,t,duration) for t in times]
            full_time=self.accessor(times,"SCALAR"); short_time=self.accessor([0.,duration],"SCALAR"); channels=[]; samplers=[]
            for bone in self.joint_names:
                rest=self.doc["nodes"][self.bones[bone]]["translation"]
                tracks=[("rotation","VEC4",[quat(*pose[0][bone]) for pose in poses]),("translation","VEC3",[add(rest,mul(pose[1][bone],self.scale)) for pose in poses])]
                for path,kind,values in tracks:
                    constant=all(all(abs(x-y)<1e-8 for x,y in zip(v,values[0])) for v in values)
                    output=self.accessor([values[0],values[-1]] if constant else values,kind)
                    samplers.append({"input":short_time if constant else full_time,"output":output,"interpolation":"LINEAR"})
                    channels.append({"sampler":len(samplers)-1,"target":{"node":self.bones[bone],"path":path}})
            self.doc["animations"].append({"name":name,"channels":channels,"samplers":samplers,"extras":{"loop":name in LOOPS,"impact_time":.60 if name.startswith("throw") else .13 if name=="strike" else None}})

    def validate(self):
        if len(self.bones)!=42: raise ValueError("Invalid humanoid hierarchy")
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
        self.doc["extras"]={"schema_version":3,"character":self.key,"style":"original stylized ring interpretation","authoring_forward":"-Z","walk_speed":1.5*self.scale,"run_speed":4.2*self.scale,"rig_bones":len(self.bones),"grip_support":"paired contact refinement pending"}
        js=json.dumps(self.doc,separators=(",",":")).encode(); js+=b" "*((-len(js))%4)
        binary=bytes(self.buf); binary+=b"\0"*((-len(binary))%4)
        data=struct.pack("<4sII",b"glTF",2,28+len(js)+len(binary))+struct.pack("<I4s",len(js),b"JSON")+js+struct.pack("<I4s",len(binary),b"BIN\0")+binary
        path.parent.mkdir(parents=True,exist_ok=True); path.write_bytes(data)
        return {"file":path.name,"sha256":hashlib.sha256(data).hexdigest(),"bones":len(self.bones),"clips":len(self.doc["animations"]),"vertices":sum(len(p["v"]) for p in self.parts.values()),"triangles":sum(len(p["i"])//3 for p in self.parts.values()),"bytes":len(data),"visual_acceptance":"model-quality-v3 candidate; render inspection required"}

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--character",choices=PROFILES)
    parser.add_argument("--output",type=Path,default=ROOT/"assets/models")
    args=parser.parse_args()
    manifest_path=args.output/"roster_manifest.json"
    previous=json.loads(manifest_path.read_text()).get("entries",[]) if args.character and manifest_path.exists() else []
    results={entry["file"]:entry for entry in previous}
    for key in ([args.character] if args.character else PROFILES):
        result=Asset(key,PROFILES[key]).save(args.output/(key+".glb")); results[result["file"]]=result
        print(key,result["triangles"],"triangles",result["bones"],"bones",result["clips"],"clips")
    manifest_path.write_text(json.dumps({"generator":"tools/build_roster.py","original_assets":True,"entries":[results[key] for key in sorted(results)]},indent=2)+"\n")

if __name__=="__main__": main()
