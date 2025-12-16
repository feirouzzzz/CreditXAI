from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

def test_login():
    driver = webdriver.Chrome()
    driver.get("http://localhost:3000/login")

    email = driver.find_element(By.ID, "email")
    password = driver.find_element(By.ID, "password")

    email.send_keys("john@test.com")
    password.send_keys("strongPass1")
    password.send_keys(Keys.ENTER)

    time.sleep(2)

    assert "dashboard" in driver.current_url

    driver.quit()
