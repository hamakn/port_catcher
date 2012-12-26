# coding: utf-8
#require File.join(File.dirname(__FILE__), 'spec_helper')

require 'socket'
require 'port_catcher'

describe PortCatcher do
  describe '.port_occupied?' do
    before do
      @port_catcher = PortCatcher.new
      @lock_port = @port_catcher.grab
      @socket = TCPServer.new('0.0.0.0', @lock_port)
    end
    after do
      @socket.close
    end

    it do
      PortCatcher.port_occupied?(@lock_port).should be_true
      PortCatcher.port_occupied?(@port_catcher.grab).should be_false
    end
  end

  describe '#grab' do
    let(:port_range) { 65500..65535 }

    context "port_rangeを使うとき" do
      subject { PortCatcher.new(port_range) }
      its(:grab) { should be_between(port_range.first, port_range.last) }
    end

    context "port_range.firstのポート番号が使われているとき" do
      before do
        @port_catcher = PortCatcher.new(port_range)
        @socket = TCPServer.new('0.0.0.0', @port_catcher.instance_variable_get(:@port))
      end
      after do
        @socket.close
      end

      it "使われているport番号が返ってこないこと" do
        port = @port_catcher.grab
        port.should be_between(port_range.first, port_range.last)
        port.should_not eq port_range.first
      end
    end

    context "すべてのport番号が使われているとき" do
      before do
        TCPServer.stub(:new).and_raise Errno::EADDRINUSE
      end

      subject { PortCatcher.new(port_range) }

      its(:grab) { should be_nil }
    end
  end
end
