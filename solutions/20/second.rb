# frozen_string_literal: true

module Day20
  module Part2
    def self.run(path, _)
      operations = {
        'broadcaster' => lambda do |map, node, pulse, _|
                           pulses = []
                           map[node][:dests].each do |dest|
                             # puts "#{node} -> #{pulse} -> #{dest}"
                             pulses << [pulse, node]
                             map[dest][:queue] << [pulse, node] unless map[dest].nil?
                           end
                           pulses
                         end,
        '%' => lambda do |map, node, pulse, _|
                 return [] if pulse

                 map[node][:state][node] = !map[node][:state][node]
                 pulses = []
                 map[node][:dests].each do |dest|
                   # puts "#{node} -> #{map[node][:state][node]} -> #{dest}"
                   pulses << [map[node][:state][node], node]
                   map[dest][:queue] << [map[node][:state][node], node] unless map[dest].nil?
                 end
                 pulses
               end,
        '&' => lambda do |map, node, pulse, from|
                 map[node][:state][from] = pulse
                 to_send = true
                 to_send = false if map[node][:state].values.uniq.count == 1 && map[node][:state].values.uniq.first
                 pulses = []
                 map[node][:dests].each do |dest|
                   # puts "#{node} -> #{to_send} -> #{dest}"
                   pulses << [to_send, node]
                   map[dest][:queue] << [to_send, node] unless map[dest].nil?
                 end
                 pulses
               end
      }
      map = {}
      reverse_map = {}
      FileReader.for_each_line(path) do |line|
        node, dests = line.split(' -> ')

        type, key =
          if node == 'broadcaster'
            %w[broadcaster broadcaster]
          else
            [node.chars[0], node.chars[1..].join]
          end
        dests = dests.split(', ')

        state = {}
        state = { key => false } if type == '%'

        dests.each do |dest|
          map[dest] = nil if map[dest].nil?
          if reverse_map[dest].nil?
            reverse_map[dest] = [key]
          else
            reverse_map[dest] << key
          end
        end

        map[key] = { dests:, type:, state:, queue: [] }
      end
      map['broadcaster'][:queue] << false

      map.each do |key, node|
        next if node.nil?
        next if reverse_map[key].nil?
        next unless node[:type] == '&'

        reverse_map[key].each do |n|
          node[:state][n] = false
        end
      end

      pulses = []
      nums = {}
      count = 0
      4060.times do |i|
        pulses << [false, 'button']
        loop = true
        while loop
          map.each do |key, node|
            next if node.nil?

            type = node[:type]
            pulse, from = node[:queue].shift
            next if pulse.nil?

            pulses += operations[type].call(map, key, pulse, from)
          end
          loop = !map.values.map { |x| x.nil? ? 0 : x[:queue].count }.sum.zero?
        end
        map['broadcaster'][:queue] << false
        count += 1
        tally = pulses.tally
        nums['gp'] = count if !tally[[true, 'gp']].nil? && nums['gp'].nil?
        nums['xp'] = count if !tally[[true, 'xp']].nil? && nums['xp'].nil?
        nums['ln'] = count if !tally[[true, 'ln']].nil? && nums['ln'].nil?
        nums['xl'] = count if !tally[[true, 'xl']].nil? && nums['xl'].nil?
        puts i
      end
      nums.values.reduce(:lcm)
    end
  end
end
