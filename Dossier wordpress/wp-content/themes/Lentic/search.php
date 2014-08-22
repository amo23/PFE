<?php
/**
 * The template for displaying Search Results pages.
 *
 * @package Shape
 * @since Shape 1.0
 */
 
get_header(); ?>



<section class="secsearch grid-container mainTitle">

<?php if ( have_posts() ): ?>
<h1 role="heading" aria-level="1" class="title"><?php _e("Votre résultat pour la recherche&nbsp;:",'theme_lentic'); ?> '<?php echo get_search_query(); ?>'</h1> 
<ol class="grid-100">
<?php while ( have_posts() ) : the_post(); ?>
    <li>
            <h2 role="heading" aria-level="2"><a href="<?php the_permalink(); ?>" title="<?php the_title(); ?>"><?php the_title(); ?></a></h2>
            <time datetime="<?php the_time( 'Y-m-d' ); ?>" pubdate><?php _e("Date de publication de l'article&nbsp;: ",'theme_lentic'); ?><?php the_date(); ?> <?php the_time(); ?></time> 
            <?php the_content(); ?>
    </li>
<?php endwhile; ?>
</ol>
<?php else: ?>
<h1 role="heading" aria-level="1" class="title"><?php _e("Pas de résultats pour&nbsp;: ",'theme_lentic'); ?> '<?php echo get_search_query(); ?>'</h1>
<?php endif; ?>


</section>
<?php get_footer(); ?>