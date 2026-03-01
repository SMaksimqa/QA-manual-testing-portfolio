
# Charles Proxy Examples

Использовал Charles для перехвата трафика, mock и throttling на сайте https://the-internet.herokuapp.com/login.

## 1. Перехват трафика (Intercept)
- POST /authenticate с log/pass.  
- Body: username=tomsmith, password=SuperSecretPassword!  
- Статус: 303 See Other.  
Скрин: 
  ![Перехват трафика](screenshots/intercept.png)  

## 2. Mock ответа 
- Изменил статус на 500, body на "Error".  
- Браузер показал подменённую ошибку.  
Скрин: 
  ![Mock](screenshots/mock.png)
  ![Mock](screenshots/mock_2.png)  

## 3. Throttling 
- Настроил 3G, загрузка стала 5+ сек.  
Скрин: 
 ![Throttling](screenshots/throttling.png)
 ![Throttling](screenshots/throttling_2.png)
Заключение: Полезно для API-тестов и симуляции проблем.
