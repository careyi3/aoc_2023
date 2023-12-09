# frozen_string_literal: true

require('benchmark')

module Instrument
  def self.time
    ans = nil
    time =
      Benchmark.measure do
        ans = yield
      end
    puts "Answer:  #{ans}"
    puts "Runtime: #{time.real.round(2)}s" if time.real > 1
    puts "Runtime: #{(time.real * 1000).round(2)}ms" if time.real > 0.001 && time.real < 1
    puts "Runtime: #{(time.real * 1_000_000).round(2)}us" if time.real < 0.001
  end
end
