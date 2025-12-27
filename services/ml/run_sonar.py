# run_sonar.py
from sonarqube import SonarQubeClient

# Connect to your SonarQube server
sonar = SonarQubeClient(
    sonarqube_url="http://localhost:9002",
    token="sqa_55b80152b2817bab7812e9f97b02f98c12fb168a"
)

# List all projects
projects = sonar.projects.get_project()
for project in projects['components']:
    print(project['key'], project['name'])

# Create a new project if needed
project_key = "CreditXAI-ML"
project_name = "CreditXAI ML"
try:
    sonar.projects.create_project(project=project_key, name=project_name)
    print(f"Project {project_name} created!")
except Exception:
    print("Project probably already exists")
