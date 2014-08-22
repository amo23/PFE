<!doctype html>
<html <?php language_attributes(); ?>>
<head>
	<meta charset="<?php bloginfo( 'charset' ); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<?php echo get_stylesheet_uri() ?>">
    <!--[if (gt IE 8) | (IEMobile)]><!-->
	  <link rel="stylesheet" href="<?php bloginfo('template_url'); ?>/css/unsemantic-grid-responsive.css" />
	<!--<![endif]-->
	<!--[if (lt IE 9) & (!IEMobile)]>
	  <link rel="stylesheet" href="<?php bloginfo('template_url'); ?>/css/ie.css" />
	<![endif]-->

    <!--[if (lt IE 9)]>
		<script src="<?php bloginfo('template_url')?>/js/html5shiv.min.js" type="text/javascript"></script>
	<![endif]-->
	<!--[if (gte IE 6)&(lte IE 9)]>
    	<script src="<?php bloginfo('template_url') ?>/js/selectivizr-min.js"></script>
	<![endif]-->
	<link rel="apple-touch-icon" sizes="57x57" href="<?php bloginfo('template_url'); ?>/img/favicons/apple-touch-icon-57x57.png">
	<link rel="apple-touch-icon" sizes="114x114" href="<?php bloginfo('template_url'); ?>/img/favicons/apple-touch-icon-114x114.png">
	<link rel="apple-touch-icon" sizes="72x72" href="<?php bloginfo('template_url'); ?>/img/favicons/apple-touch-icon-72x72.png">
	<link rel="apple-touch-icon" sizes="144x144" href="<?php bloginfo('template_url'); ?>/img/favicons/apple-touch-icon-144x144.png">
	<link rel="apple-touch-icon" sizes="60x60" href="<?php bloginfo('template_url'); ?>/img/favicons/apple-touch-icon-60x60.png">
	<link rel="apple-touch-icon" sizes="120x120" href="<?php bloginfo('template_url'); ?>/img/favicons/apple-touch-icon-120x120.png">
	<link rel="apple-touch-icon" sizes="76x76" href="<?php bloginfo('template_url'); ?>/img/favicons/apple-touch-icon-76x76.png">
	<link rel="apple-touch-icon" sizes="152x152" href="<?php bloginfo('template_url'); ?>/img/favicons/apple-touch-icon-152x152.png">
	<link rel="icon" type="image/png" href="<?php bloginfo('template_url'); ?>/img/favicons/favicon-196x196.png" sizes="196x196">
	<link rel="icon" type="image/png" href="<?php bloginfo('template_url'); ?>/img/favicons/favicon-160x160.png" sizes="160x160">
	<link rel="icon" type="image/png" href="<?php bloginfo('template_url'); ?>/img/favicons/favicon-96x96.png" sizes="96x96">
	<link rel="icon" type="image/png" href="<?php bloginfo('template_url'); ?>/img/favicons/favicon-16x16.png" sizes="16x16">
	<link rel="icon" type="image/png" href="<?php bloginfo('template_url'); ?>/img/favicons/favicon-32x32.png" sizes="32x32">
	<meta name="msapplication-TileColor" content="#da532c">
	<meta name="msapplication-TileImage" content="/mstile-144x144.png">
    <?php wp_head(); ?>
</head>

<body <?php body_class();?>>

    <header role="banner" itemtype="http://schema.org/Corporation" itemscope="">
    	
        <div id="firstline" class="grid-container">
      
	        <h1 class="grid-30 mobile-grid-100" role="heading" aria-level="1">
	            <a href="<?php bloginfo('url')?>">
	            
	            	<?php if( ICL_LANGUAGE_CODE == 'fr' ) {
					    	 echo wp_get_attachment_image(get_field('logo_site','option'), 'full',false,array('class' => "svglogosize",'itemprop' => 'logo')); 
					} else {
					   	echo wp_get_attachment_image(get_field('logo_site_en','option'), 'full',false,array('class' => "svglogosize",'itemprop' => 'logo')); 
					}
	            
		           	?>
				</a>
			</h1>
			<div class="grid-65 mobile-grid-100">	 
				<form method="get" id="searchform" action="<?php echo esc_url( home_url( '/' ) ); ?>" role="search">
				        
				        <label class="hidden" for="search">Moteur de recherches</label>
				        <div class="formpose">
					        <input type="text" id="search" placeholder="<?php _e("Votre recherche",'theme_lentic'); ?>" name="s" value="<?php echo esc_attr( get_search_query() ); ?>"/>
							<input class="imgloupe" type="submit" id="sub" value=" ">
				        </div>
				    </form>
			
            </div>
            <div id="header_language_list" class="grid-5 mobile-grid-100"><?php language_selector(); ?></div>
        </div>
        <nav class="nav clearfix" role="navigation">
        		<h1 role="heading" aria-level="1" class="hidden">Navigation du site</h1>
                <?php wp_nav_menu( array( 'theme_location' => 'menu header', 'container_class' => 'grid-container' ) ); ?>
                <a href="#" id="pull">Menu</a>
        </nav>
        
    </header>
   
    
	<div role="main">
	
	<div class="grid-container ariane"><div class="grid-100"><?php if ( function_exists('yoast_breadcrumb') ) { yoast_breadcrumb('<p id="breadcrumbs">','</p>');} ?></div></div>