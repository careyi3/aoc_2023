# frozen_string_literal: true

module Day14
  module Part1
    def self.run(path, _)
      verticals = []
      FileReader.for_each_line_with_index(path) do |line, y|
        line.chars.each_with_index do |char, x|
          verticals[x] =
            if verticals[x].nil?
              char == '.' ? [nil] : ["#{char}:#{y}"]
            else
              verticals[x] + (char == '.' ? [nil] : ["#{char}:#{y}"])
            end
        end
      end

      weights = []
      verticals.each do |rocks|
        id = 0
        weight = 0
        l = rocks.length
        rocks.compact.each do |rock|
          rock_type, ido = rock.split(':')
          if rock_type == '#'
            id = ido.to_i
          else
            weight += l - id
          end
          id += 1
        end
        weights << weight
      end

      weights.sum
    end
  end
end
