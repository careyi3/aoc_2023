# frozen_string_literal: true

module Day19
  module Part1
    def self.run(path, _)
      parts = []
      accepted = []
      rejected = []
      workflows = {}
      workflow = true
      FileReader.for_each_line(path) do |line|
        if line == ''
          workflow = false
          next
        end
        if workflow
          key, conditions = line.gsub('}', '').split('{')
          workflows[key] = []
          conditions = conditions.split(',')
          conditions.each do |condition|
            check, dest = condition.split(':')
            workflows[key] <<
              if dest.nil?
                ->(x, m, a, s) { check }
              else
                ->(x, m, a, s) { return dest if eval(check) }
              end
          end
        else
          parts << line.gsub('{', '').gsub('}', '').split(',').map { |x| x.split('=')[1].to_i }
        end
      end

      parts.each do |part|
        next_workflow = 'in'
        while next_workflow != 'A' || next_workflow != 'R'
          accepted << part if next_workflow == 'A'
          rejected << part if next_workflow == 'R'
          break if %w[A R].include?(next_workflow)

          ops = workflows[next_workflow]
          ops.each do |op|
            next_workflow = op.call(*part)
            break unless next_workflow.nil?
          end
        end
      end
      accepted.flatten.sum
    end
  end
end
