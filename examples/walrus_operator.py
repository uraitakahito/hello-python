# セイウチ演算子(walrus operator)

array = [1,2,3,4,5,6,7]
if len(array) > 5:
    print(len(array))

array = [1,2,3,4,5,6,7]
if (n := len(array)) > 5:
    print(n)

