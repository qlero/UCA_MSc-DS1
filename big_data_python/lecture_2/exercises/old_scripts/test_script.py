import sys

def my_function(x, y):
    return x/y

if __name__ == "__main__":
    try:
        a = int(sys.argv[1])
        b = int(sys.argv[2])
        print(f"OUT: {my_function(a, b)}")    
    except TypeError:
        print("ERROR: Your inputs are not divisable")
    except ZeroDivisionError:
        print("ERROR: Undefined. Your second input cannot be 0")
    except ValueError:
        print("ERROR: At least one of the input is not castable as Integer")
    finally:
        print("Exiting script")
