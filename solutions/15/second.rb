# frozen_string_literal: true

module Day15
  module Part2
    def self.run(path, _)
      sequence = []
      FileReader.for_each_line(path) do |line|
        sequence = line.split(',').map(&:chars)
      end

      map = {}
      256.times do |id|
        map[id] = {}
      end

      sequence.each do |step|
        step_string = step.join
        if step.include?('-')
          lens = step_string.split('-').first
          key = hash(lens.chars)
          map[key].delete(lens)
        else
          lens, lens_val = step_string.split('=')
          key = hash(lens.chars)
          map[key][lens] = lens_val.to_i
        end
      end

      powers = []
      map.each do |box, lenses|
        order = 1
        lenses.each_value do |lens|
          power = (box + 1) * order * lens
          order += 1
          powers << power
        end
      end
      powers.sum
    end

    def self.hash(seq)
      key = 0
      seq.each do |val|
        key = ((key + val.ord) * 17) % 256
      end
      key
    end
  end
end
