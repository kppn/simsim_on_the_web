#!/usr/bin/env ruby

require 'websocket-client-simple'
require 'json'
require 'open3'


def to_ac_subscribe(ch, id)
  {
    command: 'subscribe',
    identifier: {
      channel: ch,
    }.to_json
  }.to_json
end


def to_ac_message(ch, client_id, message)
  JSON.dump(
    {
      command: 'message',
      data: JSON.dump({
        message: message,
        action: 'send_log',
		    client_id: client_id
      }),
      identifier: JSON.dump({
        channel: ch
      }),
    }
  )
end


def setup_websocket(host, port, ch, id)
  url = "ws://#{host}:#{port.to_s}/cable"

  WebSocket::Client::Simple.connect(url).tap do |ws|
    ws.on :message do |msg|
      puts msg.data
    end
  
    ws.on :open do
      ws.send(to_ac_subscribe(ch, id))
    end
  
    ws.on :close do |e|
      exit 1
    end
  end
end


#============================================
if ARGV.length < 3
  puts 'too few arguments'
  exit 1
end

ch = 'SimsimLogReceiverChannel'

id                 = ARGV[0].to_i
config_file_path   = ARGV[1]
scenario_file_path = ARGV[2]


ws = setup_websocket('172.16.1.2', 50000, ch, id)

sleep 1

cmd = "/usr/bin/env ruby lib/simsim/simsim #{config_file_path} #{scenario_file_path}"
Open3.popen3(cmd) do |stdin, stdout, stderr, thr|
  stdout.sync = true
  loop do
    #msg = stdout.gets
    message = stdout.gets
		unless message
		  p 'exit with stdout nil'
			p stderr.gets
			exit 1
		end
    #message = gets.chomp
    if message
      ws.send(to_ac_message(ch, id, message.chomp))
    end
  end
end


