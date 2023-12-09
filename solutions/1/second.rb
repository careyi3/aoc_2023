# frozen_string_literal: true

module Day1
  module Part2
    def self.run(path, _)
      map = {
        'one' => 1,
        '1' => 1,
        'two' => 2,
        '2' => 2,
        'three' => 3,
        '3' => 3,
        'four' => 4,
        '4' => 4,
        'five' => 5,
        '5' => 5,
        'six' => 6,
        '6' => 6,
        'seven' => 7,
        '7' => 7,
        'eight' => 8,
        '8' => 8,
        'nine' => 9,
        '9' => 9
      }
      nums = []
      FileReader.for_each_line(path) do |line|
        word_nums = line.scan(Regexp.new("(?=(#{map.keys.join('|')}))")).flatten
        num = (map[word_nums.first].to_s + map[word_nums.last].to_s).to_i
        nums << num
        # "#{word_nums.join(',')} = #{num}"
      end
      nums.sum
    end
  end
end
