---
title: '在MacOS使用putty key進行ssh連線'
date: 2016-08-18 11:00
tags: [MacOSX, SSH, Putty, Tutorial]
category: Environment
socialImage: "https://imgur.com/3B3Hrd4.png"
template: "post"
draft: false
description: ""
---

# Quick Reference：

``` bash
$ brew install putty #安裝puttygen套件
$ puttygen <your-putty-key.ppk> -O private-openssh -o <your-ssh-key.pem> #將putty key轉換成ssh key
$ chmod 400 <your-ssh-key.pem> #調整.pem權限
$ ssh -i <your-ssh-key.pem> <user@your.server.com> #使用.pem進行ssh連線
```

<!-- more -->

---

突然發現學程的網站有小bug，所以需要連上網站所在的AWS(Amazon Web Service)伺服器裡修改程式碼。但建置網站的學長只留下了一個.ppk的putty專用SSH認證檔，而我這台破Mac實在沒容量給我再灌一台Windows然後裝上Putty來連線，所以我就開始研究如何讓MacOS內建的ssh指令也能吃進這支.ppk的putty key認證檔。

以下是我找到的解法：

# 1.使用puttygen將putty key轉換成ssh可用的key

ssh指令無法接受.ppk的putty key，必須先轉換成ssh可以使用的key

puttygen這支程式可以幫你轉換，你可以使用[Homebrew](http://brew.sh/index_zh-tw.html)來安裝它：

``` bash
$ brew install putty
```

接著可以輸入下面這條指令，將putty key轉換成ssh key：

``` bash
$ puttygen <your-putty-key.ppk> -O private-openssh -o <your-ssh-key.pem>
```

# 2.為ssh key設定適當的存取權限

如果你的ssh key檔的權限太過開放，伺服器會阻擋你使用這支key來連線，所以你必須為它設定適當的權限（有時候不需要設定權限就是對的了）：

``` bash
$ chmod 400 <your-ssh-key.pem>
```

# 3.連線

接著你可以用它來進行連線啦！

``` bash
$ ssh -i <your-ssh-key.pem> <user@your.server.com>
```

---

Reference: [https://stackoverflow.com/questions/3475069/use-ppk-file-in-mac-terminal-to-connect-to-remote-connection-over-ssh](https://stackoverflow.com/questions/3475069/use-ppk-file-in-mac-terminal-to-connect-to-remote-connection-over-ssh)