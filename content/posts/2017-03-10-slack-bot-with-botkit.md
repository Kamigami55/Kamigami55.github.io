title: Botkit初體驗，寫一隻Slack聊天機器人吧！
tags:
  - Botkit
  - Chatbot
  - Slack
category: Chatbot
socialImage: 'https://imgur.com/wnDgpFG.png'
date: 2017-03-10 02:57:00
template: "post"
draft: false
description: ""
---
# Botkit初體驗，寫一隻Slack聊天機器人吧！

目標：寫出一隻能運作的Slack聊天機器人(Chatbot)

需要的資源：

- 連網的可執行Node.js的電腦（我使用Arch Linux）
- 可供測試的Slack team（可以自己建立或使用現有的team）

# 什麼是Botkit

[Botkit](https://www.botkit.ai/)是一套開源的聊天機器人開發工具，目前已支援[Slack](https://slack.com/)、[Facebook Messenger](https://www.messenger.com/)、[Cisco Spark](https://www.ciscospark.com/)、[Twilio IP Messaging](https://www.twilio.com/chat)、[Microsoft Bot Framework](https://dev.botframework.com/)等平台。

<!-- more -->

Botkit的Github連結：[https://github.com/howdyai/botkit](https://github.com/howdyai/botkit)

# 下載Botkit與Node.js

## 下載Node.js (如果之前沒裝過才需要裝)

Node.js是一套開源、跨平台輕量化的JavaScript執行環境，常用來開發各式網路服務。

Botkit使用Node.js來運行，所以要使用Botkit你必須先安裝Node.js

你可以在Node.js的官網上找到個平台的安裝方法：
https://nodejs.org/en/

而在Arch Linux上，只要輸入以下指令，就可使用系統內建的pacman套件管理軟體輕鬆安裝Node.js：

``` bash
sudo pacman -S nodejs npm
```

## 下載Botkit
Botkit官方提供了兩種下載方式：透過Git與透過npm。

這裡我們使用Git來下載，這樣可以連範例程式碼也一起載下來。

在你的電腦終端機中輸入以下指令：

``` bash
git clone https://github.com/howdyai/botkit
```

這會將botkit下載至你的當前目錄裡，裡頭包含了botkit函式庫與範例程式。

接著下載Botkit所需的Node.js模組檔案：

``` bash
cd botkit/
npm install
```

# 設置你的第一隻Slack聊天機器人

下載完成後，我們就要在你的Slack team裡頭放入聊天機器人Chatbot了！

## Slack端設定

用瀏覽器開啟 https://my.slack.com/services/new/bot （請將**my**置換成你的**Slack team專屬的URL連結**）。

這連結用來在你的Slack team裡頭新增Chatbot，在**@username**的欄位輸入你想為bot取的名字，然後按下**Add bot integration**來新增，這裡我將我的機器人取名為**mmbot**

![](https://imgur.com/erLvNAU.png)

Chatbot新增成功！接著你會在它的設定頁面看到一串**API Token金鑰**，把它**複製起來**，下一步會用到。

待會你將執行的Chatbot後端程式，必須有這串Token，才能連結上你剛剛設定的Slack bot。

![](https://imgur.com/W6FAR8S.png)

## Botkit程式後端運行

最後我們使用botkit提供的slack-bot.js範例來測試！輸入指令來執行它，記得將`token=your-token`換成你剛剛複製起來的API Token

``` bash
token=your-token node slack-bot.js
```

# 完成！跟你的新Bot打聲招呼吧！

至此你的新聊天機器人就設置完成了！趕快打開Slack跟他講講話吧！！

slack-bot.js範例支援幾句非常簡單的對話，試著跟他說以下的話：

- Hello
- What is your name?
- Who am I?
- Call me Eason!

![](https://imgur.com/6VI5HdN.png)