# frozen_string_literal: true

module Day21
  module Part1
    def self.run(path, input)
      map = {}
      start_x = 0
      start_y = 0
      FileReader.for_each_line_with_index(path) do |line, y|
        line.chars.each_with_index do |char, x|
          if char == 'S'
            start_x = x
            start_y = y
          end
          map["#{x}:#{y}"] = char
        end
      end

      step_depths = {}
      depth_stop = input == 'sample' ? 6 : 64
      cache = {}
      step(map, start_x, start_y, 1, step_depths, depth_stop, cache)
      step_depths[depth_stop].uniq.count
    end

    def self.step(map, x, y, count, step_depths, depth_stop, cache)
      cache_key = "#{x}:#{y}:#{count}"
      return if cache[cache_key]

      steps = []
      [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].each_with_index do |(x, y), id|
        step_coord = [x, y]
        key = step_coord.join(':')
        step_valid = map[key] == '.' || map[key] == 'S'
        steps[id] = [step_valid, step_coord]
        if step_valid
          if step_depths[count].nil?
            step_depths[count] = [key]
          else
            step_depths[count] << key
          end
        end
      end
      cache[cache_key] = 1

      return if count == depth_stop

      step(map, steps[0][1][0], steps[0][1][1], count + 1, step_depths, depth_stop, cache) if steps[0][0]
      step(map, steps[1][1][0], steps[1][1][1], count + 1, step_depths, depth_stop, cache) if steps[1][0]
      step(map, steps[2][1][0], steps[2][1][1], count + 1, step_depths, depth_stop, cache) if steps[2][0]
      step(map, steps[3][1][0], steps[3][1][1], count + 1, step_depths, depth_stop, cache) if steps[3][0]
    end
  end
end
