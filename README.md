# Data_Project

Dans ce projet, nous allons effectuer le nettoyage d'une table avec MySQL WorkBench.

Les données utilisées pour ce projet sont des informations sur l'immobilier dans le Tennesse.

L'objectif est de rendre la base prête pour effectuer des analyses et corriger les potentielles erreurs. 

Le plan d'action sera le suivant : 


## 1.  Comprendre les données
Examiner les sources de données : Identifier toutes les sources de données et comprendre le contexte et la signification de chaque colonne/variable.
Analyse exploratoire initiale : Obtenir une vue d'ensemble des données, examiner les types de données, les dimensions du dataset, et les premières statistiques descriptives.

## 2.  Supprimer ou corriger les doublons
Identifier les doublons : Rechercher les lignes dupliquées qui peuvent fausser les analyses.
Supprimer ou fusionner : Selon le contexte, supprimer les doublons ou fusionner les lignes si cela a du sens (par exemple, lorsque les doublons représentent des enregistrements similaires).

## 3.  Gérer les valeurs manquantes
Détection : Identifier les valeurs manquantes dans le dataset.
Traitement :
Suppression : Supprimer les lignes ou colonnes avec un grand nombre de valeurs manquantes, si elles sont peu nombreuses et non critiques.
Imputation : Remplacer les valeurs manquantes par des valeurs appropriées (moyenne, médiane, mode, ou valeurs prédites).

## 4.  Correction des types de données
Vérification : S'assurer que chaque colonne a le bon type de données (numérique, chaîne de caractères, date, etc.).
Conversion : Convertir les types de données incorrects au bon format.


## 5.  Correction des erreurs de données
Validation : Rechercher des incohérences et des erreurs dans les données (par exemple, valeurs négatives pour des quantités qui ne peuvent pas être négatives).
Correction : Corriger ou supprimer les enregistrements incorrects.

## 6.  Création de nouvelles variables (feature engineering)
Transformation : Créer de nouvelles variables à partir des variables existantes pour capturer des informations plus pertinentes (par exemple, extraire le mois et l'année à partir d'une date).
Combinaison : Combiner des variables existantes pour en créer de nouvelles (par exemple, créer une variable de ratio à partir de deux variables numériques).

## 7. Réduction de la dimensionnalité
Élimination des variables inutiles : Supprimer les colonnes qui ne sont pas pertinentes pour l'analyse.
Sélection de variables : Utiliser des méthodes de sélection de variables pour conserver les plus significatives.




