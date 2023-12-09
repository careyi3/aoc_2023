# frozen_string_literal: true

module Day9
  module Part2
    def self.run(path, _)
      values = []
      FileReader.for_each_line(path) do |line|
        values << difference(line.split.map(&:to_i).reverse)
      end
      puts values.sum
    end

    def self.difference(input)
      new_input = input.each_cons(2).map { |x| x[0] - x[1] }

      return new_input.last if input.uniq.count == 1 && input.first.zero?

      input.last - difference(new_input)
    end
  end
end
