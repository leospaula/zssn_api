require 'rails_helper'

RSpec.describe API::V1::TradesController, type: :controller do
   describe "Trade the resources between two survivors" do
    it 'should raise error when a survivor does not exist' do 
      water = attributes_for(:resource, :water, quantity: 6)
      medication_1 = attributes_for(:resource, :medication, quantity: 3)
      medication_2 = attributes_for(:resource, :medication, quantity: 7)
      ammo = attributes_for(:resource, :ammunition, quantity: 10)

      survivor_1 = create(
        :survivor_1,
        resources_attributes: [water, medication_1]
      )

      survivor_2 = create(
        :survivor_2,
        resources_attributes: [medication_2, ammo]
      )

      resources_to_trade_survivor_1 = [
        {name: 'water', quantity: 1}, 
        {name: 'medication', quantity: 1}
      ]
      resources_to_trade_survivor_2 = [
        {name: 'ammunition', quantity: 6}
      ]

      trade_params = {
        trade: {
          survivor_1: {
            id: survivor_1.id,
            resources: resources_to_trade_survivor_1
          },
          survivor_2: {
            id: survivor_2.id,
            resources: resources_to_trade_survivor_2
          }
        }
      }

      trade_params[:trade][:survivor_1][:id] = '999'

      post :trade_resources, params: trade_params

      expect(response).to have_http_status(:not_found)
      expect(json_response['message']).to eq('Survivor with id 999 does not exist')
    end

    it 'should not allow trade when a survivor is infected' do
      water = attributes_for(:resource, :water, quantity: 6)
      medication_1 = attributes_for(:resource, :medication, quantity: 3)
      medication_2 = attributes_for(:resource, :medication, quantity: 7)
      ammo = attributes_for(:resource, :ammunition, quantity: 10)

      survivor_1 = create(
        :survivor_1,
        resources_attributes: [water, medication_1]
      )

      survivor_2 = create(
        :survivor_2,
        resources_attributes: [medication_2, ammo]
      )

      resources_to_trade_survivor_1 = [
        {name: 'water', quantity: 1}, 
        {name: 'medication', quantity: 1}
      ]
      resources_to_trade_survivor_2 = [
        {name: 'ammunition', quantity: 6}
      ]

      trade_params = {
        trade: {
          survivor_1: {
            id: survivor_1.id,
            resources: resources_to_trade_survivor_1
          },
          survivor_2: {
            id: survivor_2.id,
            resources: resources_to_trade_survivor_2
          }
        }
      }

      survivor_2.update_attribute(:infection_count, 3)

      post :trade_resources, params: trade_params

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['message']).to eq('Negan is infected')
    end

     it 'should not allow trade when a survivor has not enough resources' do
      water = attributes_for(:resource, :water, quantity: 6)
      medication_1 = attributes_for(:resource, :medication, quantity: 3)
      medication_2 = attributes_for(:resource, :medication, quantity: 7)
      ammo = attributes_for(:resource, :ammunition, quantity: 10)

      survivor_1 = create(
        :survivor_1,
        resources_attributes: [water, medication_1]
      )

      survivor_2 = create(
        :survivor_2,
        resources_attributes: [medication_2, ammo]
      )

      resources_to_trade_survivor_1 = [
        {name: 'water', quantity: 1}, 
        {name: 'medication', quantity: 1}
      ]
      resources_to_trade_survivor_2 = [
        {name: 'ammunition', quantity: 6}
      ]

      trade_params = {
        trade: {
          survivor_1: {
            id: survivor_1.id,
            resources: resources_to_trade_survivor_1
          },
          survivor_2: {
            id: survivor_2.id,
            resources: resources_to_trade_survivor_2
          }
        }
      }

      survivor_2.resources.find_by(name: 'ammunition').update(quantity: 3)

      post :trade_resources, params: trade_params, as: :json

      expect(response).to have_http_status(:conflict)
      expect(json_response['message']).to eq("#{survivor_2.name} doesn't have enough resources")

      survivor_1.reload

      expect(survivor_1.resources.find_by(name: 'water').quantity).to eq 6
      expect(survivor_1.resources.find_by(name: 'medication').quantity).to eq 3
    end

    it 'should not allow trade when resources are not balanced' do
      water = attributes_for(:resource, :water, quantity: 6)
      medication_1 = attributes_for(:resource, :medication, quantity: 3)
      medication_2 = attributes_for(:resource, :medication, quantity: 7)
      ammo = attributes_for(:resource, :ammunition, quantity: 10)

      survivor_1 = create(
        :survivor_1,
        resources_attributes: [water, medication_1]
      )

      survivor_2 = create(
        :survivor_2,
        resources_attributes: [medication_2, ammo]
      )

      resources_to_trade_survivor_1 = [
        {name: 'water', quantity: 1}, 
        {name: 'medication', quantity: 1}
      ]
      resources_to_trade_survivor_2 = [
        {name: 'ammunition', quantity: 6}
      ]

      trade_params = {
        trade: {
          survivor_1: {
            id: survivor_1.id,
            resources: resources_to_trade_survivor_1
          },
          survivor_2: {
            id: survivor_2.id,
            resources: resources_to_trade_survivor_2
          }
        }
      }

      trade_params[:trade][:survivor_1][:resources][0][:quantity] = 6

      post :trade_resources, params: trade_params, as: :json

      expect(response).to have_http_status(:conflict)
      expect(json_response['message']).to eq('Resources points is not balanced both sides')

      survivor_1.reload

      expect(survivor_1.resources.find_by(name: 'water').quantity).to eq 6
      expect(survivor_1.resources.find_by(name: 'medication').quantity).to eq 3
    end

     it 'should successfully trade resources between two survivors' do
      water = attributes_for(:resource, :water, quantity: 6)
      medication_1 = attributes_for(:resource, :medication, quantity: 3)
      medication_2 = attributes_for(:resource, :medication, quantity: 7)
      ammo = attributes_for(:resource, :ammunition, quantity: 10)

      survivor_1 = create(
        :survivor_1,
        resources_attributes: [water, medication_1]
      )

      survivor_2 = create(
        :survivor_2,
        resources_attributes: [medication_2, ammo]
      )

      resources_to_trade_survivor_1 = [
        {name: 'water', quantity: 1}, 
        {name: 'medication', quantity: 1}
      ]
      resources_to_trade_survivor_2 = [
        {name: 'ammunition', quantity: 6}
      ]

      trade_params = {
        trade: {
          survivor_1: {
            id: survivor_1.id,
            resources: resources_to_trade_survivor_1
          },
          survivor_2: {
            id: survivor_2.id,
            resources: resources_to_trade_survivor_2
          }
        }
      }

      post :trade_resources, params: trade_params, as: :json

      expect(response).to have_http_status(:ok)

      expect(json_response['message']).to eq('Trade successfully completed')

      survivor_1.reload
      survivor_2.reload

      expect(survivor_1.resources.find_by(name: 'water').quantity).to eq 5
      expect(survivor_1.resources.find_by(name: 'medication').quantity).to eq 2

      expect(survivor_2.resources.find_by(name: 'ammunition').quantity).to eq 4
    end
  end

end
