<?php get_header(); ?>


    
<section class="secmissingle grid-container mainTitle">
	
	<h1 role="heading" aria-level="1" class="title"><?php _e("Publications du Lentic",'theme_lentic'); ?></h1>	
	
	<div class="miscontent grid-75 mobile-grid-100">
	<h2 role="heading" aria-level="2"><?php _e("Listing de toutes les publications du Lentic",'theme_lentic'); ?></h2>
	<ul>
	
	<?php $results = $wpdb->get_results( 'SELECT title,lien FROM orbi_post', OBJECT ); ?>
	
	<?php for($i = 0;$i<count($results);$i++){
		$titre = $results[$i]->title;
		$lien = $results[$i]->lien;
		
		?><li><a href="<?php echo $lien; ?>"><?php echo $titre; ?></a></li>
	<?php } ?>
	
	 </ul>
	</div>
	<aside class="miscat grid-25 mobile-grid-100">
	<div class="cattype">
		<h2 role="heading" aria-level="2"><?php _e("Trier par catégorie",'theme_lentic'); ?></h2>
		<?php 

				$post_type		= 'Publications';
				$taxonomy		= 'orbi';
				$orderby			= 'ASC';
				$show_count		= 0;
				$hide_empty		= 0;
				$pad_counts		= 0;
				$hierarchical	        = 1;
				$exclude			= '55';
				$title				= '';
				
					$args = array(
						'post_type'		=> $post_type,
						'taxonomy'		=> $taxonomy,
						'orderby'			=> $orderby,
						'show_count'		=> $show_count,
						'hide_empty'		=> $hide_empty,
						'pad_counts'		=> $pad_counts,
						'hierarchical'	        => $hierarchical,
						'exclude'			=> $exclude,
						'title_li'			=> $title
					);
				
				?>
	        	<ul><?php wp_list_cats($args);?></ul>
	</div>
	</aside>
</section>
    
<?php get_footer();?>