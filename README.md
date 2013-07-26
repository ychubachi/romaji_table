# はじめに
このツールの目的は，最適化されたDvorakベースのローマ字かな変換表を作成
するためのスクリプトをつくることです．変換ルールを記述するためのDSLを
提供し，いかなる配列にも対応できるようにすることを目指します．


入力…変換ルール
出力…ローマ字かな変換表(Google IME, IME, ATOKなど)

ルール
母音が入力されたら，あ行の文字を出力する
aiu

変換 'aiueo' , 'あいうえお'

# キーボードの表を抽象化する

## 位置の指定方法
```
{左右: :左, 段: :上, 番号: 0}
```

# 使わない子音の整理

左手にある子音「P,Y,Q,J,K,X」の扱い

P->F
Y->V

Q->利用しない
J->Zの拗音化で
K->か行->C
X->小文字化->Lで十分
”＜＞

「ltu」で「っ」を出すようにする
ん

```
鍵盤 左右: :左,段: :上,
-> 'bmwvz' {上: 'c',tw'}
```

# 日本語クラス名

クラス名の先頭はアルファベットにしなくてはならない．

例）
  五十音表 = C五十音表.new

ファイル名は
  c五十音表.rb
  c五十音表_spec.rb
にしたい


# 参考文献

http://sfoftime.web.fc2.com/actar/index.html

キー配列いろいろ
: http://novelgames.blog3.fc2.com/blog-entry-26.html

JLOD配列の省略化キーが打ち辛い。
: http://d.hatena.ne.jp/nullplus/20101121/1290348535

Dvorak配列をベースにした拡張ローマ字入力『ACT』
: http://www1.vecceed.ne.jp/~bemu/act/act_doc_fr.html

https://sites.google.com/site/aourhairetu/Home
ローマ字

アルペジオ打鍵とは指の運動特性に適合した同手打鍵の場合に、非常に素早く打鍵できる現象の事を言い、あたかもピアノでアルペジオを弾くように指が高速に動くことから、名付けられたもの。出典は角田博保、粕川正充 「連続打鍵列の打鍵時間に対する分析と考察」 1991年

ローマ字/ひらがな/かたかなを変換するgemを作った
: http://mkdir.g.hatena.ne.jp/ymrl/20110407/1302163124

romaji というライブラリを書いた。
: http://makimoto.hatenablog.com/entry/2012/04/07/225741

オレオレかん字しゅう合（KY100）を作ってみました
: http://d.hatena.ne.jp/keita_yamaguchi/20080619/1213848566

Wikipedia頻出の漢字集合「WPJ2000」を作ってみました
: http://d.hatena.ne.jp/keita_yamaguchi/20080619/1213869551

: http://d.hatena.ne.jp/keita_yamaguchi/20080620/1213966049

* [CoLT :: Add-ons for Firefox](https://addons.mozilla.org/ja/firefox/addon/colt/)

* [RubyでDSL作ってみる - TakiTakeの日記](http://takitake.hatenablog.com/entry/2013/05/03/235622)
