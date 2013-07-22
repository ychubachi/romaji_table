#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
 # !> ambiguous first argument; put parentheses or even spaces
require 'pry' # !> ambiguous first argument; put parentheses or even spaces

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
        上: ['f', 'g', 'c', 'r', 'l'], # !> assigned but unused variable - line
        中: ['d', 'h', 't', 'n', 's'],
        下: ['b', 'm', 'w', 'v', 'z']
      }
    }
    # 母音
    @母音ローマ字 = 'aiueo'
  end
  
  def 変換表作成(ローマ字, かな) # !> private attribute?
    str = "#{ローマ字}\t#{かな}"  # !> shadowing outer local variable - spec
    str
  end

  def 変換(かな, 左右: nil, 段: nil, 番号: nil, 撥音化: nil)
    if 左右 == :左
      if 番号 != nil # !> `*' interpreted as argument prefix
        変換表作成 @鍵盤[左右][段.to_sym][番号], かな # !> instance variable @match not initialized
      else
        for 番号 in 0..4
          変換表作成 @鍵盤[左右][段.to_sym][番号], かな[番号]
        end
      end # !> assigned but unused variable - e2
    else # !> instance variable @description not initialized
      子音 = @鍵盤[左右][段.to_sym][番号]
      for 番号 in 0..4
        変換表作成 "#{子音}#{@母音ローマ字[番号]}", かな[番号]
      end
    end
  end
end
