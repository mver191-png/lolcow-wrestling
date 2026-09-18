"""Scalp-conforming layered clumps. No photographs, alpha cards or runtime fetches.

Flattened tapered cross-sections replace cylindrical hair ropes; dark backing
shells cover the scalp without opaque lenses or texture-projected faces.
"""
from __future__ import annotations
import math
from character_geometry import _sub,_add,_mul,_dot,_cross,_norm
TAU=math.tau

def lerp(a,b,t):return a+(b-a)*t
def smooth(t):t=max(0,min(1,t));return t*t*(3-2*t)


def ribbon(portrait,path,width,thickness,material='hair',region='hair_lock'):
    rows=[]
    for i,c in enumerate(path):
        t=i/(len(path)-1)
        direction=_norm(_sub(path[min(i+1,len(path)-1)],path[max(0,i-1)]))
        radial=_norm((c[0],.13*max(0,c[1]-portrait.y(.6)),c[2]-.009))
        side=_norm(_cross(direction,radial))
        if _dot(side,side)<.01:side=(1,0,0)
        outward=_norm(_cross(side,direction))
        taper=(.25+.75*math.sin(math.pi*(t+.10)/1.10))*(1-.96*smooth((t-.78)/.22))
        w=width*max(.025,taper)
        row=[]
        for j in range(13):
            angle=TAU*j/12
            lateral=math.cos(angle)*w
            # Scored ridges are very shallow, not floating strings.
            normal=math.sin(angle)*thickness*max(.12,taper)
            normal+=.0005*math.sin(angle*5+i*.1)*max(0,math.sin(angle))
            row.append(_add(c,_add(_mul(side,lateral),_mul(outward,normal))))
        rows.append(row)
    portrait.s.grid(rows,'portrait_hair' if material=='hair' else material,lambda pt,i:portrait.a.weights('Head'),region,cap=True)


def scalp(p,angle,t,volume=.006):
    rx,rz=p.dim(max(0,min(1,t)));front=max(0,-math.sin(angle))
    x=rx*math.cos(angle);z=rz*math.sin(angle)+.009
    if front>0:z=p.front(x,t)
    return (x+volume*math.cos(angle),p.y(t)+volume*max(0,(t-.8)/.2),z+volume*math.sin(angle))


def build_hair(p):
    a=p.a;s=p.s;style=p.p['hair'];head=lambda pt,i:a.weights('Head')
    if style=='close_bald':return
    from portrait_materials import hair_material
    hair_material(p)
    sparse=style in ('balding_fringe','receding_long')
    short=style in ('short_coils','rough_crop','wavy_crop')
    curly=style in ('short_coils','volume_curls','tied_curls')
    volume=.007 if not curly else .014 if style=='short_coils' else .023
    def line(angle):
        front=max(0,-math.sin(angle))
        if style in ('parted_shoulder','cap_waves'):return .41+.34*front**2+.014*math.sin(angle*3)
        if style=='wavy_crop':return .65+.10*front**2+.025*math.sin(angle*7)
        if style=='rough_crop':return .60+.17*front**2+.018*math.sin(angle*5)
        if style=='short_coils':return .67+.11*front**3+.009*math.sin(angle*13)
        return .51+.22*front**3+.034*math.sin(angle*11)
    if not sparse:
        rows=[]
        for i in range(33):
            row=[]
            for j in range(129):
                angle=TAU*j/128;t=lerp(line(angle),.999,i/32)
                relief=.0015*math.sin(angle*19+t*31)
                if curly:relief+=.0023*math.sin(angle*37+t*67)*math.sin(angle*23-t*43)
                row.append(scalp(p,angle,t,volume+relief))
            rows.append(row)
        s.grid(rows,'portrait_hair',head,'hair_cap',cap=True)
    if style in ('parted_shoulder','cap_waves'):
        # Face-framing locks originate at a visible off-center part and sweep
        # around the temple before hanging. No uniform flat fringe across brow.
        for sign in [-1,1]:
            for k in range(28):
                az=-math.pi/2+sign*(.06+1.95*k/27)
                path=[]
                for j in range(25):
                    u=j/24
                    if u<.56:
                        q=u/.56;t=lerp(.997,.51-.11*k/27,q)
                        angle=-math.pi/2+sign*(.035+(.62+1.37*k/27)*smooth(q))
                        c=scalp(p,angle,t,.008+.007*math.sin(math.pi*q))
                    else:
                        q=(u-.56)/.44;angle=az+sign*.55
                        root=scalp(p,angle,.44,.011)
                        c=(root[0]+sign*(.012*math.sin(q*4+k*.3)),
                           lerp(p.y(.44),p.y(-.21+.08*math.sin(k*4)),q),
                           root[2]+.024*q+.005*math.sin(q*7+k))
                    path.append(c)
                ribbon(p,path,.0085+.0015*math.sin(k*2),.0016,
                       'hair_highlight' if k%11==0 else 'hair')
        # Broken bangs brush the brow, exposing the center part and glasses.
        for sign in [-1,1]:
            for k in range(7):
                path=[]
                for j in range(17):
                    u=j/16;t=lerp(.996,.66+.026*k,u)
                    angle=-math.pi/2+sign*(.10+.065*k+.42*smooth(u))
                    path.append(scalp(p,angle,t,.011))
                ribbon(p,path,.004,.0011)
    elif style in ('rough_crop','wavy_crop'):
        for i in range(80):
            angle=TAU*i/80
            path=[]
            for j in range(12):
                u=j/11;t=lerp(.995-.065*((i*.618)%1),line(angle)+.018,u)
                aa=angle+.24*math.sin(u*2+i*.17)
                c=scalp(p,aa,t,.007+.014*math.sin(math.pi*u)*(.45+.55*((i*.414)%1)))
                path.append(c)
            ribbon(p,path,.0048,.0014,'hair_highlight' if i%17==0 else 'hair')
    elif sparse:
        for i in range(90):
            angle=TAU*i/90
            if math.sin(angle)<-.23:continue
            start=.64+.12*((i*.618)%1)
            end=.13 if style=='balding_fringe' else -.16+.16*((i*.414)%1)
            path=[]
            for j in range(18):
                u=j/17;t=lerp(start,end,u);c=scalp(p,angle,t,.004)
                if t<.35:
                    rx=max(abs(c[0]),p.w*.90*abs(math.cos(angle)))
                    c=(math.copysign(rx,c[0]),p.y(t),c[2]+.019*u)
                path.append((c[0]+.003*math.sin(i+u*7),c[1],c[2]))
            ribbon(p,path,.0035 if style=='balding_fringe' else .005,.0012,
                   'hair_highlight' if i%19==0 else 'hair')
    elif curly:
        # Open helical tufts have real depth and varied radii; previous closed
        # surface loops read as a patterned bonnet, not coiled hair.
        count=190 if style=='short_coils' else 210
        for i in range(count):
            angle=i*2.399963;t=lerp(line(angle)+.018,.987,(i*.41421356)%1)
            center=scalp(p,angle,t,volume+.001)
            radial=_norm((math.cos(angle),.25*(t-.5),math.sin(angle)))
            side=_norm(_cross((0,1,0),radial));up=_norm(_cross(radial,side))
            path=[];radius=(.0045 if style=='short_coils' else .007)*(.7+.5*((i*.37)%1))
            for j in range(14):
                u=j/13;phase=u*TAU*1.35
                path.append(_add(center,_add(_mul(side,radius*math.cos(phase)),
                    _add(_mul(up,radius*math.sin(phase)),_mul(radial,.004*u)))))
            ribbon(p,path,.0018 if style=='short_coils' else .0025,.0009,
                   'hair_highlight' if i%29==0 else 'hair','hair_coil')
        if style=='tied_curls':
            # A gathered bun and tied yellow band correspond to the selected
            # source look; they are not a generic colored headband texture.
            center=(.012,p.y(1.02),.058)
            a.ellipsoid(center,(.068,.063,.060),'hair','Head','gathered_bun',32,20)
            for k in range(35):
                aa=TAU*k/35;path=[]
                for j in range(18):
                    u=j/17;phase=u*math.pi
                    path.append((center[0]+.069*math.cos(aa)*math.sin(phase),
                        center[1]-.052*math.cos(phase),center[2]+.061*math.sin(aa)*math.sin(phase)))
                ribbon(p,path,.003,.0015,region='bun_strand')
            # Short loose forehead curls sit above the eyes rather than a lid.
            for k in range(21):
                aa=-math.pi+.12+(math.pi-.24)*k/20;path=[]
                for j in range(14):
                    u=j/13;tt=lerp(.87,.705+.03*math.sin(k),u)
                    c=scalp(p,aa,tt,.024+.005*math.sin(u*TAU*2+k))
                    path.append((c[0]+.003*math.cos(u*TAU*2),c[1],c[2]))
                ribbon(p,path,.0045,.0018)
    if p.p['band']:
        rows=[]
        for k in range(7):
            row=[]
            for j in range(129):
                angle=TAU*j/128;t=.715+.075*k/6
                c=scalp(p,angle,t,.028)
                row.append((c[0],c[1]+.007*math.cos(angle),c[2]))
            rows.append(row)
        s.grid(rows,'bandana',head,'headband',cap=False)
        # Tied fabric ends are flattened ribbons, not tubular stalks.
        for sign in [-1,1]:
            rows=[]
            for r in range(12):
                u=r/11;row=[]
                for j in range(7):
                    v=j/3-1
                    row.append((sign*(.017+.046*u)+v*.012*(1-.45*u),
                        p.y(.805)+.040*math.sin(math.pi*u)-.004*u,
                        -p.d-.032-.010*math.sin(math.pi*u)+v*.003))
                rows.append(row)
            s.grid(rows,'bandana',head,'band_tie',wrap=False)

    if style=='cap_waves' or p.p.get('black_bandana',False):
        # Source-selected headwear. The backwards cap's visor points away from
        # the face; the referee's tied black bandana has no invented team logo.
        bandana=p.p.get('black_bandana',False)
        # A woven cap/bandana is not leather: use an explicitly rough, nonmetal
        # material. Reuse original micro-normal data, never a source photograph.
        a.mat['headwear_cloth']=a.material('headwear_cloth',(.065,.064,.060),.94)
        a.doc['materials'][a.mat['headwear_cloth']]['normalTexture']=dict(
            a.doc['materials'][a.mat['portrait_skin']]['normalTexture'],scale=.18)
        rows=[]
        for r in range(25):
            row=[]
            for j in range(97):
                angle=TAU*j/96;front=max(0.,-math.sin(angle))
                bottom=.68+.17*front**8 if not bandana else .715+.016*math.sin(angle*3)
                tt=lerp(bottom,1.,r/24)
                c=scalp(p,angle,tt,.012 if bandana else .021)
                wave=.002*math.sin(angle*7+tt*10) if bandana else 0.
                row.append((c[0]+wave*math.cos(angle),c[1]+.014*(r/24),c[2]+wave*math.sin(angle)))
            rows.append(row)
        s.grid(rows,'headwear_cloth',head,'source_headwear',cap=True)
        if not bandana:
            strap=[]
            for r in range(4):
                row=[]
                for j in range(25):
                    x=lerp(-.067,.067,j/24);t=.746+.026*r/3
                    row.append((x,p.y(t),p.front(x,t)-.024))
                strap.append(row)
            s.grid(strap,'headwear_cloth',head,'cap_strap',wrap=False)
            # Visor/back brim kept compact so it cannot obscure the face.
            visor=[]
            for r in range(7):
                u=r/6;row=[]
                for j in range(25):
                    x=(j/12-1)*(.095+.021*u);z=p.d+.022+.10*u
                    row.append((x,p.y(.74)-.016*u+.015*(x/.13)**2,z))
                visor.append(row)
            s.grid(visor,'headwear_cloth',head,'cap_visor',wrap=False)
        else:
            for sign in [-1,1]:
                path=[(sign*.027,p.y(.72),p.d+.022),
                      (sign*.040,p.y(.55),p.d+.037),
                      (sign*.045,p.y(.42),p.d+.030)]
                ribbon(p,path,.017,.002,'headwear_cloth','bandana_tail')
