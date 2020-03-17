# frozen_string_literal: true

class Perf
  class << self
    def test options = {}, &block
      options = {times: 10}.merge(options)
      start_time = Time.now
      rv = nil
      options[:times].times do
        rv = yield(block)
      end
      end_time = Time.now
      avg_time = ((end_time - start_time) / options[:times].to_f).round(4)
      puts "Average time per cycle (n = #{options[:times]}): #{avg_time}"
      rv
    end
  end
end
