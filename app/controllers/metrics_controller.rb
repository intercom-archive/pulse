class MetricsController < ApplicationController
  before_action :set_metric, only: [:show, :edit, :update, :destroy]

  # GET /metrics
  def index
    @metrics = Metric.all
  end

  # GET /metrics/1
  def show
  end

  # GET /metrics/new
  def new
    @metric = Metric.new
  end

  # GET /metrics/1/edit
  def edit
  end

  # POST /metrics
  def create
    @metric = Metric.new(metric_params)

    if @metric.save
      redirect_to @metric, notice: 'Metric was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /metrics/1
  def update
    if @metric.update(metric_params)
      redirect_to @metric, notice: 'Metric was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /metrics/1
  def destroy
    @metric.destroy
    redirect_to metrics_url, notice: 'Metric was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metric
      @metric = Metric.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def metric_params
      params.require(:metric).permit(:title, :datapoint_source, :datapoint_name, :summary, :mitigation_steps, :contact)
    end
end
