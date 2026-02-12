import pytest
import allure
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


@pytest.fixture
def browser():
    driver = webdriver.Chrome()
    driver.implicitly_wait(5)
    yield driver
    driver.quit()
@allure.epic("UI Тестирование")
@allure.feature("Авторизация")
@allure.story("Успешный логин")
@allure.severity(allure.severity_level.CRITICAL)
@allure.tag("smoke", "positive")
def test_success_login(browser):
    with allure.step("Открываем страницу логина"):
        browser.get("https://the-internet.herokuapp.com/login")

    with allure.step("Вводим валидные credentials"):
        browser.find_element(By.ID, "username").send_keys("tomsmith")
        browser.find_element(By.ID, "password").send_keys("SuperSecretPassword!")
        browser.find_element(By.CSS_SELECTOR, "button[type='submit']").click()

    with allure.step("Ждём и проверяем сообщение об успехе"):
        message = WebDriverWait(browser, 10).until(
            EC.presence_of_element_located((By.ID, "flash"))
        )
        assert "You logged into a secure area!" in message.text

@allure.epic("UI Тестирование")
@allure.feature("Авторизация")
@allure.story("Неверный пароль")
@allure.severity(allure.severity_level.NORMAL)
@allure.tag("negative")
def test_wrong_password(browser):
    with allure.step("Открываем страницу логина"):
        browser.get("https://the-internet.herokuapp.com/login")

    with allure.step("Вводим неверный пароль"):
        browser.find_element(By.ID, "username").send_keys("tomsmith")
        browser.find_element(By.ID, "password").send_keys("wrong!")
        browser.find_element(By.CSS_SELECTOR, "button[type='submit']").click()

    with allure.step("Ждём и проверяем сообщение об ошибке"):
        message = WebDriverWait(browser, 10).until(
            EC.presence_of_element_located((By.ID, "flash"))
        )
        assert "Your password is invalid!" in message.text