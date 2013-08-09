# -*- coding: utf-8 -*-

require_relative '../romaji_table'

## ================================================================
## 高速タイピング JLOD配列 (Japanese Layout on Dvorak)
## - http://www.mikage.to/jlod/
## ================================================================

開始鍵 = {
  あ行: nil,
  か行: {左右: :右, 段: :上, 番号: 2}, # c
  さ行: {左右: :右, 段: :中, 番号: 4}, # s
  た行: {左右: :右, 段: :中, 番号: 2}, # t
  な行: {左右: :右, 段: :中, 番号: 3}, # n
  は行: {左右: :右, 段: :中, 番号: 1}, # h
  ま行: {左右: :右, 段: :下, 番号: 1}, # m
  や行: {左右: :右, 段: :下, 番号: 3}, # v
  ら行: {左右: :右, 段: :上, 番号: 3}, # r
  わ行: {左右: :右, 段: :下, 番号: 2}, # w
  が行: {左右: :右, 段: :上, 番号: 1}, # g
  ざ行: {左右: :右, 段: :下, 番号: 4}, # z
  だ行: {左右: :右, 段: :中, 番号: 0}, # d
  ば行: {左右: :右, 段: :下, 番号: 0}, # b
  ぱ行: {左右: :右, 段: :上, 番号: 0}, # f
  ぁ行: {左右: :右, 段: :上, 番号: 4}, # l
}

左中 = {左右: :左, 段: :中}
左下 = {左右: :左, 段: :下} # 撥音拡張
左上 = {左右: :左, 段: :上} # 二重母音拡張

人差指左 = {左右: :右, 番号: 0}
人差指   = {左右: :右, 番号: 1}
中指     = {左右: :右, 番号: 2}
薬指     = {左右: :右, 番号: 3}
小指     = {左右: :右, 番号: 4}

二重母音登録(['あい', 'うい', 'うう', 'えい', 'おう'])

あ行以外 = 直音行
あ行以外.delete(:あ行)

拗音行 = 直音行
拗音行.delete_if{|x| [:あ行, :や行, :わ行].include?(x)}

=begin
================================================================
A.基本的な打ち方・撥音拡張

1) 拗音，ぱ行，や行以外はほぼ通常のローマ字と同じです．

2) 清音，濁音，半濁音は「ぱ行」「や行」「か行」を除いて普通のローマ字と
同じです．「か行」の子音キーは[C]，「や行」の子音キーは[V]，「ぱ行」の
子音キーは[F]となります．

例：か【CA】，や【VA】，ぷ【FU】

3) 促音「っ」は，左手上段小指の[']キーです．通常のローマ字のように子音
を2度打ちするのではありません．(Dvorak配列の実装によっては左手上段小指
のキーが[*]となるものもあります．)

4) 撥音「ん」はほとんどの場合，撥音拡張（[;][Q][J][K][X]キー）で入力で
きます．撥音拡張は母音の下のキーになります．単独の「ん」を入力するには
[N][N] と打ちます．

5-1) 拗音は次節以降のようにJLOD独自の打ち方となります．通常のように[子
音キー]＋[Y]＋[母音キー]では打てません．

5-2) 拗音文字(ゃゅょぁぃぅぇぉゎヵヶっ)を単独で入力するには [L] を前置
します．

6) 外来語に出てくる長音符「ー」は[P]キーまたは[-]キーを使います．
Dvorak配列では[-]キーは[S]キーの１つ右です．

7)  句読点は[,][.]キーを使います．

例
天使【TJSI】or【TENNSI】
カード【CA-DO】
暗記【;CI】
過去【CACO】，聞く【CICU】
夜【VORU】，ヤカン【VAC;】
ピンク【FXCU】，ペチコート【FETICOPTO】
================================================================
=end

## A-1, A-2
直音行.each do |行|
  変換 行, 開始鍵: 開始鍵[行], 確定鍵: 左中
end

# A-3
単文字登録('っ', [{左右: :左, 段: :上, 番号: 0}])

# A-4
直音行.each do |行|
  変換 行, 追加文字: 'ん', 開始鍵: 開始鍵[行], 確定鍵: 左下
end
N = {左右: :右, 段: :中, 番号: 3}
単文字登録('ん', [N, N])

# A-5-1

# A-5-2
L = {左右: :右, 段: :上, 番号: 4}
あ = {左右: :左, 段: :中, 番号: 0}
う = {左右: :左, 段: :中, 番号: 3}
え = {左右: :左, 段: :中, 番号: 2}

変換 :ゃ行, 開始鍵: L, 中間鍵: 開始鍵[:や行], 確定鍵: 左中 # ゃゅょ
変換 :ぁ行, 開始鍵: L, 確定鍵: 左中 # ぁぃぅぇ

変換 'ゎ', 開始鍵: L, 中間鍵: 開始鍵[:わ行], 確定鍵: あ # lwa
変換 'ヵ', 開始鍵: L, 中間鍵: 開始鍵[:か行], 確定鍵: あ # lca -> 辞書になし
変換 'ヶ', 開始鍵: L, 中間鍵: 開始鍵[:か行], 確定鍵: え # lce -> 辞書になし
変換 'っ', 開始鍵: L, 中間鍵: 開始鍵[:た行], 確定鍵: う # ltu -> 辞書になし

# A-6
単文字登録('ー', [{左右: :左, 段: :上, 番号: 3}])

# A-7
単文字登録('，', [{左右: :左, 段: :上, 番号: 1}])
単文字登録('．', [{左右: :左, 段: :上, 番号: 2}])

=begin
================================================================
B.2重母音拡張

1) 二重母音拡張は母音の上のキー．母音キーと組み合わせた場合のみ（2スト
ローク目以降）使用できます．

2) 2ストロークめあるいは3ストロークめの[母音キー]を打つ代わりに，[撥音
拡張キー]あるいは[2重母音拡張キー]を打つことで，それぞれ「母音+ん」，あ
るいは「2重母音」を入力することができます．

例
端麗【T;R.】
恋愛【RJAI】※【RJ'】とは打てない
================================================================
=end

# # B-1, B-2
母音指定(あ行以外, ['あい', 'うい', 'うう', 'えい', 'おう']) do |行|
  変換 行, 開始鍵: 開始鍵[行], 確定鍵: 左上
end

=begin
================================================================
C.拗音の打ち方(い行＋ゃぃゅぇょ)

1) 拗音は[子音キー]＋[拗音化キーA]＋[母音キー]の3ストロークで入力します．

2) 通常のローマ字綴りでは拗音化キーは[Y]キーでした．JLODでは，拗音化キー
Aは子音キーと同じ段(同じ並び)の右手人差し指か薬指のどちらか打ちやすい指，
になります．[Y]キーは使えません．

  第1ストロークが中指，薬指，小指の場合は，拗音化キーAは右手人差し指と
  なります．

  第1ストロークが人差し指の場合は，拗音化キーAは右手薬指を使います．

例
情緒【ZM,THO】，百歩【HNA'FO】
平壌【FRQV;】
================================================================
=end

拗音行.each do |行|
  拗音鍵 = 開始鍵[行][:番号] < 2 ? 薬指 : 人差指
  変換 拗音(行, :い列, :ゃ行),                 開始鍵: 開始鍵[行], 中間鍵: 拗音鍵, 確定鍵: 左中 # きゃ
  変換 拗音(行, :い列, :ゃ行), 追加文字: 'ん', 開始鍵: 開始鍵[行], 中間鍵: 拗音鍵, 確定鍵: 左下 # きゃん
  変換 二重母音(拗音(行, :い列, :ゃ行)),       開始鍵: 開始鍵[行], 中間鍵: 拗音鍵, 確定鍵: 左上 # きゃい，きゅい，…
end

=begin
★★★：D.拗音の打ち方(う行＋ぁぃぅぇぉ)

1) 拗音は[子音キー]＋[拗音化キーB]＋[母音キー]の3ストロークで入力します．

2) 通常のローマ字綴りのように[F][V]キーなどでは入力できません．で

    第1ストロークが中指，薬指，小指の場合は，拗音化キーBは右手薬指となります．
    第1ストロークが人差し指の場合は，拗音化キーBは右手人差し指を使います．

例
ファイト【HH'TO】，ウォン【WVQ】
=end

[:は行, :わ行].each do |行|
  拗音鍵 = 開始鍵[行][:番号] < 2 ? 人差指 : 薬指
  拗音 = 拗音(行, :う列, :ぁ行)
  変換 拗音,                 開始鍵: 開始鍵[行], 中間鍵: 拗音鍵, 確定鍵: 左中
  変換 拗音, 追加文字: 'ん', 開始鍵: 開始鍵[行], 中間鍵: 拗音鍵, 確定鍵: 左下 # きゃん
  変換 二重母音(拗音),       開始鍵: 開始鍵[行], 中間鍵: 拗音鍵, 確定鍵: 左上 # きゃいきゅいきゅうきぇいきょう
end

=begin
E. ★★★：拗音の打ち方(え行＋ゃぃゅぇょ)

1) 拗音は[子音キー]＋[拗音化キーB]＋[母音キー]の3ストロークで入力します．

2) 通常のローマ字綴りでは[H]キーを用いる表記は，JLODでは，子音キーと同
じ段(同じ並び)の右手人差し指か薬指のどちらか打ちにくい指（い行
＋ゃぃゅぇょの場合とは異なる指），で入力します．[H]キーは使えません．

3) 第1ストロークが中指，薬指，小指の場合は，拗音化キーBは右手薬指となります．

4) 第1ストロークが人差し指の場合は，拗音化キーBは右手の人差し指を使います．

例
ディープ【DHI-FU】，ティンカーベル【TNXCA-BERU】
=end

[:た行, :だ行].each do |行|
  拗音鍵 = 開始鍵[行][:番号] < 2 ? 人差指 : 薬指
  拗音 = 拗音(行, :え列, :ゃ行)
  変換 拗音,                 開始鍵: 開始鍵[行], 中間鍵: 拗音鍵, 確定鍵: 左中
  変換 拗音, 追加文字: 'ん', 開始鍵: 開始鍵[行], 中間鍵: 拗音鍵, 確定鍵: 左下 # きゃん
  変換 二重母音(拗音),       開始鍵: 開始鍵[行], 中間鍵: 拗音鍵, 確定鍵: 左上 # きゃいきゅいきゅうきぇいきょう
end

=begin
F. ★★：頻出拗音の省略打ち

「しゅう」「しょう」などのよく出てくる拗音は，同じ段の2ストロークで打てます．
ゅう：[子音キー]＋[同段中指]
ょう：[子音キー]＋[同段小指]

拗音では，「uu」「ou」という2重母音を取るケースが多いです．前述の2重母
音拡張を使えば3ストロークで打つことはできます．しかし，なるべくホームポ
ジションに置いておいた方が楽なので，片手の2ストロークだけで打てる省略形
を用意しています．
=end

#       C       L
# F     ぴゅう  ぴょう
# G     ぎゅう  ぎょう
# C     きゅう  きょう
# R     りゅう  りょう

#       中指T   小指S
# D     ぢゅう  ぢょう
# H     ひゅう  ひょう
# T     ちゅう  ちょう
# N     にゅう  にょう
# S     しゅう  しょう

#       中指W   小指Z
# B     びゅう  びょう
# M     みゅう  みょう
# Z     じゅう  じょう

二重母音登録 ['うう', 'おう']

拗音母音L = {左右: :右, 番号: 2}
拗音母音R = {左右: :右, 番号: 4}

拗音行.each do |行|
  変換 二重母音(拗音(行, :い列, :ゃ行)), 開始鍵: 開始鍵[行], 確定鍵: [拗音母音L, 拗音母音R]
end

=begin
G. ★★：拗音＋ク・ツの省略打ち

    「しゅう」「しょう」などのよく出てくる拗音は，同じ段の3ストロークで打てます．
    拗音+く：3ストロークめを右手の母音と対称位置の指で打つ
    拗音+つ：3ストロークめを右手中指で打つ
    ゅく：[子音キー]＋[拗音化キー]＋[同段人差し指]
    ょく：[子音キー]＋[拗音化キー]＋[同段薬指]
    ゃく：[子音キー]＋[拗音化キー]＋[同段小指]
    ゅつ：[子音キー]＋[拗音化キー]＋[同段中指]

拗音のあとにツが来るものは，Ｔのイメージから，3ストロークめに中指を使います．
=end

#   人差し指G   薬指R   小指L   中指C
# FR    ぴゅく  ぴょく  ぴゃく  ぴゅつ
# GR    ぎゅく  ぎょく  ぎゃく  ぎゅつ
# CG    きゅく  きょく  きゃく  きゅつ
# RG    りゅく  りょく  りゃく  りゅつ

二重母音登録 ['うく', 'おく', 'あく', 'うつ']

拗音行.each do |行|
  拗音鍵 = 開始鍵[行][:番号] < 2 ? 薬指 : 人差指
  拗音 = 拗音(行, :い列, :ゃ行)
  変換 二重母音(拗音), 開始鍵: 開始鍵[行], 中間鍵: 拗音鍵, 確定鍵: [人差指, 薬指, 小指, 中指]
end

=begin
H.★★：母音＋「き」「く」「つ」「っ」の省略打ち

1) [子音キー]＋[省略キー]＋[母音キー]の3ストロークで入力します．

2) 子音キーと同じ段(同じ並び)の同じ側の手の人差し指で一番中央列のキーを使用します．

3) 中央段に関しては，母音＋「つ」が入力できます．

4) 下段に関しては，母音＋「っ」が入力できます．

5) 上段に関しては，え段は母音＋「き」，それ以外は母音＋「く」が入力できます．

6) あ行，ふぁ行，う゛ぁ行に関してはこの省略打ちは出来ません．

例
聞く【CFY】，極楽【GF,RF'】
実質【ZBXSDI】，発達【HD:TDA】
省略キーとして右手人差し指キー(F,D,B)を使うもの
=end

# H-2

# H-3
あ行以外.each do |行|
#  変換 行, 追加: 'つ', 開始鍵: 開始鍵[行], 中間鍵: 人差指左, 確定鍵: 左中
  変換 行, 追加文字: 'つ', 開始鍵: 開始鍵[行], 中間鍵: 人差指左, 確定鍵: 左下
end

# H-4
あ行以外.each do |行|
  変換 行, 追加文字: 'っ', 開始鍵: 開始鍵[行], 中間鍵: 人差指左, 確定鍵: 左中
end

# 拗音を追加
拗音行.each do |行|
  変換 拗音(行, :い列, :ゃ行), 追加文字: 'っ', 開始鍵: 開始鍵[行], 中間鍵: 人差指左, 確定鍵: 左上
end

# # H-5 削除
# 二重母音登録 ['あく', 'いく', 'うく', 'えき', 'おく']

# あ行以外.each do |行|
#   変換 二重母音(行), 開始鍵: 開始鍵[行], 中間鍵: 人差指左, 確定鍵: 左上
# end

=begin
I.★：頻出語句の省略打ち

右手の子音キーを，別々の段で２つタイプすることにより，頻出語句を入力します．

よく使う語句を簡単に入力できるようにしています．この部分の語句は人によ
り頻度が違うと思いますので，自分用にカスタマイズした方がよいと思います．
他の基本ルールと混ざらないよう，同段のキー２つには割り当てないようにし
ています．

※左側が１打目，上側が２打目を表しています．

=end

# 省略

## ================================================================
## 記号など
## ================================================================

=begin
--      ー
-[      「
-]      」
-`,     ‥
-`/     ・
-`;     ;
-`a     ぁ
-`b     ←
-`ca    ヵ
-`ce    ヶ
-`e     ぇ
-`f     →
-`i     ぃ
-`n     ↓
-`o     ぉ
-`p     ↑
-`u     ぅ
-`va    ゃ
-`vh    ゅ
-`vn    ょ
-`vo    ょ
-`vs    ゃ
-`vu    ゅ
-`wa    ゎ
-`we    ゑ
-`wi    ゐ
-`{     『
-`}     』
=end

## ================================================================
## メモ
## ================================================================

# # 促音を母音上に割り当てるてもある

# 拗音化，撥音化などの変化を与える．
# NOTE: 促音+母音下があいてる

# NOTE: あ行の二重母音がない： 変換 :あ行,母音: 左中 # 普通

# どの変化キーを使うか？
# 母音の段は？
# 'っ'は，\'ではなく，'ltu'でよい

# きゃっきぃっきゅっきぇっきょっ（辞書にはあり．母音上使用）

# 重複が検査できるので，様々な配列を試行錯誤しやすい
# 定義されなかった行も出力する

# 五十音表の不規則性はC五十音がカバーする

# TODO: requireのみでDSLになるようにする
# TODO: モジュールにする
# TODO: lwaのときなどの子音が破綻している
# TODO: 内部的に最後まで「位置」で扱いたい
# TODO: 子音[]をなくしたい．子音登録 :か行, {...}があればよいか？
# TODO: ルールFのとき，母音の省略は可能か？
# TODO: [:ゔゃ行, :や行] -> ゆぁ行？？ 追加できるようにする？？
# TODO: tta -> たっ
# TODO: ltu

puts 変換表
