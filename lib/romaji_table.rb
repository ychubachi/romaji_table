# -*- coding: utf-8 -*-
require_relative "romaji_table/version"
require_relative "romaji_table/c生成器"

module RomajiTable
  module Delegator
    def self.delegate(*methods)
      methods.each do |method_name|
        eval <<-RUBY, TOPLEVEL_BINDING, '(__DELEGATE__)', 1
          def #{method_name}(*args, &b)
            ::RomajiTable::C生成器.
              instance.send(#{method_name.inspect}, *args, &b)
          end
        RUBY
      end
    end

    delegate(:鍵盤母音順, :鍵盤登録, :二重母音, :二重母音登録, :変換,
             :単文字登録, :行拗音化, :変換表, :変換表出力, :文字生成, :五十音合成,
             :直音行, :拗音行, :開拗音行, :合拗音行,
             :シフト,)
  end
end

# SinatraはDSLなんかじゃない、Ruby偽装を使ったマインドコントロールだ！
# - hp12c - http://d.hatena.ne.jp/keyesberry/20110603/p1
