"""Measure real exported portrait seams, not a polygon-count proxy.

Usage: python tools/audit_portrait_seams.py [--baseline-zip previous-package.zip]
Outputs JSON to stdout; no models are changed. Requires only the standard library.
"""
from __future__ import annotations
import argparse
import json
import math
from pathlib import Path
import struct
import zipfile


def measure(data: bytes, name: str) -> dict:
    magic,version,total=struct.unpack_from('<4sII',data)
    if (magic,version,total)!=(b'glTF',2,len(data)):
        raise ValueError('Invalid GLB header: '+name)
    n,kind=struct.unpack_from('<I4s',data,12)
    if kind!=b'JSON':
        raise ValueError('Missing JSON chunk: '+name)
    doc=json.loads(data[20:20+n]);binary=data[28+n:]
    def accessor(index):
        a=doc['accessors'][index];view=doc['bufferViews'][a['bufferView']]
        dims={'VEC2':2,'VEC3':3,'VEC4':4}[a['type']]
        if a['componentType']!=5126:
            raise ValueError('Expected float geometry')
        stride=view.get('byteStride',dims*4)
        offset=view.get('byteOffset',0)+a.get('byteOffset',0)
        return [struct.unpack_from('<'+'f'*dims,binary,offset+i*stride) for i in range(a['count'])]
    for primitive in doc['meshes'][0]['primitives']:
        if doc['materials'][primitive['material']]['name']!='portrait_skin':
            continue
        values=accessor(primitive['attributes']['POSITION'])
        normals=accessor(primitive['attributes']['NORMAL'])
        uv=accessor(primitive['attributes']['TEXCOORD_0'])
        first={round(v[1],6):i for i,v in enumerate(uv) if v[0]==0.}
        last={round(v[1],6):i for i,v in enumerate(uv) if v[0]==1.}
        if len(first)!=97 or first.keys()!=last.keys():
            raise ValueError('Unexpected portrait seam topology: '+name)
        return {'character':name,'seam_pairs':len(first),
                'maximum_gap_m':max(math.dist(values[first[t]],values[last[t]]) for t in first),
                'maximum_normal_difference':max(math.dist(normals[first[t]],normals[last[t]]) for t in first)}
    raise ValueError('Portrait skin not found: '+name)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--models',type=Path,default=Path(__file__).resolve().parents[1]/'assets/models')
    parser.add_argument('--baseline-zip',type=Path)
    args=parser.parse_args()
    result={'current':[]}
    entries=json.loads((args.models/'roster_manifest.json').read_text())['entries']
    actor_files={entry['file'] for entry in entries}
    for path in sorted(args.models/name for name in actor_files):
        result['current'].append(measure(path.read_bytes(),path.stem))
    if args.baseline_zip:
        result['baseline']=[]
        with zipfile.ZipFile(args.baseline_zip) as archive:
            for name in sorted(archive.namelist()):
                path=Path(name)
                if '/assets/models/' in '/'+name and path.name in actor_files:
                    result['baseline'].append(measure(archive.read(name),path.stem))
    print(json.dumps(result,indent=2))

if __name__=='__main__':
    main()
