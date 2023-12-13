# frozen_string_literal: true

module Day12
  module Part2
    def self.run(path, _)
      data = {}
      FileReader.for_each_line_with_index(path) do |line, idx|
        layout, counts = line.split
        counts = counts.split(',').map(&:to_i)
        expanded_layout = layout
        expanded_counts = counts
        4.times do
          expanded_layout += "?#{layout}"
          expanded_counts += counts
        end
        data[idx] = { layout: expanded_layout, counts: expanded_counts }
      end

      matches =
        Parallel.map_with_index(data.values, progress: 'Computing...') do |val, idx|
          cache = {}
          ans = walk(cache, val[:layout].chars, val[:counts], val[:layout].chars.select { |x| x == '?' }.count, val[:layout].chars.select { |x| x == '#' }.count, 0, '')
          puts idx
          ans
        end
      matches.sum
    end

    def self.walk(cache, input, input_counts, unknown_count, broken_count, idx, test_pattern)
      return cache[test_pattern] unless cache[test_pattern].nil?

      test_pattern_counts = test_pattern.split('.').reject { |x| x == '' }.map(&:length)

      if test_pattern.length == input.count
        return 1 if test_pattern_counts == input_counts

        return 0
      end
      if test_pattern_counts.count.positive? &&
         test_pattern_counts.sum > input_counts.sum
        return 0
      end
      if test_pattern_counts.count.positive? &&
         test_pattern_counts.count > input_counts.count
        return 0
      end
      if test_pattern_counts.count.positive? &&
         test_pattern_counts[test_pattern_counts.count - 1] > input_counts[test_pattern_counts.count - 1]

        return 0
      end
      if test_pattern_counts.count.positive? &&
         test_pattern_counts.slice(0, test_pattern_counts.count - 1) != input_counts.slice(0, test_pattern_counts.count - 1)
        return 0
      end

      return_val =
        if input[idx] == '?'
          broken = walk(cache, input, input_counts, unknown_count - 1, broken_count, idx + 1, "#{test_pattern}#")
          fixed = walk(cache, input, input_counts, unknown_count - 1, broken_count, idx + 1, "#{test_pattern}.")
          broken + fixed
        else
          walk(cache, input, input_counts, unknown_count, broken_count, idx + 1, test_pattern + input[idx])
        end

      cache[test_pattern] = return_val
      return_val
    end
  end
end
