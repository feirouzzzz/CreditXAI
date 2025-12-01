import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_button.dart';
import '../widgets/glass_card.dart';
// providers import removed (theme toggle removed)

/// Login screen with simple fintech header and subtle gradient.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _confirm = TextEditingController();
  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;
  bool _isLogin = true;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  // keys and measurements for the sliding pill
  final GlobalKey _tabsKey = GlobalKey();
  final GlobalKey _loginLabelKey = GlobalKey();
  final GlobalKey _signLabelKey = GlobalKey();
  double _loginPillLeft = 0.0;
  double _signPillLeft = 0.0;
  double _pillWidth = 120.0;
  double _pillScale = 1.0;
  double _pillOpacity = 1.0;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _confirm.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    // start the subtle entrance animation
    _animController.forward();
    // measure pill after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _updatePillForTabs());
  }

  void _updatePillForTabs() {
    try {
      final tabsBox = _tabsKey.currentContext?.findRenderObject() as RenderBox?;
      final loginBox =
          _loginLabelKey.currentContext?.findRenderObject() as RenderBox?;
      final signBox =
          _signLabelKey.currentContext?.findRenderObject() as RenderBox?;
      if (tabsBox == null || loginBox == null || signBox == null) return;

      final tabsPos = tabsBox.localToGlobal(Offset.zero);
      final loginPos = loginBox.localToGlobal(Offset.zero);
      final signPos = signBox.localToGlobal(Offset.zero);

      final loginCenter = loginPos.dx - tabsPos.dx + loginBox.size.width / 2;
      final signCenter = signPos.dx - tabsPos.dx + signBox.size.width / 2;

      // pill width should equal label width plus horizontal padding (26*2)
      final loginPillW = loginBox.size.width + 52;
      final signPillW = signBox.size.width + 52;

      final loginLeft = loginCenter - loginPillW / 2;
      final signLeft = signCenter - signPillW / 2;

      setState(() {
        _pillWidth = _isLogin ? loginPillW : signPillW;
        _loginPillLeft = loginLeft.clamp(0.0, tabsBox.size.width - loginPillW);
        _signPillLeft = signLeft.clamp(0.0, tabsBox.size.width - signPillW);
      });
    } catch (_) {
      // measurement failed — ignore
    }
  }

  void _login() {
    final email = _email.text.trim();
    final password = _password.text;

    // demo credentials
    const userEmail = 'test@demo.com';
    const userPass = 'Password123!';
    const adminEmail = 'admin@demo.com';
    const adminPass = 'Admin123!';

    if (email == adminEmail && password == adminPass) {
      // admin
      context.goNamed('adminDashboard');
      return;
    }

    if (email == userEmail && password == userPass) {
      context.goNamed('userHome');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid credentials — try test@demo.com / Password123!'),
      ),
    );
  }

  void _attemptRegister() {
    // reset errors
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmError = null;
    });

    final name = _name.text.trim();
    final email = _email.text.trim();
    final password = _password.text;
    final confirm = _confirm.text;

    var hasError = false;
    if (name.isEmpty) {
      _nameError = 'Enter your full name';
      hasError = true;
    }
    if (email.isEmpty || !email.contains('@')) {
      _emailError = 'Enter a valid email';
      hasError = true;
    }
    if (password.length < 6) {
      _passwordError = 'Password must be at least 6 characters';
      hasError = true;
    }
    if (confirm != password) {
      _confirmError = 'Passwords do not match';
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    // demo success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created — demo mode')),
    );
    // clear form and switch to login
    setState(() {
      _name.clear();
      _email.clear();
      _password.clear();
      _confirm.clear();
      _isLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF002B36), Color(0xFF003F3B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GlassCard(
                  padding: const EdgeInsets.all(20),
                  borderRadius: 20,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 2),

                            // big icon + title matching the design
                            Center(
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: const Color(0xFF0E7A66),
                                child: const Icon(
                                  Icons.shield,
                                  color: Color(0xFF23F6D9),
                                  size: 28,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // title
                            Text(
                              'Secure, Ethical Finance',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            // login / sign up tabs (in-card toggle) with animated sliding pill
                            SizedBox(
                              width: 300,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  // stack container for tabs
                                  return Stack(
                                    key: _tabsKey,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white10,
                                          borderRadius: BorderRadius.circular(
                                            28,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isLogin = true;
                                                  _pillScale = 0.96;
                                                  _pillOpacity = 0.92;
                                                });
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback(
                                                      (_) =>
                                                          _updatePillForTabs(),
                                                    );
                                                Future.delayed(
                                                  const Duration(
                                                    milliseconds: 260,
                                                  ),
                                                  () {
                                                    if (mounted) {
                                                      setState(() {
                                                        _pillScale = 1.0;
                                                        _pillOpacity = 1.0;
                                                      });
                                                    }
                                                  },
                                                );
                                              },
                                              child: Container(
                                                key: _loginLabelKey,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 26,
                                                      vertical: 8,
                                                    ),
                                                child: Text(
                                                  'Login',
                                                  style: TextStyle(
                                                    color: _isLogin
                                                        ? Colors.white
                                                        : Colors.white70,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 28),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isLogin = false;
                                                  _pillScale = 0.96;
                                                  _pillOpacity = 0.92;
                                                });
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback(
                                                      (_) =>
                                                          _updatePillForTabs(),
                                                    );
                                                Future.delayed(
                                                  const Duration(
                                                    milliseconds: 260,
                                                  ),
                                                  () {
                                                    if (mounted) {
                                                      setState(() {
                                                        _pillScale = 1.0;
                                                        _pillOpacity = 1.0;
                                                      });
                                                    }
                                                  },
                                                );
                                              },
                                              child: Container(
                                                key: _signLabelKey,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 26,
                                                      vertical: 8,
                                                    ),
                                                child: Text(
                                                  'Sign Up',
                                                  style: TextStyle(
                                                    color: !_isLogin
                                                        ? Colors.white
                                                        : Colors.white70,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // sliding pill positioned exactly beneath the labels
                                      Positioned.fill(
                                        child: IgnorePointer(
                                          child: AnimatedBuilder(
                                            animation: Listenable.merge([
                                              _animController,
                                            ]),
                                            builder: (context, _) {
                                              // measure after layout
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback(
                                                    (_) => _updatePillForTabs(),
                                                  );
                                              final left = _isLogin
                                                  ? _loginPillLeft
                                                  : _signPillLeft;
                                              return AnimatedPositioned(
                                                duration: const Duration(
                                                  milliseconds: 260,
                                                ),
                                                curve: Curves.easeOutCubic,
                                                left: left,
                                                top: 6,
                                                width: _pillWidth,
                                                height: 36,
                                                child: AnimatedOpacity(
                                                  duration: const Duration(
                                                    milliseconds: 200,
                                                  ),
                                                  opacity: _pillOpacity,
                                                  child: AnimatedScale(
                                                    duration: const Duration(
                                                      milliseconds: 200,
                                                    ),
                                                    scale: _pillScale,
                                                    curve: Curves.easeOutBack,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white24,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // content area: animated switch between login and register
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 360),
                          transitionBuilder: (child, anim) {
                            final offsetAnim = Tween<Offset>(
                              begin: Offset(_isLogin ? 1 : -1, 0),
                              end: Offset.zero,
                            ).animate(anim);
                            return SlideTransition(
                              position: offsetAnim,
                              child: FadeTransition(
                                opacity: anim,
                                child: child,
                              ),
                            );
                          },
                          child: _isLogin
                              ? Column(
                                  key: const ValueKey('loginForm'),
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Email',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    CustomTextField(
                                      label: 'Email',
                                      controller: _email,
                                      keyboardType: TextInputType.emailAddress,
                                      dark: true,
                                    ),
                                    if (_emailError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          _emailError!,
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Password',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    CustomTextField(
                                      label: 'Password',
                                      controller: _password,
                                      obscureText: true,
                                      dark: true,
                                    ),
                                    if (_passwordError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          _passwordError!,
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 18),
                                    ScaleTransition(
                                      scale: _scaleAnim,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: GradientButton(
                                          label: 'Login',
                                          onPressed: _login,
                                          borderRadius: 18,
                                          colors: const [
                                            Color(0xFF23F6D9),
                                            Color(0xFF00C6A6),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            style: OutlinedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.g_mobiledata,
                                            ),
                                            label: const Text(
                                              'Continue with Google',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            style: OutlinedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () {},
                                            icon: const Icon(Icons.apple),
                                            label: const Text(
                                              'Continue with Apple',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {},
                                        child: const Text(
                                          'Forgot password?',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  key: const ValueKey('registerForm'),
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Full name',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    CustomTextField(
                                      label: 'Full name',
                                      controller: _name,
                                      keyboardType: TextInputType.name,
                                      dark: true,
                                    ),
                                    if (_nameError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          _nameError!,
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Email',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    CustomTextField(
                                      label: 'Email',
                                      controller: _email,
                                      keyboardType: TextInputType.emailAddress,
                                      dark: true,
                                    ),
                                    if (_emailError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          _emailError!,
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Password',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    CustomTextField(
                                      label: 'Password',
                                      controller: _password,
                                      obscureText: true,
                                      dark: true,
                                    ),
                                    if (_passwordError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          _passwordError!,
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Confirm password',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    CustomTextField(
                                      label: 'Confirm password',
                                      controller: _confirm,
                                      obscureText: true,
                                      dark: true,
                                    ),
                                    if (_confirmError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          _confirmError!,
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 18),
                                    ScaleTransition(
                                      scale: _scaleAnim,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: GradientButton(
                                          label: 'Sign Up',
                                          onPressed: _attemptRegister,
                                          borderRadius: 18,
                                        ),
                                      ),
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
        ),
      ),
    );
  }
}
