# -*- coding: utf-8 -*-
require "romaji_table/version"
require "romaji_table/c生成器"

module RomajiTable
  module Delegator
    def self.delegate(*methods)
      methods.each do |method_name|
        eval <<-RUBY, binding, '(__DELEGATE__)', 1
          def #{method_name}(*args, &b)
            ::RomajiTable::C生成器.
              instance.send(#{method_name.inspect}, *args, &b)
          end
          # private #{method_name.inspect}
        RUBY
      end
    end

    delegate :母音順
  end
end

# SinatraはDSLなんかじゃない、Ruby偽装を使ったマインドコントロールだ！
# - hp12c - http://d.hatena.ne.jp/keyesberry/20110603/p1
