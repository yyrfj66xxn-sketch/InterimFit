# INTERIM FIT

Application Shiny de prédiction de la compatibilité d’une mission d’intérim pour un étudiant.

---

## 🎯 Objectif du projet

L’objectif de ce projet est de développer une application d’aide à la décision permettant d’évaluer si une mission d’intérim est adaptée au profil d’un étudiant.

À partir d’informations personnelles, académiques et financières, l’application **INTERIM FIT** estime la probabilité qu’un étudiant accepte de refaire une mission similaire, ce qui permet d’anticiper la difficulté ou la pénibilité d’une mission.

---

## 🧠 Méthodologie

Le projet suit une démarche complète de data science :

1. Analyse et nettoyage des données issues d’un questionnaire étudiant  
2. Sélection des variables disponibles **avant la mission** (pré-mission uniquement)  
3. Recodage des variables qualitatives et catégorisation de certaines variables métier  
4. Séparation aléatoire des données en jeu d’entraînement et de test  
5. Comparaison de plusieurs modèles de classification  
6. Sélection du modèle final et intégration dans une application Shiny  

---

## 📊 Données et variables

Les variables utilisées décrivent notamment :

- le profil personnel (âge, statut de boursier, aide familiale)
- la situation académique (charge d’études)
- la situation financière (charges fixes, autonomie financière)
- l’expérience en intérim
- les caractéristiques de la mission :
  - type de mission
  - temps de trajet
  - nombre de jours travaillés d’affilée

### Variable cible (Y)

> **Si tu avais le choix demain, reprendrais-tu une mission similaire ?**

- Oui → mission adaptée  
- Non → mission non adaptée  

---

## 🤖 Modèle utilisé

Le modèle final retenu est un **Naive Bayes** avec lissage de **Laplace**, choisi pour :

- sa bonne adaptation aux variables catégorielles
- sa robustesse sur des jeux de données de taille modérée
- sa facilité d’interprétation
- sa compatibilité avec une application interactive

---

## 🖥️ Application Shiny

L’application permet :

- de saisir le profil d’un étudiant via une interface interactive
- d’obtenir une estimation probabiliste de compatibilité
- de visualiser le résultat grâce à un thermomètre de probabilité
- de recevoir un message explicatif et pédagogique
- de réinitialiser facilement les paramètres

L’interface combine une présentation **professionnelle et ludique**, adaptée à un public étudiant.

---

## 🚀 Lancer l’application

### Prérequis
- R (version récente)
- Packages R :
  - `shiny`
  - `e1071`

### Lancement

Dans R ou RStudio :

```r
setwd("InterimFit")
shiny::runApp()
