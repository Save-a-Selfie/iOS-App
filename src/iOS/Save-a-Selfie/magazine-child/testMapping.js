function oneMap(i, useThisMap) {
//  	console.log('oneMap with ' + i);
// 	console.log('oneMap with ' + i + ', caption: ' + defib[i]['caption'] + ', addr: ' + defib[i]['address'] + ', type:' + defib[i]['type'] + ', lat:' + defib[i]['lat'] + ', long:' + defib[i]['lng']);
	var lat = parseFloat(defib[i]['lat']);  
	var lng = parseFloat(defib[i]['lng']);
	if (useThisMap == '')
		var map =
		new google.maps.Map(document.getElementById('map' + i), {
			center: new google.maps.LatLng(lat, lng),
			zoom: 16, mapTypeId: 'roadmap', scrollwheel: false
		});
	else var map = useThisMap;
	var infoWindow = new google.maps.InfoWindow;
	var caption = defib[i]['caption'];
	var address = defib[i]['address'];
	var type = defib[i]['typeOfObject'];
	var point = new google.maps.LatLng(lat, lng);
	var img = typeof defib[i].standard_resolution != 'undefined' ? '<img src="' + defib[i].standard_resolution + '"><br>' : '';
	var html = '<div class="infoWindow">' + img + '<b>' + caption + '</b><br/>' + address + '</div>';
	var icon = customIcons[type] || {};
	var marker = new google.maps.Marker({
		map: map,
		position: point,
		animation: google.maps.Animation.DROP,
		icon: icon.icon
	});
// 	bindInfoWindow(marker, map, infoWindow, html);
	bindInfoWindow(i, marker, useThisMap);
}

function bindInfoWindow(id, marker, map) {
	var e = '';
// 	console.log('binding ' + id);
	google.maps.event.addListener(marker, 'click', function(e) {
		console.log('marker clicked');
		// http://stackoverflow.com/questions/387736/how-to-stop-event-propagation-with-inline-onclick-attribute
		if (!e) e = window.event;
		//IE9 & Other Browsers
		if (e.stopPropagation) { e.stopPropagation(); }
		//IE8 and Lower
		else { e.cancelBubble = true;}
		// http://jsfiddle.net/svigna/VzYF6/
        var point = fromLatLngToPoint(marker.getPosition(), map);
		floatIt(id, e, point.x, point.y);
	});
}    

function xbindInfoWindow(marker, map, infoWindow, html) {
	google.maps.event.addListener(marker, 'click', function() {
		infoWindow.setContent(html);
		infoWindow.open(map, marker);
	});
}    

function getLocation(markerCount) {
	console.log('showing user position, ' + markerCount);
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition,showError);
    } else {
        mapH.innerHTML = "Geolocation is not supported by this browser.";
    }
}

function showPosition(position) {
//     var latlon = position.coords.latitude+","+position.coords.longitude;
//     var img_url = "http://maps.googleapis.com/maps/api/staticmap?center="
//     +latlon+"&zoom=14&size=" + mapH.clientWidth + "x" + mapH.clientHeight + "&sensor=false";
//     document.getElementById("mapholder").innerHTML = "<img src='"+img_url+"'>";

	var mapH = document.getElementById('mapholder');
	console.log('1 mapH length (' + markerCount + '): '  + mapH.length + ", latitude, longitude " + position.coords.latitude + ', ' + position.coords.longitude);
	var multiMap =
		new google.maps.Map(mapH, {
			center: new google.maps.LatLng(position.coords.latitude, position.coords.longitude),
			zoom: 16, mapTypeId: 'roadmap', scrollwheel: false
		});
// 	markerCount++;
// 	defib[markerCount] = {};
// 	defib[markerCount]['caption']="Your location"; defib[markerCount]['address']=""; defib[markerCount]['lng']=position.coords.longitude; defib[markerCount]['lat']=position.coords.latitude; defib[markerCount]['type']="myLocation";
	GeoMarker = new GeolocationMarker();
	GeoMarker.setCircleOptions({fillColor: '#808080'});
	google.maps.event.addListenerOnce(GeoMarker, 'position_changed', function() {
	  multiMap.setCenter(this.getPosition());
// 	  multiMap.fitBounds(this.getBounds());
	});

	google.maps.event.addListener(GeoMarker, 'geolocation_error', function(e) {
	  console.log('There was an error obtaining your position. Message: ' + e.message);
	});

	GeoMarker.setMap(multiMap);

    for (var i = 0; i <= markerCount; i++) oneMap(i, multiMap);
}

function showError(error) {
    switch(error.code) {
        case error.PERMISSION_DENIED:
            mapH.innerHTML = "User denied the request for Geolocation."
            break;
        case error.POSITION_UNAVAILABLE:
            mapH.innerHTML = "Location information is unavailable."
            break;
        case error.TIMEOUT:
            mapH.innerHTML = "The request to get user location timed out."
            break;
        case error.UNKNOWN_ERROR:
            mapH.innerHTML = "An unknown error occurred."
            break;
    }
}
function doMap() {
	console.log('doMap()!!!');
	var mapHolder = document.getElementById('mapholder');
	console.log('2 > mapH length: ' + mapHolder.length);
// 	if (mapHolder.length > 0) {
// 		console.log('mapHolder!');
// 		for (var i = 0; i <= 18; i++) oneMap(i, ''); 
// 	}
// based on http://www.w3schools.com/html/html5_geolocation.asp

// add watchPosition() !
	console.log('pre showing user position, ' + markerCount);
	getLocation(markerCount);
	console.log('3 >> mapH length: ' + mapHolder.length);

	var tileListener1 = google.maps.event.addListenerOnce(mapHolder, 'tilesloaded', function(e){
			//this part runs when the mapobject is created and rendered
			console.log('big map loaded 1');
			var tileListener2 = google.maps.event.addListenerOnce(mapHolder, 'tilesloaded', function(e){
				//this part runs when the mapobject shown for the first time
				console.log('big map loaded 2');
				google.maps.event.removeListener(tileListener1);
				google.maps.event.removeListener(tileListener2);
			});
		});

}

// function mapLoading() {
// 	if (typeof google === 'object' && typeof google.maps === 'object') { console.log('map loaded'); return; }
// 	else setTimeout(mapLoading, 100);
// }

