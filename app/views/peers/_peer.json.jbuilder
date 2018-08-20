json.extract! peer, :id, :name, :own_ip, :own_port, :dst_ip, :dst_port, :protocol, :created_at, :updated_at
json.url peer_url(peer, format: :json)
