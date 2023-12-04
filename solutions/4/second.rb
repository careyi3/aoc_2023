# frozen_string_literal: true

module Day4
  module Part2
    def self.run(path, _)
      scores = {}
      FileReader.for_each_line(path) do |line|
        card_id_string, numbers = line.split(': ')
        _, card_id = card_id_string.split
        scores[card_id.to_i] = { score: 0, count: 1 }

        winning_numbers, our_numbers = numbers.split(' | ')
        winning_numbers = winning_numbers.split.map(&:to_i)
        our_numbers = our_numbers.split.map(&:to_i)

        winning_number_count = winning_numbers.count
        remaining_number_count = (winning_numbers - our_numbers).count
        matched_number_count = winning_number_count - remaining_number_count

        scores[card_id.to_i][:score] = matched_number_count
      end

      scores.each do |key, value|
        value[:count].times do
          ((key + 1)..key + value[:score]).each do |idx|
            scores[idx][:count] = scores[idx][:count] + 1
          end
        end
      end

      puts scores.values.map { |x| x[:count] }.sum
    end
  end
end
