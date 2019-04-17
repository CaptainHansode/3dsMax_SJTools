def grid_point(grid, i):
    r"""インプット値をグリッド値に補正"""
    q = i // grid
    x = (q * grid) + (grid / 2.0)
    if i > x:
        output = grid * (q + 1)
    else:
        output = grid * q
    return output

g = 3
"""
for i in range(50):
    print(grid_point(g, i))
"""

print(grid_point(5, 7.6))