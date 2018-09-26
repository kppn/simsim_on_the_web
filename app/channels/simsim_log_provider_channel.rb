class SimsimLogProviderChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
		puts "------ #{params}"
		puts params[:client_id]
		stream_from "provider_#{params[:client_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_log(data)
	  ActionCable.server.broadcast(
      "provider_#{data['client_id']}",
      message: data['message']
    )
  end
end
