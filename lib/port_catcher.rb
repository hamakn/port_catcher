require 'socket'
require "port_catcher/version"

class PortCatcher
  def self.grab(port = 0)
    # almost copy from https://github.com/cloudfoundry/vcap-common/blob/master/lib/vcap/common.rb
    socket = TCPServer.new('0.0.0.0', port)
    socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, true)
    Socket.do_not_reverse_lookup = true
    port = socket.addr[1]
    socket.close
    port
  end

  def self.port_occupied?(port)
    self.grab(port)
    false
  rescue Errno::EADDRINUSE
    true
  end

  attr_reader :port_range

  def initialize(port_range = 1024..65535)
    @port_range = Range.new([port_range.first, 0].max, [port_range.last, 65535].min)
    @port = rand(@port_range.count) + @port_range.first
  end

  def grab
    # Try to grab port number sequentially.
    # If already port is last, from the first.
    ranges = if @port != @port_range.last
               # example:
               #   if port_range = 50000..60000
               #      @port      = 55000 then
               #   ranges #=> [55001..60000, 50000..54999]
               [Range.new(@port + 1, @port_range.last),
                 Range.new(@port_range.first, @port, true)]
             else
               [@port_range]
             end
    ranges.each do |range|
      range.each do |port|
        begin
          return (@port = self.class.grab(port))
        rescue Errno::EADDRINUSE
        end
      end
    end
    nil
  end
end
