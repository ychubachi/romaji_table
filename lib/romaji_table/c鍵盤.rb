# -*- coding: utf-8 -*-

module RomajiTable
  class C鍵盤
    attr :鍵盤
    attr :母音

    # 定数
    Dvorak = {
      左: { 上: '\',.py', 中: 'aoeui', 下: ';qjkx' },
      右: { 上: 'fgcrl',  中: 'dhtns', 下: 'bmwvz' }
    }

    Qwerty = {
      左: { 上: 'qwert', 中: 'asdfg', 下: 'zxcvb'},
      右: { 上: 'yuiop', 中: 'hjkl;', 下: 'nm,./'}
    }

    def initialize
      登録(Dvorak)
    end

    def 登録(鍵盤)
      @鍵盤 = 鍵盤

      # 母音を検索
      結果 = {}
      for 左右 in [:左, :右]
        for 段 in [:上, :中, :下]
          for 番号 in 0..4
            鍵 = @鍵盤[左右][段][番号]
            検索 = 'aiueo'.index(鍵)
            if 検索
              結果["あいうえお"[検索]] = {左右: 左右, 段: 段, 番号: 番号}
            end
          end
        end
      end
      @母音 = []
      結果.sort.each do |k, v|
        @母音 << v
      end
    end

    def [] 左右
      @鍵盤[左右]
    end

    def self.シフト(位置)
      位置 = 位置.dup
      位置[:シフト] = true
      位置
    end
  end
end
