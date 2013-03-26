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
  
  sourceData = []
  
  now = new Date(Date.now())    
  
  for index in [12..1]
    day = {}
    
    day.date = new Date(Date.now())
    day.date.setMonth(now.getMonth() - index)
    day.xAxisLabel = $.datepicker.formatDate('M yy', day.date)
    day.target = (2000 + (index * 12))
    
    if Math.random() > 0.2
      day.consumed = Math.floor(2000-(180/index)+(400*Math.random()))
      day.burned = Math.floor(0-(120/index)-(120*Math.random()))
      day.net = day.consumed + day.burned
      if day.net > day.target
        day.summary = "Over: " + (day.net - day.target)
        day.differenceColor = ColorScheme.Above
        day.symbol = "triangle"
      else
        day.summary = "Under: " + (day.net - day.target)
        day.differenceColor = ColorScheme.Below
        day.symbol = "triangle-down"
    sourceData.push day
  
  
  $(document).ready ->
    new Highcharts.Chart(
      chart:
        renderTo: "container"
        zoomType: "xy"
      title:
        text: "Last Year (in months)"
      subtitle:
        text: ""
      xAxis: [
        labels:
          step: 2 # change this based on how many columns
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
            day.consumed
          else
            null
      ,
        name: "Calories Burned"
        type: "column"
        stacking: "normal"
        color: ColorScheme.Burned
        data: _.map sourceData, (day) ->
          if day.burned?
            day.burned
          else
            null
      ,
        name: "Over/Under"
        type: "spline"
        connectNulls: true
        color: ColorScheme.OverUnder
        data: _.map sourceData, (day) ->
          if day.net?
            y: day.net
            name: day.summary
            marker:
              fillColor: day.differenceColor
              radius: 8
              symbol: day.symbol
          else
            null
        tooltip:
          pointFormat: "{point.category}"
      ,
        name: "Target Calories"
        type: "spline"
        color: ColorScheme.Target
        dashStyle: "Dash"
        lineWidth: 2
        marker: 
          enabled: false
        data: _.map sourceData, (day) ->
          day.target
      ]
    )
