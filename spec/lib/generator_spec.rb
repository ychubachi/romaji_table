# -*- coding: utf-8 -*-

require 'generator'

describe Generator, '#変換' do
  subject(:it){Generator.new}

  context '直接' do
    it '直接位置指定登録を検査します' do
      g = Generator.new
      g.変換('っ', 位置: [{左右: :左, 段: :上, 番号: 0}]).should eq([["'", "っ"]])
      g.変換('，', 位置: [{左右: :左, 段: :上, 番号: 1}]).should eq([[",", "，"]])
      g.変換('．', 位置: [{左右: :左, 段: :上, 番号: 2}]).should eq([[".", "．"]])
      g.変換('ー', 位置: [{左右: :左, 段: :上, 番号: 3}]).should eq([["p", "ー"]])
      g.変換('？', 位置: [{左右: :左, 段: :上, 番号: 4}]).should eq([["y", "？"]])
      g.変換('ん', 位置: [{左右: :右, 段: :中, 番号: 3},
                          {左右: :右, 段: :中, 番号: 3}]).should eq([["nn", "ん"]])
    end
  end

  context '母音' do
    it 'シンボルでかな，および，鍵盤位置を指定して母音を検査します' do
      g = Generator.new
      g.変換(:あ行, 母音: :鍵盤).
        should eq([["a", "あ"], ["i", "い"], ["u", "う"], ["e", "え"], ["o", "お"]])
    end

    it '文字列でかな，および，鍵盤位置を指定して母音を検査します' do
      g = Generator.new
      g.変換('あいうえお', 母音: :鍵盤).
        should eq([["a", "あ"], ["i", "い"], ["u", "う"], ["e", "え"], ["o", "お"]])
      expect{g.変換('いうえお', 母音: {左右: :左, 段: :中})}.to raise_error
    end

    it '文字列でかな，および，母音の位置を指定して，母音を検査します（あいうえお）' do
      g = Generator.new
      g.変換('あいうえお', 母音: {左右: :左, 段: :中}).
        should eq([["a", "あ"], ["i", "い"], ["u", "う"], ["e", "え"], ["o", "お"]])
    end

    it 'シンボルでかな，および，配列で母音の位置を指定して，母音を検査します（あいうえお）' do
      g = Generator.new
      g.変換(:あ行, 母音: [{左右: :右, 段: :中, 番号: 0}, {左右: :右, 段: :中, 番号: 1}, {左右: :右, 段: :中, 番号: 2},
                               {左右: :右, 段: :中, 番号: 3}, {左右: :右, 段: :中, 番号: 4}]).
        should eq([["d", "あ"], ["h", "い"], ["t", "う"], ["n", "え"], ["s", "お"]])
      expect{g.変換(:あ行, 母音: [{左右: :右, 段: :中, 番号: 0}])}.to raise_error
    end

    it '例外を検査します' do
      g = Generator.new
      expect{g.変換(nil, 母音: [{左右: :右, 段: :中, 番号: 0}])}.to raise_error
      expect{g.変換(:あ行, 母音: :母音)}.to raise_error
    end
  end

  context '子音' do
    subject(:it){Generator.new}

    it '例外を検査します' do
      expect{it.変換(:か行, 子音: {左右: :右, 段: :上}, 母音: :鍵盤)}.
        to raise_error
      expect{it.変換(:か行, 子音: :しいん, 母音: :鍵盤)}.
        to raise_error '子音は連想配列または配列で指定してください'
      expect{it.変換(:か行, 拗音化: :ようおん, 母音: :鍵盤)}.
        to raise_error '拗音は連想配列または配列で指定してください'
    end

    it '座標で子音を登録します' do
      expect(it.変換(:か行, 子音: [:右, :上, 2], 母音: :鍵盤)).
        to eq([["ca", "か"], ["ci", "き"], ["cu", "く"], ["ce", "け"], ["co", "こ"]])
    end

    it '静音を検査します' do
      g = Generator.new
      g.変換(:か行, 子音: {左右: :右, 段: :上, 番号: 2}, 母音: :鍵盤).
        should eq([["ca", "か"], ["ci", "き"], ["cu", "く"], ["ce", "け"], ["co", "こ"]])
      g.変換(:さ行, 子音: {左右: :右, 段: :中, 番号: 4}, 母音: :鍵盤).
        should eq([["sa", "さ"], ["si", "し"], ["su", "す"], ["se", "せ"], ["so", "そ"]])
      g.変換(:た行, 子音: {左右: :右, 段: :中, 番号: 2}, 母音: :鍵盤).
        should eq([["ta", "た"], ["ti", "ち"], ["tu", "つ"], ["te", "て"], ["to", "と"]])
      g.変換(:な行, 子音: {左右: :右, 段: :中, 番号: 3}, 母音: :鍵盤).
        should eq([["na", "な"], ["ni", "に"], ["nu", "ぬ"], ["ne", "ね"], ["no", "の"]])
      g.変換(:は行, 子音: {左右: :右, 段: :中, 番号: 1}, 母音: :鍵盤).
        should eq([["ha", "は"], ["hi", "ひ"], ["hu", "ふ"], ["he", "へ"], ["ho", "ほ"]])
      g.変換(:ま行, 子音: {左右: :右, 段: :下, 番号: 1}, 母音: :鍵盤).
        should eq([["ma", "ま"], ["mi", "み"], ["mu", "む"], ["me", "め"], ["mo", "も"]])
      g.変換(:や行, 子音: {左右: :右, 段: :下, 番号: 3}, 母音: :鍵盤).
        should eq([["va", "や"], ["vi", "い"], ["vu", "ゆ"], ["ve", "え"], ["vo", "よ"]])
      g.変換(:ら行, 子音: {左右: :右, 段: :上, 番号: 3}, 母音: :鍵盤).
        should eq([["ra", "ら"], ["ri", "り"], ["ru", "る"], ["re", "れ"], ["ro", "ろ"]])
      g.変換(:わ行, 子音: {左右: :右, 段: :下, 番号: 2}, 母音: :鍵盤).
        should eq([["wa", "わ"], ["wi", "ゐ"], ["wu", "う"], ["we", "ゑ"], ["wo", "を"]])
    end

    it '濁音・半濁音を検査します' do
      g = Generator.new
      g.変換(:が行, 子音: {左右: :右, 段: :上, 番号: 1}, 母音: :鍵盤).
        should eq([["ga", "が"], ["gi", "ぎ"], ["gu", "ぐ"], ["ge", "げ"], ["go", "ご"]])
      g.変換(:ざ行, 子音: {左右: :右, 段: :下, 番号: 4}, 母音: :鍵盤).
        should eq([["za", "ざ"], ["zi", "じ"], ["zu", "ず"], ["ze", "ぜ"], ["zo", "ぞ"]])
      g.変換(:だ行, 子音: {左右: :右, 段: :中, 番号: 0}, 母音: :鍵盤).
        should eq([["da", "だ"], ["di", "ぢ"], ["du", "づ"], ["de", "で"], ["do", "ど"]])
      g.変換(:ば行, 子音: {左右: :右, 段: :下, 番号: 0}, 母音: :鍵盤).
        should eq([["ba", "ば"], ["bi", "び"], ["bu", "ぶ"], ["be", "べ"], ["bo", "ぼ"]])
      g.変換(:ぱ行, 子音: {左右: :右, 段: :上, 番号: 0}, 母音: :鍵盤).
        should eq([["fa", "ぱ"], ["fi", "ぴ"], ["fu", "ぷ"], ["fe", "ぺ"], ["fo", "ぽ"]])
    end
  end


  context '撥音化' do
    subject(:it){Generator.new}

    it '母音+撥音を検査します（あん・いん・うん・えん・おん）' do
      it.変換("あいうえお", 撥音化: {}, 母音: {左右: :左, 段: :下}).
        should eq([[";", "あん"], ["x", "いん"], ["k", "うん"],
                   ["j", "えん"], ["q", "おん"]])
    end

    it '子音+母音+撥音（一括）を検査します' do
      it.変換("かきくけこ", 子音: {左右: :右, 段: :上, 番号: 2}, 撥音化: {}, 母音: {左右: :左, 段: :下}).
        should eq([["c;", "かん"], ["cx", "きん"], ["ck", "くん"], ["cj", "けん"], ["cq", "こん"]])
    end
  end

  context '拗音化' do
    subject(:it){Generator.new}

    it 'ぁ行を検査します' do
      expect(it.変換 :ぁ行, 拗音化: {左右: :右, 段: :上, 番号: 4}, 母音: {左右: :左, 段: :中}).
        to eq [["la", "ぁ"], ["li", "ぃ"], ["lu", "ぅ"], ["le", "ぇ"], ["lo", "ぉ"]]
    end

    it '子音＋拗音化＋母音を検査します' do
      g = Generator.new
      g.変換(:きゃ行, 子音: {左右: :右, 段: :上, 番号: 2}, 拗音化: {左右: :右, 番号: 1}, 母音: :鍵盤).
         should eq([["cga", "きゃ"], ["cgi", "きぃ"], ["cgu", "きゅ"], ["cge", "きぇ"], ["cgo", "きょ"]])
    end

    it '子音＋拗音化＋撥音化＋母音を検査します' do
      g = Generator.new
      g.変換(:きゃ行,
             子音: {左右: :右, 段: :上, 番号: 2},
             拗音化: {左右: :右, 番号: 1},
             撥音化: {}, # 撥音化鍵は省略
             母音: {左右: :左, 段: :下}).
         should eq([["cg;", "きゃん"], ["cgx", "きぃん"], ["cgk", "きゅん"], ["cgj", "きぇん"], ["cgq", "きょん"]])
    end

    it '子音＋拗音＋母音＋促音を検査します' do
      g = Generator.new
      g.変換(:きゃ行,
             子音: {左右: :右, 段: :上, 番号: 2},
             拗音化: {}, # 拗音化鍵は省略
             促音化: {左右: :右, 番号: 0},
             母音: {左右: :左, 段: :上}
             ).
         should eq([["cf'", "きゃっ"], ["cfy", "きぃっ"], ["cfp", "きゅっ"], ["cf.", "きぇっ"], ["cf,", "きょっ"]])
      g.変換(:きゃ行,
             子音: {左右: :右, 段: :上, 番号: 2},
             拗音化: {},
             促音化: {左右: :右, 段: :中, 番号: 0}, # 文字固定の場合
             母音: {左右: :左, 段: :上}
             ).
         should eq([["cd'", "きゃっ"], ["cdy", "きぃっ"], ["cdp", "きゅっ"], ["cd.", "きぇっ"], ["cd,", "きょっ"]])
    end

    it '子音＋拗音化＋母音を検査します（座標指定）' do
      g = Generator.new
      g.変換(:きゃ行, 子音: [:右, :上, 2], 拗音化: [:右, :中, 1], 母音: :鍵盤).
         should eq([["cha", "きゃ"], ["chi", "きぃ"], ["chu", "きゅ"], ["che", "きぇ"], ["cho", "きょ"]])
    end

    it '拗音化キーの省略の例外処理' do
      expect{it.変換(:きゃ行, 子音: [:右, :上, 2], 拗音化: {位置: :右, 段: :中}, 母音: :鍵盤)}.
        to raise_error("拗音化の番号は省略できません")
    end
  end

  context '二重母音' do
    it '二重母音（あい，おう，えい，うう，うい）を検査します' do
      g = Generator.new
      g.変換(['あい', 'うい', 'うう', 'えい', 'おう'],
             母音: {左右: :左, 段: :上}
             ).
        should eq([["'", "あい"], ["y", "うい"], ["p", "うう"], [".", "えい"], [",", "おう"]])
    end

    # かい，くい（キー），くう（クー），けい（ケー），こう（コー）
    it '二重母音（かい，こう，けい，くう，くい）を検査します' do
      g = Generator.new
      g.変換(['かい', 'くい', 'くう', 'けい', 'こう'],
             子音: {左右: :右, 段: :上, 番号: 2},
             母音: {左右: :左, 段: :上}
             ).
        should eq([["c'", "かい"], ["cy", "くい"], ["cp", "くう"], ["c.", "けい"], ["c,", "こう"]])
    end
  end
end

describe Generator, '#initialize' do
  subject(:it) {Generator.new}

  it '生成されたか？' do
    expect(it).not_to be nil
  end
end

describe Generator, '#行' do
  subject(:it){Generator.new}

  it '行操作を検査します' do
    expect(it.あ行.join).to eq 'あいうえお'
    expect(it.か行.join).to eq 'かきくけこ'
    expect(it.さ行.join).to eq 'さしすせそ'
    expect(it.た行.join).to eq 'たちつてと'
    expect(it.な行.join).to eq 'なにぬねの'
    expect(it.は行.join).to eq 'はひふへほ'
    expect(it.ま行.join).to eq 'まみむめも'
    expect(it.や行.join).to eq 'やいゆえよ'
    expect(it.ら行.join).to eq 'らりるれろ'
    expect(it.わ行.join).to eq 'わゐうゑを'
    # TODO: きゃきぃきゅきぇきょなど
  end
end

describe Generator, '#母音' do
  subject(:it){Generator.new}


end

describe Generator, '#鍵盤母音' do
  subject(:it){Generator.new}

  it '鍵盤母音を検査します' do
    expect(it.鍵盤母音.length).to eq 5
    expect(it.鍵盤母音).
      to eq [{左右: :左, 段: :中, 番号: 0},
             {左右: :左, 段: :中, 番号: 4},
             {左右: :左, 段: :中, 番号: 3},
             {左右: :左, 段: :中, 番号: 2},
             {左右: :左, 段: :中, 番号: 1}]
  end
end

describe Generator, '#鍵盤登録' do
  subject(:it){Generator.new}

  it '鍵盤を登録して鍵盤母音を検査します' do
    it.鍵盤登録({
              左: { 上: 'qwert', 中: 'asdfg', 下: 'zxcvb'},
              右: { 上: 'yuiop', 中: 'hjkl;', 下: 'bnm,.'}
            })
    expect(it.鍵盤母音.length).to eq 5
    expect(it.鍵盤母音).
      to eq [{左右: :左, 段: :中, 番号: 0},
             {左右: :右, 段: :上, 番号: 2},
             {左右: :右, 段: :上, 番号: 1},
             {左右: :左, 段: :上, 番号: 2},
             {左右: :右, 段: :上, 番号: 3}]
  end
end

describe Generator, '二重母音登録' do
  subject(:it){Generator.new}

  it '二重母音を登録する' do
    expect(it.二重母音登録 ['あん', 'うい', 'うう', 'えい', 'おう']).to eq ["あん", "うい", "うう", "えい", "おう"]
  end
end

describe Generator, '#二重母音' do
  subject(:it){Generator.new}

  it '行を二重母音にする' do
    expect{it.二重母音(it.あ行)}.to raise_error
    it.二重母音登録 ['あん', 'うい', 'うう', 'えい', 'おう']
    expect(it.二重母音(it.あ行)).to eq ['あん', 'うい', 'うう', 'えい', 'おう']
    expect(it.二重母音(it.か行)).to eq ['かん', 'くい', 'くう', 'けい', 'こう']
    expect(it.二重母音(it.しゃ行)).to eq ["しゃん", "しゅい", "しゅう", "しぇい", "しょう"]
    it.二重母音登録 ['えあ', 'いう', 'うえ']
    expect(it.二重母音(it.か行)).to eq ['けあ', 'きう', 'くえ']
  end
end

################################################################
# DSL
#

# 標準出力の検査用
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

describe Generator, '#execute' do
  it 'DSL' do
    # 標準出力をキャプチャするため，デバッグ用のputsなどに注意
    expect(capture(:stdout) {
             Generator.execute <<-EOS
               変換 あ行, 母音: {左右: :左, 段: :中}
             EOS
           }).to eq "a\tあ\ni\tい\nu\tう\ne\tえ\no\tお\n"
  end
end

################################################################
# Private methods
#
describe Generator, 'private' do
  subject(:it) {Generator.new}

  describe '#変換表作成' do
    it '変換表が追加されたか？' do
      expect(it.send(:変換表作成, 'a', 'あ')).to eq ["a", "あ"]
    end
  end

  describe '#省略R' do
    it '鍵の位置を省略して指定します' do
      expect(it.send(:省略R, 位置: {左右: :左, 段: :中, 番号: 0})).to eq 'a'
      expect(it.send(:省略R, 位置: {左右: :左, 番号: 0}, 段: :中)).to eq 'a'
      expect{it.send(:省略R, 位置: {左右: :左, 番号: 0})}.to raise_error
      expect(it.send(:省略R, 位置: {})).to eq ''
    end
  end

  describe '#母音位置正規化' do
    it '番号を指定して母音を検査します' do
      expect(it.send(:母音位置正規化, :左, :中, 番号: 0).length).to eq 1
      expect(it.send(:母音位置正規化, :左, :中, 番号: 0)).to eq [{左右: :左, 段: :中, 番号: 0}]
      expect{it.send(:母音位置正規化, :左, :中, 番号: -1)}.to raise_error
    end

    it '母音を検査します' do
      expect(it.send(:母音位置正規化, :左, :中).length).to eq 5
      expect(it.send(:母音位置正規化, :左, :中)).
        to eq [{左右: :左, 段: :中, 番号: 0},
               {左右: :左, 段: :中, 番号: 4},
               {左右: :左, 段: :中, 番号: 3},
               {左右: :左, 段: :中, 番号: 2},
               {左右: :左, 段: :中, 番号: 1}]
    end

    it '母音順を設定して母音を検査します' do
      it.母音順 = [4, 3, 2, 1, 0]
      # todo 数もチェック
      expect(it.send(:母音位置正規化, :左, :中)).
        to eq [{左右: :左, 段: :中, 番号: 4},
               {左右: :左, 段: :中, 番号: 3},
               {左右: :左, 段: :中, 番号: 2},
               {左右: :左, 段: :中, 番号: 1},
               {左右: :左, 段: :中, 番号: 0}]
      it.母音順 = nil
      expect{it.母音位置正規化(左右: :左, 段: :中)}.to raise_error
    end
  end
end

# Coverage
# file:///home/yc/git/romantable_generator/coverage/index.html
