"""Reference-guided, original portrait surfaces for the existing skinned actors.

No photograph is sampled or embedded. Shapes are manually authored art controls.
The 46-joint bind contract and every gameplay/contact landmark are left intact.
"""
from __future__ import annotations
import math
from likeness_profiles import STUDIES

TAU=math.tau

def lerp(a,b,t):return a+(b-a)*t
def smooth(t):
    t=max(0.,min(1.,t));return t*t*(3-2*t)
def g(x,y,cx,cy,sx,sy):return math.exp(-((x-cx)/sx)**2-((y-cy)/sy)**2)
def mix(a,b,t):return tuple(lerp(x,y,t) for x,y in zip(a,b))

class Portrait:
    def __init__(self,asset,surfaces):
        self.a=asset;self.s=surfaces;self.p=STUDIES[asset.key]
        self.w=self.p['width'];self.h=self.p['height'];self.y0=self.p['chin'];self.d=self.p['depth']
        jaw=self.p['jaw'];cheek=self.p['cheek'];temple=self.p['temple']
        self.sections=[(0.,.28,.53),(.035,.46,.64),(.10,.67*jaw,.78),(.18,.83*jaw,.88),
                       (.28,.93*jaw,.97),(.38,.995*cheek,1.01),(.48,.99*cheek,1.02),
                       (.56,.97*temple,1.00),(.64,.965*temple,.99),(.74,.93,.98),
                       (.83,.88,.91),(.91,.73,.79),(.975,.39,.46),(1.,.012,.018)]
        self._dimensions_cache={}
        self.materials()

    def materials(self):
        a=self.a;p=self.p
        for key,color,roughness in [
            ('facial_hair',tuple(c*.90 for c in p.get('beard_color',p['hair_color'])),.9),
            ('beard_surface',(1.,1.,1.),.88),
            ('beard_highlight',tuple(min(1,c*.75+.10) for c in p['hair_color']),.85),
            ('frame_black',(.075,.071,.068),.48),
            ('frame_metal',(.46,.43,.38),.30),
            ('bandana',p.get('band_color',(.32,.075,.105)),.94),
            ('skin_fold',tuple(c*.89 for c in p['skin']),.77),
            ('lip_natural',tuple(c*k for c,k in zip(p['skin'],(.97,.72,.72))),.64),
            ('eye_white',(.79,.79,.735),.36),
            ('eye_iris',p['iris'],.4)]:
            a.mat[key]=a.material(key,color,roughness,metal=.60 if key=='frame_metal' else 0.)
        a.doc['materials'][a.mat['skin']]['pbrMetallicRoughness']['roughnessFactor']=.73
        a.doc['materials'][a.mat['hair']]['pbrMetallicRoughness']['roughnessFactor']=.89
        self.skin_texture()
        self.eye_texture()

    def skin_texture(self):
        from portrait_materials import skin_material
        skin_material(self)

    def eye_texture(self):
        from portrait_materials import eye_material
        eye_material(self)

    def y(self,t):return self.y0+self.h*t

    def dim(self,t):
        # Monotone cubic Hermite interpolation has a continuous radius derivative.
        # Smoothstep on every ring had produced horizontal bands in the render.
        t=max(0.,min(1.,t))
        if t in self._dimensions_cache:return self._dimensions_cache[t]
        rows=self.sections
        for i in range(len(rows)-1):
            if t>rows[i+1][0]:continue
            h=rows[i+1][0]-rows[i][0];u=(t-rows[i][0])/h;out=[]
            for c,scale in [(1,self.w),(2,self.d)]:
                slopes=[(rows[k+1][c]-rows[k][c])/(rows[k+1][0]-rows[k][0]) for k in range(len(rows)-1)]
                def tangent(k):
                    if k==0:return slopes[0]
                    if k==len(rows)-1:return slopes[-1]
                    l,r=slopes[k-1],slopes[k]
                    if l*r<=0:return 0.
                    hl=rows[k][0]-rows[k-1][0];hr=rows[k+1][0]-rows[k][0]
                    return (3*(hl+hr))/((2*hr+hl)/l+(hr+2*hl)/r)
                m0,m1=tangent(i),tangent(i+1)
                value=(2*u**3-3*u*u+1)*rows[i][c]+(u**3-2*u*u+u)*h*m0+(-2*u**3+3*u*u)*rows[i+1][c]+(u**3-u*u)*h*m1
                out.append(max(.001,value*scale))
            self._dimensions_cache[t]=tuple(out)
            return self._dimensions_cache[t]
        return .001,.001

    def front(self,x,t):
        """Front skin surface in the actor's original Y-up, -Z coordinate frame."""
        p=self.p;rx,rz=self.dim(t)
        # More planar facial mask, rounded sides and distinct jaw/temple profiles.
        q=min(.999,abs(x)/max(rx,.001))
        z=-rz*math.sqrt(max(.001,1-q*q))
        fade=(1-q*q)**1.7
        z=lerp(z,-rz*(1-.18*q*q),fade)
        # Integrated nose including tip, bridge and alae, not an attached sphere.
        n=p['nose_level'];nw=p['nose_width'];projection=p['nose_projection']
        nose=projection*g(x,t,0,n,nw,.050)
        bridge=p['bridge']*g(x,t,0,n+.093,nw*.63,.091)
        wings=.011*(g(x,t,nw*.78,n-.009,nw*.50,.022)+g(x,t,-nw*.78,n-.009,nw*.50,.022))
        z-=nose+bridge+wings
        # Subtle zygomatic planes and inset eyelids replace the former wide stare.
        eyes=p['eye_level'];ex=p['eye_spread']
        z+=.0045*(g(x,t,ex,eyes,p['eye_width']*1.2,.041)+g(x,t,-ex,eyes,p['eye_width']*1.2,.041))
        z-=.006*(g(x,t,ex*1.13,eyes-.14,.047,.083)+g(x,t,-ex*1.13,eyes-.14,.047,.083))
        z-=.005*g(x,t,0,.09,.061,.060)
        # Mouth plane and philtrum; no teeth, wounds or exaggerated medical traits.
        m=p['mouth_level'];z-=.004*g(x,t,0,m+.014,p['mouth_width'],.060)
        z+=.002*g(x,t,0,m+.064,.009,.038)
        # Brow cushions, nasolabial planes and the labiomental transition are
        # part of the skin surface, not floating dark lines or separate beads.
        z-=.007*(g(x,t,ex,eyes+.065,.036,.040)+g(x,t,-ex,eyes+.065,.036,.040))
        z-=.0025*(g(x,t,ex,eyes-.044,.031,.026)+g(x,t,-ex,eyes-.044,.031,.026))
        crease=p.get('crease',.5)
        naso_x=p['nose_width']*.88+(n-t)*.072
        naso_gate=math.exp(-((t-(n+m)*.5)/max(.04,(n-m)*.68))**4)
        z+=.0017*crease*math.exp(-((abs(x)-naso_x)/.0045)**2)*naso_gate
        z+=.0025*g(x,t,0,m-.075,p['mouth_width']*.73,.024)
        # Soft philtrum columns connect nasal base to the cupid's bow.
        z-=.0015*(g(x,t,.007,m+.044,.003,.023)+g(x,t,-.007,m+.044,.003,.023))
        return z+.009

    def head(self):
        a=self.a;s=self.s;head=lambda pt,i:a.weights('Head')
        rows=[]
        for k in range(97):
            t=k/96;rx,rz=self.dim(t);row=[]
            for j in range(129):
                theta=TAU*j/128;x=rx*math.cos(theta);z=rz*math.sin(theta)+.009
                if math.sin(theta)<0:
                    z=self.front(x,t)
                # Very small asymmetry stops a mechanically mirrored mask, while
                # remaining an art choice rather than a likeness measurement.
                x+=.0012*math.sin(t*5.0)*max(0,-math.sin(theta))
                row.append((x,self.y(t),z))
            rows.append(row)
        s.grid(rows,'portrait_skin',head,'head',cap=True)
        # Blend under-jaw into the unchanged neck with a small fitted chin support.
        for sign in [-1,1]:
            self.ear(sign)
            self.eye(sign)
        self.mouth()
        self.nostrils()
        self.facial_hair()
        self.glasses()

    def ear(self,sign):
        a=self.a;s=self.s;head=lambda pt,i:a.weights('Head');cx=sign*self.w*.97;cy=self.y(.50)
        a.ellipsoid((cx,cy,.008),(.024,.039,.023),'skin','Head','ear',20,12)
        # Concha and helix, attached at the face side rather than cartoon disks.
        a.ellipsoid((cx+sign*.010,cy-.002,-.008),(.009,.023,.006),'skin_fold','Head','ear_detail',16,8)
        path=[(cx+sign*.013+sign*.011*math.cos(TAU*i/28),cy+.032*math.sin(TAU*i/28),-.006-.007*math.cos(TAU*i/28)) for i in range(29)]
        s.tube(path,.0028,'skin',head,'ear_helix',7)

    def eye(self,sign):
        a=self.a;s=self.s;p=self.p;head=lambda pt,i:a.weights('Head')
        cx=sign*p['eye_spread'];t0=p['eye_level'];y0=self.y(t0);ew=p['eye_width'];opening=p['eye_open']
        # A shallow almond surface occupies the actual aperture. This avoids a
        # large white eyeball pushing through the cheek on a full face.
        rows=[]
        for r in range(17):
            v=r/16;row=[]
            for j in range(49):
                u=j/24-1;arc=math.sqrt(max(.001,1-u*u));x=cx+u*ew
                y=y0+lerp(-opening*.70,opening,v)*arc+sign*u*.001
                z=self.front(x,(y-self.y0)/self.h)-.0017-.0032*arc*math.sin(math.pi*v)
                row.append((x,y,z))
            rows.append(row)
        s.grid(rows,'portrait_eye',head,'eyes',wrap=False)
        for upper in [True,False]:
            path=[]
            for j in range(33):
                u=j/16-1;arc=math.sqrt(max(0,1-u*u));x=cx+u*ew
                y=y0+(opening if upper else -opening*.68)*arc+sign*u*.001
                z=self.front(x,(y-self.y0)/self.h)-.002
                path.append((x,y,z))
            s.tube(path,[.0010+.0012*math.sin(math.pi*j/32) for j in range(33)],'skin',head,'eyelid',8)
            # Tissue ramps from the aperture onto the orbital skin, with a
            # continuous broad lid surface and a very shallow crease.
            lid_rows=[]
            for r in range(6):
                v=r/5;row=[]
                for j,point in enumerate(path):
                    arch=math.sin(math.pi*j/32)
                    yy=point[1]+(.011+p['hood'])*arch*v*(1 if upper else -.65)
                    zz=self.front(point[0],(yy-self.y0)/self.h)-.0004-.0017*(1-v)*arch
                    row.append((point[0],yy,zz))
                lid_rows.append(row)
            if not upper:lid_rows.reverse()
            s.grid(lid_rows,'skin',head,'eyelid_tissue',wrap=False)
        # Sparse eyebrow fibers on a broad low ridge, sized separately per study.
        for fiber in range(35):
            u=fiber/34*2-1;x=cx+u*(ew*1.08);t=t0+.073+.009*(1-u*u)
            for offset in [0,.001]:
                path=[]
                for j in range(3):
                    xx=x+(j-1)*.0012*sign;yy=self.y(t)+offset+(j/2-.5)*p['brow']
                    path.append((xx,yy,self.front(xx,(yy-self.y0)/self.h)-.0012))
                s.tube(path,.00062,'hair',head,'brow',5)

    def mouth(self):
        a=self.a;s=self.s;p=self.p;head=lambda pt,i:a.weights('Head');mw=p['mouth_width'];level=p['mouth_level']
        # Upper and lower vermilion are thin fitted surfaces, not a colored bead.
        for upper in [True,False]:
            rows=[]
            for r in range(5):
                v=r/4;row=[]
                for j in range(33):
                    u=j/16-1;arc=(max(0,1-u*u))**.7;x=u*mw
                    bow=(1-.25*math.exp(-(u/.23)**2)) if upper else 1.0
                    yy=self.y(level)+((p['lip']*bow if upper else -p['lip']*1.10)*v)*arc
                    zz=self.front(x,(yy-self.y0)/self.h)-.0014-.0040*math.sin(math.pi*v)*arc
                    row.append((x,yy,zz))
                rows.append(row)
            if not upper:rows.reverse()
            s.grid(rows,'lip_natural',head,'lip',wrap=False)
        path=[]
        for j in range(33):
            u=j/16-1;x=u*mw;yy=self.y(level)+.0006*(1-u*u)
            path.append((x,yy,self.front(x,(yy-self.y0)/self.h)-.0018))
        s.tube(path,[.00035+.00040*math.sin(math.pi*j/32) for j in range(33)],'skin_fold',head,'mouth_seam',6)

    def nostrils(self):
        a=self.a;p=self.p
        for sign in [-1,1]:
            x=sign*p['nose_width']*.65;t=p['nose_level']-.035
            a.ellipsoid((x,self.y(t),self.front(x,t)-.0008),(.0052,.0026,.0018),'skin_fold','Head','nostril',14,8)

    def glasses(self):
        a=self.a;s=self.s;p=self.p
        if p['glasses']=='none':return
        head=lambda pt,i:a.weights('Head');cx=p['eye_spread'];cy=self.y(p['eye_level']+.006)
        frame='frame_metal' if p['glasses']=='wire_oval' else 'frame_black'
        z=min(self.front(cx,p['eye_level'])-.013,-self.d-.016)
        halfw=p.get('frame_width',.045 if p['glasses']=='rectangle' else .043);halfh=p.get('frame_height',.022 if frame=='frame_black' else .029)
        for sign in [-1,1]:
            path=[]
            for j in range(65):
                t=TAU*j/64
                if p['glasses']=='rectangle':
                    xx=math.copysign(abs(math.cos(t))**.48,math.cos(t))*halfw
                    yy=math.copysign(abs(math.sin(t))**.48,math.sin(t))*halfh
                else:xx=halfw*math.cos(t);yy=halfh*math.sin(t)
                path.append((sign*cx+xx,cy+yy,z+abs(xx)*.10))
            s.tube(path,.0018 if frame=='frame_metal' else .0030,frame,head,'glasses_frame',8)
            # Temples attach the frames to the ears. No opaque lenses obscure eyes.
            s.tube([(sign*(cx+halfw),cy,z+.002),(sign*(self.w+.013),cy+.003,-.05),(sign*(self.w+.010),cy-.003,.025)],
                   .0018 if frame=='frame_metal' else .0023,frame,head,'glasses_temple',8)
        bridge=[(-cx+halfw,cy+.006,z),(-.009,cy+.010,z-.010),(.009,cy+.010,z-.010),(cx-halfw,cy+.006,z)]
        s.tube(bridge,.0016 if frame=='frame_metal' else .0025,frame,head,'glasses_bridge',8)

    def facial_hair(self):
        a=self.a;s=self.s;p=self.p;style=p['beard'];head=lambda pt,i:a.weights('Head')
        if style=='none':return
        long=style in ('long_beard','goatee');dense=style=='long_beard';m=p['mouth_level']
        # Hair is a conforming patch with many varied fibers, not a sphere below
        # the chin. Stubble stays translucent in coverage by leaving skin exposed.
        if long:
            rows=[]
            length=p.get('beard_length',.052 if dense else .040)
            width=.079 if dense else .034
            for j in range(14):
                u=j/13;yy=lerp(self.y0-length,self.y(m-.045),u)
                half=width*(.19+.81*math.sin(u*math.pi*.66));row=[]
                for k in range(25):
                    q=k/12-1;x=q*half
                    t=max(0,(yy-self.y0)/self.h)
                    z=self.front(x,t)-.005-.010*(1-q*q)
                    if yy<self.y0:z=lerp(-self.d*.40,self.front(x,0)-.006,u/.47 if u<.47 else 1.)
                    row.append((x,yy,z))
                rows.append(row)
            s.grid(rows,'beard_surface',head,'beard',wrap=False)
        count=100 if dense else 60 if style=='short_stubble' else 35
        for i in range(count):
            u=(i*.61803398875)%1;v=(i*.41421356237)%1
            x=(u*2-1)*self.w*(.83 if dense or style=='short_stubble' else .58)
            t=.03+v*(m+.015)
            if abs(x)<p['mouth_width']*1.03 and t>m-.035:continue
            if style in ('chin_shadow','goatee') and abs(x)>.048:continue
            yy=self.y(t);z=self.front(x,t)-.0015
            length=.007 if dense else .0018 if style in ('short_stubble','light_stubble') else .0025
            path=[(x,yy,z),(x+.0015*math.sin(i),yy-length*.5,z-.001),(x+.003*math.sin(i),yy-length,z-.001)]
            s.tube(path,[.00040,.00028,.0001], 'beard_highlight' if i%9==0 else 'facial_hair',head,'beard_strand',5)
        if long:
            # Tapering chin fibers break the straight patch silhouette.
            for i in range(55):
                u=i/54*2-1;length=p.get('beard_length',.052 if dense else .040)*(1-.60*abs(u))+.003*math.sin(i*3.1);x=u*(.072 if dense else .033)
                y0=self.y(.105);z0=self.front(x,.105)-.012
                path=[(x,lerp(y0,self.y0-length,j/8),z0+.018*(j/8)**2+.004*math.sin(i+j*.6)) for j in range(9)]
                s.tube(path,[.0010*(1-j/9)+.0001 for j in range(9)],'beard_highlight' if i%8==0 else 'facial_hair',head,'beard_strand',6)
        # Moustache left/right patches follow the upper lip and philtrum.
        if style not in ('light_stubble','chin_shadow'):
            for sign in [-1,1]:
                for i in range(22):
                    x=sign*(.006+i/21*p['mouth_width']*.88);t=m+.028+.012*math.sin(i/21*math.pi)
                    y=self.y(t);z=self.front(x,t)-.0018
                    s.tube([(x,y,z),(x+sign*.002,y-.004,z-.001)],.0008,'facial_hair',head,'moustache',5)

    def hair(self):
        from portrait_hair import build_hair
        build_hair(self)

    def halo(self):
        a=self.a;s=self.s;head=lambda pt,i:a.weights('Head')
        path=[(.238*math.cos(TAU*i/64),2.01,.238*math.sin(TAU*i/64)) for i in range(65)]
        s.tube(path,.012,'halo',head,'halo',10)


def enabled(key):return STUDIES[key]['status']=='source_attributed_study'

def build_head(asset,surfaces):
    portrait=Portrait(asset,surfaces)
    portrait.head();portrait.hair()
    if asset.key=='referee_cobra':portrait.halo()
