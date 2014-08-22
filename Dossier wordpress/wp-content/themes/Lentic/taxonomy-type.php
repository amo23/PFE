<?php get_header(); ?>
    
<section class="secmissingle grid-container mainTitle">
	<?php $taxonomy = get_the_terms( $post->ID, 'type' );
							
							foreach ( $taxonomy as $key => $tax ) {
								$name = $tax->name;
							} ?>
	<h1 role="heading" aria-level="1" class="title"><?php _e("Listing des missions $name du Lentic",'theme_lentic'); ?></h1>
	
	<div class="miscontent grid-75 mobile-grid-100">
	
	<h2 role="heading" aria-level="2"><?php _e("Missions $name",'theme_lentic'); ?></h2>
		<ul>
		<?php

					$taxonomy = get_the_terms( $post->ID, 'type' );
							
							foreach ( $taxonomy as $key => $tax ) {
								$cat = $tax->slug;
							}
							

					$args = array(
						'post_type' => 'Missions',
						'tax_query' => array(
							array(
								'taxonomy' => 'type',
								'field' => 'slug',
								'terms' => $cat
							)
						)
					);
        			$the_query = new WP_Query($args);
        			if($the_query->have_posts()): ?>
        			<?php while($the_query->have_posts()): $the_query->the_post(); ?>
					<li><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></li>
					
				<?php endwhile;  ?>
                 <?php wp_reset_postdata(); ?>
                 <?php endif; ?>
          </ul>
	</div>
<aside class="miscat grid-25 mobile-grid-100">
	<div class="cattype">
		<h2 role="heading" aria-level="2"><?php _e("Trier par catégorie",'theme_lentic'); ?></h2>
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

</section>
    
<?php get_footer();?>