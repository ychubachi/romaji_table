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

# 撥音

# 参考文献
* http://sfoftime.web.fc2.com/actar/index.html

JLOD配列の省略化キーが打ち辛い。
: http://d.hatena.ne.jp/nullplus/20101121/1290348535

Dvorak配列をベースにした拡張ローマ字入力『ACT』
: http://www1.vecceed.ne.jp/~bemu/act/act_doc_fr.html

https://sites.google.com/site/aourhairetu/Home
ローマ字

