class MetricsController < ApplicationController
  before_action :set_metric, only: [:show, :edit, :update, :destroy]
  before_action :set_service, only: [:index, :new, :create]

  def index
    @metrics = @service.metrics
  end

  def show
    start_time ||= time_object(params[:start_time])
    end_time ||= time_object(params[:end_time])

    respond_to do |format|
      format.html
      format.json { render json: {
          datapoints: @metric.datapoints(start_time, end_time),
          alarm: {
            error: @metric.alarm_error,
            state: @metric.alarm_state,
            warning: @metric.alarm_warning
          }
        }
      }
    end
  end

  def new
    @metric = @service.metrics.new
  end

  def edit
  end

  def create
    @metric = @service.metrics.new(metric_params)

    if @metric.save
      redirect_to @metric, notice: 'Metric was successfully created.'
    else
      render :new
    end
  end

  def update
    if @metric.update(metric_params)
      redirect_to @metric, notice: 'Metric was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    service = @metric.service
    @metric.destroy
    redirect_to service, notice: 'Metric was successfully destroyed.'
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
      params.require(:metric).permit(:title, :datapoint_source, :datapoint_name, :summary, :mitigation_steps, :contact,
                                     :cloudwatch_namespace, :cloudwatch_identifier, :alarm_warning, :alarm_error,
                                     :negative_alarming)
    end

    def time_object(timestamp)
      Time.at(timestamp.to_i) if timestamp
    end
end
