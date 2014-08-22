<?php get_header(); ?>


    
<section class="secmissingle grid-container mainTitle">
	
	<h1 role="heading" aria-level="1" class="title"><?php _e("Listing de toutes les missions du Lentic",'theme_lentic'); ?></h1>
	
	<div class="miscontent grid-75 mobile-grid-100">
	<h2 role="heading" aria-level="2"><?php _e("Missions de recherche",'theme_lentic'); ?></h2>
		<ul>
		<?php
					 
					$args = array(
						'post_type' => 'Missions',
						'tax_query' => array(
							array(
								'taxonomy' => 'type',
								'field' => 'slug',
								'terms' => 'recherche'
							)
						)
					);
        			$the_query = new WP_Query($args);
        			if($the_query->have_posts()): ?>
        			<?php while($the_query->have_posts()): $the_query->the_post(); ?>
					<li><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></li>
				<?php endwhile; ?>
                 <?php wp_reset_postdata(); ?>
                 <?php endif; ?>
                </ul>
	<h2 role="heading" aria-level="2"><?php _e("Missions d'accompagnement",'theme_lentic'); ?></h2>
	<ul>
		<?php
					 
					$args = array(
						'post_type' => 'Missions',
						'tax_query' => array(
							array(
								'taxonomy' => 'type',
								'field' => 'slug',
								'terms' => 'accompagnement'
							)
						)
					);
        			$the_query = new WP_Query($args);
        			if($the_query->have_posts()): ?>
        			<?php while($the_query->have_posts()): $the_query->the_post(); ?>
					<li><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></li>
				<?php endwhile; ?>
                 <?php wp_reset_postdata(); ?>
                 <?php endif; ?>
                 </ul>
	<h2 role="heading" aria-level="2"><?php _e("Missions d'évaluation",'theme_lentic'); ?></h2>
	<ul>
		<?php
					 
					$args = array(
						'post_type' => 'Missions',
						'tax_query' => array(
							array(
								'taxonomy' => 'type',
								'field' => 'slug',
								'terms' => 'evaluation'
							)
						)
					);
        			$the_query = new WP_Query($args);
        			if($the_query->have_posts()): ?>
        			<?php while($the_query->have_posts()): $the_query->the_post(); ?>
					<li><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></li>
				<?php endwhile; ?>
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
</aside>
	
	
</section>
    
<?php get_footer();?>