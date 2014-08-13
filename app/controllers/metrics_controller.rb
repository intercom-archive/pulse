class MetricsController < ApplicationController
  before_action :set_metric, only: [:show, :edit, :update, :destroy]
  before_action :set_service

  def index
    @metrics = @service.metrics.all
  end

  def show
  end

  def new
    @metric = @service.metrics.new
  end

  def edit
  end

  def create
    @metric = @service.metrics.new(metric_params)

    if @metric.save
      redirect_to [@service, @metric], notice: 'Metric was successfully created.'
    else
      render :new
    end
  end

  def update
    if @metric.update(metric_params)
      redirect_to [@service, @metric], notice: 'Metric was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @metric.destroy
    redirect_to service_metrics_url, notice: 'Metric was successfully destroyed.'
  end

  private
    def set_metric
      @metric = Metric.find(params[:id])
    end

    def set_service
      @service = Service.find(params[:service_id])
    end

    # Only allow a trusted parameter "white list" through.
    def metric_params
      params.require(:metric).permit(:title, :datapoint_source, :datapoint_name, :summary, :mitigation_steps, :contact)
    end
end
