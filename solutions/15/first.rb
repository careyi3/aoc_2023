# frozen_string_literal: true

module Day15
  module Part1
    def self.run(path, _)
      sequence = []
      FileReader.for_each_line(path) do |line|
        sequence = line.split(',').map(&:chars)
      end

      values = []
      sequence.each do |step|
        value = 0
        step.each do |val|
          value = ((value + val.ord) * 17) % 256
        end
        values << value
      end
      values.sum
    end
  end
end
