# Using the Hcitools_wrapper gem to scan and return the RSSI value

## Setting up the Bluetooth LE scanner

Run the following:

    require 'hcitools_wrapper'

    hw = HcitoolsWrapper::Scan.start

## Detecting the RSSI value for a given Bluetooth LE device

First of all ensure you have installed *bluez-hcidump*. Then run the following using your own Bluetooth address:

    require 'hcitools_wrapper'

    hw = HcitoolsWrapper::Detect.new bd_address: 'FF:FF:00:00:FD:1D', verbose: true 
    hw.start

Output:

<pre>
015-07-18 18:01:58 +0100:  {:bdaddress=>"FF:FF:00:00:FD:1D", :rssi=>"-61"}
max: -60, min: -80, average: -70, a: [-80, -79, -78, -77, -76, -75, -63, -62, -61, -60]
2015-07-18 18:01:58 +0100:  {:bdaddress=>"FF:FF:00:00:FD:1D", :rssi=>"-63"}
max: -60, min: -80, average: -70, a: [-80, -79, -78, -77, -76, -75, -63, -62, -61, -60]
2015-07-18 18:01:58 +0100:  {:bdaddress=>"FF:FF:00:00:FD:1D", :rssi=>"-63"}
max: -60, min: -80, average: -70, a: [-80, -79, -78, -77, -76, -75, -63, -62, -61, -60]
2015-07-18 18:01:58 +0100:  {:bdaddress=>"FF:FF:00:00:FD:1D", :rssi=>"-64"}
max: -60, min: -80, average: -70, a: [-80, -79, -78, -77, -76, -75, -64, -63, -62, -61, -60]
changed!
2015-07-18 18:01:58 +0100:  {:bdaddress=>"FF:FF:00:00:FD:1D", :rssi=>"-61"}
max: -61, min: -61, average: -61, a: [-61]
2015-07-18 18:01:58 +0100:  {:bdaddress=>"FF:FF:00:00:FD:1D", :rssi=>"-61"}
max: -61, min: -61, average: -61, a: [-61]
2015-07-18 18:01:58 +0100:  {:bdaddress=>"FF:FF:00:00:FD:1D", :rssi=>"-61"}
max: -61, min: -61, average: -61, a: [-61]
</pre>

Notes:

* The changed! message will be displayed whenever the array length exceeds 10 or the RSSI value exceeds the max or min known recent RSSI values by 10.
* A block can be used with the start method. The objects passed in are the array containing the most recent RSSI values, and the average RSSI value.

## Resources

* Capturing the RSSI from a Bluetooth LE device http://www.jamesrobertson.eu/snippets/2015/jul/17/capturing-the-rssi-from-a-bluetooth-le-device.html

ble bluetooth lescan hcidump hcitools
