  <?php 
/*
Template Name: Accueil
*/
  ?>

 <?php get_header(); ?>

    <section id="slide" itemtype="http://schema.org/Corporation" itemscope="">
    	<div class="grid-100 bandeau">
	    	<div class="secinfos grid-container">
		    	<h1 role="heading" aria-level="1" class="hidden">Présentation de l'entreprise</h1>
		        <div class="infoslentic" >
		        	<div class="imgqui grid-33 mobile-grid-100" >
		                <h2 role="heading" aria-level="2"><?php echo fr_texturize(get_field('qui'));?></h2>
		                <p itemprop="description"><?php echo fr_texturize(get_field('qui_text'));?></p>
		            </div>
		            <div class="imgquoi grid-33 mobile-grid-100" >
		                <h2 role="heading" aria-level="2"><?php echo fr_texturize(get_field('quoi'));?></h2>
		                <p itemprop="description"><?php echo fr_texturize(get_field('quoi_text'));?></p>
		            </div>
		            <div class="imgap grid-33 mobile-grid-100" >
		                <h2 role="heading" aria-level="2"><?php echo fr_texturize(get_field('approche'));?></h2>
		                <p itemprop="description"><?php echo fr_texturize(get_field('approche_text'));?></p>
		            </div>
		        </div>  
			</div>
		</div>
    </section>
	<section class="secconf grid-100">
        <div class="infosconf grid-container">
        <div class="infosdivconf imgevent grid-100">
        <h2 role="heading" aria-level="2"><?php _e("Actualités",'theme_lentic'); ?></h2>
	<?php
					 
					$args = array(
						'post_type' => 'Actualites',
						'posts_per_page' => 2,
					);
        			$the_query = new WP_Query($args);
        			if($the_query->have_posts()): ?>
        			<?php while($the_query->have_posts()): $the_query->the_post(); ?>
        			<div class="event">
					<time><?php echo fr_texturize(get_field('date_event'));?></time>
                <h3 role="heading" aria-level="3" class="titre"><?php the_title();?></h3>
                <?php the_content();?>
                </div>
				<?php endwhile; ?>
                 <?php wp_reset_postdata(); ?>
                 <?php else: ?>
                 <p><?php _e("Il n'y a aucun événement pour l'instant",'theme_lentic'); ?></p>
                 <?php endif; ?>
                 
                 </div> 
        </div>
    </section>
     <?php get_footer();?>
     
         
                
        
    