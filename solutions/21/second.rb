# frozen_string_literal: true

module Day21
  module Part2
    def self.run(path, input)
      map = {}
      start_x = 0
      start_y = 0
      x_max = 0
      y_max = 0
      FileReader.for_each_line_with_index(path) do |line, y|
        line.chars.each_with_index do |char, x|
          if char == 'S'
            start_x = x
            start_y = y
          end
          map["#{x}:#{y}"] = char
          x_max = x
        end
        y_max = y
      end

      cache = {}
      step_depths = {}
      depth = 350
      step(map, x_max, y_max, start_x, start_y, 1, step_depths, depth, cache, input)
      (1..depth).each do |i|
        puts "#{i} - #{step_depths[i].uniq.count}"
      end

      one = step_depths[65].uniq.count # 65  - 3744
      two = step_depths[196].uniq.count # 196 - 33417
      three = step_depths[327].uniq.count # 327 - 92680

      a = (three - (2 * two) + one) / 2
      b = two - one - a
      c = one
      n = (26_501_365 - 65) / 131

      (a * (n**2)) + (b * n) + c
    end

    def self.step(map, x_max, y_max, x, y, count, step_depths, depth_stop, cache, input)
      cache_key = "#{x}:#{y}:#{count}"
      return if cache[cache_key]

      steps = []
      [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].each_with_index do |(x, y), id|
        step_coord = [x, y]
        key_x = mod_translate(x, x_max, input)
        key_y = mod_translate(y, y_max, input)
        key = [key_x, key_y].join(':')
        step_valid = map[key] == '.' || map[key] == 'S'
        steps[id] = [step_valid, step_coord]
        if step_valid
          if step_depths[count].nil?
            step_depths[count] = [step_coord.join(':')]
          else
            step_depths[count] << step_coord.join(':')
          end
        end
      end

      cache[cache_key] = 1
      return if count == depth_stop

      step(map, x_max, y_max, steps[0][1][0], steps[0][1][1], count + 1, step_depths, depth_stop, cache, input) if steps[0][0]
      step(map, x_max, y_max, steps[1][1][0], steps[1][1][1], count + 1, step_depths, depth_stop, cache, input) if steps[1][0]
      step(map, x_max, y_max, steps[2][1][0], steps[2][1][1], count + 1, step_depths, depth_stop, cache, input) if steps[2][0]
      step(map, x_max, y_max, steps[3][1][0], steps[3][1][1], count + 1, step_depths, depth_stop, cache, input) if steps[3][0]
    end

    def self.mod_translate(val, val_max, input)
      range_max = input == 'sample' ? 10 : 130
      positive_order = (0..range_max).to_a
      negative_order = [0] + range_max.downto(1).map { |x| x }

      id = val.abs % (val_max + 1)

      if val.positive? || val.zero?
        positive_order[id]
      else
        negative_order[id]
      end
    end
  end
end
