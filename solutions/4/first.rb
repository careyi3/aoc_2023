# frozen_string_literal: true

module Day4
  module Part1
    def self.run(path, _)
      scores = {}
      FileReader.for_each_line(path) do |line|
        card_id_string, numbers = line.split(': ')
        _, card_id = card_id_string.split
        scores[card_id] = 0

        winning_numbers, our_numbers = numbers.split(' | ')
        winning_numbers = winning_numbers.split.map(&:to_i)
        our_numbers = our_numbers.split.map(&:to_i)

        winning_number_count = winning_numbers.count
        remaining_number_count = (winning_numbers - our_numbers).count
        matched_number_count = winning_number_count - remaining_number_count

        scores[card_id] =
          if matched_number_count.positive?
            2**(matched_number_count - 1)
          else
            0
          end
      end

      scores.values.sum
    end
  end
end
