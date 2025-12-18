

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

| Component / Class            | Technologies / Tools                                                      |
| ---------------------------- | ------------------------------------------------------------------------- |
| Flutter Mobile App (Flutter) | Flutter, Dart, Provider, Dio, fl_chart                                    |
| Backend API                  | FastAPI, Pydantic, Swagger, Docker, Keycloak                              |
| Machine Learning (ML)        | Python, XGBoost, LightGBM, scikit-learn, MLflow, SHAP, LIME, DiCE         |
| Data Mining (Data Mining)    | Python, pandas, numpy, matplotlib, seaborn, Airflow, Feast                |
| Database / Feature Store     | PostgreSQL, MySQL, Redis, S3, Alembic                                     |
| Quality Management (QM)      | pytest, SonarQube, GitHub Actions, Fairlearn, AIF360, Grafana, Prometheus |
| Explainable AI               | SHAP, LIME, DiCE, Python NLP                                              |
| Monitoring / Audit           | ELK Stack, Prometheus, Grafana, OpenTelemetry                             |


---

## Explanation 

### Backend API: Workflow / Sequence
```
Flutter app sends POST /score request with applicant features.
Backend API validates input using Pydantic schemas.
Feature Fetcher pulls additional features from database / feature store.
Scoring Service calls ML model for prediction.
Explanation Service calls SHAP/LIME/DiCE for explanation.
Audit Service stores request, prediction, and explanation in DB.
API returns JSON response to Flutter app.
```



---
---
# Quality Assurance

## How you run tests locally
### Backend
#### Unit Tests
```
mvn test -DskipITs
```

#### Integration Tests
Testing environment must be runing
```
docker compose -f docker-compose.it.yml up -d
mvn verify -Pintegration
docker compose -f docker-compose.test.yml down -v
```
---

### ML
#### Unit Tests
#### Integration Tests


---
---

## How to test system with sonar
### Backend
```
mvn clean verify sonar:sonar "-Dsonar.host.url=http://localhost:9002" "-Dsonar.login=sqa_55b80152b2817bab7812e9f97b02f98c12fb168a"
```

### ML