# -*- coding: utf-8 -*-

# Coverage
# Linux:
#   file:///home/yc/git/romaji_table/coverage/index.html
# Mac:
#   file:///Users/yc/git/romaji_table/coverage/index.html

require 'ice_nine'

require 'generator'

=begin
it '追加文字を与えると，対応表を返す' do
  r = s.変換(:か行, 追加: 'つ',
             開始鍵: {左右: :右, 段: :上, 番号: 2},
             中間鍵: {左右: :右, 段: :上, 番号: 2},
             確定鍵: {左右: :左, 段: :下})
  expect(r).to eq [["cf;", "かつ"], ["cfx", "きつ"], ["cfk", "くつ"], ["cfj", "けつ"], ["cfq", "こつ"]]
end
=end

describe Generator do
  subject(:s){Generator.new}

  describe '#initialize' do
    it '生成されたか？' do
      expect(s).not_to be nil
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

    it '文字が文字列でなければ，例外発生' do
      expect{
        s.単文字登録(nil, [{左右: :左, 段: :上, 番号: 0}])
      }.to raise_error('文字は文字列で指定してください')
    end
    it '確定鍵が配列でなければ，例外発生' do
      expect{
        s.単文字登録('あ', nil)
      }.to raise_error('確定鍵は配列で指定してください')
    end
  end

  describe '#変換' do
    it '文字と，確定鍵の位置の配列を与えると，対応表を返す' do
      # 文字の数と同じ数の確定権を指定する
      r = s.変換('あいうえお', 確定鍵: [{左右: :右, 段: :中, 番号: 0}, {左右: :右, 段: :中, 番号: 1},
                                        {左右: :右, 段: :中, 番号: 2}, {左右: :右, 段: :中, 番号: 3},
                                        {左右: :右, 段: :中, 番号: 4}])
      expect(r).to eq([["d", "あ"], ["h", "い"], ["t", "う"], ["n", "え"], ["s", "お"]])
    end

    it '確定鍵の番号を指定すると，標準を返す' do
      確定鍵 = {左右: :左, 段: :中}.freeze
      r = s.変換('あいうえお', 確定鍵: 確定鍵)
      expect(r).to eq([["a", "あ"], ["i", "い"], ["u", "う"], ["e", "え"], ["o", "お"]])
    end

    it '確定鍵の全体を省略すると，標準の鍵盤母音を用いる' do
      # 確定鍵の全体を省略し，鍵盤の母音鍵を使用する場合
      r = s.変換('あいうえお')
      expect(r).to eq([["a", "あ"], ["i", "い"], ["u", "う"], ["e", "え"], ["o", "お"]])
    end

    it '文字に直音の行と開始鍵を与え確定鍵を省略して対応表を作る' do
      s.変換(:あ行).
        should eq([["a", "あ"], ["i", "い"], ["u", "う"], ["e", "え"], ["o", "お"]])
      s.変換(:か行, 開始鍵: {左右: :右, 段: :上, 番号: 2}).
        should eq([["ca", "か"], ["ci", "き"], ["cu", "く"], ["ce", "け"], ["co", "こ"]])
      s.変換(:さ行, 開始鍵: {左右: :右, 段: :中, 番号: 4}).
        should eq([["sa", "さ"], ["si", "し"], ["su", "す"], ["se", "せ"], ["so", "そ"]])
      s.変換(:た行, 開始鍵: {左右: :右, 段: :中, 番号: 2}).
        should eq([["ta", "た"], ["ti", "ち"], ["tu", "つ"], ["te", "て"], ["to", "と"]])
      s.変換(:な行, 開始鍵: {左右: :右, 段: :中, 番号: 3}).
        should eq([["na", "な"], ["ni", "に"], ["nu", "ぬ"], ["ne", "ね"], ["no", "の"]])
      s.変換(:は行, 開始鍵: {左右: :右, 段: :中, 番号: 1}).
        should eq([["ha", "は"], ["hi", "ひ"], ["hu", "ふ"], ["he", "へ"], ["ho", "ほ"]])
      s.変換(:ま行, 開始鍵: {左右: :右, 段: :下, 番号: 1}).
        should eq([["ma", "ま"], ["mi", "み"], ["mu", "む"], ["me", "め"], ["mo", "も"]])
      s.変換(:や行, 開始鍵: {左右: :右, 段: :下, 番号: 3}).
        should eq([["va", "や"], ["vi", "い"], ["vu", "ゆ"], ["ve", "え"], ["vo", "よ"]])
      s.変換(:ら行, 開始鍵: {左右: :右, 段: :上, 番号: 3}).
        should eq([["ra", "ら"], ["ri", "り"], ["ru", "る"], ["re", "れ"], ["ro", "ろ"]])
      s.変換(:わ行, 開始鍵: {左右: :右, 段: :下, 番号: 2}).
        should eq([["wa", "わ"], ["wi", "ゐ"], ["wu", "う"], ["we", "ゑ"], ["wo", "を"]])
      s.変換(:が行, 開始鍵: {左右: :右, 段: :上, 番号: 1}).
        should eq([["ga", "が"], ["gi", "ぎ"], ["gu", "ぐ"], ["ge", "げ"], ["go", "ご"]])
      s.変換(:ざ行, 開始鍵: {左右: :右, 段: :下, 番号: 4}).
        should eq([["za", "ざ"], ["zi", "じ"], ["zu", "ず"], ["ze", "ぜ"], ["zo", "ぞ"]])
      s.変換(:だ行, 開始鍵: {左右: :右, 段: :中, 番号: 0}).
        should eq([["da", "だ"], ["di", "ぢ"], ["du", "づ"], ["de", "で"], ["do", "ど"]])
      s.変換(:ば行, 開始鍵: {左右: :右, 段: :下, 番号: 0}).
        should eq([["ba", "ば"], ["bi", "び"], ["bu", "ぶ"], ["be", "べ"], ["bo", "ぼ"]])
      s.変換(:ぱ行, 開始鍵: {左右: :右, 段: :上, 番号: 0}).
        should eq([["fa", "ぱ"], ["fi", "ぴ"], ["fu", "ぷ"], ["fe", "ぺ"], ["fo", "ぽ"]])
    end


    it '拗音を登録する' do
      r = s.変換(:ぁ行, 開始鍵: {左右: :右, 段: :上, 番号: 4}, 確定鍵: {左右: :左, 段: :中})
      expect(r).to eq [["la", "ぁ"], ["li", "ぃ"], ["lu", "ぅ"], ["le", "ぇ"], ["lo", "ぉ"]]
    end

    it '段を週略した中間鍵を用い，拗音を登録する' do
      中間鍵 = IceNine.deep_freeze({左右: :右, 番号: 1})
      r = s.変換(:きゃ行, 開始鍵: {左右: :右, 段: :上, 番号: 2}, 中間鍵: 中間鍵)
      expect(r).to eq([["cga", "きゃ"], ["cgi", "きぃ"], ["cgu", "きゅ"],
                       ["cge", "きぇ"], ["cgo", "きょ"]])
    end

    it '文字に追加する文字を渡すことで，撥音や促音などを生成できる' do
      r = s.変換("あいうえお", 追加文字: 'ん', 確定鍵: {左右: :左, 段: :下})
      expect(r).to eq([[";", "あん"], ["x", "いん"], ["k", "うん"], ["j", "えん"], ["q", "おん"]])
      r = s.変換(:か行, 追加文字: 'ん', 開始鍵: {左右: :右, 段: :上, 番号: 2}, 確定鍵: {左右: :左, 段: :下})
      expect(r).to eq([["c;", "かん"], ["cx", "きん"], ["ck", "くん"], ["cj", "けん"], ["cq", "こん"]])
      r = s.変換(:きゃ行, 追加文字: 'っ',
                 開始鍵: {左右: :右, 段: :上, 番号: 2},
                 中間鍵: {左右: :右, 番号: 0},
                 確定鍵: {左右: :左, 段: :上}
                 )
      expect(r).to eq([["cf'", "きゃっ"], ["cfy", "きぃっ"], ["cfp", "きゅっ"], ["cf.", "きぇっ"], ["cf,", "きょっ"]])
      r = s.変換(:きゃ行, 追加文字: 'ん',
                 開始鍵: {左右: :右, 段: :上, 番号: 2},
                 中間鍵: {左右: :右, 番号: 1},
                 確定鍵: {左右: :左, 段: :下})
      expect(r).to eq([["cg;", "きゃん"], ["cgx", "きぃん"], ["cgk", "きゅん"],
                       ["cgj", "きぇん"], ["cgq", "きょん"]])
    end

    it '二重母音を与えて，対応表を作成する' do
      r = s.変換(['あい', 'うい', 'うう', 'えい', 'おう'], 確定鍵: {左右: :左, 段: :上})
      expect(r).to eq([["'", "あい"], ["y", "うい"], ["p", "うう"], [".", "えい"], [",", "おう"]])
      r = s.変換(['かい', 'くい', 'くう', 'けい', 'こう'],
                 開始鍵: {左右: :右, 段: :上, 番号: 2}, 確定鍵: {左右: :左, 段: :上})
      expect(r).to eq([["c'", "かい"], ["cy", "くい"], ["cp", "くう"], ["c.", "けい"], ["c,", "こう"]])
    end


    it '二重母音を与え，母音の段を省略して，対応表を作成録する' do
      s.二重母音登録 ['うう', 'おう']
      母音A = {左右: :右, 番号: 2}.freeze
      母音B = {左右: :右, 番号: 4}.freeze
      r = s.変換(s.二重母音(:にゃ行),
                 開始鍵: {左右: :右, 段: :中, 番号: 3}, 確定鍵: [母音A, 母音B])
      expect(r).to eq [["nt", "にゅう"], ["ns", "にょう"]]
      r = s.変換(s.二重母音(:みゃ行),
                 開始鍵: {左右: :右, 段: :下, 番号: 1}, 確定鍵: [母音A, 母音B])
      expect(r). to eq [["mw", "みゅう"], ["mz", "みょう"]]
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
        s.変換(:あ行, 確定鍵: :母音)
      }.to raise_error '確定鍵は連想配列または配列で指定，または，省略してください'
      expect{
        s.変換(:か行, 開始鍵: {左右: :右, 段: :上}, 確定鍵: :鍵盤)
      }.to raise_error '確定鍵は連想配列または配列で指定，または，省略してください'
      expect{
        s.変換(:か行, 開始鍵: :しいん, 確定鍵: :鍵盤)
      }.to raise_error '開始鍵は連想配列で指定，または，省略してください'
      expect{
        s.変換(:か行, 中間鍵: :ようおん)
      }.to raise_error '中間鍵は連想配列で指定，または，省略してください'
    end
  end

  describe '#鍵盤確定鍵' do
    it '鍵盤確定鍵を検査します' do
      expect(s.鍵盤確定鍵.length).to eq 5
      expect(s.鍵盤確定鍵).
        to eq [{左右: :左, 段: :中, 番号: 0},
               {左右: :左, 段: :中, 番号: 4},
               {左右: :左, 段: :中, 番号: 3},
               {左右: :左, 段: :中, 番号: 2},
               {左右: :左, 段: :中, 番号: 1}]
    end
  end

  describe '#鍵盤登録' do
    it '鍵盤を登録して鍵盤母音を検査します' do
      s.鍵盤登録({
                   左: { 上: 'qwert', 中: 'asdfg', 下: 'zxcvb'},
                   右: { 上: 'yuiop', 中: 'hjkl;', 下: 'bnm,.'}
                 })
      expect(s.鍵盤確定鍵.length).to eq 5
      expect(s.鍵盤確定鍵).
        to eq [{左右: :左, 段: :中, 番号: 0},
               {左右: :右, 段: :上, 番号: 2},
               {左右: :右, 段: :上, 番号: 1},
               {左右: :左, 段: :上, 番号: 2},
               {左右: :右, 段: :上, 番号: 3}]
    end
  end

  describe '#二重母音登録' do
    it '二重母音を登録する' do
      expect(s.二重母音登録 ['あん', 'うい', 'うう', 'えい', 'おう']).to eq ["あん", "うい", "うう", "えい", "おう"]
    end
  end

  describe '#二重母音' do
    it '行を二重母音にする' do
      expect{s.二重母音(s.五十音.表[:あ行])}.to raise_error '二重母音が登録されてません'
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
      expect(r).to eq [["c'", "かあ"], ["cy", "くい"], ["cp", "くう"], ["c.", "けい"], ["c,", "こう"]]
    end

    it '二重母音の1文字目があ行の文字でなければ，例外発生' do
      s.二重母音登録 ['かか', 'きき', 'くく']
      expect{
        s.変換(s.二重母音(:か行), 開始鍵: {左右: :右, 段: :上, 番号: 2}, 確定鍵: {左右: :左, 段: :上})
      }.to raise_error '「か」はあ行の文字ではありません'
    end
  end

  describe '#直音行' do
    it '直音行を返す' do
      expect(s.直音行).to eq [:あ行,
                              :か行, :さ行, :た行, :な行,
                              :は行, :ま行, :や行, :ら行, :わ行,
                              :が行, :ざ行, :だ行,
                              :ば行, :ぱ行]
    end
  end

  describe '#拗音' do
    it '行と列，拗音行(:ゃ)を与えると，拗音を返す' do
      expect(s.拗音(:か行, :い列, :ゃ行)).to eq :きゃ行
    end

    it '行と列，拗音行(:ぁ)を与えると，拗音を返す' do
      expect(s.拗音(:は行, :う列, :ぁ行)).to eq :ふぁ行
    end

    it '対象としない行と列を与えると，例外発生' do
      expect{s.拗音(:ん行, :な列, :ゃ行)}.
        to raise_error '「ん行」は行として登録されていません'
      expect{s.拗音(:か行, :な列, :ゃ行)}.
        to raise_error '「な列」はあ行の文字ではありません'
      expect{s.拗音(:か行, :い, :ん)}.
        to raise_error '拗音行には「ゃ行」または「ぁ行」を指定してください'
    end
  end

  describe '#execute' do
    it 'DSL' do
      # 標準出力をキャプチャするため，デバッグ用のputsなどに注意
      expect(capture(:stdout) {
               Generator.execute <<-EOS
                   変換 五十音.表[:あ行], 確定鍵: {左右: :左, 段: :中}
                 EOS
             }).to eq "a\tあ\ni\tい\nu\tう\ne\tえ\no\tお\n"
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

    it '「文字」にシンボルを渡すと，五十音表の行に無ければ例外発生' do
      expect{s.send(:文字正規化, :ん行)}.to raise_error '「ん行」は行として登録されていません'
    end
  end

  # ================================================================
  # private methods
  # ================================================================
  describe '#確定鍵正規化' do
    it '省略のない確定鍵を渡すと，そのまま返す' do
      r = s.send(:確定鍵正規化, 左右: :左, 段: :中, 番号: 0)
      expect(r).to be_a Array
      expect(r.length).to eq 1
      expect(r).to eq [{左右: :左, 段: :中, 番号: 0}]
    end

    it '番号を省略した確定鍵の位置を渡すと，位置配列を返す' do
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

    it '母音順を設定しておくと，それに従った位置配列を返す' do
      # todo: 母音順 -> 鍵盤母音順
      s.母音順 = [4, 2, 0, 1, 3]
      r = s.send(:確定鍵正規化, 左右: :左, 段: :中)
      expect(r).to be_a Array
      expect(r.length).to eq 5
      expect(r).
        to eq [{左右: :左, 段: :中, 番号: 4},
               {左右: :左, 段: :中, 番号: 2},
               {左右: :左, 段: :中, 番号: 0},
               {左右: :左, 段: :中, 番号: 1},
               {左右: :左, 段: :中, 番号: 3}]
    end

    it '母音順が未定義ならば，例外発生' do
      s.母音順 = nil
      expect{s.send(:確定鍵正規化, 左右: :左, 段: :中)}.
        to raise_error '確定鍵の番号を省略する場合は母音順を設定してください'
    end
  end

  describe '#母音指定' do
    it '行と母音を指定すると，母音で指定されたその行の文字をblockが受け取る' do
      expect {
        |b| s.母音指定([:や行], ['あ', 'う', 'お'], &b)
      }.to yield_with_args(['や', 'ゆ', 'よ'])
    end

    it '二重母音を指定すると，二重母音で指定されたその行の文字をblockが受け取る' do
      expect {
        |b| s.母音指定([:や行], ['あい', 'うん', 'おく'], &b)
      }.to yield_with_args(['やい', 'ゆん', 'よく'])
    end

    it '行を複数指定すると，文字を受け取るBlockを実行する' do
      expect {
        |b| s.母音指定([:や行, :か行], ['あ', 'う', 'お'], &b)
      }.to yield_successive_args(['や', 'ゆ', 'よ'], ['か', 'く', 'こ'])
    end

    it '行を複数指定すると，文字を受け取るBlockを実行する' do
      expect {
        |b| s.母音指定([:や行, :か行], ['あ', 'う', 'お'], &b)
      }.to yield_successive_args(['や', 'ゆ', 'よ'], ['か', 'く', 'こ'])
    end
  end
end

# ================================================================
# 標準出力の検査用
# ================================================================
def capture(stream)
  begin
    stream = stream.to_s
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval "$#{stream} = #{stream.upcase}"
  end
  result
end
