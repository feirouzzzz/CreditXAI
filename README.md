

# **CreditXAI-Mobile — Plateforme mobile de scoring de crédit éthique avec IA explicable (XAI)**

Projet académique – Développement d’une **application mobile Flutter** avec backend FastAPI, appliquant les normes et bonnes pratiques pour garantir la qualité du code, l’interface utilisateur et l’explicabilité de l’IA.
**Objectif** : prédire le score de crédit des candidats tout en assurant une IA explicable, éthique et testée.

---

## 📘 Sommaire

* 🎯 Objectif du projet
* 🏗️ Architecture & Microservices
* 👥 Organisation de l’équipe
* 💡 User Stories
* 📁 Structure du projet
* 🧩 Technologies & Outils
* ⚙️ Installation & Exécution
* 🧪 Assurance Qualité & Tests
* 📅 Planning & Méthodologie Agile
* 📄 Livrables & Délais
* 🎓 Présentation finale
* 📞 Contacts encadrants

---

## 🎯 Objectif du projet

CreditXAI-Mobile a pour objectif :

* Prédire la probabilité de défaut d’un candidat au crédit via un **modèle IA explicable**.
* Fournir des **explications interprétables (SHAP)** pour chaque décision afin d’assurer **l’éthique et la transparence**.
* Développer une **application mobile Flutter** ergonomique et intuitive.
* Appliquer les bonnes pratiques de **développement, tests et CI/CD** pour garantir la qualité du produit final.

---

## 🏗️ Architecture & Microservices

### 🧩 Schéma global

```
[Flutter App] <--HTTPS--> [FastAPI Backend] <--Joblib ML Model + SHAP--> [PostgreSQL DB]
```

### Microservice / Composant

| Composant          | Stack principale        | Description                                             |
| ------------------ | ----------------------- | ------------------------------------------------------- |
| Flutter Mobile App | Flutter + Dart          | Formulaire crédit, affichage score, graphiques SHAP     |
| FastAPI Backend    | Python + FastAPI        | Endpoints `/score`, `/explain`, `/health`               |
| ML Model           | Scikit-learn + SHAP     | Logistic Regression / RandomForest + XAI explainability |
| Database           | PostgreSQL              | Stockage logs et requêtes utilisateurs                  |
| DevOps / CI/CD     | Docker + GitHub Actions | Intégration, tests automatiques et déploiement cloud    |

---

## 👥 Organisation de l’équipe

| Rôle                 | Nom      | Responsabilités principales                                           |
| -------------------- | -------- | --------------------------------------------------------------------- |
| ML Engineer          | Membre 1 | Dataset, preprocessing, modèle ML, SHAP, fairness                     |
| Backend Developer    | Membre 2 | FastAPI endpoints, logs, JWT Auth, tests API                          |
| Flutter Developer    | Membre 3 | UI formulaire, API calls, affichage score, dashboard                  |
| DevOps / Integration | Membre 4 | Docker backend, CI/CD, intégration Flutter, tests finaux, déploiement |

---

## 💡 User Stories

| ID   | User Story                                                                               |
| ---- | ---------------------------------------------------------------------------------------- |
| US01 | En tant qu’utilisateur, je veux saisir mes informations pour obtenir un score de crédit. |
| US02 | Le système doit nettoyer et prétraiter automatiquement mes données.                      |
| US03 | Le modèle prédit mon score de manière fiable et explicable.                              |
| US04 | Je veux visualiser mes scores et explications SHAP dans l’application mobile.            |
| US05 | L’application doit être testée, performante et sécurisée.                                |

---

## 📁 Structure du projet

```
📦 CreditXAI-Mobile/
 ┣ 📁 flutter_app/
 ┣ 📁 backend_fastapi/
 ┣ 📁 ml_model/
 ┣ 📁 database/
 ┣ 📁 docker/
 ┣ 📁 tests/
 ┃ ┣ 📁 unit/
 ┃ ┣ 📁 integration/
 ┣ 📁 docs/
 ┣ 📜 docker-compose.yml
 ┣ 📜 README.md
```

---

## 🧩 Technologies & Outils

| Catégorie          | Outils / Technologies                          |
| ------------------ | ---------------------------------------------- |
| Langages           | Dart (Flutter), Python                         |
| Base de données    | PostgreSQL                                     |
| ML & XAI           | Scikit-learn, SHAP, Joblib                     |
| CI/CD              | GitHub Actions, Docker                         |
| Tests unitaires    | Pytest, Flutter test                           |
| Tests fonctionnels | Selenium (optionnel), tests end-to-end Flutter |
| Containerisation   | Docker, docker-compose                         |
| Gestion projet     | Jira, Trello                                   |

---

## ⚙️ Installation & Exécution

```bash
# Cloner le dépôt
git clone https://github.com/<user>/CreditXAI-Mobile.git
cd CreditXAI-Mobile

# Lancer backend + ML model
docker-compose up --build

# Lancer Flutter app
cd flutter_app
flutter pub get
flutter run
```

**Composants accessibles :**

| Composant       | URL / Port                                     |
| --------------- | ---------------------------------------------- |
| FastAPI Backend | [http://localhost:8000](http://localhost:8000) |
| Flutter App     | Emulator / APK / TestFlight                    |
| PostgreSQL      | localhost:5432                                 |

---

## 🧪 Assurance Qualité & Tests

* Suivi des standards de code et bonnes pratiques Flutter / Python
* Revue de code obligatoire avant chaque merge
* Analyse statique avec SonarQube (bugs, vulnérabilités, code smells)
* Couverture de tests unitaires ≥ 80%
* Tests end-to-end : Flutter + API calls
* CI/CD : tests automatiques à chaque push

---

## 📅 Planning & Méthodologie Agile

| Sprint | Durée         | Objectif                                                                             |
| ------ | ------------- | ------------------------------------------------------------------------------------ |
| 1      | 03/11 → 17/11 | Dataset, preprocessing, ML baseline, SHAP, setup backend & Flutter                   |
| 2      | 18/11 → 02/12 | Endpoints `/score` & `/explain`, JWT Auth, logs, formulaire Flutter, intégration API |
| 3      | 03/12 → 14/12 | Dashboard, tests end-to-end, Docker, CI/CD, documentation, slides, vidéo démo        |

---

## 📄 Livrables & Délais

| Livrable                                | Date limite |
| --------------------------------------- | ----------- |
| Code source complet (Flutter + Backend) | 14/12/2025  |
| Modèle ML + SHAP                        | 14/12/2025  |
| Docker + CI/CD pipeline                 | 14/12/2025  |
| Documentation + guide utilisateur       | 14/12/2025  |
| Slides soutenance + vidéo démo          | 14/12/2025  |

---

## 🎓 Présentation finale

Points clés à démontrer :

* Application Flutter mobile fonctionnelle
* Backend FastAPI avec scoring et explications XAI
* Dashboard simple pour visualisation des métriques
* Logs et suivi des prédictions
* Tests unitaires, fonctionnels et CI/CD réussis

**Livrables à présenter :**

* Dépôt GitHub complet
* Dockerfiles + CI/CD
* Documentation et guide utilisateur
* Slides + vidéo démo (~5 min)
