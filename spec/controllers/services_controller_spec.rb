require 'rails_helper'


RSpec.describe ServicesController, :type => :controller do

  let(:valid_attributes) {
    { title: 'My service', description: 'My service description' }
  }

  let(:invalid_attributes) {
    { title: '', description: '' }
  }

  let(:service) {
    FactoryGirl.create(:service)
  }

  describe "GET index" do
    it "assigns all services as @services" do
      service = Service.create! valid_attributes
      get :index, {}
      expect(assigns(:services)).to eq([service])
    end
  end

  describe "GET show" do
    it "assigns the requested service as @service" do
      service = Service.create! valid_attributes
      get :show, {:id => service.to_param}
      expect(assigns(:service)).to eq(service)
    end
  end

  describe "GET new" do
    it "assigns a new service as @service" do
      get :new, {}
      expect(assigns(:service)).to be_a_new(Service)
    end
  end

  describe "GET edit" do
    it "assigns the requested service as @service" do
      service = Service.create! valid_attributes
      get :edit, {:id => service.to_param}
      expect(assigns(:service)).to eq(service)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Service" do
        expect {
          post :create, {:service => valid_attributes}
        }.to change(Service, :count).by(1)
      end

      it "assigns a newly created service as @service" do
        post :create, {:service => valid_attributes}
        expect(assigns(:service)).to be_a(Service)
        expect(assigns(:service)).to be_persisted
      end

      it "redirects to the created service" do
        post :create, {:service => valid_attributes}
        expect(response).to redirect_to(Service.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved service as @service" do
        post :create, {:service => invalid_attributes}
        expect(assigns(:service)).to be_a_new(Service)
      end

      it "re-renders the 'new' template" do
        post :create, {:service => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        { description: 'An updated service description' }
      }

      it "updates the requested service" do
        service = Service.create! valid_attributes
        expect(service.description).to_not eq(new_attributes[:description])
        put :update, {:id => service.to_param, :service => new_attributes}
        service.reload
        expect(service.description).to eq(new_attributes[:description])
      end

      it "assigns the requested service as @service" do
        service = Service.create! valid_attributes
        put :update, {:id => service.to_param, :service => valid_attributes}
        expect(assigns(:service)).to eq(service)
      end

      it "redirects to the service" do
        service = Service.create! valid_attributes
        put :update, {:id => service.to_param, :service => valid_attributes}
        expect(response).to redirect_to(service)
      end
    end

    describe "with invalid params" do
      it "assigns the service as @service" do
        service = Service.create! valid_attributes
        put :update, {:id => service.to_param, :service => invalid_attributes}
        expect(assigns(:service)).to eq(service)
      end

      it "re-renders the 'edit' template" do
        service = Service.create! valid_attributes
        put :update, {:id => service.to_param, :service => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested service" do
      service = Service.create! valid_attributes
      expect {
        delete :destroy, {:id => service.to_param}
      }.to change(Service, :count).by(-1)
    end

    it "redirects to the services list" do
      service = Service.create! valid_attributes
      delete :destroy, {:id => service.to_param}
      expect(response).to redirect_to(services_path)
    end
  end

end
