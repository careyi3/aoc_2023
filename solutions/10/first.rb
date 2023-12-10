# frozen_string_literal: true

module Day10
  module Part1
    def self.run(path, _)
      connections = {
        '|' => [false, true, false, true],
        '-' => [true, false, true, false],
        'J' => [true, true, false, false],
        'L' => [false, true, true, false],
        '7' => [true, false, false, true],
        'F' => [false, false, true, true],
        'S' => [false, false, true, false],
        '.' => [false, false, false, false]
      }
      map = {}
      start = ''
      FileReader.for_each_line_with_index(path) do |line, y|
        line.chars.each_with_index do |char, x|
          start = "#{x}:#{y}" if char == 'S'
          map["#{x}:#{y}"] = { connection: connections[char], visited: false, char: }
        end
      end

      (walk(start, map, start, 0) / 2) + 1
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
