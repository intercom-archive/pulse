module ApplicationHelper
  BS_ALERT_MAP = {
    "notice" => "warning",
    "alert" => "danger"
  }

  def metric_chart(metric_id, opts={})
    content_tag(
      :div,
      nil,
      id: "metric-chart-#{metric_id}",
      class: 'metric-chart',
      data: { metric: metric_id, size: (opts[:size] || :small) }
    )
  end

  def i(n, title: nil)
    return "" unless n
    content_tag(:i, nil, class: "fa fa-#{n}", title: title)
  end

  def flash_alert(type, msg)
    class_name = BS_ALERT_MAP[type] || type
    content_tag(:div, class: "alert alert-#{class_name}") do
      content_tag(:span, msg) +
      button_tag("&times;".html_safe, data: { dismiss: "alert" }, class: "close").html_safe
    end
  end

  def all_flash_alerts
    content_tag(:div) do
      flash.collect { |type, msg| concat(flash_alert(type, msg)) }
    end
  end
end
