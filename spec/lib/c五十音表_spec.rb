# -*- coding: utf-8 -*-

require 'c五十音表'

# 五十音表は[行，段]
# 段('へ') = 'え'
# 行('ゑ') = 'わ'
# ひらがなの足し算（合成）をする関数を作る

# C五十音表を作る
describe C五十音表, '#initialize' do
  subject(:it) { C五十音表.new }

  it "生成された" do
    expect(it).not_to be nil
  end
  
  it "五十音表操作が初期化された" do
    expect(it.五十音表).not_to be nil
    expect(it.五十音表.length).to be 10
  end
  
  it "行操作が追加された" do
    expect(it.か行).to eq 'かきくけこ'
    expect(it.は行).to eq 'はひふへほ'
    expect(it.か行[1]).to eq 'き'
    expect(it.は行[4]).to eq 'ほ'
    expect{it.ん行}.to raise_error
  end

  #
  # 合成とは直前の母音を削除して，追加すること
  #
  it "合成操作" do
    # 一文字の場合の例 # Error or not??
    expect(it.合成 'あ')    .to eq 'あ'		# a
    expect(it.合成 'け')    .to eq 'け'		# ce # ???
    # 単母音「え」 との合成例
    expect(it.合成 'あえ')  .to eq 'あえ'	# ae
    expect(it.合成 'かえ')  .to eq 'け'   	# ce
    # 二重母音「あい」 との合成例
    expect(it.合成 'あい')  .to eq 'あい'	# ai  OR '
    expect(it.合成 'かあい').to eq 'かい'	# cai OR c'
    # 二重母音「えい」 との合成例
    expect(it.合成 'えい')  .to eq 'えい'	# ei  OR .
    expect(it.合成 'かえい').to eq 'けい'	# cei OR c.
    # 撥音「あん」との合成例
    expect(it.合成 'あん')  .to eq 'あん'	# ai  OR '
    # 拗音「や（ya）」との合成例
    expect{it.合成 'あや'}.to raise_error
    expect(it.合成 'かやあ')  .to eq 'きゃ'	# cga
    expect(it.合成 'たやあ')  .to eq 'きゃ'	# cga

    # 拗音「や（ya）」と二重母音「あい（ai）」との合成例
    expect(it.合成 'かやあい').to eq 'きゃい'	# cga 
    expect(it.合成 'たやあい').to eq 'ちゃい'	# cga 
    # 拗音「や（ya）」と二重母音「うい（ui）」との合成例
    expect(it.合成 'かやうい').to eq 'きゅい'	# cga 
  end
end
