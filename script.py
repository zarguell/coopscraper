from selenium import webdriver
from selenium.common.exceptions import WebDriverException
import time
import requests
import json
import os

# Set up Discord webhook URL
discord_webhook_url = os.environ.get('WEBHOOK')

# Set up options for the Chrome browser to run in headless mode
options = webdriver.ChromeOptions()
options.add_argument('--headless')
options.add_argument('--disable-extensions')
options.add_argument('--disable-dev-shm-usage')
options.add_argument('--disable-browser-side-navigation')
options.add_argument('--disable-gpu')
options.add_argument('start-maximized')
options.add_argument('disable-infobars')
options.add_argument('--disable-gpu-sandbox')
options.add_argument('--no-sandbox')

# Set up the Chrome webdriver
driver = webdriver.Chrome(options=options)

try:
    # Navigate to the login page
    driver.get("https://ort.foodcoop.com/login/")

    # Get the username and password from environment variables
    username = os.environ.get('USERNAME')
    password = os.environ.get('PASSWORD')

    # Find the username and password input fields and enter the credentials
    username_field = driver.find_element("id", "id_username")
    password_field = driver.find_element("id", "id_password")
    username_field.send_keys(username)
    password_field.send_keys(password)


    # Submit the login form
    login_button = driver.find_element("css selector", "input[type='submit'].btn.primary")


    login_button.click()

    # Wait for the page to load
    time.sleep(5)

    # Navigate to the calendar page
    driver.get("https://ort.foodcoop.com/calendar/")

    # Check if there is an appointment available
    if "all appointments are currently taken" not in driver.page_source.lower():
        # Send a Discord webhook if there is an appointment available
        webhook_data = {
            "content": "An appointment is available on the ORT Food Coop calendar! Check https://ort.foodcoop.com/calendar/ for details."
        }
        print("Found an appointment! Sending webhook.")
        requests.post(discord_webhook_url, data=json.dumps(webhook_data), headers={"Content-Type": "application/json"})
    else:
        print("Sorry, all appointments are currently taken. Please try again some other time.")
        # print(driver.page_source.lower())
except WebDriverException:
    # If we get here, the page failed to load
    print("Failed to load page, invalid run. ")

# Close the webdriver
driver.quit()