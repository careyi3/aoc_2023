# frozen_string_literal: true

module Day11
  module Part2
    def self.run(path, _)
      map = {}
      xs = []
      ys = []
      galaxy_idx = 0
      FileReader.for_each_line_with_index(path) do |line, y|
        line.chars.each_with_index do |char, x|
          xs[x] = char if xs[x].nil? || xs[x] != '#'
          ys[y] = char if ys[y].nil? || ys[y] != '#'

          if char == '#'
            map[galaxy_idx] = { x:, y: }
            galaxy_idx += 1
          end
        end
      end

      x_expanded_count = 0
      expansion_amount = 999_999
      xs.each_with_index do |val, x|
        next unless val == '.'

        map.each do |_, coords|
          coords[:x] += expansion_amount if coords[:x] > x + (x_expanded_count * expansion_amount)
        end
        x_expanded_count += 1
      end

      y_expanded_count = 0
      ys.each_with_index do |val, y|
        next unless val == '.'

        map.each do |_, coords|
          coords[:y] += expansion_amount if coords[:y] > y + (y_expanded_count * expansion_amount)
        end
        y_expanded_count += 1
      end

      pairs = {}
      map.each do |a, val_a|
        map.each do |b, val_b|
          next unless pairs[[a, b].sort.join(':')].nil?

          pairs[[a, b].sort.join(':')] = (val_b[:x] - val_a[:x]).abs + (val_b[:y] - val_a[:y]).abs
        end
      end

      pairs.values.sum
    end
  end
end
