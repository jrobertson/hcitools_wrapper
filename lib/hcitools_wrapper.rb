#!/usr/bin/env ruby

# file: hcitools_wrapper.rb


module HcitoolsWrapper

  class Scan

    # options interval and duration are in seconds
    #
    def self.start(runinterval: 8, scanduration: 0.3)
      
      while true do
        
        sleep 1
        
        `sudo hcitool lescan>result.txt &  
sleep #{scanduration}
sudo pkill --signal SIGINT hcitool`
        
        sleep runinterval - 1
        
      end

    end
    
    at_exit do
      
      `sudo hciconfig hci0 reset `
      puts 'bye'      
    end        

  end

  class Detect

    def initialize(bd_address: '', refreshinterval: 60, verbose: false)

      @bd_address = bd_address      
      @refreshinterval = refreshinterval
      @verbose = verbose

    end

    def start()

      id = @bd_address.split(':').reverse.join(' ')
      found, last_found = false, Time.now - 60
      a = []


      IO.popen('sudo hcidump --raw').each_line do |x| 
        
        found = if found then

          rssi = (x.split.last.hex - 256)
          a << rssi unless a.include? rssi
          h = {bdaddress: @bd_address, rssi: rssi}

          avg = a.max + (a.min - a.max) / 2

          if @verbose then
            puts Time.now.inspect + ':  ' + h.inspect
            puts "max: %s, min: %s, average: %s, a: %s" % \
                                    [a.max, a.min, avg, a.sort.inspect]

          end
          
          recent_movement = Time.now - last_found >= @refreshinterval

          # the RSSI will vary by up to 10 when the device is stationary
          if recent_movement or a.length > 10 then

            puts 'movement!' if @verbose
            
            if block_given? then
              yield( a, (rssi == a.min and rssi < -85) ? rssi : avg)
            end

            a = []
          end
        
          last_found = Time.now

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