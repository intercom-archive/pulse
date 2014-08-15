jQuery ->
  $el = $('select#metric_datapoint_source')
  $cloudwatch_options = $('#cloudwatch-form-options')
  $el.change ->
    if $el.val() == 'cloudwatch'
      $cloudwatch_options.hide().removeClass('hidden').show()
    else
      $cloudwatch_options.hide()