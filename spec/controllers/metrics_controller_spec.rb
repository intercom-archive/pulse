require 'rails_helper'


RSpec.describe MetricsController, :type => :controller do

  let(:metric) {
    FactoryGirl.create(:metric)
  }

  let(:service) {
    FactoryGirl.create(:service)
  }

  let(:valid_attributes) {
    { title: "P95 Latency", datapoint_source: "graphite", datapoint_name: "stats.api.latency.p95", service_id: service.id }
  }

  let(:invalid_attributes) {
    { title: "", datapoint_source: "fake_type", datapoint_name: "", service_id: service.id }
  }

  describe "GET index" do
    it "assigns all metrics as @metrics" do
      metric = Metric.create! valid_attributes
      get :index, { :service_id => service.to_param }
      expect(assigns(:metrics)).to eq([metric])
    end
  end

  describe "GET show" do
    it "assigns the requested metric as @metric" do
      metric = Metric.create! valid_attributes
      get :show, { :service_id => service.to_param, :id => metric.to_param }
      expect(assigns(:metric)).to eq(metric)
    end
  end

  describe "GET new" do
    it "assigns a new metric as @metric" do
      get :new, { :service_id => service.to_param }
      expect(assigns(:metric)).to be_a_new(Metric)
    end
  end

  describe "GET edit" do
    it "assigns the requested metric as @metric" do
      metric = Metric.create! valid_attributes
      get :edit, { :id => metric.to_param }
      expect(assigns(:metric)).to eq(metric)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Metric" do
        expect {
          post :create, { :service_id => service.to_param, :metric => valid_attributes }
        }.to change(Metric, :count).by(1)
      end

      it "assigns a newly created metric as @metric" do
        post :create, { :service_id => service.to_param, :metric => valid_attributes }
        expect(assigns(:metric)).to be_a(Metric)
        expect(assigns(:metric)).to be_persisted
      end

      it "redirects to the created metric" do
        post :create, { :service_id => service.to_param, :metric => valid_attributes }
        expect(response).to redirect_to(Metric.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved metric as @metric" do
        post :create, { :service_id => service.to_param, :metric => invalid_attributes }
        expect(assigns(:metric)).to be_a_new(Metric)
      end

      it "re-renders the 'new' template" do
        post :create, {:service_id => service.to_param, :metric => invalid_attributes }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        { summary: "A metric summary, woo!" }
      }

      it "updates the requested metric" do
        metric = Metric.create! valid_attributes
        expect(metric.summary).to_not eq(new_attributes[:summary])
        put :update, { :id => metric.to_param, :metric => new_attributes }
        metric.reload
        expect(metric.summary).to eq(new_attributes[:summary])
      end

      it "assigns the requested metric as @metric" do
        metric = Metric.create! valid_attributes
        put :update, { :id => metric.to_param, :metric => valid_attributes }
        expect(assigns(:metric)).to eq(metric)
      end

      it "redirects to the metric" do
        metric = Metric.create! valid_attributes
        put :update, { :id => metric.to_param, :metric => valid_attributes }
        expect(response).to redirect_to(metric)
      end
    end

    describe "with invalid params" do
      it "assigns the metric as @metric" do
        metric = Metric.create! valid_attributes
        put :update, { :id => metric.to_param, :metric => invalid_attributes }
        expect(assigns(:metric)).to eq(metric)
      end

      it "re-renders the 'edit' template" do
        metric = Metric.create! valid_attributes
        put :update, { :id => metric.to_param, :metric => invalid_attributes }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested metric" do
      metric = Metric.create! valid_attributes
      expect {
        delete :destroy, { :id => metric.to_param }
      }.to change(Metric, :count).by(-1)
    end

    it "redirects to the metrics list" do
      metric = Metric.create! valid_attributes
      delete :destroy, { :id => metric.to_param }
      expect(response).to redirect_to(metric.service)
    end
  end

end
