
function googleMapsCallbackListener () {
    var map;
    var preferredLatLng = new google.maps.LatLng(60.462190, 22.272416);
    var mapOptions = {
        zoom: 11,
        center: preferredLatLng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map($('#map')[0], mapOptions);
}
function loadGoogleMaps() {
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&' +
      'callback=googleMapsCallbackListener';
  document.body.appendChild(script);
}

