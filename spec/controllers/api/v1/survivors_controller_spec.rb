require 'rails_helper'

RSpec.describe API::V1::SurvivorsController, type: :controller do
  describe "Listing survivor" do
    it "should returns all survivors" do
      survivor = create(:survivor)
      
      get :index

      json_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(response.status).to eq(200)
      expect(json_response.count).to eq 1
    end
  end

  describe "Creating survivor" do
    context "with valid params" do
      it "should create a new Survivor" do
        survivor_params = attributes_for(:survivor)

        expect {
          post :create, params: {survivor: survivor_params}
        }.to change(Survivor, :count).by(1)
      end

      it "should render a JSON response with the new survivor" do
        survivor_params = attributes_for(:survivor)

        post :create, params: {survivor: survivor_params}

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end

      it "should save all survivor's attributes" do 
        survivor_params = attributes_for(:survivor)

        post :create, params: {survivor: survivor_params}

        created_survivor = Survivor.last

        expect(created_survivor.attributes.except('id', 'created_at', 'updated_at')).to eq survivor_params.with_indifferent_access
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new survivor" do
        survivor_params = attributes_for(:survivor)

        post :create, params: {survivor: survivor_params.except(:age)}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq 'application/json'
      end
    end
  end

  describe "Updating survivor" do
    it "should be able to update their last location" do
      update_params = {
        latitude: '-16.6868824', 
        longitude: '-49.2647885'
      }

      survivor = create(:survivor)

      put :update, params: { id: survivor.id, survivor: update_params }

      expect(response).to have_http_status(:no_content)

      survivor.reload

      expect(survivor.last_location[:latitude]).to eq(update_params[:latitude])
      expect(survivor.last_location[:longitude]).to eq(update_params[:longitude])
    end
  end
end