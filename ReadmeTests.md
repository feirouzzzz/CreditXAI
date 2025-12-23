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