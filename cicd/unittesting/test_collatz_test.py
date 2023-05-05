def conjetura_de_collatz(number):
    if (int(number)>0):
        i=0
        while number!=1:
            print(number)
            if (number%2==0):   #Si es par
                number=number/2
            else:               #Si es impar
                number=(3*number)+1 
            i=i+1
        return i
    else:
        print(f"{number} 0 or smaller")
        return None

def test_results_null():
    assert conjetura_de_collatz(-2)==None
    assert conjetura_de_collatz(0)==None

def test_results_valid():
    assert conjetura_de_collatz(12)==int(9)
    assert conjetura_de_collatz(23952385)==int(115)

# def test_no_math():
#     file1 = open('lambdas/collatz/main.py', 'r')
#     Lines = file1.readlines()
#     math_method_detected=False
#     # Strips the newline character
#     i=0
#     while (i<len(Lines)) and (math_method_detected==False):
#         if "import math" in Lines[i]:
#             math_method_detected=True
#             print(f"Found math lib in line {i+1}:")
#             print(Lines[i])
#         i=i+1

#     assert not math_method_detected

