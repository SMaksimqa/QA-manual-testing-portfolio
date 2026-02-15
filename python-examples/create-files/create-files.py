def create_files(n: int):
    if n < 1:
        print("Ошибка: число N должно быть больше 0")
        return

    for i in range(1, n + 1):
        filename = f"{i}.txt"
        with open(filename, 'w', encoding='utf-8') as file:
            pass
        print(f"Создан файл: {filename}")



if __name__ == "__main__":
    try:
        number = int(input("Введите число N: "))
        create_files(number)
    except ValueError:
        print("Ошибка: введите целое число")
