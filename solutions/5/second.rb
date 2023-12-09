# frozen_string_literal: true

module Day5
  module Part2
    def self.run(path, _)
      seed_ranges = []
      seeds = []
      almanac = []
      idx = -1
      FileReader.for_each_line(path) do |line|
        if line.include?('seeds:')
          seeds = line.split('seeds: ')[1].split.map(&:to_i)
          seed_ranges = seeds.each_slice(2).to_a
          seed_ranges.each do |range|
            range[1] = range[0] + range[1]
          end
        elsif line == ''
          next
        elsif line.include?(':')
          idx += 1
          almanac[idx] = { from: [], to: [] }
        else
          values = line.split.map(&:to_i)
          almanac[idx][:from] << { from: values[1], to: values[1] + values[2] - 1 }
          almanac[idx][:to] << { from: values[0], to: values[0] + values[2] - 1 }
        end
      end

      almanac.each do |map|
        new_seed_ranges = []
        seed_ranges.each do |seed_range|
          sub_ranges = []
          map[:from].each_with_index do |val, fidx|
            if seed_range[0] >= val[:from] && seed_range[1] <= val[:to]
              from_offset = seed_range[0] - val[:from]
              range_size = seed_range[1] - seed_range[0]
              sub_ranges <<
                [
                  map[:to][fidx][:from] + from_offset,
                  map[:to][fidx][:from] + from_offset + range_size
                ]
              break
            end
            if seed_range[0] < val[:from] && seed_range[1] <= val[:to] && seed_range[1] >= val[:from]
              seed_ranges <<
                [
                  seed_range[0],
                  val[:from] - 1
                ]

              range_size = seed_range[1] - val[:from]
              sub_ranges <<
                [
                  map[:to][fidx][:from],
                  map[:to][fidx][:from] + range_size
                ]
              break
            end
            if seed_range[1] > val[:to] && seed_range[0] <= val[:to] && seed_range[0] >= val[:from]
              seed_ranges <<
                [
                  val[:to] + 1,
                  seed_range[1]
                ]

              range_size = val[:to] - seed_range[0]
              sub_ranges <<
                [
                  map[:to][fidx][:to] - range_size,
                  map[:to][fidx][:to]
                ]
              break
            end
            if seed_range[0] < val[:from] && seed_range[1] > val[:to] # rubocop:disable Style/Next
              seed_ranges <<
                [
                  val[:to] + 1,
                  seed_range[1]
                ]
              seed_ranges <<
                [
                  seed_range[0],
                  val[:from] - 1
                ]
              sub_ranges <<
                [
                  map[:to][fidx][:from],
                  map[:to][fidx][:to]
                ]
              break
            end
          end
          sub_ranges << seed_range if sub_ranges.count.zero?
          new_seed_ranges += sub_ranges
        end
        seed_ranges = new_seed_ranges
      end
      seed_ranges.flatten.min
    end
  end
end
