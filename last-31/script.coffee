$ ->
  sourceData = []
  
  now = new Date(Date.now())    
  
  for index in [0..30]
    day = {}
    
    day.date = new Date()
    day.date.setDate(now.getDate() - 31 + index)
    day.xAxisLabel = "#{1+day.date.getMonth()}/#{day.date.getDate()}"
    day.target = (2000 - (index * 10))
    
    if Math.random() > 0.2
      day.consumed = Math.floor(2000-(10*index)+(89*Math.random()))
      day.burned = Math.floor(0-(6*index)-(22*Math.random()))
      day.net = day.consumed + day.burned
      if day.net > day.target
        day.zone = "Over"
      else
        day.zone = "Under"
    sourceData.push day
  
  chart = undefined
  $(document).ready ->
    chart = new Highcharts.Chart(
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
        color: "#dcf3f9"
        data: _.map sourceData, (day) ->
          if day.consumed?
            day.consumed
          else
            null
      ,
        name: "Calories Burned"
        type: "column"
        stacking: "normal"
        color: "#a9e0f4"
        data: _.map sourceData, (day) ->
          if day.burned?
            day.burned
          else
            null
      ,
        name: "Over/Under"
        type: "spline"
        connectNulls: true
        color: "#743b9a"
        data: _.map sourceData, (day) ->
          if day.net?
            y: day.net
            name: day.zone
          else
            null
        tooltip:
          pointFormat: ""
      ,
        name: "Target Calories"
        type: "spline"
        color: "#FF0000"
        data: _.map sourceData, (day) ->
          day.target
      ]
      tooltip:
        pointFormat: "<span style=\"color:#656a63\">{series.name}</span>: <b>{point.y}</b><br/>"
    )
