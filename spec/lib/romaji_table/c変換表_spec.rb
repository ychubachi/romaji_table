# -*- coding: utf-8 -*-
require 'romaji_table/c変換表'

describe RomajiTable::C変換表 do
  subject(:s){RomajiTable::C変換表.new(RomajiTable::C鍵盤.new)}

  describe '#initialize' do
    it '{#C五十音}を与え生成する' do
      expect(s).to be_a RomajiTable::C変換表
    end
    it '{#C五十音}を与えないと，例外を発生' do
      expect{
        RomajiTable::C変換表.new(nil)
      }.to raise_error('C鍵盤の実体への参照を与えてください')
    end
  end

  describe '#追加' do
    it '文字と打鍵順を与えて変換表に追加する' do
      s.追加('あ', [{左右: :左, 段: :中, 番号: 0}])
      expect(s.表).to eq [["あ", [{:左右=>:左, :段=>:中, :番号=>0}]]]
    end

    it '打鍵順が配列でなければ例外発生' do
      expect{s.追加('あ', {左右: :左, 段: :中, 番号: 0})}.
        to raise_error('打鍵順は配列で与えてください')
    end

    it '次開始鍵が連想配列でなければ例外発生' do
      expect{s.追加('あ', [{左右: :左, 段: :中, 番号: 0}], 次開始鍵: [:左, :中, 0])}.
        to raise_error('次開始鍵は連想配列で与えてください')
    end
  end

  describe '#出力' do
    it 'ローマ字かな変換表を出力する' do
      s.追加('あ', [{左右: :左, 段: :中, 番号: 0}])
      s.追加('か', [{左右: :右, 段: :上, 番号: 2}, {左右: :左, 段: :中, 番号: 0}])
      s.追加('っ', [{左右: :右, 段: :中, 番号: 2}, {左右: :右, 段: :中, 番号: 2}],
             次開始鍵: {左右: :右, 段: :中, 番号: 2})
      expect(capture(:stdout) {s.出力}).to eq "a\tあ\nca\tか\ntt\tっ\tt\n"
    end
  end

  describe '#ローマ字' do
    it '打鍵順を与えると，鍵盤の情報を元にローマ字の列を生成する' do
      expect(s.ローマ字([{左右: :左, 段: :中, 番号: 0}])).to eq 'a'
      expect(s.ローマ字([{左右: :左, 段: :中, 番号: 0}, {左右: :右, 段: :上, 番号: 3}])).to eq 'ar'
    end

    it '打鍵順が配列でなければ，例外発生' do
      expect{s.ローマ字({左右: :左, 段: :中, 番号: 0})}.to raise_error '打鍵順は配列で与えてください'
    end
  end
end
