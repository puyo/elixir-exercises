import Debug.Trace

fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)

main = putStrLn(show(fib 10))
