# frozen_string_literal: true

module Day3
  module Part1
    def self.run(path, _)
      numbers = {}
      symbols = {}
      FileReader.for_each_line_with_index(path) do |line, y|
        chars = line.chars
        chars.each_with_index do |char, x|
          next if char == '.'

          if %w[0 1 2 3 4 5 6 7 8 9].include?(char)
            numbers["#{x}:#{y}"] = char.to_i
          else
            symbols["#{x}:#{y}"] = char
          end
        end
      end

      adjacent_numbers = {}
      symbols.each_key do |symbol|
        x, y = symbol.split(':').map(&:to_i)
        locations = [
          "#{x + 1}:#{y}",
          "#{x}:#{y + 1}",
          "#{x - 1}:#{y}",
          "#{x}:#{y - 1}",
          "#{x + 1}:#{y + 1}",
          "#{x - 1}:#{y - 1}",
          "#{x + 1}:#{y - 1}",
          "#{x - 1}:#{y + 1}"
        ]
        locations.each do |location|
          adjacent_numbers[location] = numbers[location] unless numbers[location].nil?
        end
      end

      part_numbers = []
      adjacent_numbers.each_key do |location|
        x, y = location.split(':').map(&:to_i)
        next if numbers["#{x}:#{y}"].nil?

        num = [numbers["#{x}:#{y}"]]
        numbers.delete("#{x}:#{y}")

        [x + 1, x + 2].each do |right|
          break if numbers["#{right}:#{y}"].nil?

          num << numbers["#{right}:#{y}"]
          numbers.delete("#{right}:#{y}")
        end

        [x - 1, x - 2].each do |left|
          break if numbers["#{left}:#{y}"].nil?

          num.unshift(numbers["#{left}:#{y}"])
          numbers.delete("#{left}:#{y}")
        end
        part_numbers << num.join.to_i
      end
      part_numbers.sum
    end
  end
end
