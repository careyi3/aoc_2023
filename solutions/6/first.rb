# frozen_string_literal: true

module Day6
  module Part1
    def self.run(path, _)
      times = []
      distances = []
      games = []

      FileReader.for_each_line(path) do |line|
        quantity, values = line.split(':')
        if quantity == 'Time'
          times = values.split.map(&:to_i)
        else
          distances = values.split.map(&:to_i)
        end
      end

      times.each_with_index do |time, idx|
        games[idx] = { time:, distance: distances[idx], possible_wins: 0 }
      end

      games.each do |game|
        (1..(game[:time] - 1)).each do |t|
          d = (game[:time] - t) * t
          game[:possible_wins] += 1 if d > game[:distance]
        end
      end

      puts games.map { |x| x[:possible_wins] }.inject(:*)
    end
  end
end
