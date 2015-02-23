<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" <?php echo themify_get_html_schema(); ?> <?php language_attributes(); ?>>
<head>
<?php
/** Themify Default Variables
 @var object */
	global $themify; ?>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<title itemprop="name"><?php wp_title( '' ); ?></title>

<?php if(!themify_check('setting-shortcode_css')){ ?>
	<link rel="stylesheet" href="<?php echo get_template_directory_uri(); ?>/themify/css/shortcodes.css" type="text/css" media="screen" />
<?php } ?>

<?php
/**
 *  Stylesheets and Javascript files are enqueued in theme-functions.php
 */
?>

<!-- wp_header -->
<?php wp_head(); ?>

</head>

<body <?php body_class(); ?>>
<?php themify_body_start(); // hook ?>

	<div id="headerwrap">
    
		<?php themify_header_before(); // hook ?>

		<header id="header" class="pagewidth clearfix">

			<?php themify_header_start(); // hook ?>

			<hgroup>
				<img src="http://www.saveaselfie.org/wp/wp-content/uploads/2014/11/OM_AMBULANCE-CORPS_01_b.jpg" id="site-logo-logo">
				<?php echo themify_logo_image('site_logo'); ?>
			</hgroup>

			<a id="menu-icon" href="#sidr"><i class="fa fa-list-ul icon-list-ul"></i></a>
			<nav id="sidr">
				<?php themify_theme_main_menu(); ?>
				<!-- /#main-nav --> 
			</nav>
			<div class="social-widget" style="opacity: 1; display: block;">
					<div id="themify-social-links-2" class="widget themify-social-links">
						<ul class="social-links horizontal">
							<li class="social-link-item twitter image-icon icon-medium">
								<a href="https://twitter.com/@saveaselfie" title="Twitter"> <img src="http://iculture.info/saveaselfie/wp-content/themes/magazine/themify/img/social/twitter.png"> </a>
							</li>
							<!-- /themify-link-item -->
							<li class="social-link-item facebook image-icon icon-medium">
								<a href="https://www.facebook.com/#!/pages/Save-A-Selfie/1426078984328999" title="Facebook"> <img src="http://iculture.info/saveaselfie/wp-content/themes/magazine/themify/img/social/facebook.png"> </a>
							</li>
							<!-- /themify-link-item -->
						</ul>
					</div>
			</div><!-- /.social-widget -->

			<?php themify_header_end(); // hook ?>

		</header>
		<!-- /#header -->

        <?php themify_header_after(); // hook ?>
				
	</div>
	<!-- /#headerwrap -->

	<div class="header-widget pagewidth">
		<?php dynamic_sidebar('header-widget'); ?>
	</div>
	<!--/header widget -->

	<?php if( '' != themify_get('setting-breaking_news') ) : ?>
		<?php get_template_part( 'includes/breaking-news'); ?>
	<?php endif; // end breaking news ?>


	<div id="body">
	<?php themify_layout_before(); //hook ?>