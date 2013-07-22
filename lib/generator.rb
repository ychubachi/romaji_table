#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require('pry')

class Generator
  def initialize
    # キーボード配列の表
    @鍵盤 = {
      左: {
        上: ['\'', ',', '.', 'p', 'y'],
        中: ['a', 'o', 'e', 'u', 'i'],
        下: [';', 'q', 'j', 'k', 'x']
      },
      右: {
        上: ['f', 'g', 'c', 'r', 'l'],
        中: ['d', 'h', 't', 'n', 's'],
        下: ['b', 'm', 'w', 'v', 'z']
      }
    }
    # 母音
    @母音ローマ字 = 'aiueo'
  end
  
  def 変換表作成(ローマ字, かな)
    [ローマ字, かな]
  end

  def 変換(かな, 左右: nil, 段: nil, 番号: nil, 撥音化: nil)
    case
    when 左右 == :左 && 番号 != nil # 母音・単体
      if 撥音化 != nil
        かな += 'ん'
      end
      変換表作成 @鍵盤[左右][段][番号], かな
    when 左右 == :左 && 番号 == nil && かな.length == 5 # 母音・一括
      結果 = []
      for 番号 in 0..4
        結果 << 変換表作成(@鍵盤[左右][段][番号], かな[番号])
      end
      結果
    when 左右 == :右 && かな.length == 1 && 撥音化 != nil # 子音・単体・撥音化
      子音 = @鍵盤[左右][段][番号]
      母音
    when 左右 == :右 && かな.length == 5 # 子音・一括
      結果 = []
      子音 = @鍵盤[左右][段][番号]
      for 番号 in 0..4
        母音 = @母音ローマ字[番号]
        結果 << 変換表作成("#{子音}#{母音}", かな[番号])
      end
      結果
    else
      raise '定義できません'
    end
  end
end
