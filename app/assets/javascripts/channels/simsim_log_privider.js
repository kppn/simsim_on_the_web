
function start_subscription(client_id) {
  return App.cable.subscriptions.create({channel: "SimsimLogProviderChannel", client_id: client_id}, {
      connected: function() {
        // Called when the subscription is ready for use on the server
      },
    
      disconnected: function() {
        // Called when the subscription has been terminated by the server
      },
    
      received: function(data) {
          // Called when there's incoming data on the websocket for this channel
          console.log(data.message);
          console.log(data.event_socket);
  
          if (data['event_socket']) {
              let ip_port = data['event_socket']['ip_port']
              $('#command_event_socket').html(ip_port);
          }
  
          var area = $('#execute_output_area');
          area.append(data['message'] + "\n");
          var bottom = area.prop('scrollHeight') - area.height();
          area.scrollTop(bottom);
      },
    
      send_log: function() {
        // return this.perform('send_log');
      }
    });
}

//App.simsim_log_provider = start_subscription();
