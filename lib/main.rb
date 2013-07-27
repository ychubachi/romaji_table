# -*- coding: utf-8 -*-

require './generator'

Generator.execute <<-EOS
  #{DATA.read}
EOS
__END__

# [ローマ字 - Wikipedia](http://ja.wikipedia.org/wiki/%E3%83%AD%E3%83%BC%E3%83%9E%E5%AD%97)

## 訓令式
# [ローマ字のつづり方 - Wikisource](http://ja.wikisource.org/wiki/%E3%83%AD%E3%83%BC%E3%83%9E%E5%AD%97%E3%81%AE%E3%81%A4%E3%81%A5%E3%82%8A%E6%96%B9)

=begin
第1表 〔(　)は重出を示す〕
ka 	ki 	ku 	ke 	ko 	kya 	kyu 	kyo
sa 	si 	su 	se 	so 	sya 	syu 	syo
ta 	ti 	tu 	te 	to 	tya 	tyu 	tyo
na 	ni 	nu 	ne 	no 	nya 	nyu 	nyo
ha 	hi 	hu 	he 	ho 	hya 	hyu 	hyo
ma 	mi 	mu 	me 	mo 	mya 	myu 	myo
ya 	(i) 	yu 	(e) 	yo
ra 	ri 	ru 	re 	ro 	rya 	ryu 	ryo
wa 	(i) 	(u) 	(e) 	(o)
ga 	gi 	gu 	ge 	go 	gya 	gyu 	gyo
za 	zi 	zu 	ze 	zo 	zya 	zyu 	zyo
da 	(zi) 	(zu) 	de 	do 	(zya) 	(zyu) 	(zyo)
ba 	bi 	bu 	be 	bo 	bya 	byu 	byo
pa 	pi 	pu 	pe 	po 	pya 	pyu 	pyo

sha 	shi 	shu 	sho
		tsu
cha 	chi 	chu 	cho
		fu
ja 	ji 	ju 	jo
di 		du
dya 		dyu 	dyo
kwa
gwa
			wo
=end

鍵盤({
       左: { 上: 'qwert', 中: 'asdfg', 下: 'zxcvb'},
       右: { 上: 'yuiop', 中: 'hjkl;', 下: 'bnm,.'}
     })

変換 あ行,    母音: :鍵盤
変換 か行,    子音: {左右: :右, 段: :中, 番号: 2}, 母音: :鍵盤
変換 きゃ行,  子音: {左右: :右, 段: :中, 番号: 2}, 拗音化: {左右: :右, 段: :上, 番号: 0}, 母音: :鍵盤

=begin
# ローマ字変換表（JLOD）
変換 あ行,    母音位置: {左右: :左, 段: :中}
変換 きゃ行,  子音位置: {左右: :右, 段: :上, 番号: 2}, 拗音化: {左右: :右, 番号: 1}, 母音位置: :鍵盤
変換 しゃ行H, 子音位置: {左右: :右, 段: :中, 番号: 4}, 拗音化: {左右: :右, 番号: 1}, 母音位置: :鍵盤
変換 ひゃ行,  子音位置: {左右: :右, 段: :中, 番号: 1}, 拗音化: {左右: :右, 番号: 3}, 母音位置: :鍵盤
=end

