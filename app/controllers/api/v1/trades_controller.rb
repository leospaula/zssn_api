class API::V1::TradesController < ApplicationController

  # POST /trade_resources
  def trade_resources
    trade = TradeResources.new(trade_params).execute

    render json: { message: trade.message }, status: trade.status
  end

  private
    def trade_params
      params.require(:trade).permit(survivor_1: [:id, resources: [[:name, :quantity]]],
                                    survivor_2: [:id, resources: [[:name, :quantity]]])
    end
end
