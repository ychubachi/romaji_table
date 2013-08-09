# -*- coding: utf-8 -*-

require './generator'

Generator.execute <<-EOS
  #{DATA.read}
EOS
__END__

# [ローマ字 - Wikipedia](http://ja.wikipedia.org/wiki/%E3%83%AD%E3%83%BC%E3%83%9E%E5%AD%97)

## 訓令式
# [ローマ字のつづり方 - Wikisource](http://ja.wikisource.org/wiki/%E3%83%AD%E3%83%BC%E3%83%9E%E5%AD%97%E3%81%AE%E3%81%A4%E3%81%A5%E3%82%8A%E6%96%B9)

鍵盤登録({
       左: { 上: 'qwert', 中: 'asdfg', 下: 'zxcvb'},
       右: { 上: 'yuiop', 中: 'hjkl;', 下: 'bnm,.'}
     })

# 第1表 〔(　)は重出を示す〕 ※ だ行とぢゃ行の子音は異なる
# 変換 あ行,    母音: :鍵盤
# 変換 か行,    子音: {左右: :右, 段: :中, 番号: 2}, 母音: :鍵盤
# 変換 きゃ行,  子音: {左右: :右, 段: :中, 番号: 2}, 拗音化: {左右: :右, 段: :上, 番号: 0}, 母音: :鍵盤
# 変換 さ行,    子音: {左右: :左, 段: :中, 番号: 1}, 母音: :鍵盤
# 変換 ['しゃ', 'しゅ', 'しょ'], 子音: {左右: :左, 段: :中, 番号: 1}, 拗音化: {左右: :右, 段: :上, 番号: 0},
#               母音: [{左右: :左, 段: :中, 番号: 0},{左右: :左, 段: :中, 番号: 0},{左右: :左, 段: :中, 番号: 0},]
# 変換 た行,    子音: {左右: :左, 段: :上, 番号: 4}, 母音: :鍵盤
# 変換 ['ちゃ', 'ちぇ', 'ちょ'], 子音: {左右: :左, 段: :上, 番号: 4}, 拗音化: {左右: :右, 段: :上, 番号: 0},
#               母音: [{左右: :左, 段: :中, 番号: 0},{左右: :左, 段: :中, 番号: 0},{左右: :左, 段: :中, 番号: 0},]
# 変換 な行,    子音: {左右: :右, 段: :下, 番号: 1}, 母音: :鍵盤
# 変換 ['にゃ', 'にぇ', 'にょ'], 子音: {左右: :右, 段: :下, 番号: 1}, 拗音化: {左右: :右, 段: :上, 番号: 0},
#               母音: [{左右: :左, 段: :中, 番号: 0},{左右: :左, 段: :中, 番号: 0},{左右: :左, 段: :中, 番号: 0},]
変換 は行,    子音: {左右: :右, 段: :中, 番号: 0}, 母音: :鍵盤
変換 ['ひゃ', 'ひゅ', 'ひょ'],  子音: {左右: :右, 段: :中, 番号: 0}, 拗音化: {左右: :右, 段: :上, 番号: 0},
              母音: [{左右: :左, 段: :中, 番号: 0},{左右: :左, 段: :中, 番号: 0},{左右: :左, 段: :中, 番号: 0},]
変換 ま行,    子音: {左右: :右, 段: :中, 番号: 0}, 母音: :鍵盤
変換 ['みゃ', 'みゅ', 'みょ'],  子音: {左右: :右, 段: :下, 番号: 1}, 拗音化: {左右: :右, 段: :上, 番号: 0},
              母音: [{左右: :左, 段: :中, 番号: 0},{左右: :左, 段: :中, 番号: 0},{左右: :左, 段: :中, 番号: 0},]
変換 ['や', 'ゆ', 'よ'],    子音: {左右: :右, 段: :上, 番号: 0},
              母音: [{左右: :左, 段: :中, 番号: 0},{左右: :左, 段: :中, 番号: 0},{左右: :左, 段: :中, 番号: 0},]
# 変換 ら行,    子音: {左右: :左, 段: :上, 番号: 3}, 母音: :鍵盤
# 変換 りゃ行,  子音: {左右: :左, 段: :上, 番号: 3}, 拗音化: {左右: :右, 段: :上, 番号: 0}, 母音: :鍵盤 # 削除 syi, sye
# 変換 わ行,    子音: {左右: :左, 段: :上, 番号: 1}, 母音: :鍵盤 # 重出 wi,wu,we,wo  第二表 wo
# 変換 が行,    子音: {左右: :左, 段: :中, 番号: 4}, 母音: :鍵盤
# 変換 ぎゃ行,  子音: {左右: :左, 段: :中, 番号: 4}, 拗音化: {左右: :右, 段: :上, 番号: 0}, 母音: :鍵盤 # 削除 gyi, gye
# 変換 ざ行,    子音: {左右: :左, 段: :下, 番号: 0}, 母音: :鍵盤
# 変換 じゃ行,  子音: {左右: :左, 段: :下, 番号: 0}, 拗音化: {左右: :右, 段: :上, 番号: 0}, 母音: :鍵盤 # 削除 syi, sye
# 変換 だ行,    子音: {左右: :左, 段: :中, 番号: 2}, 母音: :鍵盤 # 重出 di,du 第二表 di,du
# 変換 ぢゃ行,  子音: {左右: :左, 段: :下, 番号: 0}, 拗音化: {左右: :右, 段: :上, 番号: 0}, 母音: :鍵盤 # 削除 zyi, zsye，重出 zya, zyu zyo
# 変換 ば行,    子音: {左右: :左, 段: :下, 番号: 4}, 母音: :鍵盤
# 変換 ぱ行,    子音: {左右: :右, 段: :上, 番号: 4}, 母音: :鍵盤
# # # 第2表
# 変換 しゃ行,  子音: {左右: :左, 段: :中, 番号: 1}, 拗音化: {左右: :右, 段: :中, 番号: 0}, 母音: :鍵盤 # 削除 she
# 変換 た行,    子音: {左右: :左, 段: :上, 番号: 4}, 拗音化: {左右: :左, 段: :中, 番号: 1}, 母音: :鍵盤 # 削除 tsu以外
# 変換 ちゃ行,  子音: {左右: :左, 段: :下, 番号: 2}, 拗音化: {左右: :右, 段: :中, 番号: 0}, 母音: :鍵盤 # 削除 she
# 変換 'ふ',    子音: {左右: :左, 段: :中, 番号: 3}, 母音: [{左右: :左, 段: :上, 番号: 1}]
# 変換 じゃ行,  子音: {左右: :右, 段: :中, 番号: 1}, 母音: :鍵盤 # 削除 je
# 変換 ぢゃ行,  子音: {左右: :左, 段: :中, 番号: 2}, 拗音化: {左右: :右, 段: :上, 番号: 0}, 母音: :鍵盤 # 削除 dyi, dye
# 変換 ['くゎ'], 子音: {左右: :右, 段: :中, 番号: 2}, 拗音化: {左右: :左, 段: :上, 番号: 1}, 母音: [{左右: :左, 段: :中, 番号: 0}]
# 変換 ['ぐゎ'], 子音: {左右: :左, 段: :中, 番号: 4}, 拗音化: {左右: :左, 段: :上, 番号: 1}, 母音: [{左右: :左, 段: :中, 番号: 0}]