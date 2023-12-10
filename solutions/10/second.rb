# frozen_string_literal: true

module Day10
  module Part2
    def self.run(path, input)
      connections = {
        '|' => [false, true, false, true],
        '-' => [true, false, true, false],
        'J' => [true, true, false, false],
        'L' => [false, true, true, false],
        '7' => [true, false, false, true],
        'F' => [false, false, true, true],
        'S' => [true, false, true, false],
        '.' => [false, false, false, false]
      }
      map = {}
      start = ''
      x_max = 0
      y_max = 0
      FileReader.for_each_line_with_index(path) do |line, y|
        line.chars.each_with_index do |char, x|
          start = "#{x}:#{y}" if char == 'S'
          map["#{x}:#{y}"] = { connection: connections[char], visited: false, char: }
          x_max = x
        end
        y_max = y
      end

      walk(start, map, start, 0)

      inside = 0
      outside = 0
      grid = Array.new(y_max + 1) { Array.new(x_max + 1) }
      (0..y_max).each do |y|
        (0..x_max).each do |x|
          if map["#{x}:#{y}"][:visited]
            outside += 1
            grid[y][x] = map["#{x}:#{y}"][:char]
            next
          end

          crosses = 0
          (0..x).each do |xx|
            crosses += 1 if map["#{xx}:#{y}"][:visited] && map["#{xx}:#{y}"][:connection][1]
          end

          if crosses.even?
            outside += 1
            grid[y][x] = 'O'
          else
            inside += 1
            grid[y][x] = 'I'
          end
        end
      end
      Visualisation.print_grid(grid, centre_x: 5, centre_y: 10, x_dim: 10, y_dim: 20, spacer: '') if input != 'input'
      inside
    end

    def self.walk(start, map, current_node, steps)
      map[current_node][:visited] = true
      return steps if current_node == start && steps.positive?

      x, y = current_node.split(':').map(&:to_i)
      next_nodes = [
        "#{x - 1}:#{y}",
        "#{x}:#{y - 1}",
        "#{x + 1}:#{y}",
        "#{x}:#{y + 1}"
      ]

      return walk(start, map, next_nodes[0], steps + 1) if !map[next_nodes[0]].nil? && map[next_nodes[0]][:connection][-2] && !map[next_nodes[0]][:visited] && map[current_node][:connection][0] != false
      return walk(start, map, next_nodes[1], steps + 1) if !map[next_nodes[1]].nil? && map[next_nodes[1]][:connection][-1] && !map[next_nodes[1]][:visited] && map[current_node][:connection][1] != false
      return walk(start, map, next_nodes[2], steps + 1) if !map[next_nodes[2]].nil? && map[next_nodes[2]][:connection][0] && !map[next_nodes[2]][:visited] && map[current_node][:connection][2] != false
      return walk(start, map, next_nodes[3], steps + 1) if !map[next_nodes[3]].nil? && map[next_nodes[3]][:connection][1] && !map[next_nodes[3]][:visited] && map[current_node][:connection][3] != false

      steps
    end
  end
end
