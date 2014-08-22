   <?php 
/*
Template Name: Missions
*/
  ?>
 <?php get_header(); ?>
 
 

    <section class="secmiss grid-container mainTitle">
    	<div class="grid-100">
        <h1 role="heading" aria-level="1" class="title"><?php _e("Missions et projets",'theme_lentic'); ?></h1>
        <p><?php _e("Le LENTIC se définit avant tout comme un centre de recherche-intervention. Ses missions se déclinent en trois catégories principales, largement inter-reliées&nbsp;:",'theme_lentic'); ?></p>
        <nav class="menu2">
            <?php wp_nav_menu( array( 'theme_location' => 'menu missions' ) ); ?>
        </nav>
		<div>
			<?php if(get_field('titre_mission')){ ?>
            <h2 role="heading" aria-level="2" class="title"><?php echo fr_texturize(get_field('titre_mission')); ?></h2>
            <div class="descriptif">
                <?php echo fr_texturize(get_field('descriptif_mission')); ?>
            </div>
             <?php } ?>
            <div>
            	<?php if(get_field('2e_titre_mission')){ ?>
                <h2 role="heading" aria-level="2" class="title"><?php echo fr_texturize(get_field('2e_titre_mission')); ?></h2>
                <?php } ?>
                <ul class="menu3">
			<?php
					$key = get_field('listing_missions'); 
					$args = array(
						'post_type' => 'Missions',
						'posts_per_page' => 3,
						'tax_query' => array(
							array(
								'taxonomy' => 'type',
								'field' => 'id',
								'terms' => $key
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
		<a class="calltoactionmissions" href="<?php echo get_post_type_archive_link( 'missions' ); ?>"><?php _e("Toutes les missions",'theme_lentic'); ?></a>
            </div>
        </div>
		</div>
    </section>
    
    
     <?php get_footer();?>