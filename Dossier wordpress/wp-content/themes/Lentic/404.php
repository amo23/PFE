<?php
/**
 * The template for displaying 404 pages (Not Found)
 *
 * @package WordPress
 * @subpackage Twenty_Thirteen
 * @since Twenty Thirteen 1.0
 */

get_header(); ?>

	<section class="notfound grid-container mainTitle">
		<h1 role="heading" aria-level="1" class="page-title title"><?php _e( 'Oops&nbsp;! Il semblerait que la page que vous cherchez est inexistante.', 'theme_lentic' ); ?></h1>
		<h2 role="heading" aria-level="2"><?php _e( 'C’est embarrassant n’est-ce pas&nbsp;?', 'theme_lentic' ); ?></h2>
		<p><?php _e( 'Vous pouvez repartir via le menu principal ou effectuer une recherche via la barre de recherche au sommet de la page.', 'theme_lentic' ); ?></p>
	</section>
<?php get_footer(); ?>