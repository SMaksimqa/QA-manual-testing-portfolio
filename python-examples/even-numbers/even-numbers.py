# even-numbers.py
# Выводит все чётные числа от 1 до N

n = int(input("Введите число N: "))

even_list = []

for i in range(1, n + 1):
    if i % 2 == 0:
        even_list.append(i)

print("Чётные числа:", even_list)
print("Количество чётных:", len(even_list))
