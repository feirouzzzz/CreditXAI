import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers.dart';

class CreditApplicationFormScreen extends ConsumerStatefulWidget {
  const CreditApplicationFormScreen({super.key});

  @override
  ConsumerState<CreditApplicationFormScreen> createState() =>
      _CreditApplicationFormScreenState();
}

class _CreditApplicationFormScreenState
    extends ConsumerState<CreditApplicationFormScreen> {
  final _loan = TextEditingController(text: '5000');
  final _duration = TextEditingController(text: '12');
  final _income = TextEditingController(text: '3500');
  final _debt = TextEditingController(text: '0.3');
  final _age = TextEditingController(text: '30');
  final _employment = TextEditingController(text: 'Full-time');
  // New controllers for personal info / financial details
  final _fullName = TextEditingController(text: 'Alex Johnson');
  final _dob = TextEditingController(text: '1990-04-12');
  final _ssn = TextEditingController(text: '***-**-1234');
  final _email = TextEditingController(text: 'alex.johnson@example.com');
  final _phone = TextEditingController(text: '+1 555 123 4567');
  final _assets = TextEditingController(text: '12000');
  final _liabilities = TextEditingController(text: '3000');

  int _currentStep = 0;

  @override
  void dispose() {
    _loan.dispose();
    _duration.dispose();
    _income.dispose();
    _debt.dispose();
    _age.dispose();
    _employment.dispose();
    _fullName.dispose();
    _dob.dispose();
    _ssn.dispose();
    _email.dispose();
    _phone.dispose();
    _assets.dispose();
    _liabilities.dispose();
    super.dispose();
  }

  void _onStepContinue() {
    if (_currentStep < 3) {
      setState(() => _currentStep += 1);
      return;
    }

    // final submit
    final form = {
      'fullName': _fullName.text,
      'dob': _dob.text,
      'ssn': _ssn.text,
      'email': _email.text,
      'phone': _phone.text,
      'loanAmount': double.tryParse(_loan.text) ?? 0.0,
      'durationMonths': int.tryParse(_duration.text) ?? 12,
      'income': double.tryParse(_income.text) ?? 0.0,
      'assets': double.tryParse(_assets.text) ?? 0.0,
      'liabilities': double.tryParse(_liabilities.text) ?? 0.0,
      'debtRatio': double.tryParse(_debt.text) ?? 0.0,
      'age': int.tryParse(_age.text) ?? 0,
      'employment': _employment.text,
    };
    final result = computeScoreFromForm(form);
    ref.read(latestScoreProvider.notifier).state = result;

    // add to applications list (dummy)
    ref
        .read(applicationsProvider.notifier)
        .add(
          CreditApplication(
            id: 'app-${DateTime.now().millisecondsSinceEpoch}',
            amount: form['loanAmount'] as double,
            date: DateTime.now(),
            status: result.status,
          ),
        );

    context.goNamed('userScore');
  }

  void _onStepCancel() {
    if (_currentStep == 0) return; // nothing to do
    setState(() => _currentStep -= 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step ${_currentStep + 1} of 4 - New Credit Application'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Stepper(
                  currentStep: _currentStep,
                  onStepCancel: _onStepCancel,
                  onStepContinue: _onStepContinue,
                  controlsBuilder: (context, details) {
                    final isLast = _currentStep == 3;
                    return Row(
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 18,
                              ),
                              child: Text(isLast ? 'Submit' : 'Next'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (_currentStep > 0)
                          Flexible(
                            child: TextButton(
                              onPressed: details.onStepCancel,
                              child: const Text('Back'),
                            ),
                          ),
                      ],
                    );
                  },
                  steps: [
                    Step(
                      title: const Text('Step 1 — Personal'),
                      isActive: _currentStep >= 0,
                      state: _currentStep > 0
                          ? StepState.complete
                          : StepState.indexed,
                      content: Column(
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Full legal name',
                            ),
                            controller: _fullName,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Date of birth',
                            ),
                            controller: _dob,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            decoration: const InputDecoration(labelText: 'SSN'),
                            controller: _ssn,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                            ),
                            controller: _phone,
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text('Step 2 — Financial'),
                      isActive: _currentStep >= 1,
                      state: _currentStep > 1
                          ? StepState.complete
                          : StepState.indexed,
                      content: Column(
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Income',
                            ),
                            controller: _income,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Employment status',
                            ),
                            controller: _employment,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Assets',
                            ),
                            controller: _assets,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Liabilities',
                            ),
                            controller: _liabilities,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text('Step 3 — Review'),
                      isActive: _currentStep >= 2,
                      state: _currentStep > 2
                          ? StepState.complete
                          : StepState.indexed,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${_fullName.text}'),
                          Text('DOB: ${_dob.text}'),
                          Text('Email: ${_email.text}'),
                          const SizedBox(height: 8),
                          Text('Income: ${_income.text}'),
                          Text('Assets: ${_assets.text}'),
                          Text('Liabilities: ${_liabilities.text}'),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text('Step 4 — Consent'),
                      isActive: _currentStep >= 3,
                      state: _currentStep == 3
                          ? StepState.editing
                          : StepState.indexed,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Please review and accept the terms to continue.',
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Checkbox(value: true, onChanged: (v) {}),
                              const Expanded(
                                child: Text(
                                  'I agree to the Terms and Conditions',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
