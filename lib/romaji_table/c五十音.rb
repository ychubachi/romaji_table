# -*- coding: utf-8 -*-

# Class: YARD::CLI::Yardoc — Documentation for yard (0.8.7)
# - http://rubydoc.info/docs/yard/YARD/CLI/Yardoc
# 99式ローマ字
# - http://roomazi.org/99/details.html)
# 外来語の表記：文部科学省
# - http://www.mext.go.jp/b_menu/hakusho/nc/k19910628002/k19910628002.html

module RomajiTable
  # 五十音を抽象化したクラス
  #
  class C五十音
    # 五十音の表
    #
    # 行を示すSymbolがkeyであり，かな文字の配列がValueである．
    attr :表

    # 直音の行
    #
    # 直音とは，あいうえ，がぎぐげご，ぱぴぷぺぽ，などの，拗音以外の普通のかな文字．
    #
    # 例） 直音行[:あ行] => ['あ',   'い',   'う',   'え',   'お'  ]
    attr :直音行

    # 五十音を初期化する
    def initialize
      @表 = {
        # 直音をあらわすカナ
        あ行:     ['あ',   'い',   'う',   'え',   'お'  ],
        か行:     ['か',   'き',   'く',   'け',   'こ'  ],
        が行:     ['が',   'ぎ',   'ぐ',   'げ',   'ご'  ],
        さ行:     ['さ',   'し',   'す',   'せ',   'そ'  ],
        ざ行:     ['ざ',   'じ',   'ず',   'ぜ',   'ぞ'  ],
        た行:     ['た',   'ち',   'つ',   'て',   'と'  ],
        だ行:     ['だ',   'ぢ',   'づ',   'で',   'ど'  ],
        な行:     ['な',   'に',   'ぬ',   'ね',   'の'  ],
        は行:     ['は',   'ひ',   'ふ',   'へ',   'ほ'  ],
        ば行:     ['ば',   'び',   'ぶ',   'べ',   'ぼ'  ],
        ぱ行:     ['ぱ',   'ぴ',   'ぷ',   'ぺ',   'ぽ'  ],
        ま行:     ['ま',   'み',   'む',   'め',   'も'  ],
        や行:     ['や',   'い',   'ゆ',   'え',   'よ'  ],
        ら行:     ['ら',   'り',   'る',   'れ',   'ろ'  ],
        わ行:     ['わ',   'ゐ',   'う',   'ゑ',   'を'  ],

        # イ列ヤ行拗音をあらわすカナ
        きゃ行:   ['きゃ', 'きぃ', 'きゅ', 'きぇ', 'きょ'], # ky
        ぎゃ行:   ['ぎゃ', 'ぎぃ', 'ぎゅ', 'ぎぇ', 'ぎょ'], # gy
        しゃ行:   ['しゃ', 'しぃ', 'しゅ', 'しぇ', 'しょ'], # sy
        じゃ行:   ['じゃ', 'じぃ', 'じゅ', 'じぇ', 'じょ'], # zy
        ちゃ行:   ['ちゃ', 'ちぃ', 'ちゅ', 'ちぇ', 'ちょ'], # ty
        ぢゃ行:   ['ぢゃ', 'ぢぃ', 'ぢゅ', 'ぢぇ', 'ぢょ'], # zy
        にゃ行:   ['にゃ', 'にぃ', 'にゅ', 'にぇ', 'にょ'], # ny
        ひゃ行:   ['ひゃ', 'ひぃ', 'ひゅ', 'ひぇ', 'ひょ'], # hy
        びゃ行:   ['びゃ', 'びぃ', 'びゅ', 'びぇ', 'びょ'], # by
        ぴゃ行:   ['ぴゃ', 'ぴぃ', 'ぴゅ', 'ぴぇ', 'ぴょ'], # py
        みゃ行:   ['みゃ', 'みぃ', 'みゅ', 'みぇ', 'みょ'], # my
        りゃ行:   ['りゃ', 'りぃ', 'りゅ', 'れぇ', 'りょ'], # ry

        # ウ列ワ行拗音をあらわすカナ
        うぁ行:   ['うぁ', 'うぃ', 'うぅ', 'うぇ', 'うぉ'],
        くぁ行:   ['くぁ', 'くぃ', 'くぅ', 'くぇ', 'くぉ'], # kw
        ぐぁ行:   ['ぐぁ', 'ぐぃ', 'ぐぅ', 'ぐぇ', 'ぐぉ'], # gw # Mozcにない行
        すぁ行:   ['すぁ', 'すぃ', 'すぅ', 'すぇ', 'すぉ'], # sw
        ずぁ行:   ['ずぁ', 'ずぃ', 'ずぅ', 'ぐぇ', 'ぐぉ'], # zw # Mozcにない行
        つぁ行:   ['つぁ', 'つぃ', 'つぅ', 'つぇ', 'つぉ'], # tw # 99 ts # Mozcに「つぅ」ない
        づぁ行:   ['づぁ', 'づぃ', 'づぅ', 'づぇ', 'づぉ'], # zw # 99 zw[dz] # Mozcにない行
        ぬぁ行:   ['ぬぁ', 'ぬぃ', 'ぬぅ', 'ぬぇ', 'ぬぉ'], # nw # 99 nw
        ふぁ行:   ['ふぁ', 'ふぃ', 'ふぅ', 'ふぇ', 'ふぉ'], # hw # 99 f
        ぶぁ行:   ['ぶぁ', 'ぶぃ', 'ぶぅ', 'ぶぇ', 'ぶぉ'], # bw # 99 bw
        ぷぁ行:   ['ぷぁ', 'ぷぃ', 'ぷぅ', 'ぷぇ', 'ぷぉ'], # pw # 99 pw
        むぁ行:   ['むぁ', 'むぃ', 'むぅ', 'むぇ', 'むぉ'], # mw # 99 mw
        るぁ行:   ['るぁ', 'るぃ', 'るぅ', 'るぇ', 'るぉ'], # rw #99 rw
        ゔぁ行:   ['ゔぁ', 'ゔぃ', 'ゔぅ', 'ゔぇ', 'ゔぉ'], # vw

        # ウ列ヤ行拗音をあらわすカナ
        ふゃ行:   ['ふゃ', 'ふぃ', 'ふゅ', 'ふぇ', 'ふょ'], # hj # 99 fy（i,e空白）# Mozcにない
        ぶゃ行:   ['ぶゃ', 'ぶぃ', 'ぶゅ', 'ぶぇ', 'ぶょ'], # bj
        ぷゃ行:   ['ぷゃ', 'ぷぃ', 'ぷゅ', 'ぷぇ', 'ぷょ'], # pj
        ゔゃ行:   ['ゔゃ', 'ゔぃ', 'ゔゅ', 'ゔぇ', 'ゔょ'], # vj ? # 99 vy（i,e空白）# Mozcにない

        # エ列ヤ行拗音をあらわすカナ
        てゃ行:   ['てゃ', 'てぃ', 'てゅ', 'てぇ', 'てょ'], # tj # 99 tj
        でゃ行:   ['でゃ', 'でぃ', 'でゅ', 'でぇ', 'でょ'], # dj # 99 dj

        # オ列ワ行拗音をあらわすカナ
        とぁ行:   ['とぁ', 'とぃ', 'とぅ', 'とぇ', 'とぉ'], # 99 tw
        どぁ行:   ['どぁ', 'どぃ', 'どぅ', 'どぇ', 'どぉ'], # 99 dw
        ほぁ行:   ['ほぁ', 'ほぃ', 'ほぅ', 'ほぇ', 'ほぉ'], # 99 hw
        ぼぁ行:   ['ぼぁ', 'ぼぃ', 'ぼぅ', 'ぼぇ', 'ぼぉ'],
        ぽぁ行:   ['ぽぁ', 'ぽぃ', 'ぽぅ', 'ぽぇ', 'ぽぉ'],

        # ヘボン式
        しゃ行h:  ['しゃ', 'しぃ', 'し',   'しぇ', 'しょ'], # ヘボン式のshiは「し」
        ちゃ行h:  ['ちゃ', 'ち',   'ちゅ', 'ちぇ', 'ちょ'], # ヘボン式のchiは「ち」
        じゃ行h:  ['じゃ', 'じ',   'じゅ', 'じぇ', 'じょ'], # ヘボン式のji は「じ」

        # 99例外
        うぁ行h:  ['うぁ', 'うぃ', 'う',   'うぇ', 'うぉ'], # 99 w
        ゔぁ行h:  ['ゔぁ', 'ゔぃ', 'ゔ',   'ゔぇ', 'ゔぉ'], # 99 v（u例外）

        # 独自追加
        ぁ行:     ['ぁ',   'ぃ',   'ぅ',   'ぇ',   'ぉ'  ],
        ゃ行:     ['ゃ',   'ぃ',   'ゅ',   'ぅ',   'ょ'  ],
        ゎ行:     ['ゎ',   'ぃ',   'ぅ',   'ぇ',   'ぉ'  ],
        ゔ行:     ['ゔ',   'ゔ',   'ゔ',   'ゔ',   'ゔ'  ],
      }

      @表.default_proc = Proc.new {
        |hash, key| raise "「#{key}」は行として登録されていません"
      }
      @表.freeze

      @直音行 = [:あ行,
                 :か行, :さ行, :た行, :な行,
                 :は行, :ま行, :や行, :ら行, :わ行,
                 :が行, :ざ行, :だ行,
                 :ば行, :ぱ行]
      @直音行.freeze
    end

    # 行と列を与えると，かなを返す
    def かな(行, 列)
      行x = @表[行]

      列x = @表[:あ行].index(列.to_s[0])
      if 列x == nil
        raise "「#{列}」はあ行の文字ではありません"
      end

      行x[列x]
    end

    # 行と列，拗音行を与えると，拗音行を返す
    def 拗音(行, 列, 拗音行)
      unless [:ゃ行, :ぁ行].include?(拗音行)
        raise '拗音行には「ゃ行」または「ぁ行」を指定してください'
      end

      かな = "#{かな(行, 列)}#{拗音行.to_s[0]}行"
      かな.to_sym
    end
  end
end

# 99式ローマ字は新種のヘボン式か - http://xembho.s59.xrea.com/kakimono/99siki.html
# 実際に使う使わないは別として、よい理論はあらかじめその全部を知らせる。
