# -*- coding: utf-8 -*-
require_relative 'c鍵盤'

module RomajiTable
  class C変換表
    attr :表

    def initialize(鍵盤)
      if 鍵盤.is_a?(RomajiTable::C鍵盤) == false
        raise 'C鍵盤の実体への参照を与えてください'
      end
      @鍵盤 = 鍵盤
      @表 = []
    end

    def 追加(文字, 打鍵順, 次開始鍵: nil)
      if 打鍵順.is_a?(Array) == false
        raise '打鍵順は配列で与えてください'
      end
      if 次開始鍵 && 次開始鍵.is_a?(Hash) == false
        raise '次開始鍵は連想配列で与えてください'
      end
      新規 = [文字, 打鍵順]
      if 次開始鍵
        新規 << 次開始鍵
      end
      @表 << 新規
    end

    def 出力
      @表.each do |変換|
        作業用 = []
        作業用 += [ローマ字(変換[1])]
        作業用 += [変換[0]]
        if 変換.length == 3
          作業用 += [ローマ字([変換[2]])]
        end
        puts 作業用.join("\t")
      end
    end

    def ローマ字(打鍵順)
      if 打鍵順.is_a?(Array) == false
        raise '打鍵順は配列で与えてください'
      end
      結果 = ''
      打鍵順.each do |位置|
        結果 << @鍵盤[位置[:左右]][位置[:段]][位置[:番号]]
      end
      結果
    end
  end
end
