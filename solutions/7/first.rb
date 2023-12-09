# frozen_string_literal: true

module Day7
  module Part1
    def self.run(path, _)
      cards = {
        'A' => 'D',
        'K' => 'C',
        'Q' => 'B',
        'J' => 'A',
        'T' => '9',
        '9' => '8',
        '8' => '7',
        '7' => '6',
        '6' => '5',
        '5' => '4',
        '4' => '3',
        '3' => '2',
        '2' => '1'
      }

      hand_lookup = {
        '5' => '5_of_a_kind',
        '14' => '4_of_a_kind',
        '23' => 'full_house',
        '113' => 'three_of_a_kind',
        '122' => 'two_pair',
        '1112' => 'pair',
        '11111' => 'high_card'
      }

      hand_groups = {
        '5_of_a_kind' => [],
        '4_of_a_kind' => [],
        'full_house' => [],
        'three_of_a_kind' => [],
        'two_pair' => [],
        'pair' => [],
        'high_card' => []
      }

      FileReader.for_each_line(path) do |line|
        hand, bid = line.split
        score = hand.chars.map { |card| cards[card] }.join.to_i(16)
        counts = hand.chars.group_by(&:itself)
        hand_group = hand_lookup[counts.values.map(&:count).sort.join]
        hand_groups[hand_group] << { hand:, bid: bid.to_i, score: }
      end

      ordered_bids = []
      hand_groups.each_value do |hands|
        bids = hands.sort_by { |x| x[:score] }.reverse.map { |x| x[:bid] }
        ordered_bids << bids if bids.count.positive?
      end

      score = 0
      ordered_bids.flatten.reverse.each_with_index do |bid, idx|
        score += bid * (idx + 1)
      end

      score
    end
  end
end
