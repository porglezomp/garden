from __future__ import print_function
import sys

if len(sys.argv) < 2:
    print("Usage: {} <obj>".format(sys.argv[0]))

verts = []
norms = []
uvs = []
index = []
uniq_verts = {}
real_verts = []
counter = 0

for line in open(sys.argv[1]):
    line = line.strip()
    if line[0] == '#':
        continue

    parts = line.split()
    if parts[0] == 'v':
        verts.append(list(map(float, parts[1:])))
    elif parts[0] == 'vn':
        norms.append(list(map(float, parts[1:])))
    elif parts[0] == 'vt':
        uvs.append(list(map(float, parts[1:])))
    elif parts[0] == 'f':
        for part in parts[1:]:
            if part not in uniq_verts:
                bits = part.split('/')
                uniq_verts[part] = counter
                index.append(counter)
                counter += 1
                if bits[1] == '':
                    real_verts.append((verts[int(bits[0])-1],
                                       norms[int(bits[2])-1]))
                else:
                    real_verts.append((verts[int(bits[0])-1],
                                       norms[int(bits[2])-1],
                                       uvs[int(bits[1])-1]))
            else:
                index.append(uniq_verts[part])

if uvs:
    print('''\
attrib count 3
stride 32
float size 3 offset 0
float size 3 offset 12
float size 2 offset 24
''')

    print('data count {}'.format(len(real_verts)*8))
    for vert, norm, uv in real_verts:
        print(*(vert + norm + uv))
else:
    print('''\
attrib count 2
stride 24
float size 3 offset 0
float size 3 offset 12
''')

    print('data count {}'.format(len(real_verts)*6))
    for vert, norm in real_verts:
        print(*(vert + norm))

print()

print('index count {}'.format(len(index)))
for i, idx in enumerate(index):
    print(idx, end='\n' if i % 3 == 2 else ' ')
