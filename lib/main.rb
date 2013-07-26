# -*- coding: utf-8 -*-

require './generator'

Generator.execute <<-EOS
      #{DATA.read}
EOS
__END__

# ローマ字変換表
p 変換 あ行, 母音位置: {左右: :左, 段: :中}
