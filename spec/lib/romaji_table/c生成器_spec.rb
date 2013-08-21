# -*- coding: utf-8 -*-

# Coverage
# Linux:
#   file:///home/yc/git/romaji_table/coverage/index.html
# Mac:
#   file:///Users/yc/git/romaji_table/coverage/index.html

require 'romaji_table/c生成器'
require 'ice_nine'

describe RomajiTable::C生成器 do
  subject(:s){RomajiTable::C生成器.instance}

  describe '#initialize' do
    it '実体を生成する' do
      生成器 = RomajiTable::C生成器.instance
      expect(生成器).not_to be nil
      expect(生成器).to be_a RomajiTable::C生成器
    end
  end

  describe '#変換' do
    it '文字と，確定鍵の位置の配列を与えると，対応表を返す' do
      # 文字の数と同じ数の確定権を指定する
      r = s.変換('あいうえお', 確定鍵: [{左右: :右, 段: :中, 番号: 0}, {左右: :右, 段: :中, 番号: 1},
                                        {左右: :右, 段: :中, 番号: 2}, {左右: :右, 段: :中, 番号: 3},
                                        {左右: :右, 段: :中, 番号: 4}])
      expect(r).to eq ["d\tあ", "h\tい", "t\tう", "n\tえ", "s\tお"]
    end

    it '確定鍵の番号を指定すると，標準を返す' do
      確定鍵 = {左右: :左, 段: :中}.freeze
      r = s.変換('あいうえお', 確定鍵: 確定鍵)
      expect(r).to eq ["a\tあ", "i\tい", "u\tう", "e\tえ", "o\tお"]
    end
    it '確定鍵の番号を指定すると，標準を返す（シフト）' do
      確定鍵 = {左右: :左, 段: :中, シフト: true}.freeze
      r = s.変換('あいうえお', 確定鍵: 確定鍵)
      expect(r).to eq ["A\tあ", "I\tい", "U\tう", "E\tえ", "O\tお"]
    end

    it '確定鍵を省略すると，鍵盤にある母音鍵を用いる' do
      r = s.変換('あいうえお')
      expect(r).to eq(["a\tあ", "i\tい", "u\tう", "e\tえ", "o\tお"])
    end

    it '直音の変換表を作る' do
      s.変換(:あ行).
        should eq(["a\tあ",  "i\tい",  "u\tう",  "e\tえ",  "o\tお"])
      s.変換(:か行, 開始鍵: {左右: :右, 段: :上, 番号: 2}).
        should eq(["ca\tか", "ci\tき", "cu\tく", "ce\tけ", "co\tこ"])
      s.変換(:さ行, 開始鍵: {左右: :右, 段: :中, 番号: 4}).
        should eq(["sa\tさ", "si\tし", "su\tす", "se\tせ", "so\tそ"])
      s.変換(:た行, 開始鍵: {左右: :右, 段: :中, 番号: 2}).
        should eq(["ta\tた", "ti\tち", "tu\tつ", "te\tて", "to\tと"])
      s.変換(:な行, 開始鍵: {左右: :右, 段: :中, 番号: 3}).
        should eq(["na\tな", "ni\tに", "nu\tぬ", "ne\tね", "no\tの"])
      s.変換(:は行, 開始鍵: {左右: :右, 段: :中, 番号: 1}).
        should eq(["ha\tは", "hi\tひ", "hu\tふ", "he\tへ", "ho\tほ"])
      s.変換(:ま行, 開始鍵: {左右: :右, 段: :下, 番号: 1}).
        should eq(["ma\tま", "mi\tみ", "mu\tむ", "me\tめ", "mo\tも"])
      s.変換(:や行, 開始鍵: {左右: :右, 段: :下, 番号: 3}).
        should eq(["va\tや", "vi\tい", "vu\tゆ", "ve\tえ", "vo\tよ"])
      s.変換(:ら行, 開始鍵: {左右: :右, 段: :上, 番号: 3}).
        should eq(["ra\tら", "ri\tり", "ru\tる", "re\tれ", "ro\tろ"])
      s.変換(:わ行, 開始鍵: {左右: :右, 段: :下, 番号: 2}).
        should eq(["wa\tわ", "wi\tゐ", "wu\tう", "we\tゑ", "wo\tを"])
      s.変換(:が行, 開始鍵: {左右: :右, 段: :上, 番号: 1}).
        should eq(["ga\tが", "gi\tぎ", "gu\tぐ", "ge\tげ", "go\tご"])
      s.変換(:ざ行, 開始鍵: {左右: :右, 段: :下, 番号: 4}).
        should eq(["za\tざ", "zi\tじ", "zu\tず", "ze\tぜ", "zo\tぞ"])
      s.変換(:だ行, 開始鍵: {左右: :右, 段: :中, 番号: 0}).
        should eq(["da\tだ", "di\tぢ", "du\tづ", "de\tで", "do\tど"])
      s.変換(:ば行, 開始鍵: {左右: :右, 段: :下, 番号: 0}).
        should eq(["ba\tば", "bi\tび", "bu\tぶ", "be\tべ", "bo\tぼ"])
      s.変換(:ぱ行, 開始鍵: {左右: :右, 段: :上, 番号: 0}).
        should eq(["fa\tぱ", "fi\tぴ", "fu\tぷ", "fe\tぺ", "fo\tぽ"])
    end

    it '拗音を登録する' do
      r = s.変換(:ぁ行, 開始鍵: {左右: :右, 段: :上, 番号: 4})
      expect(r).to eq ["la\tぁ", "li\tぃ", "lu\tぅ", "le\tぇ", "lo\tぉ"]
    end

    it '段を省略した中間鍵を用い，拗音を登録する' do
      中間鍵 = IceNine.deep_freeze({左右: :右, 番号: 1})
      r = s.変換(:きゃ行, 開始鍵: {左右: :右, 段: :上, 番号: 2}, 中間鍵: 中間鍵)
      expect(r).to eq ["cga\tきゃ", "cgi\tきぃ", "cgu\tきゅ", "cge\tきぇ", "cgo\tきょ"]
    end

    it '文字に追加する文字を渡すことで，撥音や促音などを生成できる' do
      r = s.変換("あいうえお", 追加文字: 'ん', 確定鍵: {左右: :左, 段: :下})
      expect(r).to eq [";\tあん", "x\tいん", "k\tうん", "j\tえん", "q\tおん"]
      r = s.変換(:か行, 追加文字: 'ん', 開始鍵: {左右: :右, 段: :上, 番号: 2}, 確定鍵: {左右: :左, 段: :下})
      expect(r).to eq ["c;\tかん", "cx\tきん", "ck\tくん", "cj\tけん", "cq\tこん"]
      r = s.変換(:きゃ行, 追加文字: 'っ',
                 開始鍵: {左右: :右, 段: :上, 番号: 2},
                 中間鍵: {左右: :右, 番号: 0},
                 確定鍵: {左右: :左, 段: :上}
                 )
      expect(r).to eq ["cf'\tきゃっ", "cfy\tきぃっ", "cfp\tきゅっ", "cf.\tきぇっ", "cf,\tきょっ"]
      r = s.変換(:きゃ行, 追加文字: 'ん',
                 開始鍵: {左右: :右, 段: :上, 番号: 2},
                 中間鍵: {左右: :右, 番号: 1},
                 確定鍵: {左右: :左, 段: :下})
      expect(r).to eq ["cg;\tきゃん", "cgx\tきぃん", "cgk\tきゅん", "cgj\tきぇん", "cgq\tきょん"]
    end

    it '二重母音を与えて，対応表を作成する' do
      r = s.変換(['あい', 'うい', 'うう', 'えい', 'おう'], 確定鍵: {左右: :左, 段: :上})
      expect(r).to eq ["'\tあい", "y\tうい", "p\tうう", ".\tえい", ",\tおう"]
      r = s.変換(['かい', 'くい', 'くう', 'けい', 'こう'],
                 開始鍵: {左右: :右, 段: :上, 番号: 2}, 確定鍵: {左右: :左, 段: :上})
      expect(r).to eq ["c'\tかい", "cy\tくい", "cp\tくう", "c.\tけい", "c,\tこう"]
    end

    it '二重母音を与え，母音の段を省略して，対応表を作成録する' do
      s.二重母音登録 ['うう', 'おう']
      母音A = {左右: :右, 番号: 2}.freeze
      母音B = {左右: :右, 番号: 4}.freeze
      r = s.変換(s.二重母音(:にゃ行),
                 開始鍵: {左右: :右, 段: :中, 番号: 3}, 確定鍵: [母音A, 母音B])
      expect(r).to eq ["nt\tにゅう", "ns\tにょう"]
      r = s.変換(s.二重母音(:みゃ行),
                 開始鍵: {左右: :右, 段: :下, 番号: 1}, 確定鍵: [母音A, 母音B])
      expect(r). to eq ["mw\tみゅう", "mz\tみょう"]
    end

    it '範囲外の鍵を登録するなど，特殊な変換を登録する' do
      expect(s.変換('ん', 開始鍵: {左右: :右, 段: :中, 番号: 3},
                    確定鍵: {範囲外: "\'"})).to eq ["n'\tん"]
      expect(s.変換 'ー', 確定鍵: {範囲外: "-"}).to eq ["-\tー"]
    end

    it '制限事項' do
      expect{
        s.変換('いうえお', 確定鍵: {左右: :左, 段: :中})
      }.to raise_error '文字は確定鍵と同じ文字数で指定してください'
      expect{
        s.変換(:あ行, 確定鍵: [{左右: :右, 段: :中, 番号: 0}])
      }.to raise_error '文字は確定鍵と同じ文字数で指定してください'
      expect{
        s.変換(nil, 確定鍵: [{左右: :右, 段: :中, 番号: 0}])
      }.to raise_error '文字はシンボル，文字列，配列で指定してください'
      expect{
        s.変換(:あ行, 確定鍵: :シンボル)
      }.to raise_error '確定鍵は連想配列または配列で指定，または，省略してください'
      expect{
        s.変換(:か行, 開始鍵: {左右: :右, 段: :上}, 確定鍵: :シンボル)
      }.to raise_error '確定鍵は連想配列または配列で指定，または，省略してください'
      expect{
        s.変換(:か行, 開始鍵: :しいん)
      }.to raise_error '開始鍵は連想配列で指定，または，省略してください'
      expect{
        s.変換(:か行, 中間鍵: :ようおん)
      }.to raise_error '中間鍵は連想配列または配列で指定，または，省略してください'
    end
  end

  describe '#単文字登録' do
    it '文字と位置を与えると，対応表を返す' do
      expect(s.単文字登録('っ', [{左右: :左, 段: :上, 番号: 0}])).to eq(["'", "っ"])
      expect(s.単文字登録('，', [{左右: :左, 段: :上, 番号: 1}])).to eq([",", "，"])
      expect(s.単文字登録('．', [{左右: :左, 段: :上, 番号: 2}])).to eq([".", "．"])
      expect(s.単文字登録('ー', [{左右: :左, 段: :上, 番号: 3}])).to eq(["p", "ー"])
      expect(s.単文字登録('？', [{左右: :左, 段: :上, 番号: 4}])).to eq(["y", "？"])
      expect(s.単文字登録('ん', [{左右: :右, 段: :中, 番号: 3}, {左右: :右, 段: :中, 番号: 3}])).to eq(["nn", "ん"])
    end

    it '制限事項' do
      expect{
        s.単文字登録(nil, [{左右: :左, 段: :上, 番号: 0}])
      }.to raise_error('文字は文字列で指定してください')
      expect{
        s.単文字登録('あ', nil)
      }.to raise_error('確定鍵は配列で指定してください')
    end
  end

  describe '#鍵盤登録' do
    it '鍵盤を登録すると，鍵盤の母音が変化する' do
      s.鍵盤登録(RomajiTable::Qwerty)
      expect(s.鍵盤.母音.length).to eq 5
      expect(s.鍵盤.母音).
        to eq [{左右: :左, 段: :中, 番号: 0},
               {左右: :右, 段: :上, 番号: 2},
               {左右: :右, 段: :上, 番号: 1},
               {左右: :左, 段: :上, 番号: 2},
               {左右: :右, 段: :上, 番号: 3}]
      s.鍵盤登録(RomajiTable::Dvorak)
    end
  end

  describe '#二重母音登録' do
    it '二重母音を登録する' do
      expect(s.二重母音登録 ['あん', 'うい', 'うう', 'えい', 'おう']).to eq ["あん", "うい", "うう", "えい", "おう"]
    end
  end

  describe '#二重母音' do
    it '行を二重母音にする' do
      s.二重母音登録 ['あん', 'うい', 'うう', 'えい', 'おう']
      expect(s.二重母音(s.五十音.表[:あ行])).to eq ['あん', 'うい', 'うう', 'えい', 'おう']
      expect(s.二重母音(s.五十音.表[:か行])).to eq ['かん', 'くい', 'くう', 'けい', 'こう']
      expect(s.二重母音(s.五十音.表[:しゃ行])).
        to eq ["しゃん", "しゅい", "しゅう", "しぇい", "しょう"]
      s.二重母音登録 ['えあ', 'いう', 'うえ']
      expect(s.二重母音(s.五十音.表[:か行])).to eq ['けあ', 'きう', 'くえ']
    end

    it '二重母音の行をシンボルで指定する' do
      s.二重母音登録 ['ああ', 'うい', 'うう', 'えい', 'おう']
      r = s.変換(s.二重母音(:か行), 開始鍵: {左右: :右, 段: :上, 番号: 2}, 確定鍵: {左右: :左, 段: :上})
      expect(r).to eq ["c'\tかあ", "cy\tくい", "cp\tくう", "c.\tけい", "c,\tこう"]
    end

    it '二重母音が登録されていなければ，例外発生' do
      s.二重母音登録 nil
      expect{s.二重母音(s.五十音.表[:あ行])}.to raise_error '二重母音が登録されてません'
    end

    it '二重母音の1文字目があ行の文字でなければ，例外発生' do
      s.二重母音登録 ['かか', 'きき', 'くく']
      expect{
        s.変換(s.二重母音(:か行), 開始鍵: {左右: :右, 段: :上, 番号: 2}, 確定鍵: {左右: :左, 段: :上})
      }.to raise_error '「か」はあ行の文字ではありません'
    end
  end

  describe '#直音行' do
    it '五十音表の直音行（「あ」「ざ」「ぱ」行などの拗音以外）を返す操作である' do
      expect(s.直音行).to eq [:あ行,
                              :か行, :さ行, :た行, :な行,
                              :は行, :ま行, :や行, :ら行, :わ行,
                              :が行, :ざ行, :だ行,
                              :ば行, :ぱ行].sort
    end

    it '受け取った直音行を破壊しても差し支えない' do
      あ行以外 = s.直音行
      あ行以外.delete(:あ行)
      expect(あ行以外).to eq [:か行, :さ行, :た行, :な行,
                              :は行, :ま行, :や行, :ら行, :わ行,
                              :が行, :ざ行, :だ行,
                              :ば行, :ぱ行].sort
      y = s.直音行
      expect(y).to eq [:あ行,
                       :か行, :さ行, :た行, :な行,
                       :は行, :ま行, :や行, :ら行, :わ行,
                       :が行, :ざ行, :だ行,
                       :ば行, :ぱ行].sort
    end
  end

  describe '#開拗音行' do
    it '五十音表の開拗音行（「きゃ」「ぴゃ」行など）を返す操作である' do
      expect(s.開拗音行).to eq [:きゃ行, :ぎゃ行, :しゃ行, :じゃ行, :ちゃ行, :ぢゃ行, :にゃ行,
                                :ひゃ行, :びゃ行, :ぴゃ行, :みゃ行, :りゃ行,
                                :ゔゃ行,].sort
    end
  end

  describe '#拗音行' do
    it '五十音表で拗音になれる行を返す操作である' do
      expect(s.拗音行).to eq [:か行, :が行, :さ行, :ざ行, :た行, :だ行, :な行,
                              :は行, :ば行, :ぱ行, :ま行, :ら行, :ゔ行].sort
    end
  end

  describe '#合拗音行' do
    it '五十音表の合拗音行（「ふぁ」「つぁ」行など）を返す操作である' do
      expect(s.合拗音行).to eq [:くぁ行, :ぐぁ行, :すぁ行, :ずぁ行, :つぁ行, :づぁ行, :ぬぁ行,
                                :ふぁ行, :ぶぁ行, :ぷぁ行, :むぁ行, :るぁ行,
                                :ゔぁ行,].sort
    end
  end

  describe '#行拗音化' do
    it '行と列，拗音行(:ゃ等)を与えると，該当する拗音行を示すシンボルを返す' do
      expect(s.行拗音化(:か行, :い列, :ゃ行)).to eq :きゃ行
      expect(s.行拗音化(:は行, :う列, :ぁ行)).to eq :ふぁ行
    end

    it '対象としない行と列を与えると，例外発生' do
      expect{s.行拗音化(:ん行, :な列, :ゃ行)}.
        to raise_error '「ん行」は行として登録されていません'
      expect{s.行拗音化(:か行, :な列, :ゃ行)}.
        to raise_error '「な列」はあ行の文字ではありません'
      expect{s.行拗音化(:か行, :い, :ん)}.
        to raise_error '拗音行には「ゃ行」または「ぁ行」を指定してください'
    end
  end

  describe '#シフト' do
    it '位置をシフトする' do
      expect(s.シフト({左右: :左, 段: :中, 番号: 0})).
        to eq({左右: :左, 段: :中, 番号: 0, シフト: true})
    end
  end

  describe '#文字生成' do
    it '行と母音を指定すると，母音で指定されたその行の文字を返す' do
      r = s.文字生成([:あ行, :や行], ['あ', 'う', 'お'])
      expect(r).to eq [[["あ", "う", "お"], :あ行], [['や', 'ゆ', 'よ'], :や行]]
    end

    it '行と母音を指定すると，母音で指定されたその行の文字をblockが受け取る' do
      expect {
        |b| s.文字生成([:や行], ['あ', 'う', 'お'], &b)
      }.to yield_with_args(['や', 'ゆ', 'よ'], :や行)
    end

    it '二重母音を指定すると，二重母音で指定されたその行の文字をblockが受け取る' do
      expect {
        |b| s.文字生成([:や行], ['あい', 'うん', 'おく'], &b)
      }.to yield_with_args(['やい', 'ゆん', 'よく'], :や行)
    end

    it '行を複数指定すると，文字を受け取るBlockを繰り返し実行する' do
      expect {
        |b| s.文字生成([:や行, :か行], ['あ', 'う', 'お'], &b)
      }.to yield_successive_args([["や", "ゆ", "よ"], :や行], [["か", "く", "こ"], :か行])
    end

    it '拗音化引数を与えると，行を拗音にすることができる' do
      expect {
        |b| s.文字生成([:か行, :さ行], ['あ', 'う', 'お'], 拗音化: [:い列, :ゃ行], &b)
      }.to yield_successive_args([['きゃ', 'きゅ', 'きょ'], :か行], [['しゃ', 'しゅ', 'しょ'], :さ行])
    end

    it '制限事項' do
      expect {
        s.文字生成(nil, nil)
      }.to raise_error '行は配列で指定してください'
    end
  end

  describe '#変換表出力' do
    it '生成した変換表を出力する' do
      s.変換表消去
      s.変換('あいうえお')
      expect(capture(:stdout){s.変換表出力}).to eq("a\tあ\ni\tい\nu\tう\ne\tえ\no\tお\n")
    end
  end

  ## ================================================================
  ## Private methods
  ## ================================================================

  describe '#変換表作成' do
    it '変換表が追加されたか？' do
      expect(s.send(:変換表作成, 'a', 'あ')).to eq ["a", "あ"]
    end
  end

  describe '#文字配列化' do
    it '「文字」に配列を渡すと，そのまま返す' do
      r = s.send(:文字正規化, ['あ', 'いん'])
      expect(r).to be_a Array
      expect(r).to eq ["あ", "いん"]
    end

    it '「文字」に文字列を渡すと，1文字毎の配列を返す' do
      r = s.send(:文字正規化, 'かき')
      expect(r).to be_a Array
      expect(r).to eq ["か", "き"]
    end

    it '「文字」にシンボルを渡すと，五十音表の行を返す' do
      r = s.send(:文字正規化, :さ行)
      expect(r).to be_a Array
      expect(r).to eq ["さ", "し", "す", "せ", "そ"]
    end

    it '「文字」にシンボルを渡したとき，五十音表の行に無ければ例外発生' do
      expect{s.send(:文字正規化, :ん行)}.to raise_error '「ん行」は行として登録されていません'
    end
  end


  describe '#中間鍵正規化' do
    it '省略のない確定鍵を渡すと，そのまま返す' do
      r = s.send(:中間鍵正規化, [左右: :左, 段: :中, 番号: 0])
      expect(r).to be_a Array
      expect(r.length).to eq 1
      expect(r).to eq [{左右: :左, 段: :中, 番号: 0}]
    end
  end

  describe '#確定鍵正規化' do
    it '省略のない確定鍵を渡すと，そのまま返す' do
      r = s.send(:確定鍵正規化, 左右: :左, 段: :中, 番号: 0)
      expect(r).to be_a Array
      expect(r.length).to eq 1
      expect(r).to eq [{左右: :左, 段: :中, 番号: 0}]
    end

    it '番号を省略した確定鍵の位置を渡すと，位置配列を返す' do
      s.鍵盤母音順([0, 4, 3, 2, 1])
      r = s.send(:確定鍵正規化, 左右: :左, 段: :中)
      expect(r).to be_a Array
      expect(r.length).to eq 5
      expect(r).
        to eq [{左右: :左, 段: :中, 番号: 0},
               {左右: :左, 段: :中, 番号: 4},
               {左右: :左, 段: :中, 番号: 3},
               {左右: :左, 段: :中, 番号: 2},
               {左右: :左, 段: :中, 番号: 1}]
    end

    it '{#鍵盤母音順}を設定しておくと，それに従った位置配列を返す' do
      s.鍵盤母音順([4, 2, 0, 1, 3])
      r = s.send(:確定鍵正規化, 左右: :左, 段: :中)
      expect(r).to be_a Array
      expect(r.length).to eq 5
      expect(r).
        to eq [{左右: :左, 段: :中, 番号: 4},
               {左右: :左, 段: :中, 番号: 2},
               {左右: :左, 段: :中, 番号: 0},
               {左右: :左, 段: :中, 番号: 1},
               {左右: :左, 段: :中, 番号: 3}]
      s.鍵盤母音順([0, 4, 3, 2, 1])
    end

    it '{#鍵盤母音順}が未定義ならば，例外発生' do
      s.鍵盤母音順(nil)
      expect{s.send(:確定鍵正規化, 左右: :左, 段: :中)}.
        to raise_error '確定鍵の番号を省略する場合は鍵盤母音順を設定してください'
      s.鍵盤母音順([0, 4, 3, 2, 1])
    end
  end

  describe '#五十音合成' do
    it '五十音を合成する' do
      expect(s.五十音合成([:あ行])).
        to eq [[["あ", "い", "う", "え", "お"], :あ行]]
    end
  end
end
