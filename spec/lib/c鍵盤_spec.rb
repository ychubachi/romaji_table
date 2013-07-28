# -*- coding: utf-8 -*-

require 'c鍵盤'

describe C鍵盤, '#new' do
  it 'C鍵盤のインスタンスを生成する' do # returns an instance of C鍵盤
    expect(C鍵盤.new).to be_an_instance_of C鍵盤
  end
end

describe C鍵盤 do
  subject(:it){C鍵盤.new}

  context '#[]' do
    it '左右の中身を返す' do
      expect(it[:左]).to be_a_kind_of Hash
      expect(it[:左][:中]).to eq 'aoeui'
    end
  end
  
  context '#登録' do
    it '鍵盤を登録したら，鍵盤はその内容を返す' do
      expect(it.鍵盤).to be_a_kind_of Hash
      expect(it[:左][:中]).to eq "aoeui"
    end

    it 'Qwertyを登録したら，鍵盤はその内容を返す' do
      it.登録(C鍵盤::Qwerty)
      expect(it.鍵盤).to be_a_kind_of Hash
      expect(it[:左][:上]).to eq "qwert"
    end
  end

  context '#母音' do
    it '母音の位置を返します' do
      expect(it.母音).to eq [{:左右=>:左, :段=>:中, :番号=>0}, {:左右=>:左, :段=>:中, :番号=>4},
                             {:左右=>:左, :段=>:中, :番号=>3}, {:左右=>:左, :段=>:中, :番号=>2},
                             {:左右=>:左, :段=>:中, :番号=>1}]
    end
  end
end


