<!--- See https://shields.io for others or to customize this set of shields.  --->

![GitHub repo size](https://img.shields.io/github/repo-size/dennislwm/MT4-Telegram-Bot-Recon?style=plastic)
![GitHub language count](https://img.shields.io/github/languages/count/dennislwm/MT4-Telegram-Bot-Recon?style=plastic)
![GitHub top language](https://img.shields.io/github/languages/top/dennislwm/MT4-Telegram-Bot-Recon?style=plastic)
![GitHub last commit](https://img.shields.io/github/last-commit/dennislwm/MT4-Telegram-Bot-Recon?color=red&style=plastic)
![GitHub stars](https://img.shields.io/github/stars/dennislwm/MT4-Telegram-Bot-Recon?style=social)
![GitHub forks](https://img.shields.io/github/forks/dennislwm/MT4-Telegram-Bot-Recon?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/dennislwm/MT4-Telegram-Bot-Recon?style=social)
![GitHub followers](https://img.shields.io/github/followers/dennislwm?style=social)
<span class="badge-buymeacoffee"><a href="https://ko-fi.com/dennislwm" title="Donate to this project using Buy Me A Coffee"><img src="https://img.shields.io/badge/buy%20me%20a%20coffee-donate-yellow.svg" alt="Buy Me A Coffee donate button" /></a></span>
<span class="badge-patreon"><a href="https://patreon.com/dennislwm" title="Donate to this project using Patreon"><img src="https://img.shields.io/badge/patreon-donate-yellow.svg" alt="Patreon donate button" /></a></span>

# Table of Contents
- [Table of Contents](#table-of-contents)
- [About MT4-Telegram-Bot-Recon](#about-mt4-telegram-bot-recon)
- [How to Create a New Telegram Bot](#how-to-create-a-new-telegram-bot)
  - [Operation mode for bots](#operation-mode-for-bots)
  - [Configuration of MT4 Client](#configuration-of-mt4-client)
  - [Example Bot Screenshot](#example-bot-screenshot)
- [Example Usage](#example-usage)
- [Reach Out!](#reach-out)

# About MT4-Telegram-Bot-Recon
[Telegram](https://telegram.org/) isn't just for sending and receiving chat messages. It's also for automating your dialog flow, including work flow. Using a Telegram Bot gives you the ability to check prices, query status, manage trades, and even have a fun conversation. And if you're a serious crypto or forex trader, you can create your own Telegram Bot to manage your order flow.

MT4-Telegram-Bot-Recon is an Expert Advisor that communicates with a Telegram Bot. You can use the Bot to query your orders from a Metatrader 4 ["MT4"] client. You can use this approach to manage your order flow, view account details, open and close orders, or even broadcast trade signals to a Telegram group or channel.


# How to Create a New Telegram Bot
* Search for a bot on telegram with name "@BotFather". We will find it through the search engine. After adding it to the list of contacts,
we will start communicating with it using the /start command. As a response it will send you a list of all available commands, As shown in the image below
![pic1](https://user-images.githubusercontent.com/32399318/56162967-1fe7ed00-5fc5-11e9-9555-192c33b34d7f.jpg)


* With the /newbot command we begin the registration of a new bot. We need to come up with two names. The first one is a name of a bot that 
can be set in your native language. The second one is a username of a bot in Latin that ends with a “bot” prefix. As a result, we obtain 
a token or API Key – the access key for operating with a bot through API as shown below

![pic2](https://user-images.githubusercontent.com/32399318/56163370-0d21e800-5fc6-11e9-8481-69861daa4a1e.jpg)

## Operation mode for bots

With regard to bots, you can let them join groups by using the /setjoingroups command. If a bot is added to a group, then by using the /setprivacy command you can set the option to either receive all messages, or only those that start with a sign of the symbol team “/”. 

![pic4](https://user-images.githubusercontent.com/32399318/56163746-05af0e80-5fc7-11e9-801c-362d94e36a4d.jpg)

The other mode focuses on operation on a channel. Telegram channels are accounts for transmitting messages for a wide audience that support an unlimited number of subscribers. The important feature of channels is that users can't leave comments and likes on the news feed (one-way connection). Only channel administrators can create messages there 

![pic5__2](https://user-images.githubusercontent.com/32399318/56163931-8241ed00-5fc7-11e9-99e4-96a879ae0b9a.jpg)

## Configuration of MT4 Client
* Export and copy all files from include to the MT4 include folder, input the api key from the bot to the Expert Advisor's token, add the bot as an administrator of your signal channel or Group, any event that happens on your trade terminal will be notify to instantly on your channel

![mt4-telegram-signal-provider-screen-8054](https://user-images.githubusercontent.com/32399318/56166011-7147aa80-5fcc-11e9-9444-1bcaa574219e.jpg)

## Example Bot Screenshot
![test1](https://user-images.githubusercontent.com/32399318/56165638-63ddf080-5fcb-11e9-9b88-5e9fb94821b6.jpg)

# Example Usage

In the following example, the default application will be created in the folder *myproject/*.

    $ git clone https://github.com/dennislwm/MT4-Telegram-Bot-Recon.git myproject

Copy all files in both *Experts/* and *Include/* to their respective MT4 folders.

# Reach Out!

Please consider giving this repository a star on GitHub.

Alternatively, leave a comment on the tutorial [Building a Telegram Chat with a MT4 Forex Trading Expert Advisor](http://bit.ly/devto002).









