Feature: Romaji table
   Scenario: Run romaji_table
     When I run `bundle exec romaji_table`
     Then the output should contain "RomajiTable"
