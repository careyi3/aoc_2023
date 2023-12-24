# frozen_string_literal: true

module Day24
  module Part2
    def self.run(path, input)
      stones = []
      FileReader.for_each_line(path) do |line|
        sx, sy, sz, ux, uy, uz = line.split(' @ ').map { |l| l.split(', ').map(&:to_f) }.flatten
        stones << { sx:, sy:, sz:, ux:, uy:, uz: }
      end

      max = input == 'sample' ? 27 : 400_000_000_000_000
      min = input == 'sample' ? 7 : 200_000_000_000_000
      crossing = 0
      stones.combination(2).to_a.each do |stone1, stone2|
        m1 = stone1[:uy] / stone1[:ux]
        a = m1
        c = (-1 * m1 * stone1[:sx]) + stone1[:sy]
        m2 = stone2[:uy] / stone2[:ux]
        b = m2
        d = (-1 * m2 * stone2[:sx]) + stone2[:sy]

        x = (d - c) / (a - b)
        y = (a * ((d - c) / (a - b))) + c

        inside_area = x >= min && x <= max && y >= min && y <= max
        stone1_positive_t = ((x - stone1[:sx]) / stone1[:ux]).positive?
        stone2_positive_t = ((x - stone2[:sx]) / stone2[:ux]).positive?
        crossing += 1 if inside_area && stone1_positive_t && stone2_positive_t
      end
      crossing
    end
  end
end
