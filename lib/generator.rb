#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative 'c鍵盤'
require_relative 'c五十音'

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

    結果 = []
    @二重母音.each do |二重母音|
      段 = @五十音.表[:あ行].index(二重母音[0])
      結果 << "#{行[段]}#{二重母音[1]}"
    end
    結果
  end

  # DSL
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
      かな =
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

      子音 =
        case 子音
        when Hash
          子音
        when Array
          {左右: 子音[0], 段: 子音[1], 番号: 子音[2]}
        when nil
          nil
        else
          raise '子音は連想配列または配列で指定してください'
        end

      拗音化 =
        case 拗音化
        when Hash
          if 拗音化 != {} && 拗音化[:番号] == nil
             raise '拗音化の番号は省略できません'
          end
          拗音化
        when Array
          {左右: 拗音化[0], 段: 拗音化[1], 番号: 拗音化[2]}
        when nil
          nil
        else
          raise '拗音は連想配列または配列で指定してください'
        end

      母音 =
        case 母音
        when Array
          母音
        when Hash
          母音位置正規化 母音[:左右], 母音[:段], 番号: 母音[:番号]
        when :鍵盤
          鍵盤母音
        else
          raise '母音位置は配列，連想配列，シンボル（:鍵盤）で指定してください'
        end

      if かな.length != 母音.length
        raise 'かなは母音と同じ文字数で指定してください'
      end

      子音R = 子音   ? @鍵盤[子音[:左右]][子音[:段]][子音[:番号]] : ''
      拗音R = 拗音化 ? 省略R(位置: 拗音化, 段: 子音[:段]) : ''
      促音R = 促音化 ? 省略R(位置: 促音化, 段: 子音[:段]) : ''
      
      促音  = 促音化 ? 'っ' : ''
      撥音  = 撥音化 ? 'ん' : ''
      
      結果 = []
      [かな, 母音].transpose.each do | (かなI, 母音I) |
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
  def 省略R(位置: nil, 段: nil)
    case
    when 位置 == {} # 変化鍵の省略（母音の位置で判断）
      ''
    when !位置[:段] # 位置の省略
      段 != nil or raise '位置の段が省略されているため段を指定してください'
      @鍵盤[位置[:左右]][段][位置[:番号]]
    else
      @鍵盤[位置[:左右]][位置[:段]][位置[:番号]]
    end
  end

  # TODO: Hashを渡したほうがスマートか？
  def 母音位置正規化(左右, 段, 番号: nil)
    case
    when !番号
      @母音順 or raise '番号を省略する場合は母音順を設定してください．'
      結果 = []
      for 番号 in 0..4
        結果 << {左右: 左右, 段: 段, 番号: @母音順[番号]}
      end
      結果
    else
      (0..4).include?(番号) or raise '番号は[0..4]で指定してください．'
      [{左右: 左右, 段: 段, 番号: 番号}]
    end
  end
end
