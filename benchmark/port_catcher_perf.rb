# coding: utf-8

require 'benchmark'

$:.unshift File.expand_path('../../lib', __FILE__)
require 'port_catcher'

TRY_COUNT = 100000
@pc = PortCatcher.new(1024..65535)

puts "--"
puts "特別な条件がないとき"
Benchmark.bmbm do |x|
  x.report("PortCatcher.grab") { TRY_COUNT.times { PortCatcher.grab } }
  x.report("PortCatcher#grab") { TRY_COUNT.times { @pc.grab } }
end

module TestCondition
  def self.occupy_ports(range)
    @sockets ||= []
    free_ports unless @sockets.empty?
    @sockets = range.map { |port| occupy_port(port) }.compact
  end

  def self.free_ports
    @sockets.each { |socket| socket.close }
  end

private
  def self.occupy_port(port)
    begin
      socket = TCPServer.new('0.0.0.0', port)
      socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, true)
      Socket.do_not_reverse_lookup = true
      port = socket.addr[1]
      return socket
    rescue Errno::EADDRINUSE
      return nil
    end
  end
end

puts "--"
puts "事前に50000〜60000portを使用中のとき"
if `ulimit -n`.to_i < 10010
  puts "You need `ulimit -n` > 10000+ before this benchmark"
  puts "now, ulimit -n: #{`ulimit -n`}"
  puts "command ulimit -n 10020"
  exit
end
TestCondition.occupy_ports(50000..60000)
Benchmark.bmbm do |x|
  x.report("PortCatcher.grab") { TRY_COUNT.times { PortCatcher.grab } }
  x.report("PortCatcher#grab") { TRY_COUNT.times { @pc.grab } }
end
TestCondition.free_ports
