$(document).ready(function(){

	// initialise le cookies a false;
	isAccessible = false;

	// au chargement de la page on vérifie si un cookie isAccessible existe
	if($.cookie('isAccessible') == 'true') {
		
		// si oui
		// on ajouter la class isAccessible au body qui permet de styliser la page
		$('body').addClass('isAccessible');
		
		// on remplace l'intitulé du lien qui sert maintenant à revenir à la version normal
		$('#isAccessible').text('Retour version normal du site');
		
		// on initialise la variable isAccessible à true;
		isAccessible = true;
	}
	
	// quand on clique sur le lien
	$('#isAccessible').click(function(e){
		e.preventDefault(); /* preventDefault annule le comportement natif des liens */
		
		// on vérifie si on est oui ou non dans la version accessible
		if(isAccessible) {
		
			// si oui ça signifie que l'intitulé du liens est "version normal" et
			// donc que l'ont souhaite quitter la version accessible
			// on supprime donc le cookie en l'initialisant à null
			$.cookie('isAccessible', null);
			
			// on set la variable à isAccessible qui défini le contexte de la page
			// c'est à dire la version accessible ou pas
			isAccessible = false;
			
			// on supprime donc la class isAccessible qui sert à gérer le CSS
			$('body').removeClass('isAccessible');
			
			// On remplace enfin l'intitulé du lien. La prochaine fois que l'on cliquera dessus
			// ca sera pour activer la version accessible, donc sont intitulé doit être "version accessible"
			$('#isAccessible').text('Version du site pour malvoyants');
		} else {
			
			// sinon c'est que l'on est pas dans la version accessible
			// on initialise donc le cookies à true et on lui défini une durée de 7 jours
			$.cookie('isAccessible', true, {expires : 7});
			
			// on spécifie une class CSS qui va nous aider à styliser la version accessible
			$('body').addClass('isAccessible');
			
			// on change l'intitulé du lien car la prochaine fois que l'on cliquera dessus
			// ça sera pour switcher vers la version normal
			$('#isAccessible').text('Retour version normale du site');
			
			// On set la variable isAccessible à true pour situé le contexte de la page
			isAccessible = true;
		}
	})
})