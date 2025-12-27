def predict_score(age: int, salary: float, loan_amount: float) -> float:
    """Simple prediction proxy used for tests.

    Returns a float between 0 and 1 representing approval probability.
    This avoids heavy model dependencies in unit tests.
    """
    # Basic sanity and clipping
    try:
        age = float(age)
        salary = float(salary)
        loan_amount = float(loan_amount)
    except Exception:
        return 0.0

    # Simple heuristic: higher salary and older age increase approval,
    # larger loan decreases approval. Normalize to 0..1.
    age_score = max(0.0, min((age - 18) / 50.0, 1.0))  # 18..68
    salary_score = max(0.0, min(salary / 10000.0, 1.0))
    loan_penalty = max(0.0, min(loan_amount / 100000.0, 1.0))

    raw = 0.4 * age_score + 0.5 * salary_score - 0.6 * loan_penalty + 0.1
    # Clip and return as float probability
    prob = max(0.0, min(raw, 1.0))
    return float(prob)
