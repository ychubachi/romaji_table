# はじめに
このツールの目的は，最適化されたDvorakベースのローマ字かな変換表を作成
するためのスクリプトをつくることです．

入力…変換ルール
出力…ローマ字かな変換表

ルール
母音が入力されたら，あ行の文字を出力する

変換 'aiueo' , 'あいうえお'
変換 '

キーボードの表を抽象化する

# 使わない子音の整理

左手にある子音「P,Y,Q,J,K,X」の扱い

P->F
Y->V

Q->利用しない
J->Zの拗音化で
K->か行->C
X->小文字化->Lで十分
”＜＞

[ltu]で[っ]を出すようにする
ん

# 撥音

# 参考文献
* http://sfoftime.web.fc2.com/actar/index.html

JLOD配列の省略化キーが打ち辛い。
: http://d.hatena.ne.jp/nullplus/20101121/1290348535

Dvorak配列をベースにした拡張ローマ字入力『ACT』
: http://www1.vecceed.ne.jp/~bemu/act/act_doc_fr.html
