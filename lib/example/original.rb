# -*- coding: utf-8 -*-
## ================================================================
## オリジナル配列
## ================================================================

require_relative '../romaji_table'

## ================================================================
## 鍵盤の設定
## ================================================================
子音鍵 = {
  あ行: nil,
  か行: {左右: :左, 段: :中, 番号: 3},
  が行: {左右: :左, 段: :下, 番号: 3},
  さ行: {左右: :左, 段: :中, 番号: 2},
  ざ行: {左右: :左, 段: :下, 番号: 2},
  た行: {左右: :左, 段: :中, 番号: 1},
  だ行: {左右: :左, 段: :下, 番号: 1},
  な行: {左右: :左, 段: :中, 番号: 0},
  は行: {左右: :左, 段: :中, 番号: 4},
  ば行: {左右: :左, 段: :下, 番号: 4},
  ぱ行: {左右: :左, 段: :上, 番号: 4},
  ま行: {左右: :左, 段: :上, 番号: 3},
  や行: {左右: :左, 段: :上, 番号: 2},
  ら行: {左右: :左, 段: :上, 番号: 1},
  わ行: {左右: :左, 段: :上, 番号: 0},
  ゔ行: {左右: :左, 段: :下, 番号: 0},
}

あ = [{左右: :右, 段: :中, 番号: 0}]
# い = [{左右: :右, 段: :中, 番号: 1}]
う = [{左右: :右, 段: :中, 番号: 2}]
え = [{左右: :右, 段: :中, 番号: 3}]
お = [{左右: :右, 段: :中, 番号: 4}]

左人指右 = {左右: :左, 番号: 4}
左人指   = {左右: :左, 番号: 3}
左中指   = {左右: :左, 番号: 2}
左薬指   = {左右: :左, 番号: 1}
左小指 = {左右: :左, 番号: 0}

右上段 = {左右: :右, 段: :上}
右中段 = {左右: :右, 段: :中}
右下段 = {左右: :右, 段: :下}

鍵盤母音順([0, 1, 2, 3, 4])

## ================================================================
## 直音
## ================================================================
五十音合成(直音行).each do |かな, 行|
  変換 かな, 開始鍵: 子音鍵[行], 確定鍵: 右中段
  変換 かな, 追加文字: 'ん', 開始鍵: 子音鍵[行], 確定鍵: 右下段
  変換 かな, 追加文字: 'っ', 開始鍵: 子音鍵[行], 確定鍵: 右上段
end

五十音合成(直音行, 列: :あ列, 行: :あ行).each do |かな, 行|
  変換(かな, 開始鍵: 子音鍵[行], 確定鍵: シフト(右上段))
end

五十音合成(直音行, 列: :う列, 行: :あ行).each do |かな, 行|
  変換(かな, 開始鍵: 子音鍵[行], 確定鍵: シフト(右中段))
end

五十音合成(直音行, 列: :お列, 行: :あ行).each do |かな, 行|
  変換(かな, 開始鍵: 子音鍵[行], 確定鍵: シフト(右下段))
end

## ================================================================
## 二重母音（あ列あ行）
## ================================================================

## |--------+----------+----------+----------+----------+----------+
## | ア母音 | (haa)    | ハイ hai | ハウ hau | ハエ hae | ハオ hao |
## |--------+----------+----------+----------+----------+----------+
五十音合成(直音行 - [:あ行], 列: :あ列, 行: :あ行).each do |かな, 行|
  変換(かな, 開始鍵: 子音鍵[行], 中間鍵: 左人指右, 確定鍵: 右中段)
  変換(かな, 追加文字: 'ん', 開始鍵: 子音鍵[行], 中間鍵: 左人指右, 確定鍵: 右下段)
  変換(かな, 追加文字: 'っ', 開始鍵: 子音鍵[行], 中間鍵: 左人指右, 確定鍵: 右上段)
end

五十音合成(直音行 - [:あ行], 列: :あ列, 行: :ぁ行).each do |かな, 行|
  変換(かな, 開始鍵: 子音鍵[行], 中間鍵: 左人指右, 確定鍵: シフト(右中段))
  変換(かな, 追加文字: 'ん', 開始鍵: 子音鍵[行], 中間鍵: 左人指右, 確定鍵: シフト(右下段))
  変換(かな, 追加文字: 'っ', 開始鍵: 子音鍵[行], 中間鍵: 左人指右, 確定鍵: シフト(右上段))
end

## ================================================================
## 開拗音（い列ゃ行）
## ================================================================

## |--------+----------+----------+----------+----------+----------+
## | イ母音 | ヒャ hya | (hyi)    | ヒュ hyu | ヒェ hye | ヒョ hyo |
## |--------+----------+----------+----------+----------+----------+

五十音合成(開拗音行).each do |かな, 行|
  変換(かな, 開始鍵: 子音鍵[行], 中間鍵: 左人指, 確定鍵: 右中段)
  変換(かな, 追加文字: 'ん', 開始鍵: 子音鍵[行], 中間鍵: 左人指, 確定鍵: 右下段)
  変換(かな, 追加文字: 'っ', 開始鍵: 子音鍵[行], 中間鍵: 左人指, 確定鍵: 右上段)
end

五十音合成(開拗音行, 列: :あ列, 行: :あ行).each do |かな, 行|
  変換(かな, 開始鍵: 子音鍵[行], 中間鍵: 左人指, 確定鍵: シフト(右上段))
end

五十音合成(開拗音行, 列: :う列, 行: :あ行).each do |かな, 行|
  変換(かな, 開始鍵: 子音鍵[行], 中間鍵: 左人指, 確定鍵: シフト(右中段))
end

五十音合成(開拗音行, 列: :お列, 行: :あ行).each do |かな, 行|
  変換(かな, 開始鍵: 子音鍵[行], 中間鍵: 左人指, 確定鍵: シフト(右下段))
end

## ================================================================
## 二重母音（う列あ行・合拗音）
## ================================================================

## |--------+----------+----------+----------+----------+----------+
## | ウ母音 | ファ hwa | フィ hwi | (hwu)    | フェ hwe | フォ hwo |
## |--------+----------+----------+----------+----------+----------+

五十音合成(直音行 - [:あ行], 列: :う列, 行: :ぁ行).each do |かな, 行|
  変換(かな, 開始鍵: 子音鍵[行], 中間鍵: 左中指, 確定鍵: 右中段)
  変換(かな, 追加文字: 'ん', 開始鍵: 子音鍵[行], 中間鍵: 左中指, 確定鍵: 右下段)
  変換(かな, 追加文字: 'っ', 開始鍵: 子音鍵[行], 中間鍵: 左中指, 確定鍵: 右上段)
end

五十音合成(直音行 - [:あ行], 列: :う列, 行: :あ行).each do |かな, 行|
  変換(かな, 開始鍵: 子音鍵[行], 中間鍵: 左中指, 確定鍵: シフト(右中段))
  変換(かな, 追加文字: 'ん', 開始鍵: 子音鍵[行], 中間鍵: 左中指, 確定鍵: シフト(右下段))
  変換(かな, 追加文字: 'っ', 開始鍵: 子音鍵[行], 中間鍵: 左中指, 確定鍵: シフト(右上段))
end

## ================================================================
## 二重母音（え列あ行）
## ================================================================

## |--------+----------+----------+----------+----------+----------+
## | エ母音 | ヘア hea | ヘイ hei | ヘウ heu | (hee)    | ヘオ heo |
## |--------+----------+----------+----------+----------+----------+

五十音合成(直音行 - [:あ行], 列: :え列, 行: :ぁ行).each do |かな, 行|
  変換(かな, 開始鍵: 子音鍵[行], 中間鍵: 左薬指, 確定鍵: 右中段)
  変換(かな, 追加文字: 'ん', 開始鍵: 子音鍵[行], 中間鍵: 左薬指, 確定鍵: 右下段)
  変換(かな, 追加文字: 'っ', 開始鍵: 子音鍵[行], 中間鍵: 左薬指, 確定鍵: 右上段)
end

## ================================================================
## 二重母音（お列あ行）
## ================================================================

## |--------+----------+----------+----------+----------+----------+
## | オ母音 | ホア hoa | ホイ hoi | ホウ hou | ホエ hoe | (hoo)    |
## |--------+----------+----------+----------+----------+----------+

五十音合成(直音行 - [:あ行], 列: :お列, 行: :あ行).each do |かな, 行|
  変換(かな, 開始鍵: 子音鍵[行], 中間鍵: 左小指, 確定鍵: 右中段)
  変換(かな, 追加文字: 'ん', 開始鍵: 子音鍵[行], 中間鍵: 左小指, 確定鍵: 右下段)
  変換(かな, 追加文字: 'っ', 開始鍵: 子音鍵[行], 中間鍵: 左小指, 確定鍵: 右上段)
end

五十音合成(直音行 - [:あ行], 列: :お列, 行: :ぁ行).each do |かな, 行|
  変換(かな, 開始鍵: 子音鍵[行], 中間鍵: 左小指, 確定鍵: シフト(右中段))
  変換(かな, 追加文字: 'ん', 開始鍵: 子音鍵[行], 中間鍵: 左小指, 確定鍵: シフト(右下段))
  変換(かな, 追加文字: 'っ', 開始鍵: 子音鍵[行], 中間鍵: 左小指, 確定鍵: シフト(右上段))
end

## ================================================================
## え列ゃ行拗音 (eg. テュ -> Oot)
## ================================================================
五十音合成([:た行, :だ行], 列: :え列, 行: :ゃ行).each do |かな, 行|
  変換(かな, 開始鍵: シフト(子音鍵[行]), 中間鍵: 左薬指, 確定鍵: 右中段)
  変換(かな, 追加文字: 'ん', 開始鍵: シフト(子音鍵[行]), 中間鍵: 左薬指, 確定鍵: 右下段)
  変換(かな, 追加文字: 'っ', 開始鍵: シフト(子音鍵[行]), 中間鍵: 左薬指, 確定鍵: 右上段)
end

## ================================================================
## う列ゃ行拗音 (eq.フュ -> Iet)
## ================================================================
五十音合成([:は行, :ば行, :ぱ行], 列: :う列, 行: :ゃ行).each do |かな, 行|
  変換(かな, 開始鍵: シフト(子音鍵[行]), 中間鍵: 左中指, 確定鍵: 右中段)
  変換(かな, 追加文字: 'ん', 開始鍵: シフト(子音鍵[行]), 中間鍵: 左中指, 確定鍵: 右下段)
  変換(かな, 追加文字: 'っ', 開始鍵: シフト(子音鍵[行]), 中間鍵: 左中指, 確定鍵: 右上段)
end

小文字鍵 = {左右: :左, 段: :下, 番号: 0}

変換 :ぁ行,    開始鍵: 小文字鍵, 確定鍵: 右中段
変換 'ゃゅょ', 開始鍵: 小文字鍵, 中間鍵: 子音鍵[:や行], 確定鍵: あ + う + お
変換 'ゎ',     開始鍵: 小文字鍵, 中間鍵: 子音鍵[:わ行], 確定鍵: あ
変換 'ゕ',     開始鍵: 小文字鍵, 中間鍵: 子音鍵[:か行], 確定鍵: あ
変換 'ゖ',     開始鍵: 小文字鍵, 中間鍵: 子音鍵[:か行], 確定鍵: え
変換 'っ',     開始鍵: 小文字鍵, 中間鍵: 子音鍵[:た行], 確定鍵: う
# ゝ ゞ ゟ
変換 'ん',     開始鍵: 小文字鍵, 確定鍵: 子音鍵[:な行]
変換 '，', 開始鍵: 子音鍵[:や行], 確定鍵: 子音鍵[:ま行]
変換 '．', 開始鍵: 子音鍵[:や行], 確定鍵: 子音鍵[:ら行]
変換 'ー', 確定鍵: {範囲外: "-"}

変換表出力
