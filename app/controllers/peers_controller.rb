class PeersController < ApplicationController
  before_action :set_peer, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /peers
  # GET /peers.json
  def index
    @peers = Peer.all
  end

  # GET /peers/1
  # GET /peers/1.json
  def show
  end

  # GET /peers/new
  def new
    @peer = Peer.new
  end

  # GET /peers/1/edit
  def edit
  end

  # POST /peers
  # POST /peers.json
  def create
    @peer = Peer.new(peer_params)

    respond_to do |format|
      if @peer.save
        format.html { redirect_to @peer, notice: 'Peer was successfully created.' }
        format.json { render :show, status: :created, location: @peer }
      else
        format.html { render :new }
        format.json { render json: @peer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /peers/1
  # PATCH/PUT /peers/1.json
  def update
    respond_to do |format|
      if @peer.update(peer_params)
        format.html { redirect_to @peer, notice: 'Peer was successfully updated.' }
        format.json { render :show, status: :ok, location: @peer }
      else
        format.html { render :edit }
        format.json { render json: @peer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /peers/1
  # DELETE /peers/1.json
  def destroy
    @peer.destroy
    respond_to do |format|
      format.html { redirect_to peers_url, notice: 'Peer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_peer
      @peer = Peer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def peer_params
      params.require(:peer).permit(:name, :own_ip, :own_port, :dst_ip, :dst_port, :protocol, :config_id)
    end
end
