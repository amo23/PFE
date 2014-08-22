<footer class="grid-100" role="contentinfo" itemtype="http://schema.org/Corporation" itemscope="">
        <div class="seccoord grid-container">
            
	            <div class="vcard infosdiv3 imgmap grid-25" itemprop="contactPoints">
	                
	                <h1 role="heading" aria-level="1" ><?php _e("Coordonnées",'theme_lentic'); ?></h1>
	                <p class="fn">Lentic</p>
	                <p class="adr" itemprop="address" itemtype="http://schema.org/PostalAddress" itemscope="">
	                	<span class="street-address" itemprop="streetAddress"><?php echo fr_texturize(get_field('adresse','options'));?></span><br/>
	                	<span class="postal-code" itemprop="postalCode"><?php echo fr_texturize(get_field('cp','options'));?></span>
	                	<span class="locality" itemprop="addressLocality"><?php echo fr_texturize(get_field('localite','options'));?></span>
	                	<span class="country-name" itemprop="addressCountry" content="FR"><?php echo fr_texturize(get_field('pays','options'));?></span>
	                </p>
	                <p class="tel" itemprop="telephone"><?php echo fr_texturize(get_field('tel','options'));?></p>
	                <p class="tel" itemprop="faxNumber"><?php echo fr_texturize(get_field('fax','options'));?></p>
	                <p class="email" itemprop="email">Email : <a href="mailto:<?php echo fr_texturize(get_field('email','options'));?>"><?php echo fr_texturize(get_field('email','options'));?></a></p>
	                 <div class="partenaires">
		            <a href="http://www.hec.ulg.ac.be/"><img src="<?php echo get_bloginfo('template_url') ?>/img/hec-ulg.png" alt="Logo École de gestion de l'Université de Liège" width="180" height="52"></a>
					<a href="http://www.ulg.ac.be/"><img src="<?php echo get_bloginfo('template_url') ?>/img/ulg.png" alt="Logo Université de Liège" width="72" height="52"></a>
					
	            </div>
	            
	            </div>
	      
				<div class="map gmap grid-50" id="gmap">
				
						<?php 
					$location = get_field('map', 'option'); 
					if( !empty($location) ):
					?>
					<a href="https://www.google.be/maps/search/lentic/@50.5811237,5.5610659,17z?hl=fr">
						<img src="<?php echo get_bloginfo('template_url') ?>/img/map.png" width="550" height="329" alt="Carte Google Map indiquant le lieu du Lentic">
					</a>
					<?php endif; ?>
				</div>
				
				<nav class="navbas grid-25">
					<h1 role="heading" aria-level="1" class="hidden">Navigation bas du site</h1>
		            <?php wp_nav_menu( array( 'theme_location' => 'menu header' ) ); ?>
		            <a class="mapsite" href="http://lentic.be/?p=364"><?php _e("Plan du site",'theme_lentic'); ?></a>
		            <a href="#" id="isAccessible"><?php _e("Version du site pour malvoyants",'theme_lentic'); ?></a>
	            </nav>
	            
	            
	          
	            
            
        </div>
        
    </footer>
    <div class="signature">
	                <a href="http://amaury-renard.be/" target="_blank">Powered &amp; designed by Amaury Renard</a>
	                <a href="http://www.hec.ulg.ac.be/" target="_blank"> | HEC ULg © 2014</a>
	            </div>
    </div>
    <script src="<?php bloginfo('template_url'); ?>/js/jquery.js"></script>
    <script src="<?php bloginfo('template_url'); ?>/js/jquery.cookie.js"></script>
    <script src="<?php bloginfo('template_url'); ?>/js/script.js"></script>
    <script src="<?php bloginfo('template_url'); ?>/js/menu.js"></script>
    <script src="<?php bloginfo('template_url'); ?>/js/modernizr.js"></script>
    <script>
if(!Modernizr.svg) {
    $('img[src*="svg"]').attr('src', function() {
        return $(this).attr('src').replace('.svg', '.png');
    });
}
</script>
    <script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-48159356-1', 'lentic.be');
  ga('send', 'pageview');

</script>
    <?php wp_footer(); ?>
</body>
</html>