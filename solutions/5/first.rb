# frozen_string_literal: true

module Day5
  module Part1
    def self.run(path, _)
      seeds = []
      almanac = []
      idx = -1
      FileReader.for_each_line(path) do |line|
        if line.include?('seeds:')
          seeds = line.split('seeds: ')[1].split.map(&:to_i)
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
        seeds.each_with_index do |seed, id|
          from_offset = nil
          from_idx = nil
          map[:from].each_with_index do |val, fidx|
            next unless val[:from] <= seed && seed <= val[:to]

            from_offset = seed - val[:from]
            from_idx = fidx
            break
          end
          next if from_offset.nil? || from_idx.nil?

          seeds[id] = map[:to][from_idx][:from] + from_offset
        end
      end

      puts seeds.min
    end
  end
end
