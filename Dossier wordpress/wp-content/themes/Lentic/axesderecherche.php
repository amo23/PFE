   <?php 
/*
Template Name: Axes
*/
  ?>
 <?php get_header(); ?>
 
 	<!-- <div class="grid-container"><div class="grid-100"><?php if ( function_exists('yoast_breadcrumb') ) { yoast_breadcrumb('<p id="breadcrumbs">','</p>');} ?></div></div> -->

    <section class="mainTitle">
    
    <h1 role="heading" aria-level="1" class="title"><?php echo fr_texturize(get_field('titre_principal')); ?></h1>
    
    <section class="axes">
        <div class="axesDiv grid-container">
            <div class="left grid-50 mobile-grid-100">
                <h2 role="heading" aria-level="2"><?php echo fr_texturize(get_field('titre_1_gauche')); ?></h2>
                <?php echo wp_get_attachment_image(get_field('image_1_gauche'), 'axes'); ?>
            </div>

            <div class="right grid-50 mobile-grid-100">
                <?php echo fr_texturize(get_field('intro_1_gauche')); ?>
                <?php echo fr_texturize(get_field('liste_1_gauche')); ?>
            </div>
        </div>
    </section>

    <section class="axes">
        <div class="axesDiv grid-container">
        
        <div class="left grid-50 mobile-grid-100">
            <h2 role="heading" aria-level="2"><?php echo fr_texturize(get_field('titre_2_droite')); ?></h2>
            <?php echo wp_get_attachment_image(get_field('image_2_droite'), 'axes'); ?>
        </div>
        <div class="right grid-50 mobile-grid-100">
            <?php echo fr_texturize(get_field('intro_2_droite')); ?>
            <?php echo fr_texturize(get_field('liste_2_droite')); ?>
        </div>
        
        
        </div>
    </section>

    <section class="axes">
        <div class="axesDiv grid-container">
        <div class="left grid-50 mobile-grid-100">
            <h2 role="heading" aria-level="2"><?php echo fr_texturize(get_field('titre_3_gauche')); ?></h2>
            <?php echo wp_get_attachment_image(get_field('image_3_gauche'), 'axes'); ?>
        </div>
        <div class="right grid-50 mobile-grid-100">
            <?php echo fr_texturize(get_field('intro_3_gauche')); ?>
            <?php echo fr_texturize(get_field('liste_3_gauche')); ?>
        </div>
        
        
        </div>
    </section>

    <section class="axes">
        <div class="axesDiv grid-container">
        <div class="left grid-50 mobile-grid-100">
            <h2 role="heading" aria-level="2"><?php echo fr_texturize(get_field('titre_4_droite')); ?></h2>
            <?php echo wp_get_attachment_image(get_field('image_4_droite'), 'axes'); ?>
        </div>
        <div class="right grid-50 mobile-grid-100">
            <?php echo fr_texturize(get_field('intro_4_droite')); ?>
            <?php echo fr_texturize(get_field('liste_4_droite')); ?>
        </div>
        
        
        </div>
    </section>

    <div class="grid-container axes"><div class="grid-100 pfin"><?php echo fr_texturize(get_field('texte_fin')); ?></div></div>
    </section>
    <?php get_footer();?>