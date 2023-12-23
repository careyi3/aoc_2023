# frozen_string_literal: true

module Day22
  module Part1
    def self.run(path, _)
      blocks = []
      FileReader.for_each_line_with_index(path) do |line, id|
        blocks << (line.split('~').map { |x| x.split(',').map(&:to_i) } + [id])
      end
      blocks = blocks.sort_by { |x| x[0][2] }
      stack = []
      blocks.each do |(start, finish, id)|
        if stack.empty?
          z_h = start[2]
          start[2] = start[2] - z_h
          finish[2] = finish[2] - z_h
          stack.unshift([start, finish, id, []])
        else
          x_range = (start[0]..finish[0])
          y_range = (start[1]..finish[1])
          match = true
          stack.each_with_index do |(s_start, s_finish, s_id, _), idx|
            z_h = s_finish[2]
            s_x_range = (s_start[0]..s_finish[0])
            s_y_range = (s_start[1]..s_finish[1])
            binding.pry
            if s_x_range.cover?(x_range) || s_y_range.cover?(y_range)
              stack[idx][3] << id
              start[2] = s_finish[2] + 1
              finish[2] = start[2] - finish[2]
              stack.insert(idx, [start, finish, id, []])
              break
            end
            match = false
          end
          next if match

          z_h = start[2]
          start[2] = start[2] - z_h
          finish[2] = finish[2] - z_h
          stack.unshift([start, finish, id, []])
        end
      end

      binding.pry

      0
    end
  end
end
