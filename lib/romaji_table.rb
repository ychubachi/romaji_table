# -*- coding: utf-8 -*-
require_relative "romaji_table/version"
require_relative "romaji_table/c生成器"

module RomajiTable
  class Main
    def initialize(argv, stdin=STDIN, stdout=STDOUT, stderr=STDERR, kernel=Kernel)
      @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
    end

    def execute!
      p 'I am RomajiTable'
      # your code here, assign a value to exitstatus
      @kernel.exit(0)
    end
  end

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

    delegate(:母音順, :鍵盤登録, :二重母音, :二重母音登録, :直音行, :変換,
             :単文字登録, :行拗音化, :変換表, :変換表出力, :文字生成)
  end
end


# SinatraはDSLなんかじゃない、Ruby偽装を使ったマインドコントロールだ！
# - hp12c - http://d.hatena.ne.jp/keyesberry/20110603/p1
