class API::V1::SurvivorsController < ApplicationController
  before_action :set_survivor, only: [:update, :flag_infection]

  # GET /survivors
  def index
    @survivors = Survivor.all

    render json: { survivors: @survivors.as_json(include: {resources: {only: [:name, :quantity]}}) }, status: :ok
  end

  # POST /survivors
  def create
    if resources_params.has_key?(:resources)
      @survivor = Survivor.new(survivor_params.merge(resources_attributes: resources_params[:resources]))

      if @survivor.save
        render json: { survivor: @survivor.as_json(include: {resources: {only: [:name, :quantity]}}) }, status: :created
      else
        render json: { message: @survivor.errors }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Survivor needs to declare resources' }, status: :conflict
    end
  end

  # PATCH/PUT /survivors/:id
  def update
    if update_params.present?
      if @survivor.update(last_location: update_params)
        head :no_content
      else
        render json: { message: @survivor.errors }, status: :unprocessable_entity
      end
    end
  end

  # POST /survivors/:id/flag_infection
  def flag_infection
    @survivor.increment!(:infection_count, 1)

    render json: { message: "Survivor was reported as infected #{@survivor.infection_count} time(s)!" }, status: :ok
  end


  private

  def set_survivor
    begin
      @survivor = Survivor.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      head :not_found
    end
  end

  def survivor_params
    params.require(:survivor).permit(:name, :age, :gender, last_location: {})
  end

  def update_params
    params.require(:survivor).permit(:latitude, :longitude)
  end

  def resources_params
    params.require(:survivor).permit(resources: [:name, :quantity])
  end
end
