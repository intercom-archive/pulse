# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Chart
  constructor: (el) ->
    @el = el
    @metricId = el.data('metric')
    @chartSize = el.data('size')

    options = _.merge(_.cloneDeep(@chartOptions.default), @chartOptions[@chartSize || {}])
    options.bindto = '#metric-chart-' + @metricId
    @c3object = c3.generate(options)
    
    @updateChartNow()
    if @chartSize is 'big'
      @updateChartEvery(10)

    @

  insertMetricData: (formattedTimeseries) -> # must be like { times: [t,t,t], points: [4,2,3] }
    @c3object.load(
      columns: [
        (['x']).concat(formattedTimeseries.times)
        (['metric']).concat(formattedTimeseries.points)
      ]
    )

  getMetricData: ->
    $.getJSON("/metrics/" + @metricId + ".json")

  formatDataForC3: (datapointsArray) ->
    datapointsArray.pop()
    graphData = { points: [], times: [] }
    datapointsArray.forEach( (pair) ->
      graphData.points.push(pair[0])
      graphData.times.push(new Date(pair[1] * 1000))
    )
    graphData

  updateChartNow: ->
    self = this
    @getMetricData().done((data) ->
      self.insertMetricData(self.formatDataForC3(data.datapoints))
    )

  updateChartEvery: (seconds) ->
    self = this
    @updateInterval = setInterval(->
      self.updateChartNow()
    , seconds * 1000)

  destroy: ->
    @c3object.data.targets = [];
    @c3object.data.xs = {};
    window.onresize = null;
    clearInterval(@updateInterval)

  chartOptions:
    default:
      data:
        x: 'x'
        columns: [
          ['x', 1]
          ['metric', -1]
        ]
        types: { metric: 'area' }
      axis:
        x:
          type: 'timeseries'
          tick: { format: '%X' }
        y: { padding: { top: 50, bottom: 0 } }
      grid:
        x: { show: true }
        y: { show: true }
      legend: { show: false }
    big:
      zoom: { enabled: true }
      subchart: { show: true }
      size: { height: 500 }
      axis:
        x: { tick: { count: 16} }
    small:
      axis:
        x: { tick: { count: 5} }


chartsOpen = {}
$(document).on("page:change", ->
  _.each(chartsOpen, (c) ->
    c.destroy()
  )
  $(".metric-chart").each( ->
    chart = new Chart($(this))
    chartsOpen["chart_#{chart.metricId}_#{chart.chartSize}"] = chart
  )
)
