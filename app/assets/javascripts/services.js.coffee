# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Chart
  constructor: (el) ->
    @el = el
    @metricId = el.data('metric-id')
    @metricTitle = el.data('title')
    @chartSize = el.data('size')

    options = _.merge(_.cloneDeep(@chartOptions.default), @chartOptions[@chartSize || {}])
    options.bindto = '#metric-chart-' + @metricId
    @c3object = c3.generate(options)
    
    @updateChartNow()
    if @chartSize is 'big'
      @updateChartEvery(10)

    @

  insertMetricData: (formattedTimeseries) -> # must be like { times: [t,t,t], points: [4,2,3] }
    data =
      columns: [
        (['x']).concat(formattedTimeseries.times)
        ([@metricTitle]).concat(formattedTimeseries.points)
      ]
    data.types = {}
    data.types[@metricTitle] = 'area'

    @c3object.load(data)

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
        ]
      color:
        pattern: ['#339966']
      axis:
        x:
          show: true
          type: 'timeseries',
          tick: {
            count: 4,
            format: '%H:%M'
          }
          padding:
            bottom: 5
        y:
          min: 0
          show: false
      grid:
        x:
          show: false
        y:
          show: false
      legend:
        show: true
    big:
      zoom:
        enabled: true
      subchart:
        show: true
      size:
        height: 500
      axis:
        x:
          tick:
            count: 16
        y:
          show: true
    small:
      point:
        show: false
      size:
        height: 100
      tooltip:
        show: false


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
