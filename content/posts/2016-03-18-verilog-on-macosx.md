---
title: '如何在Mac OS X上安裝Verilog環境'
date: 2016-03-18 17:40
tags: [Verilog, Tutorial, MacOSX, iVerilog, HDL, Tutorial]
category: Environment
socialImage: "https://i.imgur.com/5qKcx3Q.jpg"
template: "post"
draft: false
description: ""
---

> 一句話摘要：使用Icarus Verilog來編譯Verilog、使用GTKWave來顯示波形

為了資工系的數位電路設計課，我們需要一個能夠編譯Verilog這個硬體描述語言(HDL)的環境，並且要能模擬電路運作狀況加上顯示波形。

<!-- more -->

老師建議的編譯環境是[ModelSim](https://www.mentor.com/products/fpga/model/)，但是它只支援Windows，我目前還沒找到Mac OS X或是Linux的版本，所以我只好另尋他法，找看看有沒有其他能夠編譯Verilog的工具。

我找到了[Icarus Verilog](http://iverilog.icarus.com/home)，它是針對Linux的Verilog編譯器，而在Mac OS X底下，我們可以藉由Command Line來使用它。

# 安裝Icarus Verilog
這是[Icarus Verilog的安裝指南](http://iverilog.wikia.com/wiki/Installation_Guide)，很完整的說明了怎麼在各種作業系統上安裝它，不過是英文的，而且字有點多。

對於Mac OS X你有兩種安裝手段，編譯程式原始碼來安裝，或是透過套件管理系統安裝，對於我這種懶人來說，當然是選擇使用套件管理系統囉！

我使用[Homebrew](http://brew.sh/index_zh-tw.html)來安裝Icarus Verilog，如果你還沒有安裝Homebrew，去把它裝起來吧！身為一位Mac用戶兼資工系學生，Homebrew必備呀！

你可以在你的Command Line裡輸入這段文字來安裝Homebrew（請忽略最左方的$符號，這是Command Line的提示字元）：
```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

接著使用這段homebrew的指令來安裝Icarus Verilog：
```
$ brew install icarus-verilog
```
OK！現在你已經成功安裝了Icarus Verilog了！Homebrew就是這麼的神奇！

# 測試Icarus Verilog
安裝完了一個新程式，當然是要測試一下它的功能正不正常呀，這時就輪到經典Hello World測試程式登場了！

首先建立一個新文件命名為hello.v，內含以下內容（Verilog的源碼檔副檔名為.v）：
``` Verilog hello.v
module main;
  initial 
    begin
      $display("Hello, World");
      $finish ;
    end
endmodule
```
接著使用iverilog指令來編譯hello.v，使用-o hello來指定以hello來作為產生的可執行檔檔名：
```
$ iverilog -o hello hello.v
```
最後，使用vvp指令來執行hello這個可執行檔，只要你看到Hello, World這個輸出，就代表你的Icarus Verilog安裝成功了：
```
$ vvp hello
Hello, World
```

# 安裝GTKWave
接著，為了能夠更方便地查看電路運作的狀況，你需要一個波型顯示軟體，我使用[GTKWave](http://gtkwave.sourceforge.net)，這是一個可以跑在Mac OS X、Linux、和Windows上的波型顯示軟體，使用效果如下圖（截圖自官網）：

![13010278_1324168817596781_1227376771_o.png](https://i.imgur.com/qRG7zAU.jpg)

要在Mac OS X上安裝它很容易，就跟你安裝其他應用程式一樣，最大的困難可能是在官網上找到正確的下載連結......，連結已經幫你標出來了，請在官網上找到上圖紅框處download連結把它點下去！

接著把載下來了.zip檔解壓縮，完畢後得到的.app檔就是你要的GTKWave了！隨點隨用免安裝，那～麼～厲害！

# 使用GTKWave來顯示波形

## 建立新的測試程式
先別急著打開你的GTKWave，你還需要一個新的測試程式，之前的hello world程式可根本不算是一個電路呢！

首先建立兩個新檔案，命名為Simple_Circuit.v和t_Simple_Circuit.v（修改自我們老師的Lab0範例）：

``` Verilog Simple_Circuit.v
module	Simple_Circuit(A, B, C, D, E);
  output	D, E;
  input	A, B, C;
  wire	w1;
	
	and		G1(w1, A, B);
	not		G2(E, C);
	or		G3(D, w1, E);
endmodule
```

``` Verilog t_Simple_Circuit.v
module	t_Simple_Circuit;
  wire	D, E;
  reg		A, B, C;
	
  //instantiate device under test
  Simple_Circuit	M1(A, B, C, D, E);
	
  //apply inputs one at a time
  initial	begin
    $dumpfile("mytest.vcd");
    $dumpvars;
    A=1'b0; B=1'b0; C=1'b0;
    #100 A=1'b1; B=1'b1; C=1'b1; 
  end
  
  initial #200 $finish;
endmodule
```

將這兩個檔案編譯為mycircuit這個執行檔，並且執行它：
```
$ iverilog -o mycircuit t_Simple_Circuit.v Simple_Circuit.v
$ vvp mycircuit
```

因為我們在t_Simple_Circuit.v這個電路測試檔案裡頭加入了dumpfile和dumpvars，所以執行完mycircuit後，會產生一個名為mytest.vcd的檔案，裡頭包含了我們所要的波型紀錄。

現在我們可以使用GTKWave來檢視波型了！

## 正式開啟GTKWave來檢視波型

開啟你的GTKWave，點擊左上角的File > Open New Tab
選擇剛剛產生的mytest.vcd檔，你應該會很失望地發現為什麼沒有出現你要的波型，如下圖：

![螢幕快照 2016-03-19 上午1.23.20.png](https://i.imgur.com/RJIQuvS.jpg)

那是因為你還沒有告訴GTKWave你想要看什麼，那我們就來告訴它吧！

在GTKWave左側面板，你會看到一串文字寫著t_Simple_Circuit，那就是你的測試檔案，點開那個+號，點擊M1電路，下面就會列出M1電路裡所有的線路，把你想要看它波形的線路拖曳到右方的區塊吧！噠答！你要的波型顯示出來了！

![螢幕快照 2016-03-19 上午1.30.18.png](https://i.imgur.com/86eXv9b.jpg)

恭喜你成功建置你的Verilog環境，現在你可以炫砲地使用你的Macbook來做數電設計作業了！

# 指令小筆記
```
$ iverilog -o <output-file> <source-file-1> <source-file-2> ... // 編譯
$ vvp <executable-verilog-file> // 執行
```