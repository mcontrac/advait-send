from tkinter import *
from configparser import ConfigParser
import tkinter as tk
import requests

url = "https://api.openweathermap.org/data/2.5/weather?q={}&appid={}"

config_file = 'config.ini'
config = ConfigParser()
config.read(config_file)
api_key = config['api_key']['key']


def get_weather(city):
    result = requests.get(url.format(city, api_key))
    if result:
        json = result.json()
        # City, Country, temp_c, temp_f, ico, weather
        city = json['name']
        country = json['sys']['country']
        temp_kelvin = json['main']['temp']
        temp_celsius = temp_kelvin - 273.15
        temp_farenheit = temp_celsius * 9 / 5 + 32
        icon = json['weather']['icon']
        weather = json['weather']['main']
        weather_description = json['weather']['description']
    else:
        return NONE


def search():
    pass


app = Tk()
app.title("Weather")
app.geometry('700x350')

city_text = StringVar()
city_entry = Entry(app, textvariable=city_text)
city_entry.pack()

search_btn = Button(app, text="Search weather", width=12, command=search())
search_btn.pack()

location_lbl = Label(app, text="", font=("bold", 20))
location_lbl.pack()

img = Label(app, bitmap="")
img.pack()

temp_lbl = Label(app, text="")
temp_lbl.pack()

weather_lbl = Label(app, text="")
weather_lbl.pack()

weather_description = Label(app, text="test")
weather_description.pack()

app.mainloop()
