# frozen_string_literal: true

module Day16
  module Part1
    def self.run(path, _)
      vis = false
      directions = {
        up: lambda do |map, x, y|
              (y - 1).downto(0).each do |id|
                break if map["#{x}:#{id}"].nil?
                return [x, id] if map["#{x}:#{id}"][:content] != '.'

                map["#{x}:#{id}"][:visited] += 1
              end
              [x, 0]
            end,
        down: lambda do |map, x, y|
                ((y + 1)..120).each do |id|
                  break if map["#{x}:#{id}"].nil?
                  return [x, id] if map["#{x}:#{id}"][:content] != '.'

                  map["#{x}:#{id}"][:visited] += 1
                end
                [x, 120]
              end,
        left: lambda do |map, x, y|
                (x - 1).downto(0).each do |id|
                  break if map["#{id}:#{y}"].nil?
                  return [id, y] if map["#{id}:#{y}"][:content] != '.'

                  map["#{id}:#{y}"][:visited] += 1
                end
                [0, y]
              end,
        right: lambda do |map, x, y|
                 ((x + 1)..120).each do |id|
                   break if map["#{id}:#{y}"].nil?
                   return [id, y] if map["#{id}:#{y}"][:content] != '.'

                   map["#{id}:#{y}"][:visited] += 1
                 end
                 [120, y]
               end
      }
      reflections = {
        '\\' => { right: [:down], down: [:right], left: [:up], up: [:left] },
        '/' => { right: [:up], down: [:left], left: [:down], up: [:right] },
        '|' => { left: %i[up down], up: [], right: %i[up down], down: [] },
        '-' => { left: [], up: %i[right left], right: [], down: %i[right left] }
      }
      map = {}
      x_max = 0
      y_max = 0
      FileReader.for_each_line_with_index(path) do |line, y|
        line.chars.each_with_index do |char, x|
          map["#{x}:#{y}"] = { content: char, visited: 0 }
          x_max = x
        end
        y_max = y
      end

      walk(map, directions, reflections, 0, 0, :right, {})

      if vis
        grid = Array.new(y_max + 1) { Array.new(x_max + 1) }
        map.each do |key, value|
          x, y = key.split(':')
          grid[y.to_i][x.to_i] = value[:visited].positive? ? '#' : value[:content]
        end

        Visualisation.print_grid(grid, centre_x: x_max / 2, centre_y: y_max / 2, x_dim: x_max + 1, y_dim: y_max + 1, sleep: 0.01, spacer: '', character_colours: { '#' => :red }, no_clear: true)
      end

      map.values.select { |x| x[:visited].positive? }.count
    end

    def self.walk(map, directions, reflections, x, y, dir, visited)
      return unless visited["#{x}:#{y}:#{dir}"].nil?

      visited["#{x}:#{y}:#{dir}"] = 1
      coords = "#{x}:#{y}"
      return if map[coords].nil?

      map_content = map[coords][:content]
      map[coords][:visited] += 1

      if map_content == '.' || reflections[map_content][dir].count.zero?
        x_new, y_new = directions[dir].(map, x, y)
        walk(map, directions, reflections, x_new, y_new, dir, visited)
      else
        dir1, dir2 = reflections[map_content][dir]
        unless dir1.nil?
          x_new, y_new = directions[dir1].(map, x, y)
          walk(map, directions, reflections, x_new, y_new, dir1, visited)
        end
        unless dir2.nil?
          x_new, y_new = directions[dir2].(map, x, y)
          walk(map, directions, reflections, x_new, y_new, dir2, visited)
        end
      end
    end
  end
end
