"""Original model-quality-v3 surfaces; metres, Y up, -Z face direction.

Anatomical/garment regions explicitly own skin weights. These are fictional ring
costumes and stylized faces, not reference-verified likenesses. The module only
constructs art; it never changes gameplay reach, colliders or move timing.
"""
from __future__ import annotations
import math

TAU = math.tau
# Costume choices are art direction, not biographical assertions.
COSTUMES = {
    "tophiachu": ("singlet", "broadcast", 1.03, 1.00),
    "cyraxx": ("tank", "feedback", .97, .96),
    "novaonline": ("trunks", "chevron", 1.04, .99),
    "candy_rooks": ("tunic", "diamond", .99, 1.04),
    "andy_ditch": ("singlet", "bars", 1.02, 1.04),
    "jupiter_the_hybrid": ("tights", "eclipse", 1.04, .98),
    "anacondasin": ("tights", "coil", .98, 1.02),
    "daniel_larson": ("jacket", "thunder", .97, .95),
    "referee_cobra": ("referee", "official", 1.0, .97),
}

def _add(a, b): return tuple(x+y for x,y in zip(a,b))
def _sub(a, b): return tuple(x-y for x,y in zip(a,b))
def _mul(a, k): return tuple(x*k for x in a)
def _dot(a,b): return sum(x*y for x,y in zip(a,b))
def _cross(a,b): return (a[1]*b[2]-a[2]*b[1],a[2]*b[0]-a[0]*b[2],a[0]*b[1]-a[1]*b[0])
def _norm(v):
    length=math.sqrt(_dot(v,v))
    return _mul(v,1/length) if length>1e-9 else (0.,1.,0.)
def _lerp(a,b,t): return a+(b-a)*t
def _smooth(t):
    t=max(0.,min(1.,t));return t*t*(3-2*t)
def _gauss(x,y,cx,cy,sx,sy): return math.exp(-((x-cx)/sx)**2-((y-cy)/sy)**2)

def _refine_sections(sections, subdivisions=3):
    """Smooth ring spacing without introducing overshooting negative radii."""
    result=[]
    for i in range(len(sections)-1):
        p0=sections[max(i-1,0)];p1=sections[i];p2=sections[i+1];p3=sections[min(i+2,len(sections)-1)]
        for j in range(subdivisions):
            t=j/subdivisions;row=[_lerp(p1[0],p2[0],t)]
            for k in [1,2]:
                value=.5*((2*p1[k])+(-p0[k]+p2[k])*t+(2*p0[k]-5*p1[k]+4*p2[k]-p3[k])*t*t+(-p0[k]+3*p1[k]-3*p2[k]+p3[k])*t*t*t)
                row.append(max(.005,value))
            result.append(tuple(row))
    result.append(sections[-1]);return result

class Surfaces:
    """Small indexed-surface builder with explicit region tags and skin ownership."""
    def __init__(self, asset): self.a=asset

    def grid(self, rows, material, weight, region, wrap=True, cap=False):
        a=self.a;part=a.part(material);start=len(part['v']);count=len(rows[0])
        if count<3 or len(rows)<2 or any(len(row)!=count for row in rows):
            raise ValueError('Surface grid requires rectangular rows')
        for ri,row in enumerate(rows):
            for j,point in enumerate(row):
                joints,weights=weight(point,ri)
                part['v'].append(_mul(point,a.scale));part['uv'].append((j/(count-1),ri/(len(rows)-1)))
                part['j'].append(joints);part['w'].append(weights)
        for ri in range(len(rows)-1):
            for j in range(count-1):
                i=start+ri*count+j;k=i+count
                part['i'].extend([i,k,k+1,i,k+1,i+1])
        if cap:
            for ri,top in [(0,False),(len(rows)-1,True)]:
                row=rows[ri][:-1] if wrap else rows[ri]
                center=tuple(sum(p[k] for p in row)/len(row) for k in range(3))
                joints,weights=weight(center,ri);ci=len(part['v'])
                part['v'].append(_mul(center,a.scale));part['uv'].append((.5,.5));part['j'].append(joints);part['w'].append(weights)
                for j in range(count-1):
                    i=start+ri*count+j;part['i'].extend([ci,i+1,i] if top else [ci,i,i+1])
        a.regions.setdefault(region,[]).extend((a.mat[material],i) for i in range(start,len(part['v'])))

    def tube(self, centers, radii, material, weight, region, segments=10):
        """Parallel-ish transported tube; used for seam piping and hair locks."""
        rows=[];previous=None
        for i,c in enumerate(centers):
            t=_norm(_sub(centers[min(i+1,len(centers)-1)],centers[max(0,i-1)]))
            reference=previous if previous is not None else ((1,0,0) if abs(t[0])<.8 else (0,0,1))
            u=_norm(_sub(reference,_mul(t,_dot(reference,t))))
            if abs(_dot(u,t))>.01:u=_norm(_cross(t,(0,1,0)))
            v=_norm(_cross(u,t));previous=u
            radius=radii[i] if isinstance(radii,list) else radii
            rows.append([_add(c,_add(_mul(u,radius*math.cos(TAU*j/segments)),_mul(v,radius*math.sin(TAU*j/segments)))) for j in range(segments+1)])
        self.grid(rows,material,weight,region,cap=True)

    def band(self, ring_at, lo, hi, material, weight, region='seam',segments=48):
        rows=[]
        for y in [lo,lo+.003,hi-.003,hi]:
            rows.append([ring_at(y,TAU*j/segments) for j in range(segments+1)])
        self.grid(rows,material,weight,region,cap=False)


def build_character(a):
    s=Surfaces(a);p=a.p;w=p['width'];d=p['depth'];face=p['face']
    costume,emblem,shoulder_factor,hip_factor=COSTUMES[a.key]
    # Dense rings are concentrated at deformation transitions, not uniformly
    # subdivided after skinning. Torso and arm regions remain separate owners.
    body=[(.785,.73,.81),(.82,.85,.90),(.86,.94,.98),(.90,.99,1.01),(.96,1.035*hip_factor,1.04),
          (1.02,1.045*hip_factor,1.06),(1.08,1.015,1.07),(1.14,.98,1.035),(1.20,.97,1.00),
          (1.26,1.005,1.00),(1.31,1.045*shoulder_factor,.98),(1.355,1.025*shoulder_factor,.93),
          (1.395,.95*shoulder_factor,.86),(1.43,.78,.70),(1.455,.56,.55),(1.475,.28,.39)]
    def body_dimensions(y):
        for i in range(len(body)-1):
            y0,x0,z0=body[i];y1,x1,z1=body[i+1]
            if y<=y1:
                t=max(0,min(1,(y-y0)/(y1-y0)));return w*_lerp(x0,x1,t),d*_lerp(z0,z1,t)
        return w*body[-1][1],d*body[-1][2]
    def body_point(y,angle,offset=0):
        rx,rz=body_dimensions(y)
        folds=.0020*math.sin(angle*8+y*41)*math.sin(math.pi*max(0,min(1,(y-.8)/.66)))
        return ((rx+offset+folds)*math.cos(angle),y,(rz+offset+folds)*math.sin(angle))
    torso_weight=lambda pt,i:a.torso_w(pt[1])
    rows=[[body_point(y,TAU*j/48) for j in range(49)] for y,_,_ in body]
    # A trunks outfit leaves a plain undershirt rather than exposing private anatomy.
    s.grid(rows,'gear',torso_weight,'torso',cap=True)
    s.band(lambda y,angle:body_point(y,angle,.006),.842,.874,'trim',torso_weight)
    # Tailored neck opening instead of a bright ring around the entire shoulder.
    s.band(lambda y,angle:body_point(y,angle,.012),1.444,1.463,'trim',torso_weight)
    # Narrow garment panels follow the actual torso instead of floating in front.
    def panel(xcenter,halfwidth,y0,y1,material):
        rows=[]
        for i in range(16):
            y=_lerp(y0,y1,i/15);rx,rz=body_dimensions(y)
            row=[]
            for j in range(9):
                x=xcenter*w+halfwidth*w*(j/4-1)
                z=-(rz+.014)*math.sqrt(max(.03,1-(x/(rx+.014))**2))
                row.append((x,y,z))
            # x ascends while y ascends: same winding as front-face grid.
            rows.append(row)
        s.grid(rows,material,torso_weight,'gear_detail',wrap=False)
    if costume in ('singlet','tank'):
        for sign in [-1,1]:panel(sign*.42,.105,1.10,1.43,'trim')
    elif costume=='jacket':
        for sign in [-1,1]:panel(sign*.37,.070,.89,1.42,'trim')
        panel(0,.022,.87,1.42,'boots')
    elif costume=='tunic':
        panel(0,.62,.86,1.36,'trim')
        # Small pocket piping, weighted to the same torso section.
        centers=[]
        for i in range(17):
            x=w*(-.35+.7*i/16);rx,rz=body_dimensions(1.07)
            centers.append((x,1.07,-(rz+.010)*math.sqrt(max(.05,1-(x/rx)**2))))
        s.tube(centers,.0045,'gear',torso_weight,'gear_detail',8)
    elif costume=='referee':
        panel(0,.035,.88,1.43,'boots')
        for y in [1.12,1.22,1.32]:
            rx,rz=body_dimensions(y);a.ellipsoid((0,y,-rz-.012),(.008,.008,.004),'trim','Chest','button',10,6)
    else:
        for sign in [-1,1]:panel(sign*.62,.065,.88,1.32,'trim')
    # Original abstract ring emblems; no borrowed trademarks or biographical labels.
    emblem_paths={
        'broadcast':[[(-.065,-.04),(.065,-.04),(.065,.04),(-.065,.04),(-.065,-.04)],[(-.032,0),(.032,0)]],
        'feedback':[[(-.065,0),(-.04,0),(-.02,.055),(0,-.055),(.025,.038),(.045,0),(.065,0)]],
        'chevron':[[(-.075,.04),(0,-.045),(.075,.04)]],
        'diamond':[[(-.05,0),(0,.05),(.05,0),(0,-.05),(-.05,0)]],
        'bars':[[(-.07,y),(.07,y)] for y in [-.04,0,.04]],
        'eclipse':[[(.055*math.cos(i*TAU/30),.055*math.sin(i*TAU/30)) for i in range(31)]],
        'coil':[[(.006*i*math.cos(i*.48),.006*i*math.sin(i*.48)) for i in range(15)]],
        'thunder':[[(-.025,.065),(.035,.02),(-.02,-.015),(.03,-.065)]],
        'official':[],
    }
    for path in emblem_paths[emblem]:
        centers=[]
        for x,dy in path:
            y=1.28+dy;rx,rz=body_dimensions(y);centers.append((x,y,-(rz+.014)*math.sqrt(max(.03,1-(x/rx)**2))))
        s.tube(centers,.006,'gear' if costume=='tunic' else 'trim',torso_weight,'emblem',8)
    a.loft([((0,y,.009),rx,rz) for y,rx,rz in [(1.45,.112,.10),(1.48,.107,.098),(1.52,.103,.102),(1.58,.108,.108)]],
           'skin',lambda pt,i:a.weights('Neck','Head',_smooth((pt[1]-1.49)/.09)),'neck',32)
    _head(a,s)
    for side,sign in [('L',1),('R',-1)]:
        _limbs(a,s,side,sign,costume)
    _hair(a,s)
    if costume=='referee':_official(a,s)
    a.finish_mesh()


def _head(a,s):
    p=a.p;f=p['face'];key=a.key
    # Jaw, forehead and muzzle variation is deliberately restrained stylization.
    jaw={'cyraxx':.90,'daniel_larson':.89,'andy_ditch':1.08,'tophiachu':1.06}.get(key,1.0)
    sections=[(1.535,.072,.078),(1.550,.099,.109),(1.575,.132*jaw,.131),(1.60,.154*jaw,.145),
              (1.625,.166,.153),(1.65,.177,.160),(1.675,.179,.162),(1.70,.176,.158),
              (1.725,.174,.157),(1.75,.167,.150),(1.78,.160,.143),(1.81,.137,.123),
              (1.835,.098,.089),(1.850,.045,.039)]
    def face_front(x,y,rz):
        # Integrated cheekbone, eye socket, nose bridge and chin surfaces.
        nose=.042*_gauss(x,y,0,1.664,.028, .038)+.020*_gauss(x,y,0,1.70,.022,.04)
        cheeks=.009*sum(_gauss(x,y,v*f,1.645,.048,.036) for v in [-.105,.105])
        sockets=.009*sum(_gauss(x,y,v*f,1.700,.040,.020) for v in [-.073,.073])
        chin=.010*_gauss(x,y,0,1.571,.063,.022)
        return -rz-nose-cheeks+ sockets-chin
    rows=[]
    for y,rx,rz in _refine_sections(sections):
        row=[]
        for j in range(65):
            angle=TAU*j/64;x=rx*f*math.cos(angle);front=max(0,-math.sin(angle))
            z=rz*math.sin(angle)
            if front>0:
                # Flatten just the face plane; side/back cranium stay round.
                base=-(rz*(.78+.22*front));z=_lerp(z,face_front(x,y,rz)+(rz+base),front**4)
            row.append((x,y,z+.004))
        rows.append(row)
    s.grid(rows,'skin',lambda pt,i:a.weights('Head'),'head',cap=True)
    for sign in [-1,1]:
        a.ellipsoid((sign*.180*f,1.673,.002),(.025,.048,.027),'skin','Head','ear',20,12)
        a.ellipsoid((sign*.190*f,1.672,-.014),(.010,.027,.007),'mouth','Head','ear_detail',14,8)
        # Eyes sit in shallow sockets. Small irises and fitted lids avoid googly-eye spheres.
        cx=sign*.073*f;cy=1.701;cz=-.147
        a.ellipsoid((cx,cy,cz),(.037,.018,.016),'white','Head','eyes',24,12)
        a.ellipsoid((cx,cy,-.162),(.011,.012,.0035),'iris','Head','eyes',18,10)
        a.ellipsoid((cx,cy,-.165),(.0055,.007,.002),'dark','Head','eyes',14,8)
        a.ellipsoid((cx-.003,cy+.004,-.168),(.002,.002,.001),'white','Head','eyes',8,6)
        for upper in [True,False]:
            path=[]
            for i in range(17):
                t=i/16;dx=(t*2-1)*.039
                y=cy+( .019 if upper else -.014)*math.sin(math.pi*t)
                z=-.151-.010*math.sin(math.pi*t)
                path.append((cx+dx,y,z))
            s.tube(path,.0045 if upper else .0035,'skin',lambda pt,i:a.weights('Head'),'eyelid',8)
        brow=[]
        for i in range(13):
            t=i/12;brow.append((cx+(t*2-1)*.042,1.731+.010*math.sin(math.pi*t)+sign*.002*(t-.5),-.146-.009*math.sin(math.pi*t)))
        s.tube(brow,[.003+.003*math.sin(math.pi*i/12) for i in range(13)],'hair',lambda pt,i:a.weights('Head'),'brow',8)
        # Small nostrils sit inside the integrated nasal surface.
        a.ellipsoid((sign*.017,1.652,-.188),(.006,.003,.003),'mouth','Head','nostril',10,6)
    for upper in [True,False]:
        path=[]
        for i in range(21):
            t=i/20;x=(t*2-1)*.052*f
            y=1.607+(.003 if upper else -.005)*math.sin(math.pi*t)
            z=-.150-.012*math.sin(math.pi*t)
            path.append((x,y,z))
        s.tube(path,[.0015+.0025*math.sin(math.pi*i/20) for i in range(21)],'mouth',lambda pt,i:a.weights('Head'),'lip',8)
    path=[((i/16*2-1)*.049*f,1.606,-.151-.012*math.sin(math.pi*i/16)) for i in range(17)]
    s.tube(path,.0012,'dark',lambda pt,i:a.weights('Head'),'mouth_seam',6)


def _limbs(a,s,side,sign,costume):
    p=a.p;arm=p['arm'];leg=p['leg'];w=p['width'];x=sign*(w+.055);lx=sign*w*.47
    # Elbow and knee neighborhoods receive extra rings for smoother weighted bends.
    arm_sections=[(.838,.60),(.868,.66),(.91,.76),(.965,.82),(1.018,.81),(1.065,.77),
                  (1.09,.79),(1.113,.83),(1.145,.89),(1.19,.99),(1.245,1.065),(1.30,1.07),(1.348,1.00),(1.385,.84),(1.410,.63)]
    a.loft([((x,y,0),arm*r,arm*r*.90) for y,r in arm_sections],'skin',lambda pt,i:a.limb_w(side,pt[1],True),'arm',32)
    # A deformable shoulder bridge hides the capped-arm seam without assigning any
    # torso vertex to an arm. Its ownership is explicitly tagged "shoulder".
    centers=[(sign*(w*.82+(w+.055-w*.82)*i/8),1.38,0) for i in range(9)]
    bridge_r=[arm*(.43+.06*math.sin(math.pi*i/8)) for i in range(9)]
    s.tube(centers,bridge_r,'gear' if costume in ('jacket','referee') else 'skin',
           lambda pt,i:a.weights('Chest','UpperArm.'+side,_smooth((abs(pt[0])-w*.81)/(w+.055-w*.81))),'shoulder',20)
    a.loft([((x,y,0),arm*.72,arm*.66) for y in [.858,.869,.900,.912]],'wrap',lambda pt,i:a.limb_w(side,pt[1],True),'wrap',24)
    _hand(a,s,side,sign,x)
    leg_sections=[(.285,.63),(.335,.70),(.39,.71),(.445,.69),(.483,.72),(.510,.765),(.538,.80),
                  (.578,.84),(.63,.91),(.69,.97),(.75,1.02),(.81,1.03),(.88,1.02)]
    lower_mat='gear' if costume in ('tights','jacket','referee') else 'skin'
    a.loft([((lx,y,0),leg*r,leg*r*.95) for y,r in leg_sections],lower_mat,lambda pt,i:a.limb_w(side,pt[1],False),'leg',32)
    a.loft([((lx,y,0),leg*r+.004,leg*r*.95+.004) for y,r in [(.63,.92),(.655,.94),(.72,1.00),(.79,1.04),(.86,1.04)]],
           'gear',lambda pt,i:a.limb_w(side,pt[1],False),'shorts',32)
    a.loft([((lx,y,0),leg*.96,leg*.91) for y in [.635,.654]],'trim',lambda pt,i:a.limb_w(side,pt[1],False),'gear_detail',32)
    a.ellipsoid((lx,.505,-leg*.72),(leg*.69,.068,.025),'boots','Shin.'+side,'kneepad',20,12)
    a.ellipsoid((lx,.505,-leg*.89),(leg*.49,.045,.009),'trim','Shin.'+side,'pad_insert',18,10)
    if costume in ('jacket','referee'):
        a.loft([((x,y,0),arm*r,arm*r*.92) for y,r in [(1.235,1.045),(1.27,1.09),(1.325,1.105),(1.38,.93)]],
               'gear',lambda pt,i:a.limb_w(side,pt[1],True),'sleeve',32)
    a.loft([((lx,y,-.018),.102*leg/.14,rz) for y,rz in [(.045,.166),(.065,.172),(.103,.165),(.145,.137),(.182,.105),(.25,.101),(.29,.096)]],
           'boots',lambda pt,i:a.weights('Foot.'+side,'Shin.'+side,_smooth((pt[1]-.12)/.14)),'boot',32)
    a.ellipsoid((lx,.046,-.090),(.108*leg/.14,.028,.175),'boots','Foot.'+side,'sole',28,10)
    for j in range(5):
        y=.148+j*.021
        s.tube([(lx-.046,y,-.123),(lx+.046,y+.008,-.123)],.0035,'trim',lambda pt,i:a.weights('Foot.'+side),'lacing',8)
    a.loft([((lx,y,-.018),.104*leg/.14,.099) for y in [.26,.275]],'trim',lambda pt,i:a.weights('Shin.'+side),'boot_cuff',32)


def _hand(a,s,side,sign,x):
    # Palm width is X; four fingers fan across that width, not through its depth.
    a.loft([((x,y,-.006),rx,rz) for y,rx,rz in [(.762,.049,.021),(.776,.061,.025),(.798,.065,.030),(.819,.059,.029),(.838,.044,.025),(.858,.037,.024)]],
           'skin',lambda pt,i:a.weights('Hand.'+side),'hand',28)
    a.ellipsoid((x-sign*.043,.804,-.015),(.026,.035,.020),'skin','Hand.'+side,'thumb_base',18,10)
    for j in range(5):
        base=f'Finger{j}.{side}';tip=f'Finger{j}Tip.{side}'
        start=_mul(a.world[base],1/a.scale);middle=_mul(a.world[tip],1/a.scale)
        direction=_norm(_sub(middle,start));distal=.027 if j!=4 else .025
        end=_add(middle,_mul(direction,distal))
        centers=[];radii=[]
        # Rings around the interphalangeal joint retain roundness at a fist pose.
        for t,rad in [(0,.0123),(.13,.0132),(.32,.0124),(.48,.0115),(.57,.012),(.67,.0114),(.84,.0095),(1.,.0060)]:
            centers.append(_add(start,_mul(_sub(end,start),t)));radii.append(rad*(.90 if j==3 else 1.))
        joint_distance=math.sqrt(_dot(_sub(middle,start),_sub(middle,start)))
        def weight(pt,ri,b=base,t=tip):
            distance=math.sqrt(_dot(_sub(pt,start),_sub(pt,start)))
            return a.weights(b,t,_smooth((distance-joint_distance+.011)/.022))
        s.tube(centers,radii,'skin',weight,'finger',12)
        # Nail on the back of the distal segment (palm faces -Z).
        nail_center=_add(end,_mul(direction,-.012));nail_center=_add(nail_center,(0,0,.006))
        a.ellipsoid(nail_center,(.006,.010,.002),'nail',tip,'nail',10,6)
        if j<4:
            a.ellipsoid((start[0],start[1]+.004,.011),(.015,.012,.011),'skin','Hand.'+side,'knuckle',12,8)


def _hair(a,s):
    f=a.p['face'];style=a.p['hair'];head=lambda pt,i:a.weights('Head')
    if style=='beanie':
        a.loft([((0,y,.006),rx*f,rz) for y,rx,rz in [(1.731,.180,.170),(1.752,.187,.177),(1.79,.18,.167),(1.83,.145,.138),(1.863,.086,.088),(1.877,.016,.019)]],
               'boots',head,'hat',40)
        a.loft([((0,y,.006),.190*f,.179) for y in [1.731,1.748,1.765]],'gear',head,'hat_cuff',40)
        for i in range(18):
            angle=TAU*i/18
            s.tube([(math.cos(angle)*(.19*f+.003),y,math.sin(angle)*.182+.006) for y in [1.735,1.760]],
                   .0017,'trim',head,'hat_knit',6)
        return
    # Follow the actual cranium profile, rather than an unrelated hemisphere
    # which can sit inside the head and leave an unintended bald scalp.
    profile=[(1.69,.178,.160),(1.725,.174,.157),(1.75,.167,.150),
             (1.78,.160,.143),(1.81,.137,.123),(1.835,.098,.089),
             (1.850,.045,.039),(1.868,.002,.002)]
    def dimensions(y):
        for i in range(len(profile)-1):
            y0,x0,z0=profile[i];y1,x1,z1=profile[i+1]
            if y<=y1:
                t=max(0,min(1,(y-y0)/(y1-y0)))
                return _lerp(x0,x1,t),_lerp(z0,z1,t)
        return .002,.002
    rows=[]
    for i in range(21):
        row=[]
        for j in range(65):
            around=TAU*j/64;front=max(0,-math.sin(around))
            bottom=1.704+.038*front**3
            y=_lerp(bottom,1.868,i/20)
            rx,rz=dimensions(y)
            wave=.0015*math.sin(around*16+i*.12)
            x=(rx*f+.012+wave)*math.cos(around)
            z=rz*math.sin(around)
            if front>0:z=_lerp(z,-rz*(.78+.22*front),front**4)
            z+=.004+math.sin(around)*(.014+wave)
            row.append((x,y+.006,z))
        rows.append(row)
    s.grid(rows,'hair',head,'hair_cap',cap=True)
    strands=28 if style=='curls' else 18
    for k in range(strands):
        angle=TAU*k/strands
        if style in ('long','bun') and math.sin(angle)<-.6:continue
        path=[]
        for j in range(11):
            t=j/10
            end_y=1.48 if style=='long' else 1.60 if style=='bun' else 1.755
            y=_lerp(1.85,end_y,t)
            radius=.070+.105*math.sin(t*math.pi*.62)
            curl=.013*math.sin(t*TAU*1.8+k) if style=='curls' else .005*math.sin(t*5+k)
            path.append((math.cos(angle+curl*3)*(radius+curl)*f,y,math.sin(angle+curl*3)*(radius+curl)+.027))
        s.tube(path,[.004+(.012 if style=='curls' else .008)*math.sin(math.pi*(j+1)/12) for j in range(11)],
               'hair_highlight' if k%4==0 else 'hair',head,'hair_lock',10)
    if style=='bun':
        a.ellipsoid((0,1.842,.160),(.078,.072,.065),'hair','Head','bun',26,16)
    if style=='curls':
        # Flowing curls, not disconnected spherical beads.
        for k in range(12):
            angle=TAU*k/12;path=[]
            for j in range(17):
                t=j/16;c=TAU*t
                path.append(((.155+.011*math.cos(c))*math.cos(angle)*f,1.795+.055*math.sin(angle*.5)+.013*math.sin(c),
                             (.155+.011*math.cos(c))*math.sin(angle)+.033))
            s.tube(path,.009,'hair',head,'curl',12)


def _official(a,s):
    head=lambda pt,i:a.weights('Head')
    for sign in [-1,1]:
        path=[(sign*.074+.049*math.cos(TAU*i/32),1.701+.026*math.sin(TAU*i/32),-.172) for i in range(33)]
        s.tube(path,.0035,'dark',head,'glasses',8)
    s.tube([(-.023,1.704,-.172),(.023,1.704,-.172)],.003,'dark',head,'glasses',8)
    a.ellipsoid((0,1.574,-.09),(.073,.040,.070),'hair','Head','beard',24,14)
    path=[(.238*math.cos(TAU*i/64),2.01,.238*math.sin(TAU*i/64)) for i in range(65)]
    s.tube(path,.012,'halo',head,'halo',10)
