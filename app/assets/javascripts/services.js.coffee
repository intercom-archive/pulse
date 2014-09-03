# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Chart
  constructor: (el) ->
    @el = el
    @metricId = el.data('metric-id')
    @metricTitle = el.data('title')
    @chartSize = el.data('size')
    @enableAlarming = true
    @datapointStartTime = $('input[name="start_time"]').val()
    @datapointEndTime = $('input[name="end_time"]').val()

    @enableAlarming = false if @datapointStartTime && @datapointEndTime

    options = @buildChartOptions()
    @c3object = c3.generate(options)
    
    @updateChartNow()
    @

  buildChartOptions: ->
    options = _.merge(_.cloneDeep(@chartOptions.default), @chartOptions[@chartSize || {}])
    options.bindto = '#metric-chart-' + @metricId
    options

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
    url = "/metrics/" + @metricId + ".json"
    url += '?start_time=' + @datapointStartTime + '&end_time=' + @datapointEndTime if @datapointStartTime && @datapointEndTime
    $.getJSON(url)

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
      self.setAlarmLines(data.alarm.warning, data.alarm.error)
      self.setGraphColor(data.alarm.state)
      self.setGraphYRange(data.datapoints, data.alarm.warning, data.alarm.error)
    )

  updateChartEvery: (seconds) ->
    self = this
    @updateInterval = setInterval(->
      self.updateChartNow()
    , seconds * 1000)

  setAlarmLines: (warningLevel, errorLevel) ->
    warningText = 'Warning (' + warningLevel + ')' if @chartSize == 'big'
    errorText = 'Error (' + errorLevel + ')' if @chartSize == 'big'

    @c3object.ygrids([
      { value: warningLevel, text: warningText , class: 'alarm-warning' },
      { value: errorLevel, text: errorText, class: 'alarm-error' }
    ])

  setGraphYRange: (datapoints, warningLevel, errorLevel) ->
    yMax = warningLevel
    yMax = errorLevel if errorLevel > warningLevel
    max = datapoints.reduce ((max, arr) -> Math.max max, arr[0]), -Infinity
    yMax = max if max > yMax
    @c3object.axis.max({y: yMax})

  setGraphColor: (state) ->
    colors = {}
    colors[@metricTitle] = '#339966'
    colors[@metricTitle] = '#f29d50' if state == 'warning'
    colors[@metricTitle] = '#a94442' if state == 'error'
    @c3object.data.colors(colors)

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


class DateRangePicker
  constructor: (el, $start_time, $end_time) ->
    @el = el
    @displayTimeFormat = 'YYYY-MM-DD HH:mm'
    @timeFormat = 'YYYYMMDDHHmm'

    startTime = moment($start_time.val(), @timeFormat) if $start_time.val()
    endTime = moment($end_time.val(), @timeFormat) if $end_time.val()
    @el.val(startTime.format(@displayTimeFormat) + ' - ' + endTime.format(@displayTimeFormat)) if startTime && endTime

    @datePicker = @el.daterangepicker(@getOptions())
    @attachEventHandler()

  attachEventHandler: ->
    self = this
    @datePicker.on('show.daterangepicker', (ev, picker) ->
      picker.setOptions(self.getOptions())
    )
    @datePicker.on('apply.daterangepicker', (ev, picker) ->
      $('input[name="start_time"]').val(picker.startDate.clone().utc().format(self.timeFormat))
      $('input[name="end_time"]').val(picker.endDate.clone().utc().format(self.timeFormat))
    )

  getOptions: ->
    self = this
    {
      ranges:
        'Last 10 minutes': [moment().subtract('minutes', 10), moment()],
        'Last 30 minutes': [moment().subtract('minutes', 30), moment()],
        'Last hour': [moment().subtract('hours', 1), moment()],
        'Last 4 hours': [moment().subtract('hours', 4), moment()],
        'Last Day': [moment().subtract('days', 1), moment()],
        'Last Week': [moment().subtract('days', 6), moment()]
      opens: 'right',
      format: self.displayTimeFormat
      minDate: moment().subtract('days', 7),
      maxDate: moment(),
      timePicker: true,
      timePickerIncrement: 1
    }

chartsOpen = {}
$(document).on("page:change", ->
  _.each(chartsOpen, (c) ->
    c.destroy()
  )

  $('input[class*="daterange"]').each( ->
    new DateRangePicker($(this), $('input[name="start_time"]'), $('input[name="end_time"]'))
  )

  $(".metric-chart").each( ->
    chart = new Chart($(this))
    chartsOpen["chart_#{chart.metricId}_#{chart.chartSize}"] = chart
  )
)
