# frozen_string_literal: true

module Day14
  module Part2
    def self.run(path, input)
      grid = []
      FileReader.for_each_line_with_index(path) do |line, y|
        grid[y] = ['#'] + line.chars + ['#']
      end
      x_max = grid.first.length
      y_max = grid.length
      grid.unshift(Array.new(x_max) { '#' })
      grid << Array.new(x_max) { '#' }

      tilt_cache = {}
      load_cache = {}

      weights = []
      occurrences = {}
      200.times do
        puts "Tilt Cache: #{tilt_cache.count} Load Cache: #{load_cache.count}"

        cycle(tilt_cache, grid, x_max, y_max)
        weight = total_load(load_cache, grid, x_max)
        weights << weight
        occurrences[weight] = occurrences[weight].nil? ? 1 : occurrences[weight] + 1
      end
      offset = input == 'sample' ? 2 : 124
      pattern_length = input == 'sample' ? 7 : 26
      id = ((1_000_000_000 - offset) % pattern_length)
      weights.shift(offset)
      weights = weights.shift(pattern_length)
      weights[id - 1]
    end

    def self.cycle(tilt_cache, grid, x_max, y_max)
      vertical_tilt(tilt_cache, grid, x_max, y_max, true)
      horizontal_tilt(tilt_cache, grid, x_max, y_max, true)
      vertical_tilt(tilt_cache, grid, x_max, y_max, false)
      horizontal_tilt(tilt_cache, grid, x_max, y_max, false)
    end

    def self.vertical_tilt(tilt_cache, grid, x_max, y_max, dir)
      cache_key = "#{grid.flatten.join}:v:#{dir}"
      grid = tilt_cache[cache_key] unless tilt_cache[cache_key].nil?

      x_range = dir ? (0..x_max) : x_max.downto(0)
      y_range = dir ? (0..y_max) : y_max.downto(0)

      x_range.each do |x|
        free_slots = []
        y_range.each do |y|
          free_slots << y if grid[y][x] == '.'
          free_slots = [] if grid[y][x] == '#'
          next unless grid[y][x] == 'O' && free_slots.any?

          grid[free_slots.shift][x] = 'O'
          grid[y][x] = '.'
          free_slots << y
        end
      end
      tilt_cache[cache_key] = grid
    end

    def self.horizontal_tilt(tilt_cache, grid, x_max, y_max, dir)
      cache_key = "#{grid.flatten.join}:h:#{dir}"
      grid = tilt_cache[cache_key] unless tilt_cache[cache_key].nil?

      x_range = dir ? (0..x_max) : x_max.downto(0)
      y_range = dir ? (0..y_max) : y_max.downto(0)

      y_range.each do |y|
        free_slots = []
        x_range.each do |x|
          free_slots << x if grid[y][x] == '.'
          free_slots = [] if grid[y][x] == '#'
          next unless grid[y][x] == 'O' && free_slots.any?

          grid[y][free_slots.shift] = 'O'
          grid[y][x] = '.'
          free_slots << x
        end
      end
      tilt_cache[cache_key] = grid
    end

    def self.total_load(load_cache, grid, x_max)
      cache_key = grid.flatten.join
      return load_cache[cache_key] unless load_cache[cache_key].nil?

      weight = 0
      grid.each_with_index do |line, y|
        rock_count = line.select { |x| x == 'O' }.count
        weight += rock_count * ((x_max - y) - 1)
      end
      load_cache[cache_key] = weight
      weight
    end
  end
end
