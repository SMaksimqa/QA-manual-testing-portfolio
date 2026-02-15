# Test Case #1: Авторизация на сайте DemoQA (positive + negative)

ID: TC_LOGIN_001  
Название: Успешная авторизация + негативные сценарии на DemoQA Book Store Application  
Предусловие: Открыт браузер, перейдена страница https://demoqa.com/login  
Окружение: Chrome latest / Windows 11  
Приоритет: High  
Тип теста: Functional / UI / Regression  

### Positive сценарий

Шаги:
1. В поле Username ввести валидный логин: testuser123
2. В поле Password ввести валидный пароль: Test@12345
3. Нажать кнопку Login

Ожидаемый результат:
- Пользователь успешно авторизован
- Отображается сообщение "Welcome, testuser123!" или перенаправление на профиль
- Кнопка Logout становится активной
- Нет ошибок в консоли DevTools

Постусловие: Разлогиниться (Logout)

### Negative сценарии

Негатив 1: Неверный пароль  
Шаги: Username — testuser123, Password — wrongpass → Login  
Ожидаемый результат: Сообщение об ошибке «Invalid username or password!»  
Статус поля: красная подсветка или иконка ошибки

Негатив 2: Пустые поля  
Шаги: Оставить Username и Password пустыми → Login  
Ожидаемый результат: Сообщение «Please fill out this field» (или аналогичное) под каждым полем

Негатив 3: Неверный логин  
Шаги: Username — fakeuser, Password — Test@12345 → Login  
Ожидаемый результат: Ошибка «Invalid username or password!»

Негатив 4: Специальные символы в логине  
Шаги: Username — test@#$%user, Password — Test@12345 → Login  
Ожидаемый результат: Ошибка валидации или сообщение о недопустимых символах (если есть ограничение)

Негатив 5: Ввод в поле Username 100+ символов  
Ожидаемый результат: Поле обрезается / появляется ошибка валидации / запрос не проходит

