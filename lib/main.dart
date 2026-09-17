import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shmert Calculator',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101114),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB547),
          brightness: Brightness.dark,
        ),
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  double? _storedValue;
  String? _operation;
  bool _startsNewNumber = true;

  void _input(String value) {
    setState(() {
      if (_startsNewNumber || _display == '0' || _display == 'Error') {
        _display = value;
        _startsNewNumber = false;
      } else if (_display.length < 12) {
        _display += value;
      }
    });
  }

  void _decimal() {
    setState(() {
      if (_startsNewNumber || _display == 'Error') {
        _display = '0.';
        _startsNewNumber = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _chooseOperation(String operation) {
    setState(() {
      _storedValue = double.parse(_display);
      _operation = operation;
      _startsNewNumber = true;
    });
  }

  void _calculate() {
    if (_storedValue == null || _operation == null) return;
    final currentValue = double.parse(_display);
    final result = switch (_operation) {
      '+' => _storedValue! + currentValue,
      '-' => _storedValue! - currentValue,
      'x' => _storedValue! * currentValue,
      '÷' => currentValue == 0 ? double.nan : _storedValue! / currentValue,
      _ => currentValue,
    };
    setState(() {
      _display = _format(result);
      _storedValue = null;
      _operation = null;
      _startsNewNumber = true;
    });
  }

  String _format(double value) {
    if (value.isNaN || value.isInfinite) return 'Error';
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(8).replaceFirst(RegExp(r'0+$'), '');
  }

  void _clear() {
    setState(() {
      _display = '0';
      _storedValue = null;
      _operation = null;
      _startsNewNumber = true;
    });
  }

  void _toggleSign() {
    setState(() {
      if (_display != '0' && _display != 'Error') {
        _display = _display.startsWith('-')
            ? _display.substring(1)
            : '-$_display';
      }
    });
  }

  void _percent() {
    setState(() {
      _display = _format(double.parse(_display) / 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'SHMERT',
                  style: TextStyle(
                    color: Color(0xFFFFB547),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(height: 45),
              Align(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _display,
                    key: const Key('display'),
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 68,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _button(
                        'AC',
                        onPressed: _clear,
                        kind: _ButtonKind.utility,
                      ),
                      _button(
                        '+/-',
                        onPressed: _toggleSign,
                        kind: _ButtonKind.utility,
                      ),
                      _button(
                        '%',
                        onPressed: _percent,
                        kind: _ButtonKind.utility,
                      ),
                      _button(
                        '÷',
                        onPressed: () => _chooseOperation('÷'),
                        kind: _ButtonKind.operator,
                      ),
                      _button('7', onPressed: () => _input('7')),
                      _button('8', onPressed: () => _input('8')),
                      _button('9', onPressed: () => _input('9')),
                      _button(
                        'x',
                        onPressed: () => _chooseOperation('x'),
                        kind: _ButtonKind.operator,
                      ),
                      _button('4', onPressed: () => _input('4')),
                      _button('5', onPressed: () => _input('5')),
                      _button('6', onPressed: () => _input('6')),
                      _button(
                        '-',
                        onPressed: () => _chooseOperation('-'),
                        kind: _ButtonKind.operator,
                      ),
                      _button('1', onPressed: () => _input('1')),
                      _button('2', onPressed: () => _input('2')),
                      _button('3', onPressed: () => _input('3')),
                      _button(
                        '+',
                        onPressed: () => _chooseOperation('+'),
                        kind: _ButtonKind.operator,
                      ),
                      _button('0', onPressed: () => _input('0'), wide: true),
                      _button('.', onPressed: _decimal),
                      _button(
                        '=',
                        onPressed: _calculate,
                        kind: _ButtonKind.equals,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(
    String label, {
    required VoidCallback onPressed,
    _ButtonKind kind = _ButtonKind.number,
    bool wide = false,
  }) {
    final background = switch (kind) {
      _ButtonKind.number => const Color(0xFF202227),
      _ButtonKind.utility => const Color(0xFF34363D),
      _ButtonKind.operator => const Color(0xFFFFB547),
      _ButtonKind.equals => const Color(0xFFE9824B),
    };
    final foreground = kind == _ButtonKind.number || kind == _ButtonKind.utility
        ? Colors.white
        : const Color(0xFF17181B);
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: wide ? 25 : 25, fontWeight: FontWeight.w500),
      ),
    );
  }
}

enum _ButtonKind { number, utility, operator, equals }
