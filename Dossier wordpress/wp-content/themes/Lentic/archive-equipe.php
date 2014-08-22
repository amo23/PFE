   <?php 
/*
Template Name: equipe
*/
  ?>
 <?php get_header(); ?>
 
 
 
    <section class="secequipe grid-container mainTitle">
    <div class="grid-100">
        <h1 role="heading" aria-level="1" class="title"><?php echo fr_texturize(get_field('titre'));?></h1>
        <img class="fullequipe" src="<?php echo get_bloginfo('template_url') ?>/img/equipe.jpg" alt="L'équipe du lentic" />
        <p itemprop="description"><?php echo fr_texturize(get_field('intro'));?></p>
        
        <div>
	         <h2 role="heading" aria-level="2"><?php _e("Equipe Académique",'theme_lentic'); ?></h2>
        <ul itemprop="employees" itemtype="http://schema.org/Corporation" itemscope="" >
        <?php
        $args = array(
						'post_type' => 'Equipe',
						'tax_query' => array(
							array(
								'taxonomy' => 'equipe',
								'field' => 'slug',
								'terms' => 'equipe-academique'
							)
						)
					);
        			$the_query = new WP_Query($args);
        			if($the_query->have_posts()): ?>
        			<?php while($the_query->have_posts()): $the_query->the_post(); ?>
					<li class="grid-50 mobile-grid-100" itemprop="employee" itemscope="" itemtype="http://schema.org/Person">
				<a href="<?php the_permalink(); ?>">
					<figure><?php echo wp_get_attachment_image(get_field('photo'), 'equipe',false,array("alt"=>"","itemprop"=>"image")); ?></figure>
					<h3 role="heading" aria-level="3" itemprop="name"><?php echo fr_texturize(get_field('prenom_nom'));?></h3>
					<p itemprop="jobTitle"><?php echo fr_texturize(get_field('role'));?></p>
				</a>
			</li>
				<?php endwhile; ?>
                 <?php wp_reset_postdata(); ?>
                 <?php endif; ?>
		</ul>

        </div>
       
       <div>
	       <h2 role="heading" aria-level="2"><?php _e("Equipe de Recherche",'theme_lentic'); ?></h2>
        <ul itemprop="employees" itemtype="http://schema.org/Corporation" itemscope="" >
        <?php
        $args = array(
						'post_type' => 'Equipe',
						'posts_per_page' => -1,
						'orderby'=> 'title',
						'order' => 'ASC',
						'tax_query' => array(
							array(
								'taxonomy' => 'equipe',
								'field' => 'slug',
								'terms' => 'senior'
							)
						)
					);
        			$the_query = new WP_Query($args);
        			if($the_query->have_posts()): ?>
        			<?php while($the_query->have_posts()): $the_query->the_post(); ?>
					<li class="grid-50 mobile-grid-100" itemprop="employee" itemscope="" itemtype="http://schema.org/Person">
				<a href="<?php the_permalink(); ?>">
					<figure><?php echo wp_get_attachment_image(get_field('photo'), 'equipe',false,array("alt"=>"","itemprop"=>"image")); ?></figure>
					<h3 role="heading" aria-level="3" itemprop="name"><?php echo fr_texturize(get_field('prenom_nom'));?></h3>
					<p itemprop="jobTitle"><?php echo fr_texturize(get_field('role'));?></p>
				</a>
			</li>
				<?php endwhile; ?>
                 <?php wp_reset_postdata(); ?>
                 <?php endif; ?>
        <?php
        $args = array(
						'post_type' => 'Equipe',
						'posts_per_page' => -1,
						'orderby'=> 'title',
						'order' => 'ASC',
						'tax_query' => array(
							array(
								'taxonomy' => 'equipe',
								'field' => 'slug',
								'terms' => 'equipe-de-recherches'
							)
						)
					);
        			$the_query = new WP_Query($args);
        			if($the_query->have_posts()): ?>
        			<?php while($the_query->have_posts()): $the_query->the_post(); ?>
					<li class="grid-50 mobile-grid-100" itemprop="employee" itemscope="" itemtype="http://schema.org/Person">
				<a href="<?php the_permalink(); ?>">
					<figure><?php echo wp_get_attachment_image(get_field('photo'), 'equipe',false,array("alt"=>"","itemprop"=>"image")); ?></figure>
					<h3 role="heading" aria-level="3" itemprop="name"><?php echo fr_texturize(get_field('prenom_nom'));?></h3>
					<p itemprop="jobTitle"><?php echo fr_texturize(get_field('role'));?></p>
				</a>
			</li>
				<?php endwhile; ?>
                 <?php wp_reset_postdata(); ?>
                 <?php endif; ?>
		</ul>

       </div>
       <div>
	       <h2 role="heading" aria-level="2"><?php _e("Equipe Administrative",'theme_lentic'); ?></h2>
        <ul itemprop="employees" itemtype="http://schema.org/Corporation" itemscope="" >
        <?php
        $args = array(
						'post_type' => 'Equipe',
						'tax_query' => array(
							array(
								'taxonomy' => 'equipe',
								'field' => 'slug',
								'terms' => 'equipe-administrative'
							)
						)
					);
        			$the_query = new WP_Query($args);
        			if($the_query->have_posts()): ?>
        			<?php while($the_query->have_posts()): $the_query->the_post(); ?>
					<li class="grid-50 mobile-grid-100" itemprop="employee" itemscope="" itemtype="http://schema.org/Person">
				<a href="<?php the_permalink(); ?>">
					<figure><?php echo wp_get_attachment_image(get_field('photo'), 'equipe',false,array("alt"=>"","itemprop"=>"image")); ?></figure>
					<h3 role="heading" aria-level="3" itemprop="name"><?php echo fr_texturize(get_field('prenom_nom'));?></h3>
					<p itemprop="jobTitle"><?php echo fr_texturize(get_field('role'));?></p>
				</a>
			</li>
				<?php endwhile; ?>
                 <?php wp_reset_postdata(); ?>
                 <?php endif; ?>
		</ul>
       </div>
                

       </div>
    </section>

    <?php get_footer();?>