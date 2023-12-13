# frozen_string_literal: true

module Day13
  module Part2
    def self.run(path, _)
      ys = []
      xs = []
      y_idx = 0
      data = {}
      id = 0
      FileReader.for_each_line(path) do |line|
        if line == ''
          data[id] = { top: 0, left: 0, xs:, ys: }
          ys = ys.map { |y| y.to_i(2) }
          xs = xs.map { |x| x.to_i(2) }

          counts = {}
          ys.each_with_index do |y, idy|
            next unless idy + 1 < ys.count && y == ys[idy + 1]

            left = ys[0..idy].reverse
            right = ys[(idy + 1)..(ys.count - 1)]
            small, big = [left, right].sort_by(&:count)

            mirror = true
            small.each_with_index do |s, i|
              next if s == big[i]

              mirror = false
              break
            end
            counts[small.count] = (idy + 1) if mirror
          end
          data[id][:top] = counts[counts.keys.max] || 0

          counts = {}
          xs.each_with_index do |x, idx|
            next unless idx + 1 < xs.count && x == xs[idx + 1]

            left = xs[0..idx].reverse
            right = xs[(idx + 1)..(xs.count - 1)]
            small, big = [left, right].sort_by(&:count)

            mirror = true
            small.each_with_index do |s, i|
              next if s == big[i]

              mirror = false
              break
            end
            counts[small.count] = (idx + 1) if mirror
          end
          data[id][:left] = counts[counts.keys.max] || 0

          id += 1
          y_idx = 0
          ys = []
          xs = []
          next
        end
        x = []
        line.chars.each_with_index do |char, x_idx|
          x << (char == '#' ? '1' : '0')
          xs[x_idx] =
            if xs[x_idx].nil?
              (char == '#' ? '1' : '0')
            else
              xs[x_idx] + (char == '#' ? '1' : '0')
            end
        end
        ys[y_idx] = x.join
        y_idx += 1
      end

      data.each do |key, val|
        grid = val[:ys].map(&:chars)
        height = grid.count
        width = grid[0].count
        if val[:left].positive?
          grid.each do |y|
            y.insert(val[:left], '|')
          end
        end
        grid.insert(val[:top], Array.new(width) { '-' }) if val[:top].positive?
        puts "Grid: #{key + 1} - Left: #{val[:left]}, Top: #{val[:top]}"
        puts
        Visualisation.print_grid(grid, centre_x: height / 2, centre_y: width / 2, x_dim: height + 1, y_dim: width + 1, spacer: '', character_colours: { '1' => :red, '-' => :green, '|' => :green }, empty_char: '', sleep: 0.1, no_clear: true)
        puts '-------------------------'
        puts
      end

      data.values.map { |x| x[:left] }.sum + (100 * data.values.map { |x| x[:top] }.sum)
    end
  end
end
