   <?php 
/*
Template Name: Ressources
*/
  ?>
 <?php get_header(); ?>
 
 

    <section class="secress grid-container mainTitle">
    <div class="grid-100">
	    <h1 role="heading" aria-level="1" class="title"><?php echo fr_texturize(get_field('titre')); ?></h1>
		<p><?php echo fr_texturize(get_field('intro')); ?></p>
    </div>
    
    <div class=""><ul class="divcenter">
    <?php
		if( have_rows('categorie') ):
		 
		 	
		    while ( have_rows('categorie') ) : the_row(); ?>
		    			    
					
					<li class="grid-50 mobile-grid-100">
					<a href="<?php the_sub_field('lien');?>">
					<?php echo wp_get_attachment_image(get_sub_field('image'), 'full',false,array('class' => "svgiconsize")); ?>
                    <h2 role="heading" aria-level="2"><?php the_sub_field('titre');?></h2>
                    </a>
					</li>
            
			    
		<?php
		    endwhile;
		else :
		endif;
		?>
    </ul>
    </div>
    </section>
    
    <?php get_footer();?>