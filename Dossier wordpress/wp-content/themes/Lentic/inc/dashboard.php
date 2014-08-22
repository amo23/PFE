<?php

function wpc_dashboard_widget_missions() {

		$the_query = new WP_Query( array( 'post_type' => 'missions', 'posts_per_page' => 5 ) );

		if ( $the_query->have_posts() ) :

			$display = '<ul>';

			while ( $the_query->have_posts() ) : 
				$the_query->the_post();

            	$nWords = 250;
            	$description = '';
            	$last_space = '';
            	$content = get_the_content();
            	$title = get_the_title();

            	

					$description = substr( $content, 0, $nWords );
					$last_space = strrpos( $description, ' ' );
					$description = substr( $description, 0, $last_space ).'&nbsp;...';
				
				

				$display = $display . "<li style='border-bottom: 1px solid #eee; padding: 10px 0;'><article itemscope itemprop='http://schema.org/BlogPosting'>" .
						"<h4 itemprop='name'><a href='". get_the_permalink() . 
		        		"' title='Voir cette mission en d&eacute;tail'>" . 
							$title . 
						"</a></h4>" .
						"<p itemprop='description'>" .
							$description . 
						"</p>" .
					"</article></li>"
				;

			endwhile;

			$display = $display . '</ul>' .
						'<hr />' .
	        			'<a href="' . admin_url() . 'post-new.php?post_type=missions" title="Ajouter une nouvelle mission" class="btn button-primary">' .
	        				'Ajouter une mission' .
	        			'</a>' 
			;

		else :

			$display = 
						"<p>
							Aucune actualit&eacute;
						</p>" .
						'<hr />' .
	        			'<a href="' . admin_url() . 'post-new.php?post_type=missions" title="Ajouter une nouvelle mission" class="btn button-primary">' .
	        				'Ajouter une mission' .
	        			'</a>'
			;

		endif;

		echo $display;
	}
	
function wpc_dashboard_widget_equipe() {

		$the_query = new WP_Query( array( 'post_type' => 'equipe', 'posts_per_page' => 5 ) );

		if ( $the_query->have_posts() ) :

			$display = '<ul>';

			while ( $the_query->have_posts() ) : 
				$the_query->the_post();

            	$nWords = 100;
            	$description = '';
            	$last_space = '';
            	$content = get_the_content();
            	$title = get_the_title();

            	if ( strlen( $content ) > $nWords ) {

					$description = substr( $content, 0, $nWords );
					$last_space = strrpos( $description, ' ' );
					$description = substr( $description, 0, $last_space ).'&nbsp;...';
				}

				$display = $display . "<li style='border-bottom: 1px solid #eee; padding: 10px 0;'><article itemscope itemprop='http://schema.org/BlogPosting'>" .
						"<h4 itemprop='name'><a href='". get_the_permalink() . 
		        		"' title='Voir cette mission en d&eacute;tail'>" . 
							$title . 
						"</a></h4>" .
						"<p itemprop='description'>" .
							$description . 
						"</p>" .
					"</article></li>"
				;

			endwhile;

			$display = $display . '</ul>' .
						'<hr />' .
	        			'<a href="' . admin_url() . 'post-new.php?post_type=equipe" title="Ajouter une nouvelle personne" class="btn button-primary">' .
	        				'Ajouter une personne' .
	        			'</a>' 
			;

		else :

			$display = 
						"<p>
							Aucune actualit&eacute;
						</p>" .
						'<hr />' .
	        			'<a href="' . admin_url() . 'post-new.php?post_type=equipe" title="Ajouter une nouvelle personne" class="btn button-primary">' .
	        				'Ajouter une personne' .
	        			'</a>'
			;

		endif;

		echo $display;
	}

function wpc_dashboard_widget_actualites() {

		$the_query = new WP_Query( array( 'post_type' => 'Actualites', 'posts_per_page' => 5 ) );

		if ( $the_query->have_posts() ) :

			$display = '<ul>';

			while ( $the_query->have_posts() ) : 
				$the_query->the_post();

            	$nWords = 100;
            	$description = '';
            	$last_space = '';
            	$content = get_the_content();
            	$title = get_the_title();

            	if ( strlen( $content ) > $nWords ) {

					$description = substr( $content, 0, $nWords );
					$last_space = strrpos( $description, ' ' );
					$description = substr( $description, 0, $last_space ).'&nbsp;...';
				}

				$display = $display . "<li style='border-bottom: 1px solid #eee; padding: 10px 0;'><article itemscope itemprop='http://schema.org/BlogPosting'>" .
						"<h4 itemprop='name'><a href='". get_the_permalink() . 
		        		"' title='Voir cette actualité en d&eacute;tail'>" . 
							$title . 
						"</a></h4>" .
						"<p itemprop='description'>" .
							$description . 
						"</p>" .
					"</article></li>"
				;

			endwhile;

			$display = $display . '</ul>' .
						'<hr />' .
	        			'<a href="' . admin_url() . 'post-new.php?post_type=Actualites" title="Ajouter une nouvelle actualité" class="btn button-primary">' .
	        				'Ajouter une actualité' .
	        			'</a>' 
			;

		else :

			$display = 
						"<p>
							Aucune actualit&eacute;
						</p>" .
						'<hr />' .
	        			'<a href="' . admin_url() . 'post-new.php?post_type=Actualites" title="Ajouter une nouvelle actualité" class="btn button-primary">' .
	        				'Ajouter une actualité' .
	        			'</a>'
			;

		endif;

		echo $display;
	}

function wpc_add_dashboard_widgets() {

		wp_add_dashboard_widget( 'wp_dashboard_widget_missions', 'Les dernières missions', 'wpc_dashboard_widget_missions' );
		wp_add_dashboard_widget( 'wp_dashboard_widget_equipe', 'Les dernières personnes au Lentic', 'wpc_dashboard_widget_equipe' );
		wp_add_dashboard_widget( 'wp_dashboard_widget_actualites', 'Les dernières actualités du Lentic', 'wpc_dashboard_widget_actualites' );
	}

	add_action( 'wp_dashboard_setup', 'wpc_add_dashboard_widgets' );