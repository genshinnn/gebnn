
import time
import imaplib
import asyncio
import email
import telegram
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By

# Ваш логин и пароль от сайта
USERNAME = 'genshinnn'
PASSWORD = 'genshinnnlolz'

# Ваши данные от телеграм-бота и чата
TELEGRAM_TOKEN = '6231786658:AAH8KqNCXpVMOrvCNa9xWt-lEK181RUwq2o'
TELEGRAM_CHAT_ID = '-1001830114612'

# Инициализация браузера
driver = webdriver.Chrome('C:/Users/notby/New folder/chromedriver.exe')


# Заходим на сайт
driver.get('https://lzt.market/login/')


# Вводим логин и пароль
driver.find_element_by_name('login').send_keys(USERNAME)
driver.find_element_by_name('password').send_keys(PASSWORD)

# Нажимаем на кнопку "Войти"
driver.find_element_by_css_selector('input[value="Вход"]').click()

# Go to the page with account offers
driver.get('https://lzt.market/genshin-impact/?pmax=1000&legendary_min=5&ea=no&order_by=pdate_to_down_upload&search_id=274007')

# Wait for the offers to load
while not driver.find_element_by_name('category_id'):
    time.sleep(1)

# Keep track of the existing offers
existing_offers = []

async def check_for_new_offers():
    while True:
        # Get the list of offers
        offers = driver.find_elements_by_xpath('//div[@class="marketIndexItem--otherInfo" and .//span[@class="muted" and contains(text(), "Только что")]]')


        # Check for new offers
        for offer in offers:
            if offer.text not in existing_offers:
                # Get the link without /star
                link = offer.find_element_by_css_selector('a').get_attribute('href').replace('/star', '')

                # Send a notification to Telegram
                bot = telegram.Bot(token=TELEGRAM_TOKEN)
                await bot.send_message(chat_id=TELEGRAM_CHAT_ID, text=f"New account offer:\nLink: {link}")
                existing_offers.append(offer.text)

        # Refresh the page
        driver.refresh()

        # Wait for 5 seconds before checking for new offers again
        await asyncio.sleep(5)

# Start checking for new offers
asyncio.run(check_for_new_offers())
