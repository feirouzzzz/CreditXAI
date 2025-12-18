import sys
sys.path.insert(0, '.')
from app.train import train_credit_scoring_model

result = train_credit_scoring_model('app/dataset.csv')
print('\nTraining complete!')
