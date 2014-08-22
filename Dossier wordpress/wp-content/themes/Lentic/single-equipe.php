
<?php get_header(); ?>

<section class="secfiche grid-container mainTitle" itemtype="http://schema.org/Corporation" itemscope="">
	<div class="h-card" itemprop="employee" itemscope="" itemtype="http://schema.org/Person">
		<h1 class="name" role="heading" aria-level="1" itemprop="name"><?php echo fr_texturize(get_field('prenom_nom'));?></h1>
		<div class="coordprof" itemprop="contactPoints">
			<div class="grid-20 mobile-grid-100"><figure class="photo"><?php echo wp_get_attachment_image(get_field('photo'), 'fiche',false,array("alt"=>"","itemprop"=>"image")); ?></figure></div>
			<div class="grid-80 mobile-grid-100">
				<h2 role="heading" aria-level="2"><?php _e("Coordonnées Professionnelles",'theme_lentic'); ?></h2>
				<ul class="grid-50 mobile-grid-100" itemprop="address" itemtype="http://schema.org/PostalAddress" itemscope="">
					<li><span  itemprop="name"><?php echo fr_texturize(get_field('entreprise'));?></span> <br /></li>
					<li><span itemprop="streetAddress"><?php echo fr_texturize(get_field('adresse'));?></span> <br /></li>
					<li><span itemprop="postalCode"><?php echo fr_texturize(get_field('cp'));?> </span><span itemprop="addressLocality"><?php echo fr_texturize(get_field('ville'));?></span></li>
				</ul>
				<ul class="grid-50 mobile-grid-100">
					<li><p><span itemprop="telephone"><?php _e("Téléphone&nbsp;: ",'theme_lentic'); ?><?php echo fr_texturize(get_field('telephone'));?></span></p></li>
					<li><p><span itemprop="faxNumber"><?php _e("Fax&nbsp;: ",'theme_lentic'); ?><?php echo fr_texturize(get_field('fax'));?></span></p></li>
					<li><a href="mailto:<?php echo fr_texturize(get_field('mail'));?>" ><span itemprop="email"><?php echo fr_texturize(get_field('mail'));?></span></a></li>
				</ul>
			</div>
		</div>
		<div class="block">
		<div class="formations grid-33 mobile-grid-100" itemtype="http://schema.org/EducationalOrganization" itemscope="">
			<h2 role="heading" aria-level="2"><?php _e("Formations",'theme_lentic'); ?></h2>
			<ul>
			<?php
				if( have_rows('liste_des_formations') ):
					while ( have_rows('liste_des_formations') ) : the_row();?>
						<li itemprop="name"><?php the_sub_field('formation');?></li><?php
					endwhile;
				else :
				endif;
			?>
			</ul>
		</div>
		<div class="activités grid-33 mobile-grid-100">
			<h2 role="heading" aria-level="2"><?php _e("Activités professionnelles",'theme_lentic'); ?></h2>
			<ul>
			<?php
				if( have_rows('liste_des_activites') ):
					while ( have_rows('liste_des_activites') ) : the_row();?>
						<li itemprop="worksFor"><?php the_sub_field('activite');?></li><?php
					endwhile;
				else :
				endif;
			?>
			</ul>
		</div>
		<?php if(get_field('prenom_nom') != "France Bierbaum" && get_field('prenom_nom') != "Paola Fays"){ 
		
		?>
		<div class="domaines grid-33 mobile-grid-100">
			<h2 role="heading" aria-level="2"><?php _e("Domaines d'expertise",'theme_lentic'); ?></h2>
			<ul>
			<?php
				if( have_rows('liste_des_domaines') ):
					while ( have_rows('liste_des_domaines') ) : the_row();?>
						<li itemprop="jobTitle"><?php the_sub_field('domaine');?></li><?php
					endwhile;
				else :
				endif;
			?>
			</ul>
		</div>
		</div>
		<div class="publications grid-50 mobile-grid-100">
			<h2 role="heading" aria-level="2"><?php _e("Ses dernières publications",'theme_lentic'); ?></h2>
			<ul>
			
							<?php 
					
						$sNomPage = fr_texturize(get_field('prenom_nom'));
						foreach($wpdb->get_results('SELECT title,lien,auteur FROM orbi_post', OBJECT) as $oResult){
       
					        foreach (explode('; ', $oResult->auteur) as $sAuteur) {
					            $aAuteur = explode(',', $sAuteur);
					            $splitprenom = trim($aAuteur[1], " ");
					            $sSlug = $splitprenom.' '.$aAuteur[0];
					            
					           
						 if( $sSlug === $sNomPage ){
					                
					            ?>
					                <li><a href="<?php echo( $oResult->lien );?>"><?php echo( $oResult->title );?></a></li>
					            <?php
					                
					            }
					        }
					    }
						?>
				
				
				
			</ul>
			<a class="calltoactionmissions callpersonne" href="<?php echo get_post_type_archive_link( 'publications' ); ?>"><?php _e("Toutes les publications du Lentic",'theme_lentic'); ?></a>
		</div>
		<div class="missions grid-50 mobile-grid-100">
			<h2 role="heading" aria-level="2"><?php _e("Ses dernières missions",'theme_lentic'); ?></h2>
			<ul>
				<?php
						$key = get_field('listing_missions'); 
						$args = array(
							'post_type' => 'Missions',
							'posts_per_page' => 5,
							'tax_query' => array(
								array(
									'taxonomy' => 'personnes',
									'field' => 'id',
									'terms' => $key
								)
							)
						);
	        			$the_query = new WP_Query($args);
	        			if($the_query->have_posts()): ?>
	        			<?php while($the_query->have_posts()): $the_query->the_post(); ?>
						<li><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></li>
					<?php endwhile; ?>
	                 <?php wp_reset_postdata(); ?>
	                 <?php endif; ?>
			</ul>
			<a class="calltoactionmissions callpersonne" href="<?php echo get_post_type_archive_link( 'missions' ); ?>"><?php _e("Toutes les missions du Lentic",'theme_lentic'); ?></a>
		</div>
		<?php } ?>
	</div>
</section>
    
<?php get_footer();?>