   <?php 
/*
Template Name: event
*/
  ?>
 <?php get_header(); ?>
 
 
 
    <?php if(get_field('titre_section')){ ?>
    <section class="infosconf grid-container mainTitle">
        <div class="infosdivconf imgevent">
                <h1 role="heading" aria-level="1"><?php echo fr_texturize(get_field('titre_section'));?></h1>
                <time><?php echo fr_texturize(get_field('date_event'));?></time>
                <p class="titre"><?php echo fr_texturize(get_field('titre_event'));?></p>
                <p class="lab"><?php echo fr_texturize(get_field('sous_titre_event'));?></p><br/>
        </div> 
    </section>
    <?php } else{?>
	    <section class="grid-container infosconf mainTitle">
		    <h1 role="heading" aria-level="1" class="grid-100 title"><?php _e("Il n'y a aucun événement pour l'instant",'theme_lentic'); ?></h1>
	    </section>
    <?php } ?>

    <?php get_footer();?>