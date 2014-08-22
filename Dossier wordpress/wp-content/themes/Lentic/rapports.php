   <?php 
/*
Template Name: rapports
*/
  ?>
 <?php get_header(); ?>
 
 
 
    <section class="secrapport grid-container mainTitle">
        <h1 role="heading" aria-level="1" class="title"><?php the_title();?></h1>
        <p><?php echo fr_texturize(get_field('intro'));?></p>
        <ul>
        <?php
		if( have_rows('rapport') ):
		 
		 	
		    while ( have_rows('rapport') ) : the_row(); ?>
		    			    
					
					<li>
						<span class="grid-33"><?php the_sub_field('nom_du_rapport');?></span>
						<span class="grid-33"><?php the_sub_field('date_du_rapport');?></span>
						<span class="grid-33"><a href="<?php the_sub_field('fichier_rapport');?>" target="_blank">Visualiser le rapport</a></span>
					</li>
           
			    
		<?php
		    endwhile;
		else :
		endif;
		?>
         </ul>
  
    </section>

    <?php get_footer();?>