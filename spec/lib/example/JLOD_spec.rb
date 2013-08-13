# -*- coding: utf-8 -*-

describe 'example/JLOD' do
  it 'example/JLOD' do
    s = RomajiTable::C生成器.instance
    s.変換表初期化
    expect(capture(:stdout) {
             require 'example/JLOD'
           }.length).to eq 915
  end
end
