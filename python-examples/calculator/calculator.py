# Простой калькулятор: сложение, вычитание, умножение, деление

def calculator():
    print("Введите первое число:")
    a = float(input())

    print("Введите второе число:")
    b = float(input())

    print("Выберите операцию (+, -, *, /):")
    operation = input()

    if operation == '+':
        result = a + b
    elif operation == '-':
        result = a - b
    elif operation == '*':
        result = a * b
    elif operation == '/':
        if b == 0:
            print("Ошибка: деление на 0")
            return
        result = a / b
    else:
        print("Неверная операция")
        return

    print(f"Результат: {result}")


calculator()
