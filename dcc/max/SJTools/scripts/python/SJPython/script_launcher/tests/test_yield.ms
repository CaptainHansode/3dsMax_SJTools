class ReiteratableWrapper(object):
	def __init__(self, f):
		self._f = f

	def __iter__(self):
		return self._f()

def test_yield():
	my_list = ['a', 'b', 'c', 'd']
	for item in my_list:
		yield item

import functools
f = functools.partial(test_yield)

tes_dict = {"aaa":True}
if "aaaa" in tes_dict:
	print("hit")
for i in tes_dict:
	print(i)



#g2 = ReiteratableWrapper(f)
tesitr = ReiteratableWrapper(f)

print("1")
for i in tesitr:
	print(i)
print("2")
for i in tesitr:
	print(i)
print("3")
for i in tesitr:
	print(i)
print("4")
for i in tesitr:
	print(i)
print("5")
for i in tesitr:
	print(i)
print("6")
for i in tesitr:
	print(i)
print("7")
for i in tesitr:
	print(i)
print("8")
for i in tesitr:
	print(i)
print("9")
for i in tesitr:
	print(i)
print("10")
for i in tesitr:
	print(i)
print("11")
for i in tesitr:
	print(i)