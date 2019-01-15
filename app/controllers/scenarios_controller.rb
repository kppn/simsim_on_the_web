class ScenariosController < ApplicationController
  before_action :set_scenario, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /scenarios
  # GET /scenarios.json
  def index
    @scenarios = Scenario.where(user_id: current_user.id)
    respond_to do |format|
      format.html {render partial: 'list', collection: @scenarios }
      format.json { render :json => @scenarios.to_json(:include => [:peers]) }
    end
  end

  # GET /scenarios/1
  # GET /scenarios/1.json
  def show
    @scenario = Scenario.find params[:id]
    respond_to do |format|
      format.html
      format.json {render :json => @scenario.to_json(:include => [:extra]) }
    end
  end

  # GET /scenarios/new
  def new
    @scenario = Scenario.new
  end

  # GET /scenarios/1/edit
  def edit
  end

  # POST /scenarios
  # POST /scenarios.json
  def create
    @scenario = Scenario.new(scenario_params)
    @scenario.content = <<~EOL
      state :initial do
        in_action {
        }
      end

      define do
      end
    EOL
    @scenario.user_id = current_user.id

    respond_to do |format|
      if @scenario.save
        format.html { redirect_to @scenario, notice: 'Scenario was successfully created.' }
        format.json { render :show, status: :created, location: @scenario }
      else
        format.html { render :new }
        format.json { render json: @scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scenarios/1
  # PATCH/PUT /scenarios/1.json
  def update
    respond_to do |format|
      if @scenario.update(scenario_params)
        format.html { redirect_to @scenario, notice: 'Scenario was successfully updated.' }
        format.json { render :show, status: :ok, location: @scenario }
      else
        format.html { render :edit }
        format.json { render json: @scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scenarios/1
  # DELETE /scenarios/1.json
  def destroy
    @scenario.destroy
    respond_to do |format|
      format.html { head :no_content}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scenario
      @scenario = Scenario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scenario_params
      params.require(:scenario).permit(:name, :content, :user_id)
    end
end
