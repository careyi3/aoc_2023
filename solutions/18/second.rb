# frozen_string_literal: true

module Day18
  module Part2
    def self.run(path, _)
      points = [[0, 0]]
      boundry_points = 0
      FileReader.for_each_line(path) do |line|
        _, val = line.gsub('(', '').gsub(')', '').split('#')

        val = val.chars
        dir = val.pop
        dist = val.join.to_i(16)

        boundry_points += dist
        x, y = points.last

        points << [x + dist, y] if dir == '0'
        points << [x, y + dist] if dir == '1'
        points << [x - dist, y] if dir == '2'
        points << [x, y - dist] if dir == '3'
      end

      sum = 0
      points.each_with_index do |(x1, y1), id|
        break if id == points.count - 2
        next if points[id + 1].nil?

        x2, y2 = points[id + 1]
        sum += (y1 + y2) * (x1 - x2)
      end

      (sum / 2) - (boundry_points / 2) + 1 + boundry_points
    end
  end
end
