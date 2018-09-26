#!/usr/bin/env ruby

require 'websocket-client-simple'
require 'json'
require 'open3'


def to_ac_subscribe(ch, id)
  {
    command: 'subscribe',
    identifier: {
      channel: ch, #'SimsimLogChannel',
			#id: id
    }.to_json
  }.to_json
end


def to_ac_message(ch, id, message)
  JSON.dump(
    {
      command: 'message',
      data: JSON.dump({
        message: message,
        action: 'send_log'
      }),
      identifier: JSON.dump({
        channel:'SimsimLogChannel',
				#id: id
      })
    }
  )
end

ws = WebSocket::Client::Simple.connect 'ws://172.16.1.2:50000/cable'
ch = 'SimsimLogProviderChannel'
id = 2

ws.on :message do |msg|
  puts msg.data
end

ws.on :open do
  # channel参加(on :messageでメッセージを受け取れるように)
  ws.send(to_ac_subscribe(ch, id))

  # channel参加完了前にメッセージを送るとエラーとなるのでとりあえず
  sleep 1
end

ws.on :close do |e|
  exit 1
end


#cmd = './si.rb'
#Open3.popen3(cmd) do |stdin, stdout, stderr, thr|
#  loop do
#    #message = stdout.gets.chomp
#    message = stdout.gets.chomp
#    ws.send(to_ac_message(ch, id, message))
#	end
#end

gets

