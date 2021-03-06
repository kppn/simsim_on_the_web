class ConfigsController < ApplicationController
  before_action :set_config, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /configs
  # GET /configs.json
  def index
    @configs = Config.where(user_id: current_user.id)
    respond_to do |format|
      format.html {render partial: 'list', collection: @configs }
      format.json { render :json => @configs.to_json(:include => [:peers]) }
    end
  end

  # GET /configs/1
  # GET /configs/1.json
  def show
    @config = Config.find params['id']
    respond_to do |format|
      format.html
      format.json { render :json => @config.to_json(:include => [:peers]) }
    end
  end

  # GET /configs/new
  def new
    @config = Config.new
  end

  # GET /configs/1/edit
  def edit
  end

  # POST /configs
  # POST /configs.json
  def create
    @config = Config.new(config_params)
    @config.user_id = current_user.id

    respond_to do |format|
      if @config.save
        format.html { head :no_content}
        format.json { render :show, status: :created, location: @config }
      else
        format.html { render :new }
        format.json { render json: @config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /configs/1
  # PATCH/PUT /configs/1.json
  def update
    respond_to do |format|
      if @config.update(config_params)
        format.html { redirect_to @config, notice: 'Config was successfully updated.' }
        format.json { render :show, status: :ok, location: @config }
      else
        format.html { render :edit }
        format.json { render json: @config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /configs/1
  # DELETE /configs/1.json
  def destroy
    @config.destroy
    respond_to do |format|
      format.html { head :no_content}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_config
      @config = Config.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def config_params
      params.require(:config).permit(
        :name,
        :log_title,
        peers_attributes: [
          :name,
          :own_ip,
          :own_port,
          :dst_ip,
          :dst_port,
          :protocol
        ]
      )
    end
end
