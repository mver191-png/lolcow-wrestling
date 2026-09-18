"""Original procedural portrait maps, authored without sampling photographs.

Texture coordinates match the generated head and fitted eye surfaces. Color maps
are sRGB; roughness and tangent normals are linear data. No runtime file requests.
"""
from __future__ import annotations
import math
from roster_base import png


def mix(a,b,t): return a+(b-a)*t
def sat(x): return max(0.,min(1.,x))
def smooth(x): x=sat(x);return x*x*(3-2*x)
def gauss(x,y,cx,cy,sx,sy): return math.exp(-((x-cx)/sx)**2-((y-cy)/sy)**2)
def noise(x,y):
    k=(x*374761393+y*668265263)&0xffffffff
    k=((k^(k>>13))*1274126177)&0xffffffff
    return ((k^(k>>16))&65535)/65535.-.5

def texture(asset,name,w,h,pixels):
    asset.doc['images'].append({'bufferView':asset.view(png(w,h,pixels)),
                               'mimeType':'image/png','name':name})
    asset.doc['textures'].append({'sampler':0,'source':len(asset.doc['images'])-1})
    return len(asset.doc['textures'])-1


def skin_material(portrait):
    a=portrait.a;p=portrait.p;size=512;color=[];normal=[];rough=[]
    style=p['beard'];m=p['mouth_level'];eyes=p['eye_level'];n=p['nose_level']
    for row in range(size):
        t=(row+.5)/size;rx,_=portrait.dim(t)
        for col in range(size):
            angle=math.tau*(col+.5)/size;x=rx*math.cos(angle);front=max(0.,-math.sin(angle))**5
            rand=noise(col,row)
            mottling=.008*math.sin(col*.061+row*.027)*math.sin(row*.037)
            redness=.035*sum(gauss(x,t,sign*p['eye_spread'],eyes-.13,.041,.115) for sign in [-1,1])*front
            rgb=[c*factor for c,factor in zip(p['skin'],
                 [.98+rand*.012+mottling,.965+rand*.012+mottling-redness,.952+rand*.012+mottling-redness*.76])]
            # Color-zone variation is subtle and independent of lighting.
            under_eye=sum(gauss(x,t,sign*p['eye_spread'],eyes-.052,.029,.026) for sign in [-1,1])*front
            fold=.08*under_eye*p.get('crease',.5)
            rgb=[v*(1-fold) for v in rgb]
            beard=0.
            if style in ('long_beard','goatee'):
                width=.10 if style=='long_beard' else .035
                edge=m+.05+(.09*min(1.,abs(x)/.08) if style=='long_beard' else -.035)
                beard=math.exp(-(abs(x)/width)**4)*smooth((edge-t)/.105)*.85
            elif style in ('short_stubble','light_stubble','chin_shadow'):
                width=.14 if style=='short_stubble' else .052 if style=='chin_shadow' else .085
                beard=math.exp(-(abs(x)/width)**4)*smooth((m+.024-t)/.11)*smooth((t+.02)/.06)
                beard*=.34 if style=='short_stubble' else .20
            if style in ('long_beard','goatee','short_stubble'):
                moustache=math.exp(-((t-m-.03)/.020)**2)*math.exp(-(x/(p['mouth_width']*.90))**6)
                beard=max(beard,moustache*.65)
            beard*=front
            hair=p.get('beard_color',p['hair_color'])
            rgb=[mix(c,h,sat(beard*(.91+.24*(rand+.5)))) for c,h in zip(rgb,hair)]
            color.extend(round(255*sat(c)) for c in rgb)
            # Modest pore-scale surface noise. Larger forms are geometry, not
            # heavy normal-map embossing. No scars, wounds or copied skin images.
            nx=(noise((col+1)%size,row)-noise((col-1)%size,row))*.085
            ny=(noise(col,(row+1)%size)-noise(col,(row-1)%size))*.085
            length=math.sqrt(nx*nx+ny*ny+1.)
            normal.extend([round(127.5+127.5*nx/length),round(127.5+127.5*ny/length),round(127.5+127.5/length)])
            oil=(.15*gauss(x,t,0,n,.035,.09)+.10*gauss(x,t,0,.77,.095,.10))*front
            r=sat(.72-oil+.022*rand+.04*beard)
            rough.extend([255,round(255*r),0])
    albedo=texture(a,'original_face_albedo_512',size,size,color)
    normals=texture(a,'original_face_micro_normal_512',size,size,normal)
    roughness=texture(a,'original_face_roughness_512',size,size,rough)
    a.mat['portrait_skin']=a.material('portrait_skin',(1,1,1),1.)
    mat=a.doc['materials'][a.mat['portrait_skin']]
    mat['pbrMetallicRoughness']['baseColorTexture']={'index':albedo}
    mat['pbrMetallicRoughness']['metallicRoughnessTexture']={'index':roughness}
    mat['normalTexture']={'index':normals,'scale':.36}


def eye_material(portrait):
    a=portrait.a;p=portrait.p;w,h=256,128;pixels=[]
    radius=p.get('iris_radius',.0108);pupil=.0038
    for r in range(h):
        v=(r+.5)/h
        for j in range(w):
            u=(j+.5)/w*2-1;arc=math.sqrt(max(.001,1-u*u))
            x=u*p['eye_width'];y=mix(-p['eye_open']*.70,p['eye_open'],v)*arc
            dist=math.hypot(x,y);angle=math.atan2(y,x)
            # Warm off-white sclera, subtle vascular tint only at corners.
            tint=abs(u)**4
            rgb=[.79-.025*tint,.78-.085*tint,.72-.055*tint]
            if dist<radius:
                q=dist/radius
                fiber=.84+.12*math.sin(angle*41+q*13)+.06*math.sin(angle*89-q*22)
                iris=[c*factor for c,factor in zip(p['iris'],[fiber*1.17,fiber*1.13,fiber*1.10])]
                edge=smooth((q-.79)/.21)
                iris=[mix(c,.037,edge*.82) for c in iris]
                iris=[mix(c,.075,smooth((.46-q)/.13)*.30) for c in iris]
                inside=1-smooth((dist-pupil)/.0009)
                rgb=[mix(c,.011,inside) for c in iris]
            # Original tiny corneal highlight, not a photographed iris.
            glint=math.exp(-((x+.0028)/.0008)**2-((y-.0034)/.0008)**2)
            rgb=[mix(c,.92,glint*.75) for c in rgb]
            pixels.extend(round(255*sat(c)) for c in rgb)
    index=texture(a,'original_fitted_iris_sclera',w,h,pixels)
    a.mat['portrait_eye']=a.material('portrait_eye',(1,1,1),.23)
    a.doc['materials'][a.mat['portrait_eye']]['pbrMetallicRoughness']['baseColorTexture']={'index':index}


def add_tangents(asset):
    """Export orthonormal tangent frames where tangent-space maps need them.

    Gram-Schmidt with a deterministic fallback handles UV seams/cap vertices.
    This tests the actual exported tangent contract instead of depending on an
    undocumented importer fallback. Model vertices and skin weights do not move.
    """
    from roster_base import add,mul,sub,dot,cross,norm
    for primitive,(mat,part) in zip(asset.doc['meshes'][0]['primitives'],asset.parts.items()):
        if 'normalTexture' not in asset.doc['materials'][mat]:continue
        tangents=[(0.,0.,0.) for _ in part['v']]
        bitangents=[(0.,0.,0.) for _ in part['v']]
        for start in range(0,len(part['i']),3):
            i,j,k=part['i'][start:start+3]
            e1=sub(part['v'][j],part['v'][i]);e2=sub(part['v'][k],part['v'][i])
            du1,dv1=sub(part['uv'][j],part['uv'][i]);du2,dv2=sub(part['uv'][k],part['uv'][i])
            determinant=du1*dv2-dv1*du2
            if abs(determinant)<1e-12:continue
            t=mul(sub(mul(e1,dv2),mul(e2,dv1)),1/determinant)
            b=mul(sub(mul(e2,du1),mul(e1,du2)),1/determinant)
            for vertex in [i,j,k]:
                tangents[vertex]=add(tangents[vertex],t);bitangents[vertex]=add(bitangents[vertex],b)
        result=[]
        for n,t,b in zip(part['n'],tangents,bitangents):
            t=sub(t,mul(n,dot(n,t)))
            if dot(t,t)<1e-16:t=cross((0,1,0) if abs(n[1])<.9 else (1,0,0),n)
            t=norm(t);hand=-1. if dot(cross(n,t),b)<0 else 1.
            result.append((*t,hand))
        primitive['attributes']['TANGENT']=asset.accessor(result,'VEC4',5126,34962)
        part['tangent']=result


def hair_material(portrait):
    a=portrait.a;color=portrait.p['hair_color'];pixels=[];normals=[];w,h=256,256
    for row in range(h):
        v=row/h
        for col in range(w):
            # Fine longitudinal fibers plus broad clump-scale variation. Original
            # generated color/noise, never a crop or sample of source hair.
            phase=col*.72+.7*math.sin(v*6)
            ridge=math.sin(phase)+.4*math.sin(col*1.63+v*4)
            shade=.91+.085*ridge+.045*noise(col,row)
            pixels.extend(round(255*sat(c*shade)) for c in color)
            nx=.11*math.cos(phase)+.045*math.cos(col*1.63+v*4)
            normals.extend([round(127.5+nx*127.5),128,254])
    albedo=texture(a,'original_hair_fibers',w,h,pixels)
    normal=texture(a,'original_hair_fiber_normal',w,h,normals)
    a.mat['portrait_hair']=a.material('portrait_hair',(1,1,1),.78)
    mat=a.doc['materials'][a.mat['portrait_hair']]
    mat['pbrMetallicRoughness']['baseColorTexture']={'index':albedo}
    mat['normalTexture']={'index':normal,'scale':.40}
