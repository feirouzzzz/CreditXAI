

# 📄 Cahier des Charges — Projet Flutter : Application de Scoring de Crédit Éthique (XAI)



* Driss — ML Engineer
* Soulaiman — Backend Developer
* Zakaria — Flutter Developer
* Feirouz — DevOps & CI/CD

---

## 1. **Contexte et Objectifs du Projet**

**Contexte :**
Avec la digitalisation des services financiers, il devient crucial d’évaluer la solvabilité des utilisateurs de manière fiable, éthique et explicable. L’usage de l’IA peut améliorer la précision des scores de crédit, mais introduit des risques de biais et d’opacité dans les décisions.

**Objectifs :**

* Créer un **modèle de scoring de crédit fiable et éthique**.
* Fournir des **explications transparentes** pour chaque prédiction via SHAP.
* Développer une **application mobile Flutter intuitive** pour les utilisateurs et les analystes.
* Fournir un **backend sécurisé et robuste** avec API exposée.
* Mettre en place un **pipeline DevOps complet** avec CI/CD, tests automatisés et monitoring.

---

## 2. **Périmètre du Projet**

**Inclus :**

* Collecte et préparation de datasets financiers anonymisés.
* Entraînement et export d’un modèle ML (Logistic Regression + RandomForest).
* Explication des prédictions via SHAP.
* API FastAPI sécurisée (JWT, audit, logs).
* Application mobile Flutter (formulaire crédit, affichage score, graphiques SHAP, dashboard analyste).
* CI/CD avec tests automatisés (unitaires, UI Selenium, performance JMeter).
* Qualité du code et monitoring (SonarQube, Allure).
* Déploiement cloud (Railway / Render / AWS).

**Exclus :**

* Gestion de crédit réel en production.
* Collecte de données personnelles sensibles sans anonymisation.
* Prédiction pour d’autres types de scoring non liés au crédit.

---

## 3. **Fonctionnalités Principales**

| Module             | Fonctionnalité           | Description                                                     |
| ------------------ | ------------------------ | --------------------------------------------------------------- |
| **IA / ML**        | Modèle de scoring        | Entraînement ML fiable avec Logistic Regression et RandomForest |
|                    | Explication SHAP         | Graphiques et interprétations simplifiées pour l’utilisateur    |
|                    | Fairness                 | Mesure et réduction des biais dans les prédictions              |
| **Backend**        | API `/score`             | Endpoint pour calculer le score crédit                          |
|                    | API `/explain`           | Endpoint pour renvoyer l’explication SHAP                       |
|                    | Authentification JWT     | Sécurisation des endpoints sensibles                            |
|                    | Logging et audit         | Historisation des requêtes et actions                           |
| **Mobile Flutter** | Formulaire utilisateur   | Saisie des informations nécessaires au scoring                  |
|                    | Affichage score          | Carte de score avec interprétation simple                       |
|                    | Graphiques SHAP          | Visualisation explicable des facteurs influents                 |
|                    | Dashboard analyste       | Vue globale des scores et performances (optionnel)              |
| **DevOps & QA**    | Conteneurisation Docker  | Backend + DB + ML service                                       |
|                    | Pipeline CI/CD           | Build, tests unitaires, génération APK, déploiement automatique |
|                    | Tests UI Selenium        | Automatisation des scénarios frontend                           |
|                    | Tests Performance JMeter | Validation sous charge et stress tests                          |
|                    | Qualité code SonarQube   | Analyse continue et correction des anomalies                    |
|                    | Monitoring & Reporting   | Dashboard Allure, notifications Slack/Teams                     |

---

## 4. **Contraintes Techniques**

* **Backend :** FastAPI, PostgreSQL
* **ML :** Python, scikit-learn, SHAP
* **Frontend :** Flutter, Dart
* **DevOps :** Docker, Docker-Compose, GitHub Actions, Railway/Render/AWS
* **Tests :** Pytest, Selenium, JMeter, Allure
* **Qualité :** SonarQube, badges de qualité automatique

---

## 5. **Contraintes Fonctionnelles et Non-Fonctionnelles**

**Fonctionnelles :**

* L’API doit être sécurisée (authentification JWT obligatoire).
* L’application doit être compatible Android/iOS.
* Les prédictions doivent être explicables et traçables.

**Non-Fonctionnelles :**

* Temps de réponse backend ≤ 1s pour scoring.
* Disponibilité ≥ 99% pour le service API.
* CI/CD entièrement automatisé.
* Centralisation des logs et KPI pour monitoring.

---

## 6. **Livrables**

1. Modèle ML exporté (.joblib) avec documentation.
2. Backend FastAPI sécurisé et documenté (Swagger/Redoc).
3. Application Flutter fonctionnelle avec UI et intégration API.
4. Pipeline DevOps complet avec CI/CD, tests Selenium & JMeter.
5. Rapport de qualité de code (SonarQube) et tableau de monitoring Allure.
6. Documentation complète pour installation, usage et maintenance.

---

## 7. **Répartition des Tâches**

| Membre    | Rôle              | Responsabilités                                            |
| --------- | ----------------- | ---------------------------------------------------------- |
| Driss     | ML Engineer       | Dataset, Modèle ML, SHAP, Fairness                         |
| Soulaiman | Backend Developer | API FastAPI, Auth JWT, Logs, DB                            |
| Zakaria   | Flutter Developer | Mobile App, UI/UX, API Integration                         |
| Feirouz   | DevOps            | Docker, CI/CD, Tests automatisés, Monitoring, Qualité Code |

---

## 8. **Planning Prévisionnel**

| Phase                     | Durée      | Description                                    |
| ------------------------- | ---------- | ---------------------------------------------- |
| Analyse & Design          | 1 semaine  | Figma, architecture ML/Backend/Flutter         |
| Développement ML          | 2 semaines | Collecte dataset, entraînement, SHAP, fairness |
| Développement Backend     | 2 semaines | API, DB, Auth, logging                         |
| Développement Flutter     | 2 semaines | Formulaire, score, graphiques SHAP, dashboard  |
| DevOps & Tests            | 2 semaines | Docker, CI/CD, Selenium, JMeter, SonarQube     |
| Intégration & Déploiement | 1 semaine  | Tests finaux, déploiement cloud, documentation |

---

## 9. **Critères de Réussite**

* Modèle ML précis et explicable (SHAP).
* API sécurisée et stable.
* Application mobile intuitive et responsive.
* Pipeline DevOps fonctionnel et automatisé.
* Tests unitaires et UI ≥ 95% de réussite.
* Monitoring et reporting centralisés.

