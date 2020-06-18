![](/img/mainScreenX9D.jpg)

# Track & Locate (script LUA)

## *Localiser son racer FPV en cas de crash, de perte de télémétrie, de lipo débranchée*



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

## Astuces

### Distance importante avant même de décoller !?

La distance est calculée entre la position du pilote (prise par le GPS à l'initialisation) et la position courante. Le temps que le GPS se cale sur tous les satellites, cette distance peut être très différente de 0.
Pour y remédier avant de décoller : `Long press ENTER` + `Réinit. Télémétrie`

## Installation

1. Renommer le script `TrackLocate_PhilPagan_2.0.lua` pour compatibilité avec OpenTx. 
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

