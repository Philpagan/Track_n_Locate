![](/img/mainScreenX9D.jpg)

# Track & Locate (script LUA)

## *Localiser son racer FPV en cas de crash, de perte de télémétrie, de lipo débranchée*

## Nouveau : v3.0

- Mémorisation sur carte SD de la dernière position du Racer : la dernière position peut être récupérée même si la radio commande a été éteinte !
- Compatible OpenTX 2.2 et 2.3
- [Plus d'informations](#v3.0)

## Script LUA

Disponible dans [Releases](https://github.com/Philpagan/Track_n_Locate/releases)

## Objectifs

- Suivre en permanence la position, la direction et l’altitude de son Racer,
- Conserver les dernières informations reçues en cas de perte de télémétrie, y compris si le Racer n’est plus alimenté,
- Faciliter sa localisation et sa récupération via une application de type Google Map.

## Qu’est-ce que Track & Locate ?

Il s’agit d’un Script LUA pour radio-commande sous OpenTx 2.x.

A titre personnel, ce script est installé et fonctionne sur Taranis X9D+. Il est toutefois normalement compatible de toute radio sous OpenTx avec écran minimum de 128x64 : X9D, X9D+, QX7, Tango2, Xlite, ...

![](/img/mainScreenTango2.jpg)

## Prérequis

Racer FPV équipé d’un GPS et d’un Rx avec retour de télémétrie.

## Fonctionnement

Le script est utilisable via les écrans de télémétrie de la radio commande.
Il comprend un écran principal qui regroupe les informations utiles

- le nombre de satellites reçus
- la latitude et la longitude du Racer : données décimales, compatibles Google Map
- la distance par rapport au pilote
- la direction (Nord, Sud, Est, Ouest, ...) et le cap
- l’altitude relative (par rapport au point de décollage)

![](/img/mainScreenX9D.jpg)

L’application propose également un écran secondaire ne comprenant **que les coordonnées du point GPS**. Ces informations sont présentées sous une forme et un format facilitant l’analyse par une application smartphone de type **Google Lens** qui renvoie alors sur **Google Map** pour une localisation du “point de chute” et un routage vers ce point.

![](/img/coordScreen_Lens.jpg)

*Nota : point donné à titre d'exemple, sans lien avec une situation réelle. A gauche : la photographie des coordonnées par Google Lens et leur interprétation. A droite : Le point GPS sous Google Map*

**Le passage d’un écran à l’autre se fait par appui prolongé sur la touche Menu** de la radio commande

## Récupération de la dernière position du Racer (nouveauté v3.0)

<a name="V3.0"></a>

Votre Racer a crashé et dans votre empressement à le récupérer vous avez malheureusement éteint la radio commande !!!
Pas de panique, la dernière position du Racer peut être visualisée en rallumant la radio commande et en se rendant dans l'écran secondaire de Track_n_Locate.

En fonctionnement opérationnel (Racer et son GPS en fonctionnement), l'écran secondaire propose la Localisation actuelle:

![](/img/loc_actual.jpg)

Après avoir rallumé la radio commande (et si Racer et GPS ne sont plus opérationnels), l'écran secondaire rappelle la dernière location enregistrée :

![](/img/loc_rec.jpg)

## Astuces

### Distance importante avant même de décoller !?

La distance est calculée entre la position du pilote (prise par le GPS à l'initialisation) et la position courante. Le temps que le GPS se cale sur tous les satellites, cette distance peut être très différente de 0.
Pour y remédier avant de décoller : `Long press ENTER` + `Réinit. Télémétrie`

### Difficulté à capturer les coordonnées avec Google Lens !?

Ce n'est pas aussi facile qu'un QRcode (code trop lourd à intégrer pour nos radios !), ça ne marche pas à tous les coups et il faut 

- trouver la bonne distance
- ne capturer que sur image bien nette
- capturer quand le rétro-éclairage est encore actif

... mais c'est top quand même !

## Installation

1. Renommer le script `TrackLocate_PhilPagan_x.0.lua` pour compatibilité avec OpenTx. 
   Par exemple ici : `trkloc.lua`

2. Le copier sur la carte SD de la radio, dans le répertoire 

   ```
   /SCRIPTS/TELEMETRY
   ```

3. Vérifiez que pour votre modèle, vos capteurs comprennent bien `GPS, Alt et Sats`
   N'hésitez pas à relancer une découverte des capteurs si besoin
   ![](/img/sensors.jpg)

4. Dans la page de télémétrie de votre modèle, réservez un écran à Track_n_Locate en sélectionnant `Script` + `trlloc` (ou autre nom donné au script LUA)

   ![](/img/script_in_telemetry.jpg)

