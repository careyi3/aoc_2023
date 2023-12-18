# frozen_string_literal: true

module Day17
  module Part1
    def self.run(path, _)
      map = {}
      grid = []
      vis = false
      FileReader.for_each_line_with_index(path) do |line, y|
        line.chars.each_with_index do |char, x|
          map["#{x}:#{y}"] = char.to_i
        end
        grid << line.chars
      end

      end_coord = map.keys.last
      visited = {}
      walk(vis, map, grid, 0, 0, 0, 2, 0, visited)

      end_path_lengths = []
      visited.each do |key, val|
        end_path_lengths << val if key.include?(end_coord)
      end

      end_path_lengths.min + map[end_coord]
    end

    def self.walk(vis, map, grid, dist, x, y, dir, dir_steps, visited)
      coord = "#{x}:#{y}"
      return if map[coord].nil?

      key = "#{x}:#{y}:#{dir}:#{dir_steps}"
      return if dist > 900
      return unless visited[key].nil? || dist < visited[key]

      visited[key] = dist
      dist += map[coord]

      if vis
        grid[y][x] = '<' if dir == 0
        grid[y][x] = '^' if dir == 1
        grid[y][x] = '>' if dir == 2
        grid[y][x] = 'v' if dir == 3

        vis(grid, x, y)
      end

      nexts = []
      [[x - 1, y], [x, y - 1], [x + 1, y], [x, y + 1]].each_with_index do |(xx, yy), id|
        next if dir == id && dir_steps == 2
        next if (id == dir + 2) || (id == dir - 2)
        next if map["#{xx}:#{yy}"].nil?

        nexts << { x: xx, y: yy, dir: id, val: map["#{xx}:#{yy}"] }
      end

      nexts = nexts.sort_by { |v| v[:val] }

      if vis
        walk(vis, map, Marshal.load(Marshal.dump(grid)), dist, nexts[0][:x], nexts[0][:y], nexts[0][:dir], dir == nexts[0][:dir] ? dir_steps + 1 : 0, visited) unless nexts[0].nil?
        walk(vis, map, Marshal.load(Marshal.dump(grid)), dist, nexts[1][:x], nexts[1][:y], nexts[1][:dir], dir == nexts[1][:dir] ? dir_steps + 1 : 0, visited) unless nexts[1].nil?
        walk(vis, map, Marshal.load(Marshal.dump(grid)), dist, nexts[2][:x], nexts[2][:y], nexts[2][:dir], dir == nexts[2][:dir] ? dir_steps + 1 : 0, visited) unless nexts[2].nil?
        walk(vis, map, Marshal.load(Marshal.dump(grid)), dist, nexts[3][:x], nexts[3][:y], nexts[3][:dir], dir == nexts[3][:dir] ? dir_steps + 1 : 0, visited) unless nexts[3].nil?
      else
        walk(vis, map, grid, dist, nexts[0][:x], nexts[0][:y], nexts[0][:dir], dir == nexts[0][:dir] ? dir_steps + 1 : 0, visited) unless nexts[0].nil?
        walk(vis, map, grid, dist, nexts[1][:x], nexts[1][:y], nexts[1][:dir], dir == nexts[1][:dir] ? dir_steps + 1 : 0, visited) unless nexts[1].nil?
        walk(vis, map, grid, dist, nexts[2][:x], nexts[2][:y], nexts[2][:dir], dir == nexts[2][:dir] ? dir_steps + 1 : 0, visited) unless nexts[2].nil?
        walk(vis, map, grid, dist, nexts[3][:x], nexts[3][:y], nexts[3][:dir], dir == nexts[3][:dir] ? dir_steps + 1 : 0, visited) unless nexts[3].nil?
      end
    end

    def self.vis(grid, x, y)
      Visualisation.print_grid(grid, centre_x: x, centre_y: y, x_dim: 20, y_dim: 20, sleep: 0.1, empty_char: '', spacer: ' ', character_colours: { 'v' => :red, '<' => :red, '>' => :red, '^' => :red }, no_clear: false)
    end
  end
end
