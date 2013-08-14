# -*- coding: utf-8 -*-

require 'romaji_table'

describe 'example/JLOD' do
  it 'example/JLOD' do
    s = RomajiTable::C生成器.instance
    s.変換表 = []
    expect(capture(:stdout) {
             require 'example/JLOD'
           }.length).to eq 915
  end
end
