class API::V1::ReportsController < ApplicationController
  before_action :check_survivors

  # GET /reports/infected_survivors
  def infected_survivors
    render json: { data: SurvivorReport.new.infected_survivors }, status: :ok
  end

  # GET /reports/not_infected_survivors
  def not_infected_survivors
    render json: { data: SurvivorReport.new.not_infected_survivors }, status: :ok
  end

  # GET /reports/resources_by_survivor
  def resources_by_survivor
    render json: { data: SurvivorReport.new.average_resources }, status: :ok
  end

  # GET /reports/lost_infected_points
  def lost_infected_points 
    render json: { data: SurvivorReport.new.lost_infected_points }, status: :ok
  end

  private

  def check_survivors
    unless Survivor.exists?
      render json: { message: 'There are no survivors' }, status: :unprocessable_entity
    end
  end
end
