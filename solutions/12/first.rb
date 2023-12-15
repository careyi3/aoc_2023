# frozen_string_literal: true

module Day12
  module Part1
    def self.run(path, _)
      data = {}
      FileReader.for_each_line_with_index(path) do |line, idx|
        layout, counts = line.split
        data[idx] = { layout:, counts: counts.split(',').map(&:to_i) }
      end

      hit_miss_ratios = []
      cache_sizes = []
      size_hits_ratio = []
      matches =
        data.values.map do |val|
          cache = { hit: 0, miss: 0 }
          ans = walk(cache, ['.'] + val[:layout].chars, val[:counts], 0)
          hit_miss_ratio = (100.0 * cache[:hit] * 1.0 / ((cache[:miss] * 1.0) + (cache[:hit] * 1.0)))
          hit_miss_ratios << hit_miss_ratio
          cache_size = (cache.count - 2)
          cache_sizes << cache_size
          size_hits_ratio << (cache_size * 1.0 / hit_miss_ratio) if hit_miss_ratio.positive?
          ans
        end
      puts "Cache Size: #{cache_sizes.sum / cache_sizes.count}"
      puts "Size/Hits Ratio: #{size_hits_ratio.sum / size_hits_ratio.count}"
      puts "Hit/Miss Ratio: #{hit_miss_ratios.sum / hit_miss_ratios.count}"
      matches.sum
    end

    def self.walk(cache, input, input_counts, idx)
      counts = input.join.split('.').reject { |x| x == '' }.map { |x| x.chars.select { |y| y == '#' }.count }.reject(&:zero?)
      count_unknown = input.select { |x| x == '?' }.count
      count_working = input.select { |x| x == '.' }.count
      count_broken = counts.sum
      count_desired_brokens = input_counts.sum

      key = "#{count_broken}:#{count_working}:#{count_unknown}:#{counts}"
      unless cache[key].nil?
        cache[:hit] = cache[:hit] + 1
        return cache[key]
      end

      cache[:miss] = cache[:miss] + 1

      if count_broken > count_desired_brokens
        cache[key] = 0
        return 0
      end
      if count_desired_brokens - count_broken > count_unknown
        cache[key] = 0
        return 0
      end
      if counts.count > input_counts.count
        cache[key] = 0
        return 0
      end

      sub_counts = input[0..idx].join.split('.').reject { |x| x == '' }.map { |x| x.chars.select { |y| y == '#' }.count }.reject(&:zero?)
      sub_counts.each_with_index do |count, i|
        if count > input_counts[i]
          cache[key] = 0
          return 0
        end
      end

      if idx == input.count || count_unknown.zero?
        if counts == input_counts
          cache[key] = 1
          return 1
        end

        cache[key] = 0
        return 0
      end

      new_input = Marshal.load(Marshal.dump(input))
      if input[idx] == '?'
        new_input[idx] = '#'
        broken = walk(cache, new_input, input_counts, idx + 1)
        new_input = Marshal.load(Marshal.dump(input))
        new_input[idx] = '.'
        fixed = walk(cache, new_input, input_counts, idx + 1)
        broken + fixed
      else
        walk(cache, new_input, input_counts, idx + 1)
      end
    end
  end
end
