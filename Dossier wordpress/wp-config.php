<?php
/**
 * La configuration de base de votre installation WordPress.
 *
 * Ce fichier contient les réglages de configuration suivants : réglages MySQL,
 * préfixe de table, clefs secrètes, langue utilisée, et ABSPATH.
 * Vous pouvez en savoir plus à leur sujet en allant sur 
 * {@link http://codex.wordpress.org/fr:Modifier_wp-config.php Modifier
 * wp-config.php}. C'est votre hébergeur qui doit vous donner vos
 * codes MySQL.
 *
 * Ce fichier est utilisé par le script de création de wp-config.php pendant
 * le processus d'installation. Vous n'avez pas à utiliser le site web, vous
 * pouvez simplement renommer ce fichier en "wp-config.php" et remplir les
 * valeurs.
 *
 * @package WordPress
 */
 


// ** Réglages MySQL - Votre hébergeur doit vous fournir ces informations. ** //
/** Nom de la base de données de WordPress. */
define('DB_NAME', 'lentic_be');

/** Utilisateur de la base de données MySQL. */
define('DB_USER', 'root');

/** Mot de passe de la base de données MySQL. */
define('DB_PASSWORD', '687yRfC6Be');

/** Adresse de l'hébergement MySQL. */
define('DB_HOST', 'localhost');

/** Jeu de caractères à utiliser par la base de données lors de la création des tables. */
define('DB_CHARSET', 'utf8');

/** Type de collation de la base de données. 
  * N'y touchez que si vous savez ce que vous faites. 
  */
define('DB_COLLATE', '');

/**#@+
 * Clefs uniques d'authentification et salage.
 *
 * Remplacez les valeurs par défaut par des phrases uniques !
 * Vous pouvez générer des phrases aléatoires en utilisant 
 * {@link https://api.wordpress.org/secret-key/1.1/salt/ le service de clefs secrètes de WordPress.org}.
 * Vous pouvez modifier ces phrases à n'importe quel moment, afin d'invalider tous les cookies existants.
 * Cela forcera également tous les utilisateurs à se reconnecter.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '[x]:OE.ZkJgfAo]2fb@+:9.iO>xK2?_J U3G4?{$En<KXj3=+VKho9=@hk2HbX!a');
define('SECURE_AUTH_KEY',  'VZqV=gLN=hcxRHX|`2Ev> BeTKL@3A*OejP.uk,e86{Q,tV(P*8}NE1`zU#*!2I+');
define('LOGGED_IN_KEY',    'Z~8UX*4QHjZfb),Z3U0#;~4S1+2KG-b$5-{Ly>viLgEd C+^/Z=?|ANUJgE=l94z');
define('NONCE_KEY',        'p@%KZ~5Y_7nzB-9I+7=j=zbMzDs%|MmXNz)`(w-bZXgR |km+]Z[),MT|]{|3fz|');
define('AUTH_SALT',        'BTdO;G#60i5UdZSU.*2`XR0MNS-]HjVj[~?-w~clVxcm*9Mg0g9?|HY,A4uh-MTw');
define('SECURE_AUTH_SALT', 'ojWs;kGShB8%O!X#/&Y11f1>Aw tqJr@:+HLx>JpVs85_N#z}lOobMfX#s@~Z( @');
define('LOGGED_IN_SALT',   'i)i_1tR{j<jeCSzP855rt6tn|SzhGQ;mmNy;<TSriSc<OO ZA6Kh`jKbd+W@k++J');
define('NONCE_SALT',       '6XPG_PgmENjsan/`8*[&b*iXth^:Vm91G2}rKphv4ixu!-Uy$Z#f9+R/oDj4p<L`');
/**#@-*/

/**
 * Préfixe de base de données pour les tables de WordPress.
 *
 * Vous pouvez installer plusieurs WordPress sur une seule base de données
 * si vous leur donnez chacune un préfixe unique. 
 * N'utilisez que des chiffres, des lettres non-accentuées, et des caractères soulignés!
 */
$table_prefix  = 'wp_';

/**
 * Langue de localisation de WordPress, par défaut en Anglais.
 *
 * Modifiez cette valeur pour localiser WordPress. Un fichier MO correspondant
 * au langage choisi doit être installé dans le dossier wp-content/languages.
 * Par exemple, pour mettre en place une traduction française, mettez le fichier
 * fr_FR.mo dans wp-content/languages, et réglez l'option ci-dessous à "fr_FR".
 */
define('WPLANG', 'fr_FR');

/** 
 * Pour les développeurs : le mode deboguage de WordPress.
 * 
 * En passant la valeur suivante à "true", vous activez l'affichage des
 * notifications d'erreurs pendant votre essais.
 * Il est fortemment recommandé que les développeurs d'extensions et
 * de thèmes se servent de WP_DEBUG dans leur environnement de 
 * développement.
 */ 
define('WP_DEBUG', false); 

/* C'est tout, ne touchez pas à ce qui suit ! Bon blogging ! */

/** Chemin absolu vers le dossier de WordPress. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Réglage des variables de WordPress et de ses fichiers inclus. */
require_once(ABSPATH . 'wp-settings.php');

define('FS_METHOD', 'direct');

define('WPCF7_LOAD_JS', false);
define('WPCF7_LOAD_JS', false);

if ( function_exists( 'wpcf7_enqueue_scripts' ) ) {
		wpcf7_enqueue_scripts();
		wpcf7_enqueue_styles();
	}