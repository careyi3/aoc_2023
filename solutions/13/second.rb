# frozen_string_literal: true

module Day13
  module Part2
    def self.run(path, _)
      ys = []
      xs = []
      y_idx = 0
      data = []
      id = 0
      tops = []
      lefts = []
      FileReader.for_each_line(path) do |line|
        if line == ''
          data[id] = {}

          xss = Marshal.load(Marshal.dump(xs))
          yss = Marshal.load(Marshal.dump(ys))

          xss = xss.map(&:join)
          yss = yss.map(&:join)

          counts = {}
          yss.each_with_index do |y, idy|
            next unless idy + 1 < yss.count && y == yss[idy + 1]

            left = yss[0..idy].reverse
            right = yss[(idy + 1)..(yss.count - 1)]
            small, big = [left, right].sort_by(&:count)

            mirror = true
            small.each_with_index do |s, i|
              next if s == big[i]

              mirror = false
              break
            end
            counts[small.count] = (idy + 1) if mirror
          end
          original_top = counts[counts.keys.max] || 0

          counts = {}
          xss.each_with_index do |x, idx|
            next unless idx + 1 < xss.count && x == xss[idx + 1]

            left = xss[0..idx].reverse
            right = xss[(idx + 1)..(xss.count - 1)]
            small, big = [left, right].sort_by(&:count)

            mirror = true
            small.each_with_index do |s, i|
              next if s == big[i]

              mirror = false
              break
            end
            counts[small.count] = (idx + 1) if mirror
          end
          original_left = counts[counts.keys.max] || 0

          inner_lefts = []
          inner_tops = []
          (0..ys.count - 1).each do |jj|
            (0..xs.count - 1).each do |ii|
              xss = Marshal.load(Marshal.dump(xs))
              yss = Marshal.load(Marshal.dump(ys))

              xss[ii][jj] = xss[ii][jj] == '1' ? '0' : '1'
              yss[jj][ii] = yss[jj][ii] == '1' ? '0' : '1'

              xss = xss.map(&:join)
              yss = yss.map(&:join)

              counts = {}
              yss.each_with_index do |y, idy|
                next unless idy + 1 < yss.count && y == yss[idy + 1]

                left = yss[0..idy].reverse
                right = yss[(idy + 1)..(yss.count - 1)]
                small, big = [left, right].sort_by(&:count)

                mirror = true
                small.each_with_index do |s, i|
                  next if s == big[i]

                  mirror = false
                  break
                end
                counts[small.count] = (idy + 1) if mirror && (idy + 1) != original_top
              end
              top = counts[counts.keys.max] || 0

              counts = {}
              xss.each_with_index do |x, idx|
                next unless idx + 1 < xss.count && x == xss[idx + 1]

                left = xss[0..idx].reverse
                right = xss[(idx + 1)..(xss.count - 1)]
                small, big = [left, right].sort_by(&:count)

                mirror = true
                small.each_with_index do |s, i|
                  next if s == big[i]

                  mirror = false
                  break
                end
                counts[small.count] = (idx + 1) if mirror && (idx + 1) != original_left
              end
              left = counts[counts.keys.max] || 0

              inner_lefts << left if left != 0 && original_left != left
              inner_tops << top if top != 0 && original_top != top
            end
          end
          left = (inner_lefts.max || 0)
          top = (inner_tops.max || 0)

          lefts << left
          tops << top

          data[id] = { left:, top: }

          id += 1
          y_idx = 0
          ys = []
          xs = []
          next
        end
        x = []
        line.chars.each_with_index do |char, x_idx|
          x << (char == '#' ? '1' : '0')
          xs[x_idx] =
            if xs[x_idx].nil?
              [(char == '#' ? '1' : '0')]
            else
              xs[x_idx] + [(char == '#' ? '1' : '0')]
            end
        end
        ys[y_idx] = x
        y_idx += 1
      end

      lefts.compact.sum + (100 * tops.compact.sum)
    end
  end
end
