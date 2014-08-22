<?php get_header(); ?>
    
<article class="secmissingle grid-container mainTitle" itemtype="http://schema.org/Article" itemscope="" role="article">

<h1 class="title" role="heading" aria-level="1"><?php the_title(); ?></h1>

<div class="miscontent grid-75 mobile-grid-100">
	<h2 role="heading" aria-level="2" itemprop="text"><?php _e("Description",'theme_lentic'); ?></h2>
	<?php the_content(); ?>
	<?php 
										$terms = get_the_terms($post->ID, 'type' );
										if ($terms && ! is_wp_error($terms)) :
											$term_slugs_arr = array();
											foreach ($terms as $term) {
											    $term_slugs_arr[] = $term->slug;
											}
											$terms_slug_str = join( " ", $term_slugs_arr);
										endif;
										
									?>
									<p class="category"><?php _e("Catégorie de cette mission&nbsp;:",'theme_lentic'); ?>  
										<?php echo $terms_slug_str; ?>
									</p>
	<h2 role="heading" aria-level="2"><?php _e("Chercheurs concernés",'theme_lentic'); ?></h2>
	<ul><?php echo get_the_term_list( $post->ID, 'personnes', '<li itemprop="contributor">', '</li><li itemprop="contributor">', '</li>' ); ?></ul>
	<h2 role="heading" aria-level="2"><?php _e("Rapport(s) liés à cette mission",'theme_lentic'); ?></h2>
	<ul>
        <?php
		if( have_rows('rapport') ):
		 
		 	
		    while ( have_rows('rapport') ) : the_row(); ?>
		    		
					<li>
						<a target="_blank" class="pdf" href="<?php the_sub_field('fichier_rapport'); ?>"><img src="<?php echo get_bloginfo('template_url') ?>/img/pdf.svg" width="48" height="48" alt="<?php the_sub_field('nom_du_rapport'); ?>"></a>
					</li>
           
		<?php
		    endwhile;
		else :
		endif;
		?>
         </ul>
	
</div>
<aside class="miscat grid-25 mobile-grid-100">
	<div class="cattype">
		<h2 role="heading" aria-level="2"><?php _e("Trier les missions",'theme_lentic'); ?></h2>
		<?php 

				$post_type		= 'missions';
				$taxonomy		= 'type';
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
	<div class="cattype">
		<h2 role="heading" aria-level="2"><?php _e("Trier par chercheurs",'theme_lentic'); ?></h2>
		<?php 

				$post_type		= 'missions';
				$taxonomy		= 'personnes';
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
	<a class="calltoactionmissions callpersonne" href="<?php echo get_post_type_archive_link( 'missions' ); ?>"><?php _e("Toutes les missions",'theme_lentic'); ?></a>

</aside>
	
</article>
    
<?php get_footer();?>