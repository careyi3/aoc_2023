# frozen_string_literal: true

module Day17
  module Part1
    def self.run(path, _)
      map = {}
      grid = []
      FileReader.for_each_line_with_index(path) do |line, y|
        line.chars.each_with_index do |char, x|
          map["#{x}:#{y}"] = { val: char.to_i, shortest_path: nil }
        end
        grid << line.chars
      end

      end_coord = map.keys.last
      walk(map, end_coord, 0, 0, 0, 2, 0, {})

      map[end_coord][:shortest_path]
    end

    def self.walk(map, end_coord, dist, x, y, dir, dir_steps, visited)
      #puts dist
      coord = "#{x}:#{y}"
      visited_key = "#{x}:#{y}"
      return unless visited[visited_key].nil?

      dist += map[coord][:val]

      #grid[y][x] = '<' if dir == 0
      #grid[y][x] = '^' if dir == 1
      #grid[y][x] = '>' if dir == 2
      #grid[y][x] = 'v' if dir == 3

      if coord == end_coord
        #puts '--------'
        #vis(grid)
        puts dist
        #puts '--------'
        return
      end

      nexts = []
      [[x - 1, y], [x, y - 1], [x + 1, y], [x, y + 1]].each_with_index do |(xx, yy), id|
        next if dir == id && dir_steps == 2
        next if (id == dir + 2) || (id == dir - 2)
        next if map["#{xx}:#{yy}"].nil?

        nexts << { x: xx, y: yy, dir: id, val: map["#{xx}:#{yy}"][:val] }
      end

      nexts = nexts.sort_by { |v| v[:val] }

      nexts.each do |n|
        map["#{n[:x]}:#{n[:y]}"][:shortest_path] = dist if map["#{n[:x]}:#{n[:y]}"][:shortest_path].nil? || map["#{n[:x]}:#{n[:y]}"][:shortest_path] > dist
      end

      walk(map, end_coord, dist, nexts[0][:x], nexts[0][:y], nexts[0][:dir], dir == nexts[0][:dir] ? dir_steps + 1 : 0, visited) unless nexts[0].nil?
      walk(map, end_coord, dist, nexts[1][:x], nexts[1][:y], nexts[1][:dir], dir == nexts[1][:dir] ? dir_steps + 1 : 0, visited) unless nexts[1].nil?
      walk(map, end_coord, dist, nexts[2][:x], nexts[2][:y], nexts[2][:dir], dir == nexts[2][:dir] ? dir_steps + 1 : 0, visited) unless nexts[2].nil?
      walk(map, end_coord, dist, nexts[3][:x], nexts[3][:y], nexts[3][:dir], dir == nexts[3][:dir] ? dir_steps + 1 : 0, visited) unless nexts[3].nil?
      visited[visited_key] = dist
    end

    def self.vis(grid)
      #Visualisation.print_grid(grid, centre_x: 7, centre_y: 7, x_dim: 14, y_dim: 14, sleep: 0, empty_char: '', spacer: ' ', character_colours: { 'v' => :red, '<' => :red, '>' => :red, '^' => :red }, no_clear: true)
      Visualisation.print_grid(grid, centre_x: 71, centre_y: 71, x_dim: 142, y_dim: 142, sleep: 0, empty_char: '', spacer: '', character_colours: { 'v' => :red, '<' => :red, '>' => :red, '^' => :red }, no_clear: false)
    end
  end
end
