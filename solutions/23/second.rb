# frozen_string_literal: true

module Day23
  module Part2
    def self.run(path, _)
      map = {}
      start = ''
      finish = ''
      FileReader.for_each_line_with_index(path) do |line, y|
        line.chars.each_with_index do |char, x|
          coord = "#{x}:#{y}"
          start = coord if char == 'S'
          finish = coord if char == 'F'
          map[coord] = char
        end
      end
      visited = {}
      max = { finish => 0 }
      walk(map, finish, start, visited, 0, max)
    end

    def self.walk(map, finish, next_coord, visited, steps, max)
      x, y = next_coord.split(':').map(&:to_i)

      visited[next_coord] = true

      if next_coord == finish
        if steps > max[finish]
          max[finish] = steps
          puts steps
        end
        return steps
      end

      to_visit = []
      [[x - 1, y], [x, y - 1], [x + 1, y], [x, y + 1]].each_with_index do |(xx, yy), slop_dir|
        test_coord = "#{xx}:#{yy}"
        val = map[test_coord]
        can_visit = (val != '#' && !val.nil?)
        can_visit = false unless visited[test_coord].nil?
        to_visit[slop_dir] = [test_coord, can_visit]
      end

      lengths = []
      lengths << walk(map, finish, to_visit[0][0], visited.clone, steps + 1, max) if to_visit[0][1]
      lengths << walk(map, finish, to_visit[1][0], visited.clone, steps + 1, max) if to_visit[1][1]
      lengths << walk(map, finish, to_visit[2][0], visited.clone, steps + 1, max) if to_visit[2][1]
      lengths << walk(map, finish, to_visit[3][0], visited.clone, steps + 1, max) if to_visit[3][1]

      lengths.max || 0
    end
  end
end
