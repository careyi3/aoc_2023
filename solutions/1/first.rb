# frozen_string_literal: true

module Day1
  module Part1
    def self.run(path, _)
      nums = []
      FileReader.for_each_line(path) do |line|
        line_nums = []
        line.chars.each do |char|
          line_nums << char if char.to_i.to_s == char
        end
        nums << (line_nums.first + line_nums.last).to_i
      end
      puts nums.sum
    end
  end
end
