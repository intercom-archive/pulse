module ApplicationHelper
  def metric_chart(metric_id, opts={})
    content_tag(
      :div,
      nil,
      id: "metric-chart-#{metric_id}",
      class: 'metric-chart',
      data: { metric: metric_id, size: (opts[:size] || :small) }
    )
  end
end
