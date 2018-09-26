class SimsimLogReceiverChannel < ApplicationCable::Channel
  def subscribed
		stream_from 'receiver'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_log(data)
		frame = { message: data['message'] }

		if /event socket: (?<ip_port>[0-9.:]+)/ =~ data['message'] 
		  frame[:event_socket] = { ip_port: ip_port }
		end

	  ActionCable.server.broadcast(
      "provider_#{data['client_id']}",
			frame
    )
  end
end

