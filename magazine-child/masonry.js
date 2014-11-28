// 	var floatingOpen = -1;
// 	var floatingImage = jQuery('#floatingImage');
// 	var floatingBox = jQuery('#floatingBox');
// 	var floatingCaption = jQuery('#floatingCaption');
// 	var floatPageX = 0;
// 	var fadeTime = 250;
// 	var overFloatingBox = false;
// 	var imageCountp = 20;
// 	if (!p) var p = [];
// 	var artistNameOnly = 0;
// 	var linkToArtistPage = 0;
// 	var maxDimension = 600;
// 	var maxRatio = 0.66;
// 	
// 		p[0] = {};
// 		p[0]['title'] = 'Long Playing';
// 		p[0]['URL'] = 'http://www.inisink.ie/wp-content/uploads/2014/04/copperwhite_long-playing-500x397.jpg';
// 		p[0]['w'] = 500;
// 		p[0]['h'] = 397;
// 		p[0]['ID'] = 2253;
// 		p[0]['pLink'] = 'http://www.inisink.ie/shop/lithograph/long-playing-2/';
// 		p[0]['artist ID'] = '../?artists=diana-copperwhite';
// 		p[0]['caption'] = '<b>Diana Copperwhite</b>: <i>Long Playing</i>, lithograph,  <b>€480</b> ';
// 		p[0]['price'] = 480;

// <script>imageHash["#thumb19"] = 'http://scontent-b.cdninstagram.com/hphotos-xap1/t51.2885-15/926232_298372217002873_1459684648_n.jpg'; captionHash["#thumb19"] = '#ddefib Charlemont';</script>
// <script>defib[20]={}; defib[20]['caption']="#ddefib oars"; defib[20]['address']=""; defib[20]['lng']="-6.22795434"; defib[20]['lat']="53.34167513"; defib[20].thumb = "http://pbs.twimg.com/media/ByufmyJCcAANTkZ.jpg:thumb"; defib[20].standard_resolution = "http://pbs.twimg.com/media/ByufmyJCcAANTkZ.jpg:thumb"; defib[20]['type']="twitter";</script>

var floatDelay;
var useHover = false; // if true, floating box appears when image box is hovered
var baseUnit = 10;
var baseUnitHasBeenSet = true;

function fillMasonryDivs(p, alreadyInserted, imageCount, columnCount, mbWidth, presetWallWidth) {

	jQuery(window).scroll(function() { checkInView(p, imageCount, alreadyInserted); });
	if (!baseUnitHasBeenSet) setTimeout(function(){ fillMasonryDivs(p, alreadyInserted, imageCount, columnCount, mbWidth, presetWallWidth); }, 250);
	else fillMasonryDivsAfterWait(p, alreadyInserted, imageCount, columnCount, mbWidth, presetWallWidth);
	jQuery(window).resize(function(){ clearTimeout(resizeWait); resizeWait = setTimeout(function(){ fillMasonryDivs(p, alreadyInserted, imageCount, columnCount, mbWidth, presetWallWidth); }, 250); });

}
function fillMasonryDivsAfterWait(p, alreadyInserted, imageCount, columnCount, mbWidth, presetWallWidth) {

// 	jQuery('.masonryBox').css('opacity', 0);
	for (var i = 0; i < p.length; i++) alreadyInserted[i] = false;
	var columnGap = baseUnit;
	masonryWall = jQuery('#masonryWall');
	var wallWidth = masonryWall.width();
	console.log('* wall width: ' + wallWidth);

	var masonryBoxWidth;
	if (typeof mbWidth == 'undefined') {
		masonryBoxWidth = 180; if (jQuery(window).width() <= 320) masonryBoxWidth = 240;
	} else if (mbWidth > 0) masonryBoxWidth = mbWidth; else masonryBoxWidth = 180;
	if (isTouch) masonryBoxWidth *= 0.8;
	console.log('starting masonry box width is ' + masonryBoxWidth);

	var masonryBoxPadding = 0;
	var masonryBoxBorderWidth = 0;
	var masonryBoxBorderColour = '#eee';
	var masonryBoxPmarginBottom = 10;
	var extras = columnGap;
	var masonryBoxOuterWidth = masonryBoxWidth + extras;
console.log('1 masonry box outer width: ' + masonryBoxOuterWidth + ", wall width: " + wallWidth);
	columnCount = Math.floor(wallWidth / masonryBoxOuterWidth);
	columnCount = columnCountX = Math.floor(wallWidth / (masonryBoxOuterWidth));
console.log('column count: ' + columnCount);
	if (columnCount > 0) {
		masonryBoxWidth = (wallWidth / columnCount) - extras; masonryBoxWidth *= 0.98;
		masonryBoxWidth = masonryBoxWidthX = ((wallWidth - (columnCount - 0) * baseUnit) / columnCountX);
		console.log("columnCountX: " + columnCount + ", masonryBoxWidthX: " + masonryBoxWidth);
	} else {
		masonryBoxWidth = 280;
		extras -= columnGap; // already set masonryBoxWidth above
		jQuery('#masonryWall').width(masonryBoxWidth);
		columnCount = 1;
	}
	if (columnCount == 1) {
		if (wW > 495) jQuery('.nine.units').css('width', '40%');
	}
	masonryBoxOuterWidth = masonryBoxWidth + extras;
console.log('2 masonry box width: ' + masonryBoxWidth);
	var column = []; for (var i = 0; i < columnCount; i++) column[i] = '';
console.log('column count: ' + columnCount + " (" + masonryBoxWidth + ")" );
	var info = '';
	var imageBoxWidth = masonryBoxWidth;
	// console.log('image box width: ' + imageBoxWidth);
	for (var i = 0; i < p.length; i++) {
		var imagei = p[i];
// 		console.log("i is " + i + ", image width is " + imagei['w']);
		if (imagei['skip in columns']) continue;
		var width = imagei['w'];
		var scaler = imageBoxWidth / width;
		var height = imagei['h'] * scaler;
		width = imageBoxWidth + 'px'; height += 'px';
		var tempDiv = document.createElement("div");
		tempDiv.innerHTML = imagei['caption'];	var simpleText = tempDiv.textContent || tempDiv.innerText || "";
		column[i % columnCount] +=
			'<ul class="products"><li class="product" style="width:100%">'+
			'<div id="masonryBox' + i + '" class="masonryBox" ' + 
			'style="width:' + masonryBoxWidth + 'px; padding:' + masonryBoxPadding + 'px; border:' + masonryBoxBorderWidth + 'px solid ' + masonryBoxBorderColour + ';">' + "\n";
			column[i % columnCount] +=	'<a href="javascript:clickToEnlarge();">';
			column[i % columnCount] += '<img nopin="nopin" id="' + i + '" alt="' + simpleText + '" class="masonryImageBox" style="width:' + width +
			';"></a>';

			column[i % columnCount] +=	'<div id="masonryImageBoxText' + i + '" class="masonryImageBoxText">' + imagei['caption'] + "</div>\n</div>\n";
			// '-12' above refers to amount of left- and right-padding

			column[i % columnCount] +=	'</li></ul>' + "\n";
			
// 			jQuery('#masonryBox' + i).fadeTo(1000 + i * 100, 1);
	}
	for (var i = 0; i < columnCount; i++) {
		var colMargin = i == (columnCount - 1) ? 0 : columnGap;
		info += '<div id="column' + i + '" class="masonryImageColumn" style="width:' + (masonryBoxWidth + extras - colMargin - (1.0 / columnCount)) + 'px; margin-right:' + colMargin + 'px;">' + "\n";
		info += column[i] + "</div>\n";
	}
	jQuery('#masonryWall').html(info);
	if (columnCount == 1) {
		jQuery('.masonryImageColumn').css('margin-bottom', 0);
		console.log("changing things...:" + jQuery('.masonryImageColumn').css('margin-bottom'));
	}
	jQuery('#placeholder').width(0);
	checkInView(p, p.length, alreadyInserted);
	jQuery(document).keyup(function(e) {
		var code = e.keyCode || e.which;
// 		console.log("code is " + code + ", floating open: " + floatingOpen); // doesn't work with 'alert'
		if (floatingOpen >= 0) if (!p[floatingOpen]['skip in columns']) {
			if (code == 27) { noFloat(); floatingOpen = -1; }
			if (code == 37) leftOrRight(true);
			if (code == 39) leftOrRight(false);
		}
		function leftOrRight(left) {
			if (left) { // left-arrow
				floatingOpen--; if (floatingOpen < 0) floatingOpen = imageCount - 1;
			} else {
				floatingOpen++; if (floatingOpen >= imageCount) floatingOpen = 0;
			}
			noFloat(); setTimeout(function(){ showFloatingBox(floatingOpen, floatPageX); }, fadeTime);
		}
	});
// create hover / float
		var floatImage = true;
		function floatIt(id, e) {
			floatingOpen = id;
			floatPageX = e.pageX;
			console.log("about to float: " + id);
			showFloatingBox(id, floatPageX);
			overFloatingBox = true;
		}
		if (useHover) // floating box appears when image box is hovered
		jQuery('.masonryImageBox').mouseenter(function(e) {
			var id = jQuery(this).attr('id'); // id = id.replace('thumb', '');
			floatDelay = setTimeout(function() { floatIt(id, e); }, 250); // don't respond too quickly or interface experience gets jumpy
			jQuery(this).mouseleave(function(event) { // cancel float if cursor leaves this masonry image box
// 				console.log("related target: " + event.relatedTarget.nodeName);
				if (floatingOpen < 0)
					if ((event.relatedTarget != floatingBox) && (event.relatedTarget != floatingImage)
						&& (event.relatedTarget.nodeName != 'IMG')) { noFloat(); floatingOpen = -1; }
			});
		}); else
		jQuery('.masonryImageBox').click(function(e) {
			console.log('masonryImageBox clicked');
			// http://stackoverflow.com/questions/387736/how-to-stop-event-propagation-with-inline-onclick-attribute
			if (!e) e = window.event;
			//IE9 & Other Browsers
			if (e.stopPropagation) { e.stopPropagation(); }
			//IE8 and Lower
			else { e.cancelBubble = true;}
			var id = jQuery(this).attr('id'); // id = id.replace('thumb', '');
			floatDelay = setTimeout(function() { floatIt(id, e); }, 250); // don't respond too quickly or interface experience gets jumpy
			jQuery(this).mouseleave(function(event) { // cancel float if cursor leaves this masonry image box
// 				console.log("related target: " + event.relatedTarget.nodeName);
				if (floatingOpen < 0)
					if ((event.relatedTarget != floatingBox) && (event.relatedTarget != floatingImage)
						&& (event.relatedTarget.nodeName != 'IMG')) { noFloat(); floatingOpen = -1; }
			});
		});

		if (isTouch) {
			jQuery('.masonryImageBox').bind("touchstart", function(e) {
				var id = jQuery(this).attr('id'); // id = id.replace('thumb', '');
// 				setTimeout(function(){ floatIt(id, e); }, 500);
			});
// 			jQuery('#moreInfoButton').bind("touchstart", function(e) { return true; });
// 			jQuery('#floatingBox').bind("touchstart", function(e) { return false; });
			jQuery(this).bind("click", function(e) {
				return true;
			});
		}
		floatingBox.mouseleave(function() {
			noFloat(); floatingOpen = -1;
		});
// 		if (!isTouch)

		if (jQuery('#bottomPageNavigation').length) { // pagination on shop
			var bottomMargin = jQuery('.masonryImageColumn').css('margin-bottom');
			console.log("bottom margin is " + bottomMargin);
			jQuery('.masonryImageColumn').css('margin-bottom', '50px');
			jQuery('#bottomPageNavigation').css('margin-bottom', (parseInt(bottomMargin.replace('px', '')) + 50) + 'px');
			if (wW <= 480) jQuery('#bottomPageNavigation').css('position', 'relative').css('top', '-80px');
		}

		masonryDone = true;
		
// 		if (jQuery('.woocommerce-pagination').length) { console.log('pagination (' + jQuery('.woocommerce-pagination').width() + ')');
// 			if (wW >= 495) jQuery('.shop-descwrap, .nine.units').width(Math.min(baseUnit * 12, jQuery('.woocommerce-pagination').width()));
// 			else jQuery('.shop-descwrap, .nine.units').width(jQuery('#container').width() - 2 * baseUnit).css('margin-top', '58px');
// 		} else { console.log('no pagination');
// 		}

}

function isScrolledIntoView(elem) {
	if (jQuery(elem).length == 0) { return false; }
	var docViewTop = jQuery(window).scrollTop();
	var docViewBottom = docViewTop + jQuery(window).height();
	var elemTop = jQuery(elem).offset().top;
	var elemBottom = elemTop + jQuery(elem).height();
	var inView = docViewBottom >= elemTop && docViewTop <= elemBottom;
// 	console.log('in view? ' + inView);
//     console.log(elem + ", " + docViewTop + ", " + docViewBottom + ", " + elemTop + ", " + elemBottom);
	return inView;
}

function checkInView(p, imageCount, alreadyInserted) {
// 	console.log("checking in view");
	for (var i = 0; i < imageCount; i++)
		if (isScrolledIntoView('#' + i)) insertBackgroundImage(p, i, alreadyInserted);
//  			else console.log("image " + i + " is not in view");
// 	jQuery('#footerwrap').animate({'top':(jQuery('#layout').offset().top + jQuery('#layout').height() + 2) + 'px'}, 500);
}

function clickToEnlarge() { console.log('clicked'); return; } // dummy function – creates correct-looking cursor over image box

function insertBackgroundImage(p, i, alreadyInserted) {
	if (alreadyInserted[i]) return;
// 	console.log("inserting image for " + i);
// 	console.log("p[i]['URL'] is " + p[i].thumb + " (" + i + ")");
	var fadeTime = 500;
	jQuery('#' + i).attr("src", p[i].thumb.replace('_thumb', '_medium'));
	jQuery('#' + i).animate({'opacity': '1'}, fadeTime);
	alreadyInserted[i] = true;
	clearInterval(footerWait);
	var footerWait = setInterval(function(){
			clearInterval(footerWait);
			jQuery('#footerwrap').stop(1).delay(1000).animate({'padding-top':'20px', 'opacity':1, 'top':(jQuery('#body').offset().top + jQuery('#body').height()) + 'px'}, 1000);
	}, 100);
}

function setupLeftRight(imageWidth, imageHeight) {
	setTimeout(function() {
		jQuery('#goLeft').css('height', imageHeight + 'px');
		jQuery('#goLeft').css('line-height', imageHeight + 'px');
		jQuery('#goRight').css('height', imageHeight + 'px');
		jQuery('#goRight').css('line-height', imageHeight + 'px');
		jQuery('#goLeft').mouseenter(function(){ console.log("up"); jQuery('#goLeft').stop().animate({'opacity': '1'}, fadeTime);});
		jQuery('#goLeft').mouseout(function(){ console.log("down"); jQuery('#goLeft').stop().animate({'opacity': '0'}, fadeTime);});
		jQuery('#goRight').mouseenter(function(){ jQuery('#goRight').stop().animate({'opacity': '1'}, fadeTime);});
		jQuery('#goRight').mouseout(function(){ jQuery('#goRight').stop().animate({'opacity': '0'}, fadeTime);});
	}, fadeTime);
}
function goLeft() { leftOrRight(true); }
function goRight() { leftOrRight(false); }

// });