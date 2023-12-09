# frozen_string_literal: true

module Day9
  module Part1
    def self.run(path, _)
      values = []
      FileReader.for_each_line(path) do |line|
        values << difference(line.split.map(&:to_i))
      end
      puts values.sum
    end

    def self.difference(input)
      new_input = input.each_cons(2).map { |x| x[1] - x[0] }

      return new_input.last if input.uniq.count == 1 && input.first.zero?

      input.last + difference(new_input)
    end
  end
end
