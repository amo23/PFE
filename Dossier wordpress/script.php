<?php

      ini_set('display_errors', 1);

      header('content-type: text/html; charset=utf-8');



    $url = "http://orbi.ulg.ac.be/widget?query=%28%28researchcenter%3ALENTIC%29+OR+%28affil%3ALENTIC%29%29&amp;chars=100&amp;etal=3&amp;language=fr&amp;data=pr&amp;format=apa&amp;css=%2Ffiles%2Fcss%2Fwl.css&amp;sort_by0=1&amp;order0=DESC&amp;sort_by1=3&amp;order1=ASC&amp;sort_by2=2&amp;order2=ASC" ; //URL

            $header[0]  = "Accept: text/xml,application/xml,application/xhtml+xml,";
            $header[0] .= "text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5";
            $header[]   = "Cache-Control: max-age=0";
            $header[]   = "Connection: keep-alive";
            $header[]   = "Keep-Alive: 300";
            $header[]   = "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7";
            $header[]   = "Accept-Language: fr-be,fr;q=0.5";
            $header[]   = "Pragma: ";
            $curl = curl_init(); // crée la fct 
            curl_setopt($curl, CURLOPT_HTTPHEADER, $header); // entêtes html
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1); // récupérer le code
            curl_setopt($curl, CURLOPT_URL, $url); // lien
            curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1); // suivre les redirections

            $html = curl_exec($curl); // exéution de la méthode
            curl_close($curl); // fermeture méthode

      $items = explode('<div class="info"', $html); // on explose pour récup les div class info
      
      $count = count($items); // on compte le nombre qu'il y en a
      //$items est un tableau qui récupère chaque article séparément

      try{

            $connex = new PDO ("mysql:host=localhost;dbname=lentic_be", "root", "687yRfC6Be",array( //connexion à la BDD
                  PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                  PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
                  ));
            $connex->query('SET CHARACTER SET UTF8');
            $connex->query('SET NAMES UTF8');
      } catch (PDOException $e){
            die($e->getMessage());
            
      }

      try{
            $req = 'SELECT * FROM orbi_post'; // on prend la table de la BDD créée pour ORBI
            $res = $connex->query($req);
            $posts = $res->fetchAll();
            print_r($posts);
      }catch (PDOException $e){
            die($e->getMessage());
      }

      $dbCount = count($posts);
      
      
      $reqDel = 'TRUNCATE TABLE orbi_post'; // on vide la table avant de la remplir
      
      try{
                        $ps = $connex->prepare($reqDel);
                        $connex->beginTransaction();
                        $ps->execute();
                        $connex->commit();
                  }
                  catch(PDOException $e){
                        $connex->rollback();
                        die($e->getMessage());
                  }


      if ($count != 0 && $count > $dbCount){
      		echo($dbCount);
            for ($i = 1; $i <  $count; $i++){ // on compte combien il y a de publications et on les prend une à une
            		var_dump($i);
            		
            	  $Title = null;
            	  $link = null;
            	  $finalAuteur = null;
            	  $categorie = null;
            	  $blockSecondPara = null;
            	  
                  //Récupérer Titre
                  //strpos = position d'un ou d'une chaine de caract
                  //substr = substituer la chaine de caractère hors du texte
                  $startTitle = strpos($items[$i], "<a"); // rechercher le caractère <a dans l'article
                  $endTitle = strpos($items[$i], "<br/>", $startTitle); // recherche la fermeture du lien, première chaine de caractère après le start
                  $blockTitle = substr($items[$i], $startTitle, $endTitle-$startTitle); // récupère le bloc du titre
                  $findTitleStart = strpos($items[$i], "/>"); // récupère le début du titre, la fermeture de la balise image
                  $findTitleEnd = strpos($items[$i], "</a>", $findTitleStart); // récupère la fermeture du a, 
                  $findTitleStart += 2; // /> = 2 caractères
                  $Title = substr($items[$i], $findTitleStart, $findTitleEnd-$findTitleStart); // on découpe le bloc pour obtenir le titre

                  //Récupérer lien du Titre + concaténation URL
                  $resultLien = array();
                  preg_match('#<a class="([^"]+)" href="([^"]+)"#', $blockTitle, $resultLien); // on cherche une chaine de caractère dans blocktitle 
                  $link = "http://orbi.ulg.ac.be" . $resultLien[2]; 
                  
                  //Récupérer l'auteur.
                  $startAuteur = strpos($items[$i], "<br/>"); 
                  $startAuteur += 5; // 5 car <br/> = 5 caractères
                  $endAuteur = strpos($items[$i], "<br/>", $startAuteur);
                  $blockAuteur = substr($items[$i], $startAuteur, $endAuteur-$startAuteur);
                  $resultAuteur = array();
                  preg_match_all('#<span class="author">([^<]+)</span>#', $blockAuteur, $resultAuteur);
                  $resultAuteur = split('#<span class="author">([^<]+)</span>#', $blockAuteur);
                  $finalAuteur = strip_tags($resultAuteur[0]);
                  
				  
                  
                  //Récupérer la catégorie
                  $startFirstPara = strpos($items[$i], "<p>");
                  $endFirstPara = strpos($items[$i], "</p>", $startFirstPara);
                  $startFirstPara += 3;
                  $blockFirstPara = substr($items[$i], $startFirstPara, $endFirstPara-$startFirstPara);
                  $categorie = strip_tags($blockFirstPara);

                  //Récupérer le contenu
                  if ( $startSecondPara = strpos($items[$i], '<p class="gray">') ){
                        $endSecondPara = strpos($items[$i], "</p>", $startSecondPara);
                        $startSecondPara += 16;
                        $blockSecondPara = substr($items[$i], $startSecondPara, $endSecondPara-$startSecondPara);
                        
                  }
				  // on insère les données séparées dans la BDD
                  $reqIns = 'INSERT INTO orbi_post (title, lien, auteur, categorie, contenu) VALUES (:title, :lien, :auteur, :categorie, :contenu) ON DUPLICATE KEY UPDATE title = :title';

                  try{
                        $ps = $connex->prepare($reqIns);
                        $connex->beginTransaction();
                        $ps->bindValue(':title',$Title);
                        $ps->bindValue(':lien',$link);
                        $ps->bindValue(':auteur',$finalAuteur);
                        $ps->bindValue(':categorie',$categorie);
                        $ps->bindValue(':contenu',$blockSecondPara);
                        $ps->execute();
                        $connex->commit();
                        $lastId = $connex->lastInsertId();
                  }
                  catch(PDOException $e){
                        $connex->rollback();
                        die($e->getMessage());
                  }
                  


                  
            }
      }
            



