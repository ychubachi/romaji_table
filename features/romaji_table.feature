Feature: Romaji table
   Scenario: Run romaji_table
     When I run `bundle exec romaji_table`
     Then the output should contain "RomajiTable"

   Scenario: Run romaji_table
     Given a file named "test.rb" with:
     """
     require 'romaji_table'
     変換 'あ', 確定鍵: {左右: :左, 段: :中, 番号: 0}
     変換表出力
     """
     When I run `bundle exec ruby test.rb`
     Then it should pass with exactly:
     """
     a	あ

     """

   Scenario: Run romaji_table
     Given a file named "test.rb" with:
     """
     require 'romaji_table'
     変換 'あい', 確定鍵: [{左右: :左, 段: :中, 番号: 0}, {左右: :左, 段: :中, 番号: 4}]
     変換表出力
     """
     When I run `bundle exec ruby test.rb`
     Then it should pass with exactly:
     """
     a	あ
     i	い

     """
