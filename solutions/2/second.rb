# frozen_string_literal: true

module Day2
  module Part2
    def self.run(path, _)
      powers = {}
      FileReader.for_each_line(path) do |line|
        game_id, subsets = line.split(': ')
        game_id = game_id.gsub('Game ', '').to_i
        values = {}
        subsets.split(';').each do |subset|
          subset.split(',').each do |colour_pair|
            num, colour = colour_pair.split
            values[colour] = num.to_i if values[colour].nil? || num.to_i > values[colour]
          end
        end
        powers[game_id] = values.values.inject(:*)
      end
      puts powers.values.sum
    end
  end
end
