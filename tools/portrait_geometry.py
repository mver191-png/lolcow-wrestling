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
                       (.28,.94*jaw,.97),(.38,1.00*cheek,1.01),(.48,.99*cheek,1.02),
                       (.56,.92*temple,1.00),(.64,.92*temple,.99),(.74,.93,.98),
                       (.83,.88,.91),(.91,.73,.79),(.975,.39,.46),(1.,.012,.018)]
        self._dimensions_cache={}
        self.materials()

    def materials(self):
        a=self.a;p=self.p
        for key,color,roughness in [
            ('facial_hair',tuple(c*.90 for c in p['hair_color']),.9),
            ('beard_surface',(1.,1.,1.),.88),
            ('beard_highlight',tuple(min(1,c*.75+.10) for c in p['hair_color']),.85),
            ('frame_black',(.075,.071,.068),.48),
            ('frame_metal',(.46,.43,.38),.30),
            ('bandana',(.32,.075,.105),.9),
            ('skin_fold',tuple(c*.89 for c in p['skin']),.77),
            ('lip_natural',tuple(c*k for c,k in zip(p['skin'],(.91,.78,.76))),.64),
            ('eye_white',(.79,.79,.735),.36),
            ('eye_iris',p['iris'],.4)]:
            a.mat[key]=a.material(key,color,roughness,metal=.60 if key=='frame_metal' else 0.)
        a.doc['materials'][a.mat['skin']]['pbrMetallicRoughness']['roughnessFactor']=.73
        a.doc['materials'][a.mat['hair']]['pbrMetallicRoughness']['roughnessFactor']=.89
        self.skin_texture()

    def skin_texture(self):
        # Hand-authored procedural albedo, no photo sampling. Each pixel uses the
        # same angular/height coordinates as this head surface's UVs. Coverage
        # variation and beard roots soften the prior flat material boundaries.
        from roster_base import png
        a=self.a;p=self.p;size=384;pixels=[];style=p['beard'];m=p['mouth_level']
        for row in range(size):
            t=(row+.5)/size;rx,_=self.dim(t)
            for col in range(size):
                angle=TAU*(col+.5)/size;x=rx*math.cos(angle);front=max(0.,-math.sin(angle))
                seed=(col*374761393+row*668265263)&0xffffffff
                seed=((seed^(seed>>13))*1274126177)&0xffffffff
                noise=((seed^(seed>>16))&65535)/65535-.5
                mottling=.006*math.sin(col*.074+row*.03)*math.sin(row*.052)
                redness=.035*sum(g(x,t,v*p['eye_spread'],p['eye_level']-.11,.043,.10) for v in [-1,1])*front**5
                factors=(.98+noise*.018+mottling,.968+noise*.018+mottling-redness,.958+noise*.018+mottling-redness*.82)
                rgb=[c*v for c,v in zip(p['skin'],factors)]
                beard=0.
                if style in ('long_beard','goatee'):
                    width=.13 if style=='long_beard' else .038
                    edge=m+.06+(.10*min(1.,abs(x)/.08) if style=='long_beard' else -.035)
                    beard=math.exp(-(abs(x)/width)**4)*smooth((edge-t)/.105)*(.91 if style=='long_beard' else .90)
                elif style in ('short_stubble','light_stubble','chin_shadow'):
                    width=.16 if style=='short_stubble' else .055 if style=='chin_shadow' else .10
                    beard=math.exp(-(abs(x)/width)**4)*smooth((m+.015-t)/.10)*smooth((t+.02)/.06)
                    beard*=.29 if style=='short_stubble' else .17
                if style in ('long_beard','goatee','short_stubble'):
                    moustache=math.exp(-((t-m-.031)/.019)**2)*math.exp(-(x/(p['mouth_width']*.90))**6)
                    beard=max(beard,moustache*.66)
                beard*=front**5
                if beard>0:
                    density=max(0,min(1,beard*(.91+.18*(noise+.5))))
                    rgb=[lerp(c,h*.98,density) for c,h in zip(rgb,p['hair_color'])]
                pixels.extend(round(255*max(0,min(1,c))) for c in rgb)
        data=png(size,size,pixels)
        a.doc['images'].append({'bufferView':a.view(data),'mimeType':'image/png','name':'original_portrait_albedo'})
        a.doc['textures'].append({'sampler':0,'source':len(a.doc['images'])-1})
        a.mat['portrait_skin']=a.material('portrait_skin',(1,1,1),.74)
        mat=a.doc['materials'][a.mat['portrait_skin']]['pbrMetallicRoughness']
        mat['baseColorTexture']={'index':len(a.doc['textures'])-1}

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
        return z+.009

    def head(self):
        a=self.a;s=self.s;head=lambda pt,i:a.weights('Head')
        rows=[]
        for k in range(65):
            t=k/64;rx,rz=self.dim(t);row=[]
            for j in range(97):
                theta=TAU*j/96;x=rx*math.cos(theta);z=rz*math.sin(theta)+.009
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
        for r in range(9):
            v=r/8;row=[]
            for j in range(33):
                u=j/16-1;arc=math.sqrt(max(.001,1-u*u));x=cx+u*ew
                y=y0+lerp(-opening*.68,opening,v)*arc+sign*u*.001
                z=self.front(x,(y-self.y0)/self.h)-.0015-.003*arc*math.sin(math.pi*v)
                row.append((x,y,z))
            rows.append(row)
        s.grid(rows,'eye_white',head,'eyes',wrap=False)
        cz=self.front(cx,t0)-.0050
        radius=min(.010,opening*1.06)
        a.ellipsoid((cx,y0,cz),(radius,radius,.0020),'eye_iris','Head','eyes',24,14)
        a.ellipsoid((cx,y0,cz-.0016),(radius*.43,radius*.48,.001),'dark','Head','eyes',16,10)
        a.ellipsoid((cx-.002,y0+.0025,cz-.0029),(.00125,.00125,.0007),'white','Head','eyes',8,6)
        for upper in [True,False]:
            path=[]
            for j in range(33):
                u=j/16-1;arc=math.sqrt(max(0,1-u*u));x=cx+u*ew
                y=y0+(opening if upper else -opening*.68)*arc+sign*u*.001
                z=self.front(x,(y-self.y0)/self.h)-.002
                path.append((x,y,z))
            s.tube(path,[.0010+.0012*math.sin(math.pi*j/32) for j in range(33)],'skin',head,'eyelid',8)
            # Upper hood blends toward the brow instead of a thick separate tube.
            hood=[]
            for j,point in enumerate(path):
                u=j/16-1
                offset=(.003+p['hood'])*math.sin(math.pi*j/32)*(1 if upper else -.5)
                yy=point[1]+offset
                hood.append((point[0],yy,self.front(point[0],(yy-self.y0)/self.h)-.0007))
            s.tube(hood,.0010,'skin_fold',head,'eyelid_crease',6)
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
                    yy=self.y(level)+((p['lip']*bow if upper else -p['lip']*.92)*v)*arc
                    zz=self.front(x,(yy-self.y0)/self.h)-.0013-.0025*math.sin(math.pi*v)*arc
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
        halfw=.045 if p['glasses']=='rectangle' else .043;halfh=.022 if frame=='frame_black' else .029
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
            length=.079 if dense else .066
            width=.092 if dense else .039
            for j in range(14):
                u=j/13;yy=lerp(self.y0-length,self.y(m-.045),u)
                half=width*(.10+.90*math.sin(u*math.pi*.75));row=[]
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
                u=i/54*2-1;length=(.060 if dense else .048)*(1-.60*abs(u))+.003*math.sin(i*3.1);x=u*(.072 if dense else .033)
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
        a=self.a;s=self.s;p=self.p;style=p['hair'];head=lambda pt,i:a.weights('Head')
        if style=='close_bald':
            # The source-selected look has an uncovered scalp; no invented cap.
            return
        sparse=style in ('balding_fringe','receding_long')
        long=style in ('parted_shoulder','receding_long','volume_curls')
        # Scalp shell follows each head's skull, with a source-specific hairline.
        if not sparse:
            rows=[]
            for r in range(19):
                row=[]
                for j in range(97):
                    angle=TAU*j/96;front=max(0,-math.sin(angle));side=abs(math.cos(angle))
                    line=.47+.28*front**2 if style=='parted_shoulder' else .56+.20*front**3
                    if style=='rough_crop':line=.61+.14*front**2+.026*math.sin(angle*5)
                    if style=='volume_curls':line=.47+.23*front**3
                    if style=='short_coils':line=.60+.15*front**4
                    t=lerp(line,1,r/18);rx,rz=self.dim(t)
                    volume=.016 if style=='short_coils' else .018 if style=='volume_curls' else .006
                    ripple=.0007*math.sin(angle*31+r*.23)
                    x=(rx+volume+ripple)*math.cos(angle)
                    z=(rz+volume+ripple)*math.sin(angle)+.009
                    if front>0:z=self.front(min(rx*.995,abs(rx*math.cos(angle)))*math.copysign(1,math.cos(angle)),t)-volume-ripple
                    yy=self.y(t)+volume*(r/18)**3
                    row.append((x,yy,z))
                rows.append(row)
            s.grid(rows,'hair',head,'hair_cap',cap=True)
        # Continuous curved locks, with sufficient density to read as hair rather
        # than a band of isolated noodles. Strands remain attached to Head.
        n=100 if style=='volume_curls' else 94 if style=='parted_shoulder' else 44 if sparse else 60
        for i in range(n):
            angle=TAU*i/n;front=max(0,-math.sin(angle))
            if sparse and front>.22:continue
            if style=='parted_shoulder' and front>.65:continue
            if style=='volume_curls' and front>.42:continue
            if style=='short_coils' and front>.55:continue
            if style=='receding_long' and front>.0:continue
            side=abs(math.cos(angle));seed=math.sin(i*13.51)
            if style=='volume_curls':
                tstart=.76+.23*((i*.381966)%1);end=-.05+.34*((i*.71)%1);radius=.010
            elif style=='parted_shoulder':
                tstart=.99-.09*side;end=-.18+.19*((i*.61)%1);radius=.006
            elif sparse:
                tstart=.63+.11*((i*.73)%1);end=(-.08 if style=='receding_long' else .20)+.12*((i*.31)%1);radius=.007
            else:
                tstart=.95+.045*seed;end=.73+.09*((i*.618)%1)+(.055 if front>.4 else 0);radius=.005
            path=[]
            for j in range(15):
                u=j/14;t=lerp(tstart,end,u);rx,rz=self.dim(max(0,min(1,t)))
                if long or sparse:
                    rx=max(rx,self.w*(.92+(.14 if style=='volume_curls' else .04))*smooth(u*3))
                    rz=max(rz,self.d*.72*smooth(u*3))
                curl=.012*math.sin(u*TAU*2.4+i) if style=='volume_curls' else .006*math.sin(u*6+i)
                aa=angle+(.028*math.sin(u*TAU*2+i) if style=='volume_curls' else .035*math.sin(u*4))
                out=.027 if style=='volume_curls' else .009
                xx=(rx+out+curl)*math.cos(aa)
                zz=(rz+out+curl)*math.sin(aa)+.009
                yy=self.y(t)+(.018*(1-u) if style=='rough_crop' else 0)
                if not long and not sparse:
                    yy+=.014*math.sin(math.pi*u)*(1+seed*.35)
                path.append((xx,yy,zz))
            radii=[max(.0004,radius*(.28+.72*math.sin(math.pi*(j+.7)/15.5))*(1-.94*smooth((j/14-.76)/.24))) for j in range(15)]
            s.tube(path,radii,'hair_highlight' if i%9==0 else 'hair',head,'hair_lock',8)
        if style in ('volume_curls','short_coils'):
            # Dense loops sit ON the shaped cap, rather than being buried inside
            # it. Their size is deliberately small: silhouette and light breakup
            # should read as coils rather than large ribbons or beads.
            count=330 if style=='short_coils' else 260
            for i in range(count):
                aa=i*2.399963;front=max(0,-math.sin(aa))
                line=(.60+.15*front**4) if style=='short_coils' else (.47+.23*front**3)
                tt=lerp(line+.010,.996,(i*.41421356)%1)
                radius=.004 if style=='short_coils' else .0065
                centers=[]
                for j in range(13):
                    u=TAU*j/12;angle=aa+math.cos(u)*.026
                    t=max(line,min(.999,tt+radius/self.h*math.sin(u)))
                    rx,rz=self.dim(t);volume=.016 if style=='short_coils' else .018
                    x=(rx+volume)*math.cos(angle)
                    z=(rz+volume)*math.sin(angle)+.009
                    if math.sin(angle)<0:
                        z=self.front(rx*math.cos(angle),t)-volume
                    x+=.0025*math.cos(angle);z+=.0025*math.sin(angle)
                    centers.append((x,self.y(t)+volume*((t-line)/(1-line))**3,z))
                s.tube(centers,.0015 if style=='short_coils' else .0019,'hair_highlight' if i%13==0 else 'hair',head,'curl',6)
        if p['band']:
            rows=[]
            for k in range(5):
                row=[]
                for j in range(97):
                    angle=TAU*j/96;front=max(0,-math.sin(angle));t=.70+.035*k/4
                    rx,rz=self.dim(t);row.append(((rx+.021)*math.cos(angle),self.y(t)+.007*math.cos(angle),(rz+.025)*math.sin(angle)+.009))
                rows.append(row)
            s.grid(rows,'bandana',head,'headband',cap=False)
            # Two tucked fabric ends; no floating logo or borrowed pattern.
            for sign in [-1,1]:
                s.tube([(sign*.035,self.y(.76),self.d+.02),(sign*.070,self.y(.64),self.d+.031)],.009,'bandana',head,'band_tie',8)

    def halo(self):
        a=self.a;s=self.s;head=lambda pt,i:a.weights('Head')
        path=[(.238*math.cos(TAU*i/64),2.01,.238*math.sin(TAU*i/64)) for i in range(65)]
        s.tube(path,.012,'halo',head,'halo',10)


def enabled(key):return STUDIES[key]['status']=='source_attributed_study'

def build_head(asset,surfaces):
    portrait=Portrait(asset,surfaces)
    portrait.head();portrait.hair()
    if asset.key=='referee_cobra':portrait.halo()
