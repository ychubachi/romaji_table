# -*- coding: utf-8 -*-

require 'c五十音'

describe C五十音 do
  subject(:it) {C五十音.new}

  describe '#initialize' do
    it '五十音を生成する' do
      expect(C五十音.new).to be_an_instance_of C五十音
    end
  end

  describe '#表' do
    it '行を与えると，その行のかなを返す' do
      expect(it.表[:あ行]).to eq ["あ", "い", "う", "え", "お"]
    end

    it '表にない文字を与えると，例外発生' do
      expect{it.表[:ん行]}.to raise_error("「ん行」は行として登録されていません")
    end
  end

  describe '#列' do
    it '列にあ行の文字を与えると，その列を返す' do
      expect(it.列(:う)).to eq ["う", "く", "す", "つ", "ぬ",
                                "ふ", "む", "ゆ", "る", "う",
                                "ぐ", "ず", "づ", "ぶ", "ぷ"]
    end

    it '列にあ行にない文字を与えると，例外発生' do
      expect{it.列(:し)}.to raise_error('列にはあ行の文字を指定してください')
    end
  end

  describe '#直音' do
    it '直音を返す' do
      expect(it.直音行).to eq [:あ行,
                               :か行, :さ行, :た行, :な行,
                               :は行, :ま行, :や行, :ら行, :わ行,
                               :が行, :ざ行, :だ行,
                               :ば行, :ぱ行]
    end
  end

  describe '#拗音' do
    it '行と列，拗音行(:ゃ)を与えると，拗音を返す' do
      expect(it.拗音(:か行, :い列, :ゃ行)).to eq :きゃ行
    end

    it '行と列，拗音行(:ぁ)を与えると，拗音を返す' do
      expect(it.拗音(:は行, :う列, :ぁ行)).to eq :ふぁ行
    end

    it '対象としない行と列を与えると，例外発生' do
      expect{it.拗音(:ん行, :な列, :ゃ行)}.to raise_error('「ん行」は行として登録されていません')
      expect{it.拗音(:か行, :な列, :ゃ行)}.to raise_error('「な列」はあ行の文字ではありません')
      expect{it.拗音(:か行, :い列, :ん行)}.to raise_error('拗音行には「ゃ行」または「ぁ行」を指定してください')
    end
  end

  describe '#かな' do
    it '行と列を与えると，かなを返す' do
      expect(it.かな(:あ行, :え)).to eq 'え'
      expect(it.かな(:は行, :う)).to eq 'ふ'
    end

    it '五十音の行にない行または列を与えると，例外発生' do
      expect{it.かな(:ん行, :お)}.to raise_error('「ん行」は行として登録されていません')
      expect{it.かな(:あ行, :ん)}.to raise_error('「ん」はあ行の文字ではありません')
    end
  end
end

# -*- coding: utf-8 -*-

# require 'c五十音表'

# # 五十音表は[行，段]
# # 段('へ') = 'え'
# # 行('ゑ') = 'わ'
# # ひらがなの足し算（合成）をする関数を作る

# # C五十音表を作る
# describe C五十音表, '#initialize' do
#   subject(:it) { C五十音表.new }

#   it "生成された" do
#     expect(it).not_to be nil
#   end

#   it "五十音表操作が初期化された" do
#     expect(it.五十音表).not_to be nil
#     expect(it.五十音表.length).to be 10
#   end

#   it "行操作が追加された" do
#     expect(it.か行).to eq 'かきくけこ'
#     expect(it.は行).to eq 'はひふへほ'
#     expect(it.か行[1]).to eq 'き'
#     expect(it.は行[4]).to eq 'ほ'
#     expect{it.ん行}.to raise_error
#   end

#   #
#   # 合成とは直前の母音を削除して，追加すること
#   #
#   it "合成操作" do
#     # 一文字の場合の例 # Error or not??
#     expect(it.合成 'あ')    .to eq 'あ'		# a
#     expect(it.合成 'け')    .to eq 'け'		# ce # ???
#     # 単母音「え」 との合成例
#     expect(it.合成 'あえ')  .to eq 'あえ'	# ae
#     expect(it.合成 'かえ')  .to eq 'け'       # ce
#     # 二重母音「あい」 との合成例
#     expect(it.合成 'あい')  .to eq 'あい'	# ai  OR '
#     expect(it.合成 'かあい').to eq 'かい'	# cai OR c'
#     # 二重母音「えい」 との合成例
#     expect(it.合成 'えい')  .to eq 'えい'	# ei  OR .
#     expect(it.合成 'かえい').to eq 'けい'	# cei OR c.
#     # 撥音「あん」との合成例
#     expect(it.合成 'あん')  .to eq 'あん'	# ai  OR '
#     # 拗音「や（ya）」との合成例
#     expect{it.合成 'あや'}.to raise_error
#     expect(it.合成 'かやあ')  .to eq 'きゃ'	# cga
#     expect(it.合成 'たやあ')  .to eq 'きゃ'	# cga

#     # 拗音「や（ya）」と二重母音「あい（ai）」との合成例
#     expect(it.合成 'かやあい').to eq 'きゃい'	# cga
#     expect(it.合成 'たやあい').to eq 'ちゃい'	# cga
#     # 拗音「や（ya）」と二重母音「うい（ui）」との合成例
#     expect(it.合成 'かやうい').to eq 'きゅい'	# cga
#   end
# end
