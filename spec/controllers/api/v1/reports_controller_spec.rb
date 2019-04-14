require 'rails_helper'

RSpec.describe API::V1::ReportsController, type: :controller do
  describe "GET #infected_survivors" do
    context 'with valid survivors' do
      it "should return the infected survivors percentage" do
        create_list(
          :survivor,  5, 
          :infected, 
          resources_attributes: [
            attributes_for(:resource, :water, quantity: 3),
            attributes_for(:resource, :food,  quantity: 7),
            attributes_for(:resource, :medication, quantity: 1),
            attributes_for(:resource, :ammunition, quantity: 6)
          ]
        )

        create_list(
          :survivor, 15, 
          :not_infected,
          resources_attributes: [
            attributes_for(:resource, :water, quantity: 2),
            attributes_for(:resource, :food,  quantity: 3),
            attributes_for(:resource, :medication, quantity: 8),
            attributes_for(:resource, :ammunition, quantity: 5)
          ]
        )

        get :infected_survivors

        expect(response).to have_http_status(:ok)
        expect(json_response[:data]).to eq '25.0%'
      end
    end

    context 'with invalid survivors' do
      it "should return erro if there is no survivors" do 
        get :infected_survivors

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:message]).to eq 'There are no survivors'
      end
    end
  end

  describe "GET #not_infected_survivors" do
    context 'with valid survivors' do
      it "should return the not infected survivors percentage" do
        create_list(
          :survivor,  10, 
          :infected, 
          resources_attributes: [
            attributes_for(:resource, :water, quantity: 3),
            attributes_for(:resource, :food,  quantity: 7),
            attributes_for(:resource, :medication, quantity: 1),
            attributes_for(:resource, :ammunition, quantity: 6)
          ]
        )

        create_list(
          :survivor, 30, 
          :not_infected,
          resources_attributes: [
            attributes_for(:resource, :water, quantity: 2),
            attributes_for(:resource, :food,  quantity: 3),
            attributes_for(:resource, :medication, quantity: 8),
            attributes_for(:resource, :ammunition, quantity: 5)
          ]
        )

        get :not_infected_survivors
        expect(response).to have_http_status(:ok)
        expect(json_response[:data]).to eq '75.0%'
      end
    end
  end

  describe "GET #resources_by_survivor" do
    it "should return the not infected survivors percentage" do
      create_list(
        :survivor,  10, 
        :infected, 
        resources_attributes: [
          attributes_for(:resource, :water, quantity: 3),
          attributes_for(:resource, :food,  quantity: 7),
          attributes_for(:resource, :medication, quantity: 1),
          attributes_for(:resource, :ammunition, quantity: 6)
        ]
      )

      create_list(
        :survivor, 30, 
        :not_infected,
        resources_attributes: [
          attributes_for(:resource, :water, quantity: 2),
          attributes_for(:resource, :food,  quantity: 3),
          attributes_for(:resource, :medication, quantity: 8),
          attributes_for(:resource, :ammunition, quantity: 5)
        ]
      )

      get :resources_by_survivor
      
      expect(response).to have_http_status(:ok)        
      expect(json_response[:data][:water]).to eq 2.25
      expect(json_response[:data][:food]).to eq 4.0
      expect(json_response[:data][:medication]).to eq 6.25
      expect(json_response[:data][:ammunition]).to eq 5.25
    end
  end

  describe "GET #lost_infected_points" do
    it "should return the lost point because of infected survivors" do
      create_list(
        :survivor,  10, 
        :infected, 
        resources_attributes: [
          attributes_for(:resource, :water, quantity: 3),
          attributes_for(:resource, :food,  quantity: 7),
          attributes_for(:resource, :medication, quantity: 1),
          attributes_for(:resource, :ammunition, quantity: 6)
        ]
      )

      create_list(
        :survivor, 30, 
        :not_infected,
        resources_attributes: [
          attributes_for(:resource, :water, quantity: 2),
          attributes_for(:resource, :food,  quantity: 3),
          attributes_for(:resource, :medication, quantity: 8),
          attributes_for(:resource, :ammunition, quantity: 5)
        ]
      )

      get :lost_infected_points
            
      expect(response).to have_http_status(:ok)        
      expect(json_response[:data]).to eq '410 points lost'
    end
  end
end
