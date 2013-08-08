#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative 'c鍵盤'
require_relative 'c五十音'

module RomajiTable
  # ローマ字変換表生成器
  class C生成器
    attr :母音順, true
    attr :鍵盤母音
    attr :変換表
    attr :五十音

    Qwerty = C鍵盤::Qwerty
    Dvorak = C鍵盤::Dvorak

    C省略 = nil

    def initialize
      @変換表 = []
      @鍵盤 = C鍵盤.new
      @五十音 = C五十音.new
      @二重母音 = nil

      # 01234    04321
      # aiueo -> aoeui
      self.母音順 = [0, 4, 3, 2, 1]
    end

    # DSL
    def 鍵盤登録(鍵盤)
      @鍵盤.登録 鍵盤
    end

    # 五十音から直音（あ，ざ，ぱなど）を返す．
    # DSLで変更可能にするため，dupをしている．
    def 直音行
      @五十音.直音行.dup
    end

    def 拗音(行, 列, 拗音行)
      @五十音.拗音(行, 列, 拗音行)
    end

    # 文字（または記号）を登録する
    #
    # @param [String] 文字 登録する文字
    # @param [Array] 確定鍵 確定する鍵の位置の配列
    # @return [Array] 変換表
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
    def 変換(文字, 追加文字: '', 開始鍵: nil, 中間鍵: nil, 確定鍵: nil)
      # # Uncomment a floowing line when you need.
      # IceNine.deep_freeze([文字, 追加文字, 開始鍵, 中間鍵, 確定鍵])

      case
      when 開始鍵 && 開始鍵.is_a?(Hash) == false
        raise '開始鍵は連想配列で指定，または，省略してください'
      when 中間鍵 && 中間鍵.is_a?(Hash) == false
        raise '中間鍵は連想配列で指定，または，省略してください'
      when 確定鍵 && (確定鍵.is_a?(Hash) == false && 確定鍵.is_a?(Array) == false)
        raise '確定鍵は連想配列または配列で指定，または，省略してください'
      end

      文字配列   = 文字正規化(文字)
      確定鍵配列 = 確定鍵正規化(確定鍵)
      if 文字配列.length != 確定鍵配列.length
        raise '文字は確定鍵と同じ文字数で指定してください'
      end

      if 中間鍵 && 中間鍵[:段] == C省略
        中間鍵 = 中間鍵.dup
        中間鍵[:段] = 開始鍵[:段]
      end

      開始鍵R, 中間鍵R = '', ''
      if 開始鍵
        開始鍵R = @鍵盤[開始鍵[:左右]][開始鍵[:段]][開始鍵[:番号]]
      end
      if 中間鍵
        中間鍵R = @鍵盤[中間鍵[:左右]][中間鍵[:段]][中間鍵[:番号]]
      end

      結果 = []
      [文字配列, 確定鍵配列].transpose.each do | (文字I, 確定鍵I) |
        if 確定鍵I[:段] == C省略
          確定鍵I[:段] = 開始鍵[:段]
        end
        確定鍵R = @鍵盤[確定鍵I[:左右]][確定鍵I[:段]][確定鍵I[:番号]]
        結果 << 変換表作成("#{開始鍵R}#{中間鍵R}#{確定鍵R}",
                           "#{文字I}#{追加文字}")
      end
      結果
    end

    def 母音指定(行配列, 母音, &block)
      if 行配列.is_a?(Array) == false
        raise '行は配列で指定してください'
      end
      元母音 = @二重母音
      self.二重母音登録(母音)
      結果 = []
      行配列.each do |行|
        行 = 二重母音(行)
        yield 行 if block
        結果 << 行
      end
      self.二重母音登録(元母音)
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

    # @todo 削除候補
    def 鍵盤確定鍵
      @鍵盤.母音
    end

    private

    def 変換表作成(ローマ字, かな)
      @変換表 << [ローマ字, かな]
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

    # TODO: 母音位置にて番号が省略されている場合，登録されている母音順に従い位置の配列に正規化する
    #
    # 番号を省略する場合は，必ず{#母音順}を設定しておくこと．
    #
    # @return [Array] 母音の配列
    def 確定鍵正規化(確定鍵)
      case 確定鍵
      when Hash
        case
        when 確定鍵[:番号]
          [確定鍵]
        else
          if @母音順
          else
            raise '確定鍵の番号を省略する場合は母音順を設定してください'
          end
          結果 = []
          for 番号 in 0..4
            結果 << {左右: 確定鍵[:左右], 段: 確定鍵[:段], 番号: @母音順[番号]}
          end
          結果
        end
      when Array
        # Making Deep Copies in Ruby
        # - http://ruby.about.com/od/advancedruby/a/deepcopy.htm)
        Marshal.load(Marshal.dump(確定鍵))
      when nil
        鍵盤確定鍵
      end
    end

    def self.execute(contents)
      g = C生成器.new
      g.instance_eval(contents, 'JLOD.rb', 9)
      g.変換表.each do |(k, v)|
        puts "#{k}\t#{v}"
      end
    end
  end
end
