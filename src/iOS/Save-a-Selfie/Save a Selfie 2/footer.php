		<?php themify_layout_after(); //hook ?>
	</div>
	</div>
	<!-- /#body -->

	<div id="footerwrap">
    
    	<?php themify_footer_before(); // hook ?>
		<footer id="footer" class="pagewidth clearfix">
			<?php themify_footer_start(); // hook ?>

			<p class="back-top">
				<a href="#header"><?php _e('Back to Top', 'themify'); ?></a>
			</p>

			<?php get_template_part( 'includes/footer-widgets'); ?>

			<div class="social-widget">
				<?php dynamic_sidebar('footer-social-widget'); ?>
			</div>
			<!-- /.social-widget -->

			<div class="footer-nav-wrap">
				<?php if (function_exists('wp_nav_menu')) {
					wp_nav_menu(array('theme_location' => 'footer-nav' , 'fallback_cb' => '' , 'container'  => '' , 'menu_id' => 'footer-nav' , 'menu_class' => 'footer-nav'));
				} ?>
			</div>
	
			<div class="footer-text clearfix">
				<?php themify_the_footer_text(); ?>
				<?php themify_the_footer_text('right'); ?>
			</div>
			<!-- /footer-text --> 
			<?php themify_footer_end(); // hook ?>
		</footer>
		<!-- /#footer --> 
        <?php themify_footer_after(); // hook ?>
	</div>
	<!-- /#footerwrap -->

<?php
/**
 *  Stylesheets and Javascript files are enqueued in theme-functions.php
 */
?>

<?php themify_body_end(); // hook ?>
<!-- wp_footer -->
<?php wp_footer(); ?>
<script src="http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/testMapping.js"></script>
<script>
Object.values = function(object) {
  var values = [];
  for(var property in object) {
    values.push(object[property]);
  }
  return values;
}
var root = 'http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/icons/';
var customIcons = {
  0: {
	icon: root + 'defibrillatorSm.png'
  },
  1: {
	icon: root + 'lifeRingSm.png'
  },
  2: {
  	icon: root + 'firstAidKitSm.jpg'
  },
  3: {
  	icon: root + 'hydrantSm.jpg'
  },
  myLocation: {
	icon: 'http://labs.google.com/ridefinder/images/mm_20_blue.png'
  }
};
var alreadyInserted = new Array();
var columnCount = 5; var floatingOpen = -1; var firstSizeCheck = true;
var resizeWait, resizeWait2;
var macComputer = navigator.userAgent.indexOf('Mac OS X') != -1; console.log('macComputer: ' + macComputer);
var villageIdiot;
var masonryDone = false;
var homePage = window.location.href == 'http://www.saveaselfie.org/' || window.location.href == 'http://saveaselfie.org/' || window.location.href == 'http://www.saveaselfie.org' || window.location.href == 'http://saveaselfie.org';
var bodyFooterLoaded = false; var clickToAdded = false;

jQuery(document).ready(function(){

	console.log('homePage: ' + homePage);

// 	alert('URL is ' + window.location.href);

	isTouch = navigator.userAgent.match(/(iPhone|iPod|iPad|Blackberry|Android)/); // only this one seems to be correct
// 	if (isTouch) jQuery('#headerwrap').css('position', 'fixed');

	jQuery('.two, .back-top').hide();
	jQuery("#headerwrap").append("<div id='SASLogo'></div>");
	villageIdiot = navigator.userAgent.match(/msie|trident/i) ? true : false;
	var windowWidth;
	
	// footer widget widths
	jQuery('.col4-1').css('width', '23%').css('margin-left', 0); jQuery('.col4-1.first').css('width', '30%');
	
	var wURL = document.URL;
// 	var homePage = window.location.origin == window.location.href || window.location.origin == window.location.href + '/';
// 	if (homePage) {
// 		jQuery(window).resize(function(){ clearTimeout(resizeWait); resizeWait = setTimeout(checkSizes, 250); });
// 	} else console.log(window.location.origin + ', ' + window.location.href);

	jQuery(window).resize(function(){ clearTimeout(resizeWait2); resizeWait2 = setTimeout(function(){
		windowWidth = jQuery(window).width(); console.log("window width: " + windowWidth);
		jQuery('#main-nav a').css('padding', '26px 15px'); // jQuery('#sidr').css('width', '100%');
		if (windowWidth < 1100) jQuery('#SASLogo').hide(); else jQuery('#SASLogo').show().fadeTo(1000, 1);
		if (windowWidth < 860) {
			if (windowWidth > 780) { jQuery('#site-logo-logo').css('display', 'none'); jQuery('#site-logo').animate({'font-size': (windowWidth / 15) + 'px'}, 500, moveNavbar); }
			else {
				jQuery('#main-nav a').css('padding', '7px 0 7px 9px');
				jQuery('#sidr').css('width', '40%').css('left', (windowWidth * 0.5) + 'px');
				jQuery('#menu-icon').click(function(){ jQuery('#sidr').toggle(1000); });
			}
			homePageMax = 12;
			jQuery('#headerwrap #main-nav a').css('color', '#f00');
		} else {
			jQuery('#site-logo-logo').css('display', 'block').fadeTo(1000, 1);
			jQuery('#site-logo').animate({'font-size': Math.min( (44 * windowWidth / 1200.0), 44) + 'px'}, 500, moveNavbar);
			homePageMax = 12;
			jQuery('#headerwrap #main-nav a').css('color', '#f00');
		}
		if (windowWidth <= 900) {
			console.log('hereeee');
// 			jQuery('.footer-widgets').each(function(){ jQuery(this).find('.col4-1').attr('style', 'width:88% !important; margin-left:' + 2 * baseUnit + 'px !important'); });
			jQuery('.footer-widgets').each(function(){ jQuery(this).find('.col4-1').css('text-align', 'center').css('max-width', '1000px').css('width', '50%'); });
		} else {
			jQuery('.footer-widgets').each(function(){ jQuery(this).find('.col4-1').css('text-align', 'left').css('max-width', '23%'); });
		}
		
		function moveNavbar() {
			console.log('moveNavbar');
			var logoBackground = 'http://www.saveaselfie.org/wp/wp-content/uploads/2014/10/SAS-adjusted-300.png';
			var SASLogo = jQuery('#SASLogo');
			SASLogo.css({'background': 'url(' + logoBackground + ')', 'background-size':'contain', 'background-repeat':'no-repeat'}).animate({'right': jQuery('hgroup').offset().left + 'px'}, 250, function(){
					console.log('logoBackground: ' + logoBackground);
					var sl = jQuery('#site-logo'); var sidr = jQuery('#sidr');
					var firstLi = jQuery('#main-nav li').first(); console.log('firstLi left: ' + firstLi.offset().left);
					var lastLi = jQuery('#main-nav li').last();  console.log('lastLi right: ' + lastLi.offset().left + lastLi.width());
					var navbarWidth = (lastLi.offset().left + lastLi.width()) - firstLi.offset().left; console.log('navbarWidth: ' + navbarWidth);
					var rightSideOfSlogan = sl.offset().left + sl.width(); console.log('rightSideOfSlogan: ' + rightSideOfSlogan);
					var availableSpace = SASLogo.offset().left - rightSideOfSlogan;
					var leftMove = ((availableSpace - navbarWidth) * 0.5 - 20) + 'px';
// 					console.log('sidr.offset().left: ' + sidr.offset().left + ", sidr.width(): " + sidr.width() + ', SASLogo.offset().left: ' + SASLogo.offset().left);
					console.log('left move: ' + leftMove);
					sidr.delay(20).animate({'left':leftMove}, 250);
				}
			); //.delay(2000).animate({'top':'15px'}, 1500);
			
			jQuery('#AndroidLogo').height(jQuery('#AppleLogo').height()).css('margin-top', '-1px'); // only matters on Home and About pages, makes App Store logos the same height

		}
// 	setTimeout(function(){ jQuery('#SASLogo').css({'background':'url(' + logoBackground + ')', 'background-size':'cover'}); }, 3750); // logo looks ragged after being moved

		checkSizes();
	}, 250); });

	if (wURL.indexOf('/map') > 0) {
		console.log('map');
		jQuery('#footerwrap').css('top', jQuery(window).height() + 'px');
		var body = jQuery('#body');
		jQuery('#body').prepend(jQuery('#mapholder')).css('margin-top', 0).height(jQuery('#mapholder').height());
		var mapholder = jQuery('#mapholder');
		mapholder.height(jQuery(window).height() * 0.7);
// 		body.css('top', jQuery('#headerwrap').offset().top + jQuery('#headerwrap').height() + 'px');
		console.log('pre doMap()');
		jQuery('#footerwrap').fadeTo(1500, 1).css({'width':'100%'}).css('border-top', '2px solid #000');
		jQuery('#footerwrap').css({'position':'absolute'}).delay(2000).animate({'top':(jQuery('#mapholder').offset().top + jQuery('#mapholder').height() - 34) + 'px'}, 500);
		setTimeout(doMap, 500);
		jQuery('#body').delay(500).fadeTo(1000, 1);
		bodyFooterLoaded = true;
	} else jQuery('#mapholder').hide();
	if (wURL.indexOf('/mapx') > 0) {
		console.log('mapx');
		jQuery('#header').remove();
		jQuery('#footerwrap').remove();
		jQuery('h1.page-title').remove();
		jQuery('#mapholder').height(jQuery(window).height());
	}
	if (wURL.indexOf('/gallery') > 0) {
		console.log('gallery');
// 		jQuery('#footerwrap').css('top', jQuery(window).height() + 'px');
		jQuery('#body').prepend(jQuery('#masonryWall'));
		fillMasonryDivs(defib, alreadyInserted, defib.length, columnCount, 150);
// 		setTimeout(doMap, 500);
		jQuery('#body').delay(500).fadeTo(1000, 1).css('background', '#ccc');
		jQuery('#footerwrap').css({'border-top':'2px solid #000', 'top':jQuery(window).height() + 'px'});
		bodyFooterLoaded = true;
	} else jQuery('#masonryWall').hide();

	if (wURL.indexOf('/about') > 0) {
		jQuery('#layout').css('width', '80%').css('margin', '0 auto');
		jQuery('#body').delay(500).fadeTo(1000, 1);
		jQuery('#footerwrap').css('padding-top', '20px').fadeTo(1500, 1);
		bodyFooterLoaded = true;
		jQuery('.col4-3.first').css('margin-top', '50px').css('padding-right', '50px');
		jQuery('.col4-1.last').css('margin-top', '24px');
	}

	if (wURL.indexOf('/partners') > 0) {
		jQuery('#layout').css('width', '80%').css('margin', '0 auto');
		jQuery('#body').delay(500).fadeTo(1000, 1);
		jQuery('#content').css('padding-top', '40px');
		jQuery('#footerwrap').css('padding-top', '20px').fadeTo(1500, 1);
		bodyFooterLoaded = true;
	}

	if (!bodyFooterLoaded) {
		homePage = true; checkSizes();
	}
	jQuery('#SASLogo').append(jQuery('.social-widget')).delay(1500).fadeTo(1000, 1);
// 	jQuery('#SASLogo').delay(1500).fadeTo(1000, 1);
	jQuery('.social-widget').delay(1500).fadeTo(1000, 1);
});

function checkSizes() {
	if (!homePage) return;
	console.log('checkSizes');
// 	jQuery('#image-2-0-1-0').css('text-align','right');
	bodyFooterLoaded = true;
	var wW = jQuery('body').width(); var pixPerRow = homePageMax / homePageRows;
	var instagramImages = jQuery('#instagramImages'); instagramImages.width(wW + pixPerRow);
	jQuery('.squareThumb').css('opacity', firstSizeCheck ? 0 : 0.25);
	var mg = (instagramImages.width() - wW) * 0.5 + 'px';
// 		console.log('home (' + mg + ', ' + instagramImages.width() + ', ' + jQuery('body').width() + ')');
	jQuery('.squareThumb').width((Math.floor(wW / pixPerRow) - 0));
	console.log("home page max: " + homePageMax + ", rows: " + homePageRows + ', jQuery(.squareThumb).width(): ' + jQuery('.squareThumb').width());
	instagramImages.width(jQuery(window).width() * 1.05);
	jQuery('#instagramHolder').insertBefore('#body');
	instagramImages.css('margin-left', '-' + mg + 'px').css('margin-right', mg + 'px').height(jQuery('.squareThumb').width() * homePageRows);
	jQuery('#instagramHolder').width(wW); // with no x-overflow
	jQuery('.squareThumb').each(function(index){
		var th = jQuery(this);
		if (index > homePageMax) th.hide();
		setTimeout(function(){
			th.animate({'height':th.width() + 'px'}, firstSizeCheck ? 150 : 20).fadeTo(500 + index * (firstSizeCheck ? 120 : 50), 1);
		}, firstSizeCheck ? index * 50 : 30);
	});
	jQuery('#footerwrap').css('top', jQuery(window).height() + 'px');
	setTimeout(function(){
		var topV = jQuery('#body').offset().top + jQuery('#body').height() - 12 + (macComputer || villageIdiot ? 2 : 2);
		if (!clickToAdded) {
			jQuery('#body').append('<div id="clickTo">click image to enlarge, click again to locate</div>');
			jQuery('#clickTo').css({'position':'absolute', 'top': 0, 'right':'-500px', 'font-size':'12px'}).delay(2500).animate({'left':'none', 'right':'30px'}, 1000);
			clickToAdded = true;
		}
		jQuery('#footerwrap').fadeTo(1500, 1).animate({'position':'absolute', 'top': topV + 'px', 'padding-top':'20px'}, 500);
		jQuery('#body').delay(1000).fadeTo(1000, 1).animate({'margin-top': '-18px'}, 100); //.delay((jQuery('.squareThumb').length + 2) * 200).animate({'position':'absolute', 'top':(jQuery('#instagramImages').offset().top + jQuery('#instagramImages').height() + 2) + 'px'}, 1000);
	}, jQuery('.squareThumb').length * 20);
// 	console.log('height of instagram div: ' + jQuery('#instagramImages').height());
// 	if (jQuery('#instagramImages').height() * (153 * homePageRows)) jQuery('.squareThumb').height(149);
	firstSizeCheck = false;
}
</script>
<div id="mapholder">&nbsp;</div>
<div id="masonryWall">&nbsp;</div>
<script src="http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/float.js"></script>

<!-- view-source:http://google-maps-utility-library-v3.googlecode.com/svn/trunk/geolocationmarker/examples/mylocation.html -->
<script src="https://maps.googleapis.com/maps/api/js?sensor=true"></script>
<script src="//google-maps-utility-library-v3.googlecode.com/svn/trunk/geolocationmarker/src/geolocationmarker-compiled.js"></script>

<script src="http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/masonry.js"></script>
<!-- <div id="tapImages">Tap images to enlarge (tap again to close image, or move cursor off image)</div> -->
</body>
</html>
