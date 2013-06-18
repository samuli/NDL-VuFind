<!-- START of: Record/view-googlemap.tpl -->

{js filename="jquery.geo.min.js"}

{literal}
<script type="text/javascript">

$(document).ready(function() {
  var map = $("#map_canvas").geomap({
    center: [27, 66], 
    scroll: "off",
    shift: "dragBox",
    zoom: 4,
    zoomMin: 1,
    zoomMax: 17,
  });
  $("#map_canvasTools input").click(function() {
    $("#map_canvas").geomap("option", "mode", $(this).val());
    $("#map_canvasHelp").children().hide();
    switch ($(this).val()) {
      case 'pan': $("#map_canvasHelpPan").show(); break;
      case 'drawPolygon': $("#map_canvasHelpPolygon").show(); break;
      case 'dragBox': $("#map_canvasHelpRectangle").show(); break;
    }
  });
  $("#zoomControlPlus").click(function() {
    $("#map_canvas").geomap("zoom", 1);
    $("#zoomPath").slider("option", "value", $("#map_canvas").geomap("option", "zoom")); 
  });
  $("#zoomControlMinus").click(function() {
    $("#map_canvas").geomap("zoom", -1);
    $("#zoomPath").slider("option", "value", $("#map_canvas").geomap("option", "zoom")); 
  });
  $("#zoomControlPlus").click(function() {
    $("#map_canvas").geomap("zoom", 1);
    $("#zoomPath").slider("option", "value", $("#map_canvas").geomap("option", "zoom")); 
  });
  $("#zoomControlMinus").click(function() {
    $("#map_canvas").geomap("zoom", -1);
    $("#zoomPath").slider("option", "value", $("#map_canvas").geomap("option", "zoom")); 
  });
  $("#zoomSlider").bind('dblclick', function(e) {
    e.preventDefault();
  });
  
  
  var sliderElement = $("#zoomPath");
  sliderElement.slider({
    orientation: "vertical",
    min: parseInt($("#map_canvas").geomap("option", "zoomMin")),
    max: parseInt($("#map_canvas").geomap("option", "zoomMax")),
    value: $("#map_canvas").geomap("option", "zoom"),
    stop: function() {
      $("#map_canvas").geomap("option", "zoom", parseInt(sliderElement.slider("option", "value")));
    }
  });
  
  var markersData = {/literal}{$map_marker}{literal};
  for (var i = 0; i < markersData.length; i++) {
    var disTitle = markersData[i].title;
    var iconTitle = disTitle;
    if (disTitle.length > 50) {
      iconTitle = disTitle.substring(0, 47) + "...";
    }
    if (markersData[i].polygon) {
      var polygon = markersData[i].polygon;
      map.geomap("append", { type: "Polygon", coordinates: polygon });
      if (i == 0) {
	      var lon = 0, lat = 0;
	      for (var c = 0; c < polygon[0].length - 1; c++) {
	        var coord = polygon[0][c];
	        lon += coord[0];
	        lat += coord[1];
	      }
	      lon /= (polygon[0].length - 1);
	      lat /= (polygon[0].length - 1);
	      map.geomap("option", "center", [lon, lat]);
      }
    } else if (markersData[i].multipolygon) {
      // Handle multipolygon as multiple separate polygons for now due to https://github.com/AppGeo/geo/issues/130
      var multipolygon = markersData[i].multipolygon;
      for (m = 0; m < multipolygon.length; m++) {
        map.geomap("append", { type: "Polygon", coordinates: multipolygon[m] });
      }
      if (i == 0) {
        var lon = 0, lat = 0;
        for (var m = 0; m < multipolygon[0].length; m++) {
          for (var c = 0; c < multipolygon[m][0].length - 1; c++) {
            var coord = multipolygon[m][0][c];
            lon += coord[0];
            lat += coord[1];
          }
          lon /= (multipolygon[m][0].length - 1);
          lat /= (multipolygon[m][0].length - 1);
        }
        map.geomap("option", "center", [lon, lat]);
      }
    } else {
      map.geomap("append", { type: "Point", coordinates: [markersData[i].lon, markersData[i].lat] }, '<span class="mapMarker">' + iconTitle + '</span>');
      if (i == 0) {
        map.geomap("option", "center", [markersData[i].lon, markersData[i].lat]);
      }
    }
    map.geomap("refresh"); 
  }
});
</script>
{/literal}
<div id="wrap" class="selectionMapContainer">
  <div id="map_canvas" style="    width: 100%;
    height: 400px;
    border: 1px solid gray;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
  ">
    <div id="zoomSlider">
      <div id="zoomControlPlus" class="ui-widget-content ui-corner-all ui-icon ui-icon-plus"></div>
      <div id="zoomRange">
        <div id="zoomPath"></div>
      </div>
      <div id="zoomControlMinus" class="ui-widget-content ui-corner-all ui-icon ui-icon-minus"></div>
    </div>
  </div>
</div>

<!-- END of: Record/view-googlemap.tpl -->
