# frozen_string_literal: true

module Day6
  module Part2
    def self.run(path, _)
      time = 0
      distance = 0

      FileReader.for_each_line(path) do |line|
        quantity, values = line.split(':')
        if quantity == 'Time'
          time = values.split.join.to_i
        else
          distance = values.split.join.to_i
        end
      end

      b = time
      c = distance
      r1 = ((-1 * b) + Math.sqrt((b**2) - (4 * c))) / 2
      r2 = ((-1 * b) - Math.sqrt((b**2) - (4 * c))) / 2

      r1.to_i - r2.to_i
    end
  end
end
