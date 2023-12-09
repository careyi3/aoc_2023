# frozen_string_literal: true

module Day8
  module Part2
    def self.run(path, _)
      instructions = []
      instruction_count = 0
      next_nodes = []
      map = {}
      FileReader.for_each_line_with_index(path) do |line, idx|
        if idx.zero?
          instructions = line.chars
          instruction_count = instructions.count
        else
          next if line == ''

          key, nodes = line.split(' = ')
          next_nodes << key if key.chars[2] == 'A'
          left, right = nodes.gsub('(', '').gsub(')', '').split(', ')
          map[key] = { left:, right: }
        end
      end

      steps = []
      next_nodes.each do |next_node|
        step = 0
        while next_node.chars[2] != 'Z'
          next_node =
            if instructions[step % instruction_count] == 'L'
              map[next_node][:left]
            else
              map[next_node][:right]
            end
          step += 1
        end
        steps << step
      end
      steps.reduce(1, :lcm)
    end
  end
end
