var PUMPS_TXT = '/files/lectures/2014-10-09/john-snow-voronoi/data-hold/pumps.txt',
    DEATHS_TXT = '/files/lectures/2014-10-09/john-snow-voronoi/data-hold/deaths-plus.txt',
    STREETS_TXT = '/files/lectures/2014-10-09/john-snow-voronoi/data-hold/streets.txt';

var DATA = { };

var CONTAINER_EL = '#snow-map';
var elBox = d3.select(CONTAINER_EL);
var EL_WIDTH = parseInt(elBox.style('width')),
    EL_HEIGHT = parseInt(elBox.style('height'));

var svgBox = elBox.append("svg:svg")
                  .style("width", EL_WIDTH)
                  .style("height", EL_HEIGHT);

var x_range = d3.scale.linear().range([0, EL_WIDTH ]).domain([3,18]);
var y_range = d3.scale.linear().range([EL_HEIGHT, 0]).domain([3,18]);
var vPath = svgBox.append("g").selectAll("path");


// Load the Streets
d3.tsv(STREETS_TXT, function(data) {
  data.forEach(function(d) {
    d.x1 = +d.x1, d.y1 = +d.y1,
    d.x2 = +d.x2, d.y2 = +d.y2;
  });

  DATA.streets = data
  svgBox.selectAll(".street")
      .data(data)
      .enter().append("line")
      .attr("class", "street")
      .attr('stroke', '#777')
      .attr("x1", function(d) { return x_range(d.x1); })
      .attr("y1", function(d) { return y_range(d.y1); })
      .attr("x2", function(d) { return x_range(d.x2); })
      .attr("y2", function(d) { return y_range(d.y2); });
});

// Load the Pumps
d3.tsv(PUMPS_TXT, function(data) {
  data.forEach(function(d) {
    console.log("pump: " + d.x);

    d.x = +d.x;
    d.y = +d.y;
  });

  DATA.pumps = data

  // move this on a different call back...
  drawVoronoi(vPath, DATA.pumps.map(function(d){
    console.log("Voronoi: " + d.id)
    return [x_range(d.x), y_range(d.y)];
  } ));


  var pumpTip = d3.tip().attr('class', 'd3-tip').html(function(d){
    var deaths = DATA.deaths.filter(function(death){ return death.closest_by_bird_pump_id == d.id})
    // return ("Pump " + d.id + ": "  + d.x + ", " + d.y + "<br> Deaths: " + deaths.length);
    return "Deaths nearest to this pump: <strong>" + deaths.length + "</strong>";
  });
  svgBox.call(pumpTip);
  svgBox.selectAll(".point")
      .data(data)
      .enter().append("circle")
      .attr("class", "pump")
      .attr("id", function(d){ console.log("pump-" + d.id); return "pump-" + d.id; }  )
      .attr("r", 5)
      .attr('stroke', 'black')
      .attr('fill', '#ff9933')
      .attr("cx", function(d) { return x_range(d.x); })
      .attr("cy", function(d) { return y_range(d.y); })
      .on('mouseover', function(d){
        pumpTip.show(d);
      })
      .on('mouseout', function(d){
        pumpTip.hide(d);
      });



});


// Load the deaths
d3.tsv(DEATHS_TXT, function(data) {
  data.forEach(function(d) {
    d.x = +d.x;
    d.y = +d.y;
  });

  DATA.deaths = data

  svgBox.selectAll(".point")
      .data(data)
      .enter().append("circle")
      .attr("class", "point")
      .attr("r", 1.0)
      .attr("cx", function(d) { return x_range(d.x); })
      .attr("cy", function(d) { return y_range(d.y); })
      .attr("fill", '#BB0000')

});


function drawVoronoi(v_path, vertices) {
  var voronoi = d3.geom.voronoi()
    .clipExtent([[0, 0], [EL_WIDTH, EL_HEIGHT]]);
  v_path = v_path.data(voronoi(vertices), polygon);
  var colorScale = d3.scale.category20b();
  v_path.exit().remove();

  var ptip = d3.tip().attr('class', 'd3-tip').html(function(idx){
    var deaths = DATA.deaths.filter(function(death){ return death.closest_by_bird_pump_id == idx + 1});
    return "Deaths nearest to this pump: <strong>" + deaths.length + "</strong>";
  });
  svgBox.call(ptip);


  v_path.enter().append("path")
      .attr("d", polygon)
      .attr("class", "pumpRegion")
      .attr('fill', function(d,i){  return colorScale(i); })
      .attr('opacity', 0.3)
      .on("mouseover", function(d, i){
        d3.select(this).attr('opacity', 0.32);
        ptip.show(i);
      }).on("mouseout", function(d, i){
        d3.select(this).attr('opacity', 0.2);
        ptip.hide();
      });

  v_path.order();
}

function polygon(d) {
  return "M" + d.join("L") + "Z";
}
