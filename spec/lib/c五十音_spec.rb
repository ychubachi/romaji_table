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

  describe '#行' do
    it '母音を与え，かなを取り出す' do
      pending
      expect(it.行(:か)).to eq 'かきくけこ'
      expect(it.行(:か, 'あうお')).to eq 'かくこ'
      expect(it.行(:か, ['あい', 'うえ', 'おあ', 'えう'])).to eq ['かい', 'くえ', 'こあ', 'けう']
    end

    it '母音を与え，かなを取り出す（撥音，促音）' do
      pending
      expect(it.行(:か, 変化: 撥音)).to eq ['かん', 'きん', 'くん', 'けん', 'こん']
      expect(it.行(:か, 変化: 促音)).to eq ['かっ', 'きっ', 'くっ', 'けっ', 'こっ']
      expect(it.行(:か, ['あい', 'うえ', 'おあ', 'えう'])).to eq ['かい', 'くえ', 'こあ', 'けう']
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
      expect(it.直音).to eq [:あ行,
                             :か行, :さ行, :た行, :な行,
                             :は行, :ま行, :や行, :ら行, :わ行,
                             :が行, :ざ行, :だ行,
                             :ば行, :ぱ行]
    end
  end

  describe '#拗音' do
    it '行と列(:ゃ)を与えると，妥当な拗音を返す' do
      expect(it.拗音(:い, :ゃ)).to eq [:きゃ行, :しゃ行, :ちゃ行, :にゃ行,
                                       :ひゃ行, :みゃ行, :りゃ行,
                                       :ぎゃ行, :じゃ行, :ぢゃ行, :びゃ行,
                                       :ぴゃ行]
    end

    it '行と列(:ぁ)を与えると，妥当な拗音を返す' do
      expect(it.拗音(:い, :ぁ)).to eq [:きぁ行, :しぁ行, :ちぁ行, :にぁ行,
                                       :ひぁ行, :みぁ行, :りぁ行,
                                       :ぎぁ行, :じぁ行, :ぢぁ行, :びぁ行,
                                       :ぴぁ行]
    end

    it '対象としない行と列を与えると，例外発生' do
      expect{it.拗音(:な, :ゃ)}.to raise_error('列にはあ行の文字を指定してください')
      expect{it.拗音(:い, :ん)}.to raise_error('行には「:ゃ」または「:ぁ」を指定してください')
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
