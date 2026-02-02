dataset = """ w, 2, z, 4, -, 0
 o, 1, z, 3, n, 9
 n, 2, o, 4, -, 0
 w, 3, o, 5, n, 1
 w, 4, -, 0, -, 0
 z, 9, o, 7, -, 0
 w, 6, o, 8, -, 0
 w, 7, -, 0, -, 0
 z, 2, n, 6, -, 0
 u, 9, -, 0, -, 0
 u, 9, -, 0, -, 0
 u, 9, z,13, -, 0
 n,12, o,14, z,17
 w,13, o,15, z,16
 w,14, -, 0, -, 0
 n,14, w,17, -, 0
 u, 1, n,13, o,16
 o,19, -, 0, -, 0
 w,18, h,20, -, 0
 l,19, -, 0, -, 0
 u,13, z,22, -, 0
 n,21, o,23, -, 0
 w,22, n,24, z,25
 u,14, z,23, -, 0
 n,23, w,26, -, 0
 u,17, l,27, o,25
 u,18, h,26, -, 0
 u, 5, z,29, -, 0
 n,28, -, 0, -, 0
 u,28, z,31, -, 0
 h,29, n,30, -, 0
 o,31, w,33, -, 0
 o,32, -, 0, -, 0
 u, 8, -, 0, -, 0
 u,36, -, 0, -, 0
 -, 0, -, 0, -, 0
 u,36, -, 0, -, 0"""

label_map = {
    'w': 'west',
    'o': 'oost',
    'n': 'noord',
    'z': 'zuid',
    'l': 'omlaag',
    'h': 'omhoog',
    'u': 'uit'
}

lines = dataset.strip().split('\n')
dot_lines = ["digraph G {"]

for idx, line in enumerate(lines, 1):
    parts = [p.strip() for p in line.split(',')]
    # Process pairs: (direction, destination)
    for i in range(0, len(parts), 2):
        direction = parts[i]
        destination = parts[i+1]

        if direction != '-':
            label = label_map.get(direction, direction)
            dot_lines.append(f'    {idx} -> {destination} [label="{label}"]')

dot_lines.append("}")

with open('graph.gv', 'w') as f:
    f.write("\n".join(dot_lines))