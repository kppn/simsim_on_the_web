require 'test_helper'

class PeersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @peer = peers(:one)
  end

  test "should get index" do
    get peers_url
    assert_response :success
  end

  test "should get new" do
    get new_peer_url
    assert_response :success
  end

  test "should create peer" do
    assert_difference('Peer.count') do
      post peers_url, params: { peer: { dst_ip: @peer.dst_ip, dst_port: @peer.dst_port, name: @peer.name, own_ip: @peer.own_ip, own_port: @peer.own_port, protocol: @peer.protocol } }
    end

    assert_redirected_to peer_url(Peer.last)
  end

  test "should show peer" do
    get peer_url(@peer)
    assert_response :success
  end

  test "should get edit" do
    get edit_peer_url(@peer)
    assert_response :success
  end

  test "should update peer" do
    patch peer_url(@peer), params: { peer: { dst_ip: @peer.dst_ip, dst_port: @peer.dst_port, name: @peer.name, own_ip: @peer.own_ip, own_port: @peer.own_port, protocol: @peer.protocol } }
    assert_redirected_to peer_url(@peer)
  end

  test "should destroy peer" do
    assert_difference('Peer.count', -1) do
      delete peer_url(@peer)
    end

    assert_redirected_to peers_url
  end
end
