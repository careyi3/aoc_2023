# frozen_string_literal: true

module Day19
  module Part2
    def self.run(path, _)
      workflows = {}
      FileReader.for_each_line(path) do |line|
        break if line == ''

        key, conditions = line.gsub('}', '').split('{')
        workflows[key] = []
        conditions = conditions.split(',')
        conditions.each do |condition|
          check, dest = condition.split(':')
          to_check = check.split(/[\s<>]/)[0]

          workflows[key] <<
            if dest.nil?
              ->(x, m, a, s) { [check, [x, m, a, s], [x, m, a, s]] }
            else
              ->(x, m, a, s) {
                [
                  dest,
                  [
                    to_check == 'x' ? x.select { |x| eval(check) } : x,
                    to_check == 'm' ? m.select { |m| eval(check) } : m,
                    to_check == 'a' ? a.select { |a| eval(check) } : a,
                    to_check == 's' ? s.select { |s| eval(check) } : s
                  ],
                  [
                    to_check == 'x' ? x.reject { |x| eval(check) } : x,
                    to_check == 'm' ? m.reject { |m| eval(check) } : m,
                    to_check == 'a' ? a.reject { |a| eval(check) } : a,
                    to_check == 's' ? s.reject { |s| eval(check) } : s
                  ]
                ]
              }
            end
        end
      end

      state = [Array(1..4000), Array(1..4000), Array(1..4000), Array(1..4000)]
      walk(workflows, 'in', state)
    end

    def self.walk(workflows, next_wf, state)
      return state.map(&:count).inject(:*) if next_wf == 'A'
      return 0 if next_wf == 'R'

      num = 0
      workflows[next_wf].each do |op|
        next_wf, matches, non_matches = op.call(*state)
        num += walk(workflows, next_wf, matches)
        state = non_matches
      end
      num
    end
  end
end
