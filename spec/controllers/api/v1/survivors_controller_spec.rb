require 'rails_helper'

RSpec.describe API::V1::SurvivorsController, type: :controller do
  describe "Listing survivor" do
    it "should returns all survivors" do
      survivor = create(:survivor)
      
      get :index

      expect(response).to be_success
      expect(response.status).to eq(200)
      expect(json_response.count).to eq 1
    end
  end

  describe "Creating survivor" do
    context "with valid params" do
      it "should create a new Survivor" do
        ammunition = attributes_for :resource, :ammunition
        food = attributes_for :resource, :food
        survivor_params = attributes_for(:survivor, resources: [ammunition, food])

        expect {
          post :create, params: {survivor: survivor_params}
        }.to change(Survivor, :count).by(1)
      end

      it "should render a JSON response with the new survivor" do
        medicine = attributes_for :resource, :water
        ammunition = attributes_for :resource, :food
        survivor_params = attributes_for(:survivor, resources: [medicine, ammunition])

        post :create, params: {survivor: survivor_params}

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end

      it "should save all survivor's attributes" do
        water = attributes_for :resource, :water
        food = attributes_for :resource, :food
        survivor_params = attributes_for(:survivor, resources: [water, food])

        post :create, params: {survivor: survivor_params}

        created_survivor = Survivor.last

        expect(created_survivor.attributes.except('id', 'resources', 'created_at', 'updated_at'))
          .to eq(survivor_params.except(:resources).with_indifferent_access)
      end

      it "should save survivor's resources" do
        water = attributes_for :resource, :water
        food = attributes_for :resource, :food
        survivor_params = attributes_for(:survivor, resources: [water, food])

        post :create, params: {survivor: survivor_params}

        resources = Resource.where(survivor_id: json_response.fetch(:survivor).fetch(:id))

        expect(resources).to_not be_nil
        expect(resources.first[:name]).to eq "water"
        expect(resources.second[:name]).to  eq "food"
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new survivor" do
        water = attributes_for :resource, :water
        food = attributes_for :resource, :food
        survivor_params = attributes_for(:survivor, resources: [water, food])

        post :create, params: {survivor: survivor_params.except(:age)}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq 'application/json'
      end

      it "should not allow survivor without declare resources" do 
        survivor_params = attributes_for(:survivor)
        post :create, params: {survivor: survivor_params}

        expect(response).to have_http_status(:conflict)
        expect(json_response.fetch(:message)).to eq 'Survivor needs to declare resources'
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

  describe "Flag survivor as infected" do 
    context 'with a valid survivor' do
      it "should increment the infection counter" do
        water = attributes_for :resource, :water
        food = attributes_for :resource, :food

        not_infected_survivor = create(
          :survivor, 
          :not_infected, 
          resources_attributes: [water, food]
        )

        post :flag_infection, params: { id: not_infected_survivor.id }

        expect(response).to have_http_status(:ok)

        expect(json_response[:message]).to eq "Survivor was reported as infected 1 time(s)!"

        not_infected_survivor.reload

        expect(not_infected_survivor.infected?).to eq false
        expect(not_infected_survivor.infection_count).to eq 1
      end

      it "if the infection count is 3 should return a infected warning" do
        water = attributes_for :resource, :water
        food = attributes_for :resource, :food

        almost_infected_survivor = create(
          :survivor, 
          :almost_infected, 
          resources_attributes: [water, food]
        )  
        post :flag_infection, params: { id: almost_infected_survivor.id }

        expect(response).to have_http_status(:ok)

        expect(json_response[:message]).to eq "Survivor was reported as infected 3 time(s)!"

        almost_infected_survivor.reload

        expect(almost_infected_survivor.infected?).to eq true
        expect(almost_infected_survivor.infection_count).to eq 3
      end      
    end

    context 'with a invalid survivor' do
      it 'should returns an not found error' do
        post :flag_infection, params: { id: 123 }

        expect(response.status).to eq(404)
      end
    end
  end
end