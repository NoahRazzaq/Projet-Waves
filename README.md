# Projet-Waves
## 📄 Description
Le projet "Waves Blossom" a été développé dans le cadre d'une licence, en tant que projet tutoré pour un client nommé "Waves". Il s'agit d'un collectif d'artistes qui souhaitaient disposer d'une application de réseau social dédiée aux artistes.

L'application "Waves Blossom" vise à fournir une plateforme communautaire où les artistes peuvent se connecter, partager leur travail artistique, interagir avec d'autres artistes et se tenir au courant des événements et des projets artistiques.
## ✨ Fonctionnalités 

- Authentification: Les utilisateurs peuvent créer un compte et se connecter à l'application à l'aide d'un nom d'utilisateur et d'un mot de passe.

- Profil utilisateur: Chaque artiste dispose d'un profil personnalisé où il peut ajouter des informations telles que sa biographie, une photo de profile etc...

- Publication d'oeuvres: Les artistes peuvent publier leurs œuvres d'art, qu'il s'agisse de peintures, de photographies, de sculptures ou d'autres formes d'art.

- Exploration d'oeuvres: Les utilisateurs peuvent parcourir et découvrir les œuvres d'autres artistes, les liker et les commenter.

- Recherche d'utilisateurs: Il est possible de rechercher des artistes par leur nom d'utilisateur ou par des mots-clés liés à leurs intérêts artistiques.

- Événements artistiques: L'application affiche les événements artistiques tels que des expositions, des vernissages ou des ateliers qui pourraient intéresser les artistes.

## 🔧 Technologies Utilisées
Le projet "Waves Blossom" a été développé en utilisant un ensemble de technologies modernes qui garantissent la sécurité, la performance et l'évolutivité de l'application. Voici les principales technologies utilisées :

### Flutter 
Flutter est un framework open-source développé par Google, qui permet de créer des applications multiplateformes pour Android, iOS, Web et bien d'autres plateformes à partir d'un seul codebase. Flutter a été choisi pour son excellente performance, sa réactivité et sa facilité de développement.

### Firebase 
Firebase est une plateforme mobile développée par Google, qui propose un ensemble de services en cloud pour faciliter le développement d'applications. Dans le projet "Waves Blossom", les services Firebase suivants ont été utilisés :

### Firebase Authentication 
Ce service a été utilisé pour gérer l'authentification des utilisateurs de l'application. Il permet de gérer l'inscription, la connexion et la déconnexion des utilisateurs de manière sécurisée.

### Cloud Firestore 
Firestore est une base de données NoSQL en temps réel fournie par Firebase. Elle a été utilisée pour stocker et gérer les données relatives aux utilisateurs, aux événements et aux publications des artistes.

### Cloud Storage  
Cloud Storage a été utilisé pour stocker les images des événements et des publications des artistes. Cela permet de les sauvegarder de manière sécurisée et d'y accéder rapidement depuis l'application.

## ⚙️ Architecture 
### Introduction
L'architecture du projet "Waves Blossom" a été conçue pour garantir une organisation claire, une évolutivité aisée et une maintenabilité efficace de l'application. Nous avons opté pour une approche modulaire, où chaque fonctionnalité principale du projet est séparée en modules distincts. Chaque module suit le modèle MVC (Modèle-Vue-Contrôleur), ce qui permet une séparation claire des responsabilités et facilite la collaboration entre les développeurs.

### Modèles MVC
Le modèle MVC est un patron de conception qui divise une application en trois composants principaux :

#### Modèle (Model) 
C'est la couche de données de l'application. Elle représente les données, les règles de gestion et les opérations qui peuvent être effectuées sur ces données. Dans notre projet, chaque module dispose de ses propres modèles, qui gèrent la logique métier spécifique à ce module.
#### Vue (View) 
C'est la couche d'interface utilisateur de l'application. Elle est responsable de l'affichage des données au format approprié pour les utilisateurs. Dans notre projet, chaque module dispose de ses propres vues, qui représentent les écrans et les widgets spécifiques à ce module. Par exemple, le module "Post" aura une vue pour afficher les détails d'une publication.

#### Contrôleur (Controller) 
C'est la couche de gestion des événements et de la logique de l'application. Elle fait le lien entre le modèle et la vue, en transmettant les données du modèle à la vue et en traitant les actions de l'utilisateur. Dans notre projet, chaque module dispose de ses propres contrôleurs, qui orchestrent les interactions entre les modèles et les vues spécifiques à ce module. Par exemple, le contrôleur du module "Authentification" gérera les actions de connexion, d'inscription, etc.

### Modularité
La modularité est une caractéristique clé de notre architecture. Chaque fonctionnalité majeure du projet est encapsulée dans un module distinct, ce qui facilite la réutilisation du code, la collaboration entre les développeurs et la maintenance de l'application. Chaque module est indépendant des autres, ce qui signifie qu'il peut être développé, testé et déployé de manière autonome.

Voici quelques exemples de modules principaux du projet :

- Module **Authentification** (CRUD): Gère l'inscription, la connexion et la déconnexion des utilisateurs.
- Module **Publication** (CRUD): Gère la création, l'affichage et l'interaction avec les publications d'œuvres d'art.
- Module **Recherche**: Gère la recherche d'autres artistes et de publications.
- Module **Swipe**: Gère la partie principale de la navigation de l'application en utilisant le geste de balayage (swipe).
- Module **Événement** (CRUD): Gère la création, l'affichage des événements et l'interaction avec différents artistes.

## 🔗 Fichier de configuration
Le projet "Waves Blossom" utilise des fichiers de configuration à la racine du projet pour centraliser certaines valeurs personnalisées et options de connexion à Firebase. Voici une description de ces fichiers :

- colors.dart : Ce fichier contient des constantes pour les couleurs personnalisées utilisées dans l'application. Plutôt que de spécifier des couleurs directement dans le code, ce fichier permet de définir des couleurs sous forme de constantes pour une gestion plus facile et cohérente des couleurs dans l'ensemble de l'application.
```dart
class AppColors {
  static Color purple = Color.fromRGBO(116, 0, 239, 1);
  static Color green = Color.fromRGBO(19, 137, 132, 1);
  static Color darkBlue = Color.fromRGBO(0, 9, 73, 1);
}
```
- font_sizes.dart : Ce fichier contient des constantes pour les tailles de police utilisées dans l'application. Comme pour les couleurs, cela permet de centraliser la gestion des tailles de police et de les réutiliser facilement dans toute l'application.
```dart
class FontSizes {
 static const double xs = 12.0;
  static const double sm = 14.0;
  static const double md = 16.0;
  // ... Ajouter d'autres tailles de police ici ...
}
```
- firebase_options.dart : Ce fichier contient les informations de configuration nécessaires pour se connecter au service Firebase. Il permet de définir le projet Firebase spécifique utilisé par l'application, et d'obtenir les clés d'accès nécessaires pour communiquer avec les services Firebase tels que Firebase Authentication, Firestore et Cloud Storage.
```dart
class FirebaseOptions {
  static const String apiKey = 'VOTRE_API_KEY';
  static const String projectId = 'VOTRE_PROJECT_ID';
  // ... Ajouter d'autres informations de configuration Firebase ici ...
}
```
- pubspec.yaml : Le fichier "pubspec.yaml" est un fichier essentiel dans un projet Flutter. Il est utilisé pour spécifier toutes les dépendances (packages) nécessaires à votre projet. Ces dépendances sont téléchargées à partir du référentiel pub.dev lorsque vous exécutez la commande flutter pub get. Voici à quoi ressemble un extrait typique du fichier "pubspec.yaml" :
```dart
dependencies:
  flutter:
    sdk: flutter


  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.2
  firebase_core: ^2.10.0
  cloud_firestore: ^4.0.5
  appinio_swiper: ^1.1.1
```
- router :
Dans le dossier "router", on trouve les fichiers et classes qui gèrent la navigation de l'application en utilisant le package "go_router". Ce dossier contient des définitions de routes, des gestionnaires de routes, et il facilite la transition entre les écrans de l'application.

- services :
Dans le dossier "services", on regroupe les différentes classes ou fichiers qui fournissent des services essentiels à l'application. Cela inclut probablement le service d'authentification, qui gère les processus d'inscription, de connexion et de déconnexion des utilisateurs en utilisant Firebase Authentication.

- csc_picker :
Le dossier "csc_picker" contient les fichiers spécifiques au package "csc_picker", qui permet d'ajouter facilement des lieux aux posts en utilisant une interface de sélection de pays, d'état et de ville.

## 🚀 Comment démarrer ?
### Prérequis :
Assurez-vous d'avoir installé le SDK Flutter sur votre ordinateur. Vous pouvez suivre les instructions d'installation à partir du site officiel de Flutter (https://flutter.dev/docs/get-started/install).

### Clonage du dépôt :
Clonez le dépôt du projet "Waves Blossom" depuis le référentiel Git sur votre ordinateur local. Vous pouvez utiliser la commande suivante dans votre terminal :

```bash
git clone <lien-du-repo>
```
### Configuration de l'environnement 
Ouvrez le projet Waves Blossom dans votre IDE préféré, comme Android Studio ou Visual Studio Code. Assurez-vous également d'avoir un appareil Android connecté à votre ordinateur ou utilisez un émulateur Android pour tester l'application.

### Exécution de l'application 
Lancez l'application en appuyant sur le bouton "Run" dans votre IDE. L'application sera déployée sur votre appareil Android ou émulée sur l'émulateur.

### Profitez de l'application 
Vous êtes prêt à explorer l'application Waves Blossom ! Connectez-vous ou inscrivez-vous pour commencer à utiliser cette plateforme sociale dédiée aux artistes.
