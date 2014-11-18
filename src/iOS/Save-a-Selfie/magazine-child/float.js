function noFloat() {
	if (floatingOpen == -1) return;
	console.log('in noFloat with ' + swappedOutImage + ' and floatingOpen: ' + floatingOpen);
	jQuery('#' + floatingOpen).css({'background-image':swappedOutImage, 'background-repeat':'no-repeat', 'background-size':'cover'});
	floatingOpen = -1;
	clearTimeout(floatDelay); clearTimeout(mapTimer);
	floatingCaption.html('');
	floatingBox.stop(1,1).fadeTo(fadeTime, 0);
	setTimeout(function(){ floatingBox.css({'width': '0'}).css('border', 'none').css('left', '-3000px'); }, fadeTime);
	floatingImage.stop(1,1).fadeTo(fadeTime, 0);
	setTimeout(function(){ floatingImage.css({'width': '0'}); }, fadeTime);
}

function showFloatingBox(imageID, pageX, x, y) {
	console.log("imageID: " + imageID + ", images[imageID]: " + images[imageID]);
// 	console.log(Object.values(images));
	images[imageID] = images[imageID].replace(':thumb', ':medium'); // for twitter images
	floatingBox.stop(1,1).css({'opacity': '0'}).css({'width':'0'});
	floatingCaption.html('');
	var imageURL = images[imageID];
	var caption = captions[imageID];
	floatingImage.attr('src', imageURL);
	var image = new Image();
 	image.src = imageURL;
	image.onload = function(){
		// - - - - - - need to scale image - - - - -
		var imageWidth = image.width;
		var imageHeight = image.height;
		var maxDim = maxDimension;
		var scalerW = maxDim / imageWidth;
		var scalerH = maxDim / imageHeight;
		var scaler = Math.min(scalerW, scalerH);
		if (scaler > 1) scaler = 1; // don't blow up images
		imageWidth *= scaler;
		imageHeight *= scaler;
		var windowWidth = jQuery(window).width();
		var ratio = maxRatio;
		var maxWidthAllowedByWindow = windowWidth * ratio;
		if (imageWidth > maxWidthAllowedByWindow) {
			scaler = maxWidthAllowedByWindow / imageWidth;
			imageWidth *= scaler; imageHeight *= scaler;
		}
		var windowHeight = jQuery(window).height();
		var maxHeightAllowedByWindow = windowHeight * ratio;
		if (imageHeight > maxHeightAllowedByWindow) {
			scaler = maxHeightAllowedByWindow / imageHeight;
			imageWidth *= scaler; imageHeight *= scaler;
		}
		// - - - - - - - - - - - - - - - - - - - - - -
		var topbar = jQuery('#main-nav');
		var topbarOffset = topbar.offset();
		var topbarHeight = topbar.height();
		var topbarBottom = topbarOffset.top + topbarHeight;
		var scrollTop = jQuery(window).scrollTop();
		var imageTop = (windowHeight - imageHeight) * 0.5 + scrollTop - 20;
		var imagei = jQuery('#' + imageID);
		var imageiOffset = imagei.offset();
		var imageiTop, left;
		if (typeof y == 'undefined') {
			imageiTop = imageiOffset.top; // + scrollTop;
			left = imageiOffset.left + imagei.width() * 0.5 - (imageWidth * 0.5); // - (windowWidth - bodyWidth) * 0.5;
		} else { imageiTop = y; left = x; }
		if (imageTop > imageiTop) imageTop = imageiTop;
		if (imageTop < topbarBottom) imageTop = topbarBottom;
		var bodyWidth = jQuery(document.body).width();
		var windowWidth = jQuery(window).width();
		var rightMarginOfBox = left + imageWidth + 10;
		if (rightMarginOfBox > (bodyWidth  + (windowWidth - bodyWidth) * 0.5 - baseUnit)) left = left - (rightMarginOfBox - bodyWidth + baseUnit) + (windowWidth - bodyWidth) * 0.5;
		if (left < baseUnit) left = baseUnit;
		floatingBox.offset({top: imageTop,left: left});
		floatingBox.stop(1,1).css({'opacity': '0'}).css({'width': '0'}).css('border', 'none');
		floatingImage.stop(1,1).css({'opacity': '0'}).css({'width': '0'});
		floatingCaption.stop(1,1).css({'opacity': '0'}).css({'width': '0'});
		floatingBox.stop(1,1).animate({'opacity': '1'}, fadeTime).animate({'width': imageWidth}, fadeTime);
		floatingImage.stop(1,1).animate({'opacity': '1'}, fadeTime).animate({'width': imageWidth}, fadeTime);
		floatingCaption.stop(1,1).animate({'width': imageWidth}, fadeTime).delay(fadeTime).animate({'opacity': '1'}, fadeTime * 2);
		setTimeout(function(){
			var via = defib[imageID]['type']; via = via == 'inst' ? 'Instagram' : (via == 'twit' ? 'Twitter' : 'iPhone');
			floatingCaption.html('<div id="floatText">' + caption + ' &bull; <span id="via">via ' + via + '</span></div>');
			jQuery('#floatText').width(imageWidth);
			console.log("imageWidth: " + imageWidth);
		}, fadeTime);
		setTimeout(function(){ floatingBox.css('border', '5px solid #fff')}, fadeTime * 2);
		floatingOpen = imageID;
		jQuery(floatingBox).mouseleave(function(event) { noFloat(); });
	// 	setupLeftRight(imageWidth, imageHeight);
	}
}

var floatingBox = jQuery('#floatingBox');
var floatingCaption = jQuery('#floatingCaption');
var floatingImage = jQuery('#floatingImage');
var floatImage = true;
var maxDimension = 600, maxRatio = 0.65;
var useHover = false;
var floatDelay; var isTouch;
var overFloatingBox = false;
// var isTouch = ('ontouchstart' in window) || (navigator.msMaxTouchPoints > 0) || (navigator.MaxTouchPoints > 0); // || navigator.userAgent.match(/(iPhone|iPod|iPad|Blackberry|Android)/));
// var isTouch = "ontouchstart" in window || window.DocumentTouch && document instanceof DocumentTouch;
var fadeTime = 500, baseUnit = 20;
var swappedOutImage = '';

function floatIt(id, e, x, y) {
	console.log("about to float: " + id + ' (' + x + ', ' + y + ')');
	if (floatingOpen == -1) {
		swappedOutImage = jQuery('#' + id).css('background-image'); console.log('swapped out: ' + swappedOutImage);
		jQuery('#' + id).css({'background-image':'url(http://iculture.info/wpSelfie/wp-content/uploads/2014/09/loading.gif)', 'background-repeat':'no-repeat', 'background-size':'contain'});
	}
	floatPageX = e.pageX;
	showFloatingBox(id, floatPageX, x, y);
	overFloatingBox = true;
}

var check = setInterval(function(){ if (jQuery('.squareThumb, .thumb, .twThumb').length > 0) { setFloatingOnClick(); } }, 100);
function setFloatingOnClick() {
	clearInterval(check); // console.log('>> setting onclicks...');
	if (useHover) // floating box appears when image box is hovered
		jQuery('.squareThumb, .thumb, .twThumb').mouseenter(function(e) {
			var id = jQuery(this).attr('id');
			floatDelay = setTimeout(function() { floatIt(id, e); }, 250); // don't respond too quickly or interface experience gets jumpy
			jQuery(this).mouseleave(function(event) { // cancel float if cursor leaves this masonry image box
				if (floatingOpen < 0)
					if ((event.relatedTarget != floatingBox) && (event.relatedTarget != floatingImage)
						&& (event.relatedTarget.nodeName != 'IMG')) { noFloat(); }
			});
		}); else {
// 		console.log('setting onclick');
		jQuery('.squareThumb, .thumb, .twThumb').click(function(e) {
// 			console.log('masonryImageBox clicked');
			// http://stackoverflow.com/questions/387736/how-to-stop-event-propagation-with-inline-onclick-attribute
			if (!e) e = window.event;
			//IE9 & Other Browsers
			if (e.stopPropagation) { e.stopPropagation(); }
			//IE8 and Lower
			else { e.cancelBubble = true;}
			var id = jQuery(this).attr('id');
			clearTimeout(floatDelay);
			floatDelay = setTimeout(function() { floatIt(id, e); }, 150); // don't respond too quickly or interface experience gets jumpy
			jQuery(this).mouseleave(function(event) { // cancel float if cursor leaves this masonry image box
		// 				console.log("related target: " + event.relatedTarget.nodeName);
				if (floatingOpen < 0)
					if ((event.relatedTarget != floatingBox) && (event.relatedTarget != floatingImage)
						&& (event.relatedTarget.nodeName != 'IMG')) { noFloat(); }
			});
		});
	}
}

if (isTouch) {
	console.log('it is touch');
	jQuery('.squareThumb, .thumb, .twThumb').bind("touchstart", function(e) {
		var id = jQuery(this).attr('id');
	});
	jQuery(this).bind("click", function(e) {
		return true;
	});
	jQuery(document).click(function() {
		console.log('document clicked');
		if (floatingOpen == -1) return;
		fm.fadeTo(100, 0); fi.fadeTo(100, 1); mapOff = true;
		noFloat();
	});
}

var villageIdiot = navigator.userAgent.match(/msie|trident/i);
var mapOff = true; var mapTimer;
var fi = jQuery('#floatingImage'); var fm = jQuery('#floatingMap');

floatingBox.mouseleave(function() {
	fm.fadeTo(100, 0); fi.fadeTo(100, 1); mapOff = true;
	noFloat();
});

// if (!villageIdiot) {
	floatingBox.click(function() {
		if (floatingOpen == -1) return;
		clearTimeout(mapTimer);
		mapTimer = setTimeout(function(){
		if (mapOff) {
			fm.width(fi.width() - 2).height(fi.height()); var fo = floatingOpen; // parseInt(floatingOpen.replace('#thumb', ''));
			console.log("switching to map..." + fo);
			var lat = parseFloat(defib[fo]['lat']);  
			var lng = parseFloat(defib[fo]['lng']);
			var newMap = new google.maps.Map(document.getElementById('floatingMap'), {
							center: new google.maps.LatLng(lat, lng),
							zoom: 15, mapTypeId: 'roadmap', scrollwheel: false
						});
			oneMap(fo, newMap);
			google.maps.event.addListener(newMap, 'dblclick', function(event) { clearTimeout(mapTimer); });
			mapOff = false;
			fm.fadeTo(1000, 1); fi.fadeTo(1000, 0);
			} else {
				fm.fadeTo(1000, 0); fi.fadeTo(1000, 1); mapOff = true;
			}
		}, 250); // debouncing
// 		google.maps.event.addListener(newMap, 'click', function() { console.log('clicked!'); });
		
// 				noFloat(); floatingOpen = -1;
	});
// 			jQuery(document).click(function() {
// 				noFloat(); floatingOpen = -1;
// 				console.log("x2 leaving...");
// 			});
// } // else console.log("village idiot");

jQuery(document).keyup(function(e) {
	var code = e.keyCode || e.which;
// 		console.log("code is " + code + ", floating open: " + floatingOpen); // doesn't work with 'alert'
	if (floatingOpen >= 0) {
		if (code == 27) { noFloat(); floatingOpen = -1; }
// 		if (code == 37) leftOrRight(true);
// 		if (code == 39) leftOrRight(false);
	}
	function leftOrRight(left) {
		var newID;
		if (left) { // left-arrow
			floatingOpen--; if (floatingOpen < 0) newID = images.length - 1;
		} else {
			floatingOpen++; if (floatingOpen >= images.length) newID = 0;
		}
		noFloat(); setTimeout(function(){ floatIt(newID, e); }, fadeTime);
	}
});

// http://jsfiddle.net/svigna/VzYF6/
function fromLatLngToPoint(latLng, map) {
    var topRight = map.getProjection().fromLatLngToPoint(map.getBounds().getNorthEast());
    var bottomLeft = map.getProjection().fromLatLngToPoint(map.getBounds().getSouthWest());
    var scale = Math.pow(2, map.getZoom());
    var worldPoint = map.getProjection().fromLatLngToPoint(latLng);
    return new google.maps.Point((worldPoint.x - bottomLeft.x) * scale, (worldPoint.y - topRight.y) * scale);
}