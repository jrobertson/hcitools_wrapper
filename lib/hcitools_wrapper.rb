#!/usr/bin/env ruby

# file: hcitools_wrapper.rb

require 'run_every'


module HcitoolsWrapper

  class Scan

    # options interval and duration are in seconds
    #
    def self.start(runinterval: 10, scanduration: 2)

      interval, duration = runinterval, scanduration
      RunEvery.new(seconds: interval) do
        pid = spawn("sudo hcitool lescan", :err=>"log")
        sleep duration
        `sudo hciconfig hci0 reset `
      end

    end
    
    at_exit do      
      `sudo hciconfig hci0 reset `
    end        

  end

  class Detect

    def initialize(bd_address: '', interval: 0, verbose: false)

      @bd_address = bd_address      
      @interval = interval
      @verbose = verbose

    end

    def start()

      id = @bd_address.split(':').reverse.join(' ')
      found = false
      a = []

      t3 = Time.now + @interval

      IO.popen('sudo hcidump --raw').each_line do |x| 
        
        found = if found then

          rssi = (x.split.last.hex - 256)
          a << rssi.to_i unless a.include? rssi.to_i
          h = {bdaddress: @bd_address, rssi: rssi.inspect}

          if t3 < Time.now then

            avg = a.max + (a.min - a.max) / 2

            if @verbose then
              puts Time.now.inspect + ':  ' + h.inspect
              puts "max: %s, min: %s, average: %s, a: %s" % \
                                      [a.max, a.min, avg, a.sort.inspect]

            end

            # the RSSI will vary by up to 10 when the device is stationary
            if a.length > 10 or rssi > (a.max + 10) or rssi < (a.min - 10) then

              puts 'changed!' if @verbose
              
              if block_given? then
                yield a, avg
              end

              a = []
            end

            t3 = Time.now + @interval
          end

          false

        else
          x.include?(id)
        end

      end

    end
  end

end

if __FILE__ == $0 then

  hw = HcitoolsWrapper::Scan.start
  #hw = HcitoolsWrapper::Detect.new bd_address: 'FF:FF:00:00:FD:1D', verbose: true 
  #hw.start
end