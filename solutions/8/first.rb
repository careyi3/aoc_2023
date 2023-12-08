# frozen_string_literal: true

module Day8
  module Part1
    def self.run(path, _)
      instructions = []
      instruction_count = 0
      map = {}
      FileReader.for_each_line_with_index(path) do |line, idx|
        if idx.zero?
          instructions = line.chars
          instruction_count = instructions.count
        else
          next if line == ''

          key, nodes = line.split(' = ')
          left, right = nodes.gsub('(', '').gsub(')', '').split(', ')
          map[key] = { left:, right: }
        end
      end

      next_node = 'AAA'
      step = 0
      while next_node != 'ZZZ'
        next_node =
          if instructions[step % instruction_count] == 'L'
            map[next_node][:left]
          else
            map[next_node][:right]
          end
        step += 1
      end
      puts step
    end
  end
end
