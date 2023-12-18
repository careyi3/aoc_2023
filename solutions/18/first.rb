# frozen_string_literal: true

module Day18
  module Part1
    def self.run(path, input)
      vis = true
      x = 0
      y = 0
      x_max = 0
      y_max = 0
      x_min = 0
      y_min = 0
      map = {}
      min_max = {}
      map["#{x}:#{y}"] = 'F'
      grid_size = (input == 'sample' ? 10 : 400)
      grid = Array.new(grid_size) { Array.new(grid_size) { '.' } }
      grid[input == 'sample' ? 0 : 78][0] = 'F'

      corner_lookup = {
        'DL' => 'J',
        'LD' => 'F',
        'RU' => 'J',
        'UR' => 'F',
        'DR' => 'l',
        'RD' => '7',
        'LU' => 'l',
        'UL' => '7'
      }

      last_dir = 'R'
      FileReader.for_each_line(path) do |line|
        dir, dist, = line.gsub('(', '').gsub(')', '').split
        dist.to_i.times do
          if !corner_lookup["#{last_dir}#{dir}"].nil?
            grid[y + (input == 'sample' ? 0 : 78)][x] = corner_lookup["#{last_dir}#{dir}"] if vis
            map["#{x}:#{y}"] = corner_lookup["#{last_dir}#{dir}"]
          end

          y -= 1 if dir == 'U'
          y += 1 if dir == 'D'
          x -= 1 if dir == 'L'
          x += 1 if dir == 'R'

          x_max = x if x > x_max
          y_max = y if y > y_max
          x_min = x if x < x_min
          y_min = y if y < y_min

          if vis
            grid[y + (input == 'sample' ? 0 : 78)][x] = dir unless x.zero? && y.zero?
          end
          map["#{x}:#{y}"] = dir unless x.zero? && y.zero?

          if min_max[y].nil?
            min_max[y] = { min: x, max: x }
          else
            min_max[y][:max] = x if x > min_max[y][:max]
            min_max[y][:min] = x if x < min_max[y][:min]
          end

          last_dir = dir
        end
      end

      inside = 0
      (y_min..y_max).each do |y|
        count = 0
        ((min_max[y][:min] - 1)..(min_max[y][:max] + 1)).each do |x|
          count += 1 if !map["#{x}:#{y}"].nil? && %w[U D J l].include?(map["#{x}:#{y}"])
          next unless map["#{x}:#{y}"].nil?

          if count.odd?
            inside += 1
            grid[y + (input == 'sample' ? 0 : 78)][x] = 'I' if vis
          end
        end
      end

      Visualisation.print_grid(grid, centre_x: (input == 'sample' ? 5 : 200), centre_y: (input == 'sample' ? 5 : 200), x_dim: (input == 'sample' ? 10 : 400), y_dim: (input == 'sample' ? 10 : 400), sleep: 0.01, spacer: '', empty_char: '.', no_clear: true, character_colours: { 'I' => :red }) if vis

      inside + map.count
    end
  end
end
