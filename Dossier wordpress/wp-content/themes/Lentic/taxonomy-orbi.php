<?php get_header(); ?>
    
<section class="secmissingle grid-container mainTitle">
	<?php $taxonomy = get_the_terms( $post->ID, 'orbi' );
							
							foreach ( $taxonomy as $key => $tax ) {
								$name = $tax->name;
							} ?>
	<h1 role="heading" aria-level="1" class="title"><?php _e("Listing des publications $name du Lentic",'theme_lentic'); ?></h1>
	
	<div class="miscontent grid-75 mobile-grid-100">
	
	<h2 role="heading" aria-level="2"><?php _e("Publications $name",'theme_lentic'); ?></h2>
		<ul>
			<?php 
					
						
						foreach($wpdb->get_results('SELECT title,lien,contenu FROM orbi_post', OBJECT) as $oResult){
       
					        foreach (explode('-', $oResult->contenu) as $sCatego) {
					            $splitcatego = trim($sCatego, " ");
					            
					            /*

					            $sCatego = explode(',', $sCatego);
					            $splitcatego = trim($aAuteur[1], " ");
					            $sSlug = $splitcatego;
					            
*/
					         
						 if( $splitcatego === $name ){
					                
					            ?>
					                <li><a href="<?php echo( $oResult->lien );?>"><?php echo( $oResult->title );?></a></li>
					            <?php
					                
					            }
					        }
					    }
						?>
          </ul>
	</div>
<aside class="miscat grid-25 mobile-grid-100">
	<div class="cattype">
		<h2 role="heading" aria-level="2"><?php _e("Trier par catégorie",'theme_lentic'); ?></h2>
		<?php 

				$post_type		= 'Orbi';
				$taxonomy		= 'orbi';
				$orderby			= 'ASC';
				$show_count		= 0;
				$hide_empty		= 0;
				$pad_counts		= 0;
				$hierarchical	        = 1;
				$exclude			= '55';
				$title				= '';
				
					$args = array(
						'post_type'		=> $post_type,
						'taxonomy'		=> $taxonomy,
						'orderby'			=> $orderby,
						'show_count'		=> $show_count,
						'hide_empty'		=> $hide_empty,
						'pad_counts'		=> $pad_counts,
						'hierarchical'	        => $hierarchical,
						'exclude'			=> $exclude,
						'title_li'			=> $title
					);
				
				?>
	        	<ul><?php wp_list_cats($args);?></ul>
	</div>
	<a class="calltoactionmissions callpersonne" href="<?php echo get_post_type_archive_link( 'publications' ); ?>"><?php _e("Toutes les publications du Lentic",'theme_lentic'); ?></a>
</aside>

</section>
    
<?php get_footer();?>