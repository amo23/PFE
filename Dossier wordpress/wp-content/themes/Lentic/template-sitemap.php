<?php
/*
Template Name: Sitemap
*/
?>

<?php get_header(); ?>
<section class="secplandusite grid-container mainTitle">
	<h1 role="heading" aria-level="1" class="title"><?php _e('Plan du site', 'theme_lentic'); ?></h1>
	<div class="grid-100 mobile-grid-100" id="content">
		<h2 role="heading" aria-level="2"><?php _e('Pages', 'theme_lentic'); ?></h2>
		<ul><?php wp_list_pages("title_li=" ); ?></ul>
	</div>
</section>

<?php get_footer(); ?>