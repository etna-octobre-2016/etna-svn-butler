# ETNA SVN BUTLER

## Présentation

Ce script shell permet de reproduire dans l'ordre chronologique les commits d'un dépôt Git sur un dépôt SVN.
Simple et personnalisable, il vous aidera obtenir les temps de logs que vous méritez !

## Comment ça marche ?

Rien de plus simple, il suffit de suivre les étapes suivantes :
1. Cloner le dépôt SVN de destination
2. Mettre le fichier ```svn-butler.sh``` à la racine du dépôt SVN
3. Changer les variables dans le fichier :

  * SVN_TMP_DIR : chemin de destination du code sur le dépôt SVN
  * GIT_BRANCH_NAME : nom de la branche Git à utiliser
  * GIT_REPOSITORY_DIR : nom du dossier dans lequel le dépôt Git sera cloné
  * GIT_REPOSITORY_URL : URL Git du dépôt à cloner
  * GIT_REMOTE_NAME : nom du remote à utiliser
  * TICKER_SVN_UP_MINUTES : fréquence des ```svn up```
  * TICKER_SVN_COMMITS_MINUTES : fréquence des ```svn commit```
