#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative 'c鍵盤'
require_relative 'c五十音'
require_relative 'c変換表'

require 'singleton'

module RomajiTable
  Qwerty = C鍵盤::Qwerty
  Dvorak = C鍵盤::Dvorak

  # ローマ字変換表生成器
  class C生成器
    include Singleton

    # 鍵盤にある母音の順番を左からの番号で指定
    attr :鍵盤母音順

    # 生成された変換表の配列
    attr :変換表配列, true

    # {RomajiTable::C五十音}の実体への参照
    attr :五十音

    # {RomajiTable::C鍵盤}の実体への参照
    attr :鍵盤

    # nilへのエイリアス
    C省略 = nil

    def initialize
      @五十音 = C五十音.new
      @鍵盤   = C鍵盤.new
      @変換表 = C変換表.new(@鍵盤)

      @変換表配列 = []
      @二重母音 = nil

      # 01234    04321
      # aiueo -> aoeui
      @鍵盤母音順 = [0, 4, 3, 2, 1]
    end

    def 鍵盤登録(鍵盤)
      @鍵盤.登録 鍵盤
    end

    def 鍵盤母音順(母音順)
      @鍵盤母音順 = 母音順
    end

    def 直音行
      @五十音.直音行.dup
    end

    def 拗音行
      @五十音.拗音行.dup
    end

    def 開拗音行
      @五十音.開拗音行.dup
    end

    def 合拗音行
      @五十音.合拗音行.dup
    end

    def 行拗音化(行, 列, 拗音)
      @五十音.拗音(行, 列, 拗音)
    end

    # 文字（または記号）を登録する
    #
    # @param [String] 文字 登録する文字
    # @param [Array] 確定鍵 確定する鍵の位置の配列
    # @return [Array] 変換表配列
    def 単文字登録(文字, 確定鍵)
      if 文字.is_a?(String) == false
        raise '文字は文字列で指定してください'
      end
      if 確定鍵.is_a?(Array) == false
        raise '確定鍵は配列で指定してください'
      end

      ローマ字 = ''
      確定鍵.each do |位置|
        ローマ字 += @鍵盤[位置[:左右]][位置[:段]][位置[:番号]]
      end
      変換表作成(ローマ字, 文字)
    end

    # 子音と母音の位置を指定する．
    #
    # @param [String, Array<String>, Symbol] かな 打鍵順序に対応づけるひらがなである．
    #   「かな」がStringのときは1文字毎に，Arrayの場合は要素毎に変換規則を生成する．
    #   またSynbolの場合，{C五十音#表}の行を表す．
    # @param [Hash] 開始鍵 子音の位置を指定するHash．位置の内容を省略することはできない．
    # @param [Array, Hash] 確定鍵 母音の位置を指定するArrayもしくはHash．
    #   Hashの場合，内部で{#母音位置正規化}する．
    #   また，省略した（nil）場合，鍵盤にある母音の位置になる．
    #   いずれの場合も，必ず「かな」と同じ長さになるようにすること．
    # @return [Array] ローマ字変換列
    # @todo 中間鍵を配列でも渡せるようにする
    def 変換(文字, 追加文字: '', 開始鍵: nil, 中間鍵: nil, 確定鍵: nil, 次開始鍵: nil)
      # # Uncomment a floowing line when you need.
      # IceNine.deep_freeze([文字, 追加文字, 開始鍵, 中間鍵, 確定鍵])
      文字配列   = 文字正規化(文字)
      中間鍵配列 = 中間鍵正規化(中間鍵)
      確定鍵配列 = 確定鍵正規化(確定鍵)

      if 開始鍵 && 開始鍵.is_a?(Hash) == false
        raise '開始鍵は連想配列で指定，または，省略してください'
      end

      if 文字配列.length != 確定鍵配列.length
        raise '文字は確定鍵と同じ文字数で指定してください'
      end

      中間鍵配列 = 段省略(中間鍵配列, 開始鍵)
      確定鍵配列 = 段省略(確定鍵配列, 開始鍵)

      打鍵順 = []
      開始鍵     and 打鍵順 += [開始鍵]
      中間鍵配列 and 打鍵順 += 中間鍵配列

      結果 = []
      [文字配列, 確定鍵配列].transpose.each do | (文字i, 確定鍵i) |
        結果 << @変換表.追加(文字i + 追加文字, 打鍵順 + [確定鍵i], 次開始鍵: 次開始鍵)
      end
      結果
    end

    def 文字生成(行配列, 母音, 拗音化: nil, &block)
      if 行配列.is_a?(Array) == false
        raise '行は配列で指定してください'
      end
      元母音, @二重母音 = @二重母音, 母音
      結果 = []
      行配列.each do |行|
        行x =
          if 拗音化
            行拗音化(行, 拗音化[0], 拗音化[1])
          else
            行
          end
        文字 = 二重母音(行x)
        yield 文字, 行 if block
        結果 << [文字, 行]
      end
      @二重母音 = 元母音
      結果
    end

    def 二重母音登録(二重母音)
      @二重母音 = 二重母音
    end

    def 二重母音(行)
      if @二重母音 == nil
        raise '二重母音が登録されてません'
      end

      case 行
      when Symbol
        行 = @五十音.表[行]
      end

      結果 = []
      @二重母音.each do |二重母音|
        列 = @五十音.表[:あ行].index(二重母音[0])
        if 列 == C省略
          raise "「#{二重母音[0]}」はあ行の文字ではありません"
        end
        結果 << "#{行[列]}#{二重母音[1]}"
      end
      結果
    end

    def 変換表出力
      @変換表.出力
      # @変換表配列.each do |ローマ字, かな|
      #   puts "#{ローマ字}\t#{かな}"
      # end
    end

    def 変換表消去
      @変換表.消去
    end
    def 五十音合成(対象行, 列: nil, 行: nil)
      @五十音.合成(対象行, 列: 列, 行: 行)
    end

    def シフト(位置)
      C鍵盤.シフト(位置)
    end

    private

    def 変換表作成(ローマ字, かな)
      @変換表配列 << [ローマ字, かな]
      [ローマ字, かな]
    end

    # 指定に基づき，「かな」の配列を得る操作
    #
    # @param かな [Array, String, Symbol]
    #        かな（'かきくけこ'，['きゃ', 'きゅ', 'きょ'], :さ行）など．
    #        配列の場合は，そのまま返す．
    #        文字列の場合は，1文字ごとの配列にする．
    # @return [Array] かなの配列
    def 文字正規化(文字)
      case 文字
      when Array
        文字
      when String
        文字.split("")
      when Symbol
        @五十音.表[文字]
      else
        raise '文字はシンボル，文字列，配列で指定してください'
      end
    end

    def 中間鍵正規化(中間鍵)
      case 中間鍵
      when Array
        Marshal.load(Marshal.dump(中間鍵))
      when Hash
        [中間鍵.dup]
      when nil
        []
      else
        raise '中間鍵は連想配列または配列で指定，または，省略してください'
      end
    end


    def 確定鍵正規化(確定鍵)
      case 確定鍵
      when Array
        Marshal.load(Marshal.dump(確定鍵))
      when Hash
        case
        when 確定鍵[:番号] || 確定鍵[:範囲外]
          [確定鍵]
        else
          if @鍵盤母音順
          else
            raise '確定鍵の番号を省略する場合は鍵盤母音順を設定してください'
          end
          結果 = []
          for 番号 in 0..4
            x = 確定鍵.dup
            x[:番号] = @鍵盤母音順[番号]
            結果 << x
          end
          結果
        end
      when nil
        @鍵盤.母音
      else
        raise '確定鍵は連想配列または配列で指定，または，省略してください'
      end
    end

    def 段省略(鍵配列, 参照鍵)
      鍵配列.each do |鍵i|
        if 鍵i[:範囲外] == nil && 鍵i[:段] == C省略
          鍵i[:段] = 参照鍵[:段]
        end
      end
    end
  end
end
