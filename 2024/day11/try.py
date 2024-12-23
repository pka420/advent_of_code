from functools import cache
@cache
def f(s,b):
    return 1 if b==0 else f(1,b-1) if s==0 else f(int(x[:len(x)//2]),b-1)+f(int(x[len(x)//2:]),b-1) if len(x:=str(s))%2==0 else f(s*2024,b-1)
print("\n".join([str(sum(f(s,b) for s in map(int, open("input.txt").read().strip().split()))) for b in [25,75]]))

