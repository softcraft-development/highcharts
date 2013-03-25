$ ->
  randomCaloriesConsumed = []
  randomCaloriesBurned = []
  randomCaloriesNet = []
  xAxisLabels = []
  now = new Date(Date.now())    
  for index in [0..30]
    consumed = Math.floor(2000-(10*index)+(89*Math.random()))
    burned = Math.floor(0-(6*index)-(22*Math.random()))
    if Math.random() > 0.2
      randomCaloriesConsumed.push consumed
      randomCaloriesBurned.push burned
      randomCaloriesNet.push consumed + burned
    else
      randomCaloriesConsumed.push null
      randomCaloriesBurned.push null
      randomCaloriesNet.push null
    d = new Date()
    d.setDate(now.getDate() - 31 + index)
    xAxisLabels.push "#{1+d.getMonth()}/#{d.getDate()}"
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
        categories: xAxisLabels
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
        plotLines: [ 
          value: 1700
          zIndex: 6
          color: 'green',
          dashStyle: 'shortdash',
          width: 1,
          label: {
            text: 'Target Calories'
            x: -92
            y: 3
          }
        ]
      ]
      tooltip:
        pointFormat: "<span style=\"color:#656a63\">{series.name}</span>: <b>{point.y}</b><br/>"
      series: [
        stacking: "normal"
        name: "Calories Consumed"
        color: "#dcf3f9"
        type: "column"
        data: randomCaloriesConsumed
      ,
        stacking: "normal"
        name: "Calories Burned"
        color: "#a9e0f4"
        type: "column"
        data: randomCaloriesBurned
      ,
        stacking: null
        connectNulls: true
        name: "Over/Under"
        color: "#743b9a"
        type: "spline"
        data: randomCaloriesNet
      ]
    )
