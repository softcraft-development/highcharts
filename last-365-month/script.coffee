$ ->
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
        day.color = "#A61E09"
        day.symbol = "triangle"
      else
        day.summary = "Under: " + (day.net - day.target)
        day.color = "#089934"
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
            color: "#656a63"
        title:
          text: "" # "Calories"
          style:
            color: "#656a63"
      ]
      series: [
        name: "Calories Consumed"
        type: "column"
        stacking: "normal"
        color: "#9ddbf4"
        data: _.map sourceData, (day) ->
          if day.consumed?
            day.consumed
          else
            null
      ,
        name: "Calories Burned"
        type: "column"
        stacking: "normal"
        color: "#1fbae3"
        data: _.map sourceData, (day) ->
          if day.burned?
            day.burned
          else
            null
      ,
        name: "Over/Under"
        type: "spline"
        connectNulls: true
        color: "#731491"
        data: _.map sourceData, (day) ->
          if day.net?
            y: day.net
            name: day.summary
            marker:
              fillColor: day.color
              radius: 8
              symbol: day.symbol
          else
            null
        tooltip:
          pointFormat: ""
      ,
        name: "Target Calories"
        type: "spline"
        color: "#731491"
        dashStyle: "Dash"
        lineWidth: 1
        marker: 
          enabled: false
        data: _.map sourceData, (day) ->
          day.target
      ]
    )
