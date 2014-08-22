<?php

	include('inc/dashboard.php');  
	
    add_action( 'init', 'create_post_type' );

    register_nav_menu('menu header',__( 'menu header' ));
    register_nav_menu('menu missions',__( 'menu missions' ));
    
    // Fonction qui insere le lien vers le css qui surchargera celui d'origine
	function custom_login_css()  {
	    echo '<link rel="stylesheet" type="text/css" href="' . get_bloginfo('template_directory') . '/css/style-login.css" />';
	}
	add_action('login_head', 'custom_login_css');
    
    function create_post_type() {
                
    
        register_post_type( 'Equipe',
            array(
                'labels' => array(
                    'name' => __( 'Equipe' ),
                    'singular_name' => __( 'Equipe' )
                ),
            'public' => true,
            'has_archive' => true,
            'supports' => array('title', 'editor','excerpt','custom_fields')
            )
        );
        
        register_taxonomy( 'equipe', 'equipe', array( 'hierarchical' => true, 'label' => 'Team', 'query_var' => true, 'rewrite' => true ) );
        
        register_post_type( 'Missions',
            array(
                'labels' => array(
                    'name' => __( 'Missions' ),
                    'singular_name' => __( 'Missions' )
                ),
            'public' => true,
            'has_archive' => true,
            'supports' => array('title', 'editor','excerpt','custom_fields')
            )
        );
        
         register_taxonomy( 'type', 'missions', array( 'hierarchical' => true, 'label' => 'Type', 'query_var' => true, 'rewrite' => true ) );  
		 register_taxonomy( 'personnes', 'missions', array( 'hierarchical' => true, 'label' => 'Personnes', 'query_var' => true, 'rewrite' => true ) );
		 
		 register_post_type( 'Actualites',
	        array(
	            'labels' => array(
	                'name' => __( 'Actualités' ),
	                'singular_name' => __( 'Actualités' )
	            ),
	        'public' => true,
	        'has_archive' => true,
	        'supports' => array('title', 'editor','excerpt','custom_fields')
	        )
	    );
	    
	    register_post_type( 'Publications',
            array(
                'labels' => array(
                    'name' => __( 'Publications' ),
                    'singular_name' => __( 'Publications' )
                ),
            'public' => true,
            'has_archive' => true,
            'supports' => array('title', 'editor','excerpt','custom_fields')
            )
        );
        
         register_taxonomy( 'orbi', 'publications', array( 'hierarchical' => true, 'label' => 'orbi', 'query_var' => true, 'rewrite' => true ) );  
    }
            
	if ( function_exists( 'add_image_size' ) ) { 
		/*
add_image_size( 'icons', 48, 48, true );
		add_image_size( 'logo', 310, 95, true );
		add_image_size( 'photosize', 90, 90, true );
*/
add_image_size( 'axes', 400, 267, true );
add_image_size( 'logo', 287, 90, true );
add_image_size( 'equipe', 90, 90, true );
add_image_size( 'fiche', 180, 180, true );
add_image_size( 'map', 550, 329, true );
	}
	
	function cc_mime_types( $mimes ){
		$mimes['svg'] = 'image/svg+xml';
		return $mimes;
	}
	add_filter( 'upload_mimes', 'cc_mime_types' );
	

	function language_selector(){
	$languages = icl_get_languages('skip_missing=0&orderby=code');
	if(!empty($languages)){
			foreach($languages as $l){
				if(!$l['active']) { echo '<a href="'.$l['url'].'"> ';
				echo '<img src="'.$l['country_flag_url'].'" alt="Drapeau menant vers la langue '.$l['language_code'].'" width="48" height="38" />';
				if(!$l['active']) echo '</a>';
			}
		}
	}
}



	






