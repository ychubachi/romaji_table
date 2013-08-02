#!/usr/bin/env ruby
# -*- coding: utf-8 -*-


require_relative 'c鍵盤'
require_relative 'c五十音'

=begin
# ローマ字変換表生成器

# ほげ
位置とは，連想配列による鍵盤の座標表現のことである．

 hoge

```ruby
 a = a + 1
 if hoge
   p 'baka'
 end
```

do_this_and_do_that_and_another_thing
=end
class Generator
  attr :母音順, true
  attr :鍵盤母音
  attr :変換表

  Qwerty = C鍵盤::Qwerty
  Dvorak = C鍵盤::Dvorak

  # DSL実行
  def self.execute(contents)
    g = Generator.new
    g.instance_eval(contents)
    g.変換表.each do |(k, v)|
      puts "#{k}\t#{v}"
    end
  end

  # DSL初期化
  def initialize
    # 変換表の生成結果を格納する配列
    @変換表 = []

    # キーボード配列の表
    @鍵盤 = C鍵盤.new

    # 01234    04321
    # aiueo -> aoeui
    self.母音順 = [0, 4, 3, 2, 1]

    @五十音 = C五十音.new

    # が行(), さ行() ... 操作を追加
    @五十音.表.each_key do |行|
      eval <<-RUBY
            def #{行}
              @五十音.表[:#{行}]
            end
          RUBY
    end

    @二重母音 = nil
  end

  # DSL
  def 鍵盤登録(鍵盤)
    @鍵盤.登録 鍵盤
  end

  # DSL
  def 鍵盤母音
    @鍵盤.母音
  end

  #DSL
  def 二重母音登録(二重母音)
    @二重母音 = 二重母音
  end

  #DSL
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
      段 = @五十音.表[:あ行].index(二重母音[0])
      結果 << "#{行[段]}#{二重母音[1]}"
    end
    結果
  end

  # 子音と母音の位置を指定する．
  #
  # @param かな [String, Array<String>, Symbol]  打鍵順序に対応づけるひらがなである．
  #   「かな」がStringのときは1文字毎に，Arrayの場合は要素毎に変換規則を生成する．
  #   またSynbolの場合，{C五十音#表}の行を表す．
  # @param 母音 [Array, Hash] 母音の位置を指定するArrayもしくはHash．
  #   Hashの場合，内部で{#母音位置正規化}する．
  #   また，省略した（nil）場合，鍵盤にある母音の位置になる．
  #   いずれの場合も，必ず「かな」と同じ長さになるようにすること．
  # @param 子音 [Hash] 子音の位置を指定するHash．
  # @return [Array] ローマ字変換列
  # @todo 撥音化，拗音化の検査
  def 変換(かな,
           子音: nil, 母音: nil,
           拗音化: nil, 撥音化: nil, 促音化: nil,
           位置: nil)

    case
    when 位置
      ローマ字 = ''
      位置.each do |位置I|
        ローマ字 += @鍵盤[位置I[:左右]][位置I[:段]][位置I[:番号]]
      end
      [変換表作成(ローマ字, かな)]
    else
      かな配列 = かな配列化(かな)

      case
      when 子音 && 子音.is_a?(Hash) == false
        raise '子音は連想配列またはnilで指定してください'
      when 拗音化 && 拗音化.is_a?(Hash) == false
        raise '拗音は連想配列またはnilで指定してください'
      when 撥音化 && 撥音化.is_a?(Hash) == false
        raise '撥音は連想配列またはnilで指定してください'
      when 促音化 && 促音化.is_a?(Hash) == false
        raise '促音は連想配列またはnilで指定してください'
      end

      母音配列 =
        case 母音
        when Array
          # [Making Deep Copies in Ruby](http://ruby.about.com/od/advancedruby/a/deepcopy.htm)
          Marshal.load(Marshal.dump(母音))
        when Hash
          母音位置正規化(母音)
        when nil
          鍵盤母音
        else
          raise '母音位置は配列，連想配列またはnilで指定してください'
        end

      if かな配列.length != 母音配列.length
        raise 'かなは母音と同じ文字数で指定してください'
      end

      ## 母音の段が省略されている場合，子音の段を設定する
      n = 母音配列.length - 1
      for i in 0..n
        if 母音配列[i][:段] == nil
          母音配列[i] = 母音配列[i] # 上でDeep Copyしないと呼び元の変数を壊す
          母音配列[i][:段] = 子音[:段]
        end
      end

      子音R = 子音   ? @鍵盤[子音[:左右]][子音[:段]][子音[:番号]] : ''

      # TODO: ここのロジックを見直します
      if 子音
        拗音R = 拗音化 ? 省略R(位置: 拗音化, 段: 子音[:段]) : ''
        促音R = 促音化 ? 省略R(位置: 促音化, 段: 子音[:段]) : ''
      else
        拗音R = 拗音化 ? 省略R(位置: 拗音化) : ''
        促音R = 促音化 ? 省略R(位置: 促音化) : ''
      end

      促音  = 促音化 ? 'っ' : ''
      撥音  = 撥音化 ? 'ん' : ''

      結果 = []
      [かな配列, 母音配列].transpose.each do | (かなI, 母音I) |
        母音R = @鍵盤[母音I[:左右]][母音I[:段]][母音I[:番号]]
        結果 << 変換表作成("#{子音R}#{拗音R}#{促音R}#{母音R}", "#{かなI}#{促音}#{撥音}")
      end
      結果
    end
  end

  private

  def 変換表作成(ローマ字, かな)
    @変換表 << [ローマ字, かな]
    [ローマ字, かな]
  end

  # 省略して位置を指定された場合です
  #
  # @param 位置 [Hash]
  # @param
  def 省略R(位置: nil, 段: nil)
    case
    when 位置 == {} # 変化鍵の省略（母音の位置で判断）
      ''
    when !位置[:段] # 位置の省略
      if 段 == nil
        raise '位置の段が省略されているため段を指定してください'
      end
      @鍵盤[位置[:左右]][段][位置[:番号]]
    else
      @鍵盤[位置[:左右]][位置[:段]][位置[:番号]]
    end
  end

  # 指定に基づき，「かな」の配列を得る操作
  #
  # @param かな [Array, String, Symbol]
  #        かな（'かきくけこ'，['きゃ', 'きゅ', 'きょ'], :さ行）など．
  #        配列の場合は，そのまま返す．
  #        文字列の場合は，1文字ごとの配列にする．
  # @return [Array] かなの配列
  def かな配列化(かな)
    case かな
    when Array
      かな
    when String
      かな.split("")
    when Symbol
      @五十音.表[かな]
    else
      raise 'かなはシンボル，文字列，配列で指定してください'
    end
  end

  # 母音位置にて番号が省略されている場合，登録されている母音順に従い位置の配列に正規化する．
  # 番号を省略する場合は，必ず{#母音順}を設定しておくこと．
  #
  # @return [Array] 母音の配列
  def 母音位置正規化(左右: nil, 段: nil, 番号: nil)
    case
    when !番号
      if !@母音順
        raise '番号を省略する場合は母音順を設定してください'
      end
      結果 = []
      for 番号 in 0..4
        結果 << {左右: 左右, 段: 段, 番号: @母音順[番号]}
      end
      結果
    else
      if (0..4).include?(番号)
      else
        raise '番号は[0..4]で指定してください'
      end
      [{左右: 左右, 段: 段, 番号: 番号}]
    end
  end
end
