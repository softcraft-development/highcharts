$ ->
  SourceColors = 
    Purple: "#6b3092"
    LightPurple: "#e4dcee"
    Blue: "#00cbe8"
    LightBlue: "#e2f5fa"
    Mint: "#eaf5cf"
    
  ColorScheme =
    Consumed: SourceColors.LightPurple
    Burned: SourceColors.Purple
    Above: "#bc7579"
    Below: "#58ab53"
    Line: "#656a63"
    OverUnder: SourceColors.Blue
    Target: "#d8431f"
    
  xAxisFormat = "m/d"
    
  sourceData = []
  
  now = new Date(Date.now())    
  
  for index in [0...31]
    day = {}
    
    day.date = new Date()
    day.date.setDate(now.getDate() - 31 + index)
    day.xAxisLabel = $.datepicker.formatDate(xAxisFormat, day.date)
    day.target = (2000 - (index * 10))
    
    if Math.random() > 0.2
      day.consumed = Math.floor(2000-(11*index)+(108*Math.random()))
      day.burned = Math.floor(0-(7*index)-(24*Math.random()))
      day.net = day.consumed + day.burned
      if day.net > day.target
        day.summary = "#{$.datepicker.formatDate(xAxisFormat, day.date)}<br/>Over: " + (day.net - day.target)
        day.differenceColor = ColorScheme.Above
        day.symbol = "triangle"
      else
        day.summary = "#{$.datepicker.formatDate(xAxisFormat, day.date)}<br/>Under: " + (day.net - day.target)
        day.differenceColor = ColorScheme.Below
        day.symbol = "triangle-down"
    sourceData.push day
  
  
  $(document).ready ->
    new Highcharts.Chart(
      exporting:
        enabled: false
      chart:
        renderTo: "container"
        zoomType: "xy"
      title:
        text: "Last 31 Days (with gaps)"
      subtitle:
        text: ""
      xAxis: [
        labels:
          step: 3 # change this based on how many columns
        categories: _.map sourceData, (day) ->
          day.xAxisLabel
      ]
      yAxis: [ 
        labels:
          formatter: ->
            @value + " calories"
          style:
            color: ColorScheme.Line
        title:
          text: "" # "Calories"
          style:
            color: ColorScheme.Line
      ]
      series: [
        name: "Calories Consumed"
        type: "column"
        stacking: "normal"
        color: ColorScheme.Consumed
        data: _.map sourceData, (day) ->
          if day.consumed?
            y: day.consumed
            name: "#{$.datepicker.formatDate(xAxisFormat, day.date)}<br/>Calories Consumed: #{day.consumed}"
          else
            null
      ,
        name: "Calories Burned"
        type: "column"
        stacking: "normal"
        color: ColorScheme.Burned
        data: _.map sourceData, (day) ->
          if day.burned?
            y: day.burned
            name: "#{$.datepicker.formatDate(xAxisFormat, day.date)}<br/>Calories Burned: #{day.burned * -1}"
          else
            null
      ,
        name: "Over/Under"
        type: "spline"
        connectNulls: true
        color: ColorScheme.OverUnder
        lineWidth: 3
        data: _.map sourceData, (day) ->
          if day.net?
            y: day.net
            name: day.summary
            marker:
              enabled: false
          else
            null
      ,
        name: "Target Calories"
        type: "spline"
        color: ColorScheme.Target
        dashStyle: "Dash"
        lineWidth: 2
        marker: 
          enabled: false
        data: _.map sourceData, (day) ->
          y: day.target
          name: "#{$.datepicker.formatDate(xAxisFormat, day.date)}<br/>Target Calories: #{day.target}"
      ]
      tooltip: 
        formatter: () ->
          this.point.name
    )
