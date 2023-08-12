def collatzIteration(n):
    if n % 2 == 0:
        return n // 2
    else:
        return 3 * n + 1

def test():
    for n in range(1, 200):
        p = n
        for _ in range(5):
            p = collatzIteration(p)
        print(p)
test()