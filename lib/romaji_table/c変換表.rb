# -*- coding: utf-8 -*-
require_relative 'c鍵盤'

module RomajiTable
  class C変換表
    class C変換 < Struct.new(:文字, :打鍵順, :次開始鍵)
    end

    attr :表

    def initialize(鍵盤)
      if 鍵盤.is_a?(RomajiTable::C鍵盤) == false
        raise 'C鍵盤の実体への参照を与えてください'
      end
      @鍵盤 = 鍵盤
      消去
    end

    def 追加(文字, 打鍵順, 次開始鍵: nil)
      unless 打鍵順.is_a?(Array)
        raise '打鍵順は配列で与えてください'
      end
      if 次開始鍵 && 次開始鍵.is_a?(Hash) == false
        raise '次開始鍵は連想配列で与えてください'
      end
      if @重複[打鍵順]
        raise "#{打鍵順}は既に「#{@重複[打鍵順]}」として登録されています"
      else
        @重複[打鍵順] = 文字
      end
      変換 = C変換.new(文字, 打鍵順, 次開始鍵)
      @表 << 変換
      文字列化(変換)
    end

    def 出力
      @表.each do |変換|
        puts 文字列化(変換)
      end
    end

    def 消去
      @表 = []
      @重複 = {}
    end

    private

    def 文字列化(変換)
      作業用 = []
      作業用 += [ローマ字(変換.打鍵順)]
      作業用 += [変換.文字]
      if 変換.次開始鍵
        作業用 += [ローマ字([変換.次開始鍵])]
      end
      作業用.join("\t")
    end

    def ローマ字(打鍵順)
      if 打鍵順.is_a?(Array) == false
        raise '打鍵順は配列で与えてください'
      end
      結果 = ''
      打鍵順.each do |位置|
        unless 位置[:範囲外]
          x = @鍵盤[位置[:左右]][位置[:段]][位置[:番号]]
        else
          x = 位置[:範囲外]
        end

        if 位置[:シフト]
          x.upcase!
        end

        結果 << x
      end
      結果
    end
  end
end
