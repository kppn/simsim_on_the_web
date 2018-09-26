class WorkController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json{ render :json => {client_id: Random.rand(10000000)}.to_json }
    end
   end
end
