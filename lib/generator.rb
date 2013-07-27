#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

class Generator
  attr :母音順, true
  attr :鍵盤母音位置
  attr :変換表

  def initialize
    # 変換表の生成結果を格納する配列
    @変換表 = []

    # キーボード配列の表
    self.鍵盤 = {
      左: { 上: '\',.py', 中: 'aoeui', 下: ';qjkx' },
      右: { 上: 'fgcrl',  中: 'dhtns', 下: 'bmwvz' }
    }
    
    # 01234    04321
    # aiueo -> aoeui
    self.母音順 = [0, 4, 3, 2, 1]

    @五十音表 = {
      あ行:   ['あ',   'い',   'う',   'え',   'お'  ],
      か行:   ['か',   'き',   'く',   'け',   'こ'  ],
      が行:   ['が',   'ぎ',   'ぐ',   'げ',   'ご'  ],
      さ行:   ['さ',   'し',   'す',   'せ',   'そ'  ],
      ざ行:   ['ざ',   'じ',   'ず',   'ぜ',   'ぞ'  ],
      た行:   ['た',   'ち',   'つ',   'て',   'と'  ],
      だ行:   ['だ',   'ぢ',   'づ',   'で',   'ど'  ],
      な行:   ['な',   'に',   'ぬ',   'ね',   'の'  ],
      は行:   ['は',   'ひ',   'ふ',   'へ',   'ほ'  ],
      ば行:   ['ば',   'び',   'ぶ',   'べ',   'ぼ'  ],
      ぱ行:   ['ぱ',   'ぴ',   'ぷ',   'ぺ',   'ぽ'  ],
      ま行:   ['ま',   'み',   'む',   'め',   'も'  ],
      や行:   ['や',   '　',   'ゆ',   '　',   'よ'  ],
      ら行:   ['ら',   'り',   'る',   'れ',   'ろ'  ],
      わ行:   ['わ',   'ゐ',   '　',   'ゑ',   'を'  ],
      # ゃぃゅぇょ
      ゃ行:   ['ゃ',   '　',   'ゅ',   '　',   'ょ'  ],
      きゃ行: ['きゃ', 'きぃ', 'きゅ', 'きぇ', 'きょ'],
      ぎゃ行: ['ぎゃ', 'ぎぃ', 'ぎゅ', 'ぎぇ', 'ぎょ'],
      しゃ行: ['しゃ', 'しぃ', 'しゅ', 'しぇ', 'しょ'], # ヘボン式のshiは「し」
      じゃ行: ['じゃ', 'じぃ', 'じゅ', 'じぇ', 'じょ'], # ヘボン式のji は「じ」
      ちゃ行: ['ちゃ', 'ちぃ', 'ちゅ', 'ちぇ', 'ちょ'], # ヘボン式のchiは「ち」
      ぢゃ行: ['ぢゃ', 'ぢぃ', 'ぢゅ', 'ぢぇ', 'ぢょ'],
      てゃ行: ['てゃ', 'てぃ', 'てゅ', 'てぇ', 'てょ'],
      でゃ行: ['でゃ', 'でぃ', 'でゅ', 'でぇ', 'でょ'],
      にゃ行: ['にゃ', 'にぃ', 'にゅ', 'にぇ', 'にょ'],
      ひゃ行: ['ひゃ', 'ひぃ', 'ひゅ', 'ひぇ', 'ひょ'],
      びゃ行: ['びゃ', 'びぃ', 'びゅ', 'びぇ', 'びょ'],
      ぴゃ行: ['ぴゃ', 'ぴぃ', 'ぴゅ', 'ぴぇ', 'ぴょ'],
      ふゃ行: ['ふゅ', '　',   'ふゅ', '○',   'ふょ'],
      みゃ行: ['みゃ', 'みぃ', 'みゅ', 'みぇ', 'みょ'],
      りゃ行: ['りゃ', 'りぃ', 'りゅ', 'れぇ', 'りょ'],
      ゔゃ行: ['ゔゃ', 'ゔぃ', 'ゔゅ', 'ゔぇ', 'ゔょ'],
      # ぁぃぅぇぉ
      ぁ行:   ['ぁ',   'ぃ',   'ぅ',   'ぇ',   'ぉ'  ], # la, xa
      うぁ行: ['うぁ', 'うぃ', 'う',   'うぇ', 'うぉ'],
      ゔぁ行: ['ゔぁ', 'ゔぃ', 'ゔ',   'ゔぇ', 'ゔぉ'], # ゔぅ？
      くぁ行: ['くぁ', 'くぃ', 'く',   'くぇ', 'くぉ'],
      つぁ行: ['つぁ', 'つぃ', 'つぅ', 'つぇ', 'つぉ'], # Mozcに「つぅ」ない
      とぁ行: ['とぁ', 'とぃ', 'とぅ', 'とぇ', 'とぉ'],
      どぁ行: ['どぁ', 'どぃ', 'どぅ', 'どぇ', 'どぉ'],
      ふぁ行: ['ふぁ', 'ふぃ', 'ふ',   'ふぇ', 'ふぉ'], # ふぅ？
    }

    # が行(), さ行() ... 操作を追加
    @五十音表.each_key do |行|
      eval <<-RUBY
            def #{行}
              @五十音表[:#{行}]
            end
          RUBY
    end
  end

  def 鍵盤=(鍵盤)
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
    @鍵盤母音位置 = []
    結果.sort.each do |k, v|
      @鍵盤母音位置 << v
    end
  end
  
  def 変換表作成(ローマ字, かな)
    @変換表 << [ローマ字, かな]
    [ローマ字, かな]
  end

  # 省略して位置を指定された場合です
  def 省略R(位置: nil, 段: nil)
    case
    when 位置 == {} # 変化鍵の省略
      ''
    when !位置[:段] # 位置の省略
      段 != nil or raise '位置の段が省略されているため段を指定してください'
      @鍵盤[位置[:左右]][段][位置[:番号]]
    else
      @鍵盤[位置[:左右]][位置[:段]][位置[:番号]]
    end
  end

  def 変換(かな,
           子音位置: nil, 母音位置: nil,
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
      母音位置 =
        case 母音位置
        when Array
          母音位置
        when Hash
          母音位置正規化 母音位置[:左右], 母音位置[:段], 番号: 母音位置[:番号]
        when :鍵盤
          鍵盤母音位置
        else
          raise '母音位置は配列，連想配列，シンボルで指定してください'
        end

      かな =
        case かな
        when Array
          かな
        when String
          かな.split("")
        when Symbol
          @五十音表[かな]
        else
          raise 'かなはシンボル，文字列，配列で指定してください'
        end

      if かな.length != 母音位置.length
        raise 'かなは母音位置と同じ文字数で指定してください'
      end

      if 子音位置 && 子音位置[:番号] == nil
        raise '子音位置の番号は省略できません'
      end

      子音R = 子音位置 ? @鍵盤[子音位置[:左右]][子音位置[:段]][子音位置[:番号]] : ''
      拗音R = 拗音化 ? 省略R(位置: 拗音化, 段: 子音位置[:段]) : ''
      促音R = 促音化 ? 省略R(位置: 促音化, 段: 子音位置[:段]) : ''
      
      促音 = 促音化 ? 'っ' : ''
      撥音 = 撥音化 ? 'ん' : ''
      
      結果 = []
      [かな, 母音位置].transpose.each do | (かなI, 母音位置I) |
        母音R = @鍵盤[母音位置I[:左右]][母音位置I[:段]][母音位置I[:番号]]
        結果 << 変換表作成("#{子音R}#{拗音R}#{促音R}#{母音R}", "#{かなI}#{促音}#{撥音}")
      end
      結果
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

  def self.execute(contents)
    g = Generator.new 
    g.instance_eval(contents)
    g.変換表.each do |(k, v)|
      puts "#{k}\t#{v}"
    end
  end
end
