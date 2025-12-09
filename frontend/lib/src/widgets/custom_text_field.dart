import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool dark;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.dark = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;
  late FocusNode _focusNode;
  late TextEditingController _effectiveController;
  double _strength = 0.0; // 0.0 - 1.0

  String _strengthLabel() {
    if (_strength < 0.25) return 'Very weak';
    if (_strength < 0.5) return 'Weak';
    if (_strength < 0.75) return 'Good';
    return 'Strong';
  }

  Color _strengthColor() {
    if (_strength < 0.25) return Colors.redAccent;
    if (_strength < 0.5) return Colors.deepOrangeAccent;
    if (_strength < 0.75) return Colors.amberAccent;
    return Colors.greenAccent;
  }

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    _focusNode = FocusNode();
    _effectiveController = widget.controller ?? TextEditingController();
    // listen for changes to update strength
    if (widget.obscureText) {
      _effectiveController.addListener(_updateStrength);
    }
    _focusNode.addListener(() => setState(() {}));
  }

  void _updateStrength() {
    final text = _effectiveController.text;
    double score = 0;
    if (text.length >= 6) score += 0.25;
    if (text.length >= 10) score += 0.15;
    if (RegExp(r'[A-Z]').hasMatch(text)) score += 0.2;
    if (RegExp(r'[0-9]').hasMatch(text)) score += 0.2;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(text)) score += 0.2;
    _strength = score.clamp(0.0, 1.0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final showStrength = widget.obscureText;
    final eyeColor = _focusNode.hasFocus
        ? (widget.dark ? Colors.white : Theme.of(context).colorScheme.primary)
        : (widget.dark ? Colors.white70 : Colors.black45);

    final textField = TextField(
      controller: _effectiveController,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      obscureText: _obscure,
      decoration: InputDecoration(
        labelText: widget.label,
        filled: widget.dark,
        fillColor: widget.dark ? const Color(0xFF072022) : null,
        labelStyle: TextStyle(color: widget.dark ? Colors.white70 : null),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: widget.obscureText
            ? Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: GestureDetector(
                  onTap: () => setState(() => _obscure = !_obscure),
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 140),
                    scale: _focusNode.hasFocus ? 1.05 : 1.0,
                    child: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: eyeColor,
                    ),
                  ),
                ),
              )
            : null,
      ),
      style: TextStyle(color: widget.dark ? Colors.white : null),
    );

    if (!showStrength) return textField;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textField,
        const SizedBox(height: 8),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _strength > 0 ? 1.0 : 0.0,
          child: Row(
            children: [
              Expanded(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: _strength),
                  duration: const Duration(milliseconds: 260),
                  builder: (context, animatedValue, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: animatedValue.clamp(0.0, 1.0),
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _strengthColor(),
                        ),
                        minHeight: 6,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _strengthLabel(),
                style: TextStyle(
                  color: _strengthColor().withAlpha((0.9 * 255).round()),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (widget.obscureText) {
      _effectiveController.removeListener(_updateStrength);
    }
    if (widget.controller == null) {
      _effectiveController.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }
}
