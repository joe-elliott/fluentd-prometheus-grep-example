require 'fluent/filter'

module Fluent
  class PassThruFilter < Filter

    Fluent::Plugin.register_filter('substringcounter', self)

    @key
    @substrings

    def configure(conf)
      super

      @key = conf.key?('key') ? conf['key'] : 'log';

      @substrings = conf['substrings'].split(',')

    end

    def start
      super
    end

    def shutdown
      super
    end

    def filter(tag, time, record)
      tBefore = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      @substrings.each do |search|
        record[search] = record[@key].downcase().include?(search) ? 1 : 0;
      end

      tAfter = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      record["processing_time"] = ((tAfter - tBefore) * 1000)

      record
    end
  end
end
