$ ->
  sourceData = []
  
  now = new Date(Date.now())    
  
  for index in [0...31]
    day = {}
    
    day.date = new Date()
    day.date.setDate(now.getDate() - 31 + index)
    day.xAxisLabel = "#{1+day.date.getMonth()}/#{day.date.getDate()}"
    day.target = (2000 - (index * 10))
    
    if Math.random() > 0.2
      day.consumed = Math.floor(2000-(11*index)+(108*Math.random()))
      day.burned = Math.floor(0-(7*index)-(24*Math.random()))
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
              radius: 6
              symbol: day.symbol
          else
            null
        tooltip:
          pointFormat: "{point.category}"
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
