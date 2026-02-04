# create_files.py
# Урок 14: Функции, аргументы, работа с файлами
# Задача: создать N пустых текстовых файлов (1.txt, 2.txt, ..., N.txt)

def create_files(n: int):
    """
    Создаёт n пустых текстовых файлов в текущей папке.
    
    Аргументы:
        n (int): количество файлов (от 1 до n)
    """
    if n < 1:
        print("Ошибка: число N должно быть больше 0")
        return
    
    for i in range(1, n + 1):
        filename = f"{i}.txt"
        with open(filename, 'w', encoding='utf-8') as file:
            pass  # создаём пустой файл
        print(f"Создан файл: {filename}")


if name == "__main__":
    try:
        number = int(input("Введите число N: "))
        create_files(number)
    except ValueError:
        print("Ошибка: введите целое число")
