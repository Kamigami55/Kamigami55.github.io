---
title: '使用production mode啟動你的rails專案'
date: 2016-08-16 02:34
tags: [Rails, Tutorial]
category: Rails
socialImage: "https://imgur.com/a21E49E.jpg"
template: "post"
draft: false
description: ""
redirect_from:
  - /2016/08/16/start-your-rails-project-with-production-mode/
---

# Quick Reference:

``` bash
$ RAILS_ENV=production rake db:migrate
$ rake secret //產生secret key
$ export SECRET_KEY_BASE=[貼入上個指令產生出來的密鑰]
$ vim config/initializers/assets.rb  //加入用到的assets路徑
確認各處引用assets的方法正確
$ RAILS_ENV=production rake assets:precompile
$ vim config/environments/production.rb  //將這行改成true: config.serve_static_assets = true
$ rails s -e production
```

<!-- more -->

---

# 什麼是production模式？為什麼要用它？

在通常情況下，直接在你的專案裡下`$ rails s`這條指令，我們是使用development mode來啟動你的專案

在development模式下，大部分的修改都會直接顯現在網頁上，方便開發

但實際讓系統上線，我們不會使用development模式，而是**production模式**

在production模式裡，rails會將assets預編譯在一起(pre-compile)，並放在public/資料夾底下以供存取，這能**增進網站效能**

# 使用production mode啟動rails專案

## 0.migrate你的資料庫

production mode和development mode的資料庫是分開的，所以你需要再migrate一次

``` bash
$ RAILS_ENV=production rake db:migrate
```

## 1.修改config/secret.yml，設定production mode的secret_key_base

要順利運行rails程式，你需要設定一個叫**secret_key_base**的東西，它是rails用來認證瀏覽器cookie的一串密鑰。rails已經幫你在development mode和test mode設定好了，但production mode沒有，你得自己來，它的設定在**config/secret.yml**這隻檔案，讓我們來看看它：

``` c secret.yml
// development mode的設定
// 它使用 b1f4eb...3a9 這串密鑰（隨機生成的）
development:
  secret_key_base: b1f4eb6c1d97f627fbc0a3919fc27ab5f831200cdd0ea72317f404a2b9d878192bca27d92380f56051c60d0a364c86fe53d9b9866d487a17cf06582a783723a9

// test mode使用 fe9d...c3b 這串密鑰
test:
  secret_key_base: fe9d49b7edc8e3a4dfa47c0682974aca4572388e929ea3e4f037b3e8841747fc3029e030bbd102a62d372596b4d753dd0c419b7425a8dcceca3817cf7d5dbc3b

// production mode從執行環境裡抓 $SECRET_KEY_BASE 這個環境變數當作密鑰，但正常情況下該變數並不存在，所以出錯
production:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
```

你有兩種方法能設定production mode的secret_key_base

### (1)比較簡易的做法是直接寫死一串固定的密鑰給它：

``` c secret.yml
// 前略...

production:
// 刪掉原本的 <%= ... %> ，替換成隨便一串長度30以上的英數組合字串給他當密鑰
	secret_key_base: iameasonchangiamhandsomeiamthekingoftheworldnoonecandefeatmeiwantagirlfriendiamaloserqq
```

### (2)更安全的做法是把密鑰設在執行環境中：

``` bash
$ rake secret // 生成一串密鑰，顯示在終端機上
$ export SECRET_KEY_BASE=[此處貼上你剛剛產生的密鑰] // 把密鑰設定至環境變數 $SECRET_KEY_BASE
```

但只做到這樣的話，重開終端機的話環境變數設定就消失了，所以可以把設定寫進環境設定檔裡頭

像我使用zsh的話，環境設定檔是**./.zshrc**
而Mac的terminal預設的bash，則是**./.bash_profile**

``` bash .zshrc
// 在.zshrc中插入下面這行
export SECRET_KEY_BASE=[此處貼上你剛剛產生的密鑰]
```

到此你應該可以無錯誤地使用production mode開啟你的rails專案了，你可以下`$ rails s -e production`來開啟伺服器，並且用瀏覽器連至`localhost:3000`查看目前的結果

你的畫面應該跟我很像，怎麼醜不拉幾的？我不眠不休設計出來的精美網頁呢？

![Imgur](https://i.imgur.com/oVAdVyK.png?2)

那是因為你還沒有告訴rails你用到了哪些設計元素，接下來的步驟教你怎麼做：

## 2.告訴rails你有哪些assets需要被pre-compile

前面我們提過，使用production mode的理由是**增進網頁讀取效能**，方法是**預編譯(pre-compile)各類assets**，而你需要手動告訴rails你有哪些assets需要預編譯，除了圖檔，所有使用到的assets都需要加入裡頭，如js、css檔

方法是更新**config/initializers/assets.rb**這隻檔案，加入你有使用到的assets的路徑：

``` c++ assets.rb
// 前略...
// 後面加入這一行，裡頭放入你要precompile的檔案
Rails.application.config.assets.precompile += [
  'bootstrap.js', // 請幫我compile vendor/assets/javascripts/bootstrap.js 這支檔案
	'courses/content.js', // 還有 app/assets/javascripts/courses/content.js
	'courses/chart.js',  // app/assets/javascripts/courses/chart.js 也要
	'new-index.css', // 還有這個css，它在app/assets/stylesheets/new-index.css.scss
	'login.css', // app/assets/stylesheets/login.css.erb也要
	'newcomer/*.css', // app/assets/stylesheets/newcomer/裡面的css檔都要！
	'NotoSans-Regular-ttf' // 這個是字形檔唷！它在app/assets/fonts/NotoSans-Regular-ttf
]
```

rails會去 **app/assets/** 和 **vendor/assets/** 這兩個資料夾去找你的assets檔案，並且會根據副檔名尋找對應的路徑：

- js檔會去找底下的 **javascripts/**
- css檔會去找底下的 **stylesheets/**
- font檔會去找底下的 **fonts/**
- image檔會去找底下的 **images/**

但rails預設會幫你compile所有的圖檔，所以**.png、.jpg等圖檔就不用加進去**了

## 3.確認你引入assets的方法有沒有誤

compile後的assets，檔名會改變，所以傳統引入assets的方法會失效，必須改用rails提供的方法

- 引入js檔使用 `<%= javascript_include_tag 'your-js-path' %>`
- 引入css檔使用 `<%= stylesheet_link_tag 'your-css-path' %>`
- 引入圖檔使用 `<%= image_tag 'your-image-path' %>`
- js檔裡要再引入asset請使用 `<%= asset_path('your-img-path') %>`

## 4.Pre-compile it!

在你的專案目錄裡下指令：

``` bash
$ RAILS_ENV=production rake assets:precompile
```

就會將assets pre-compile進/public/assets裡頭

## 5.修改production的模式設定

雖然compile了，但production模式預設是不會讓使用者讀取/public/assets的檔案

必須修改 **config/environments/production.rb** 這個檔案

將位在第24行左右的

``` ruby production.rb
config.serve_static_assets = false
```

改為 **true**:

``` ruby production.rb
config.serve_static_assets = true
```

## 6.使用production mode啟動吧!!

在專案的目錄裡下指令：

``` bash
$ rails s -e production
```

就可以使用production mode開啟你的rails專案啦！

使用瀏覽器連入`localhost:3000`，就可以看到你速度大幅提升的美麗網頁啦！

![imgur](https://imgur.com/IGxS4QM.jpg)

---

測試環境：

- OS: Mac OS X
- Rails version: 4.2.6
- Ruby version: 2.0.0p481
- Shell: zsh