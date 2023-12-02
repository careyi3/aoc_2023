# frozen_string_literal: true

module Day2
  module Part1
    def self.run(path, _)
      limits = {
        'blue' => 14,
        'red' => 12,
        'green' => 13
      }
      possible_games = []
      impossible_games = []
      FileReader.for_each_line(path) do |line|
        game_id, subsets = line.split(': ')
        game_id = game_id.gsub('Game ', '').to_i
        possible = true
        subsets.split(';').each do |subset|
          next unless possible

          subset.split(',').each do |colour_pair|
            next unless possible

            num, colour = colour_pair.split
            if num.to_i > limits[colour]
              possible = false
              next
            end
          end
        end
        if possible
          possible_games << game_id
        else
          impossible_games << game_id
        end
      end
      puts possible_games.sum
    end
  end
end
