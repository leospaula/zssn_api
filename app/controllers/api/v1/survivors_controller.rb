class API::V1::SurvivorsController < ApplicationController
  before_action :set_survivor, only: :update

   # GET /survivors
  def index
    @survivors = Survivor.all

    render json: { survivors: @survivors }, status: :ok
  end

   # POST /survivors
  def create
    @survivor = Survivor.new(survivor_params)

    if @survivor.save
      render json: { survivor: @survivor }, status: :created
    else
      render json: { message: @survivor.errors }, status: :unprocessable_entity
    end
  end

  def update
    if update_params.present?
        
      if @survivor.update(last_location: update_params)
        head :no_content
      else
        render json: { message: @survivor.errors }, status: :unprocessable_entity
      end
    end
  end

  private

  def set_survivor
    @survivor = Survivor.find(params[:id])
  end

  def survivor_params
    params.require(:survivor).permit(:name, :age, :gender, last_location: {})
  end

  def update_params
    params.require(:survivor).permit(:latitude, :longitude)
  end
end
