import 'package:apotek_flutter/ui/home.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:apotek_flutter/widget/app_text_button.dart';
import 'package:apotek_flutter/widget/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showBody = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _showBody = true;
      });
    });
  }

  void _doLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: implement login action

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Home())
      );
    }
  }

  double _minValue(double a, double b) => a < b ? a : b;
  double _maxValue(double a, double b) => a > b ? a : b;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final splashScreenDefaltContainerSize = _minValue(size.width / 2, 200);
    final logoSize = splashScreenDefaltContainerSize - 48;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          AnimatedContainer(
            height: _showBody ? 52 : size.height / 2 - (logoSize / 2),
            duration: Duration(seconds: 1),
          ),

          // Main Logo
          Center(
            child: SizedBox(
                width: splashScreenDefaltContainerSize * 2 - 48,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo-icon only.png',
                      width: logoSize,
                      height: logoSize,
                    ),
                    Image.asset(
                      'assets/images/logo-text only (dark).png',
                      width: splashScreenDefaltContainerSize,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
          ),

          // Login Body
          AnimatedOpacity(
            opacity: _showBody ? 1 : 0,
            duration: Duration(seconds: 1),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                constraints: BoxConstraints(
                  maxWidth: 500,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      SizedBox(height: 16),
                            
                      MyTextFormField(
                        labelText: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16),
                            
                      MyTextFormField(
                        labelText: 'Kata Sandi',
                        controller: _passwordController,
                        obscureText: true,
                        // keyboardType: TextInputType.pas,
                      ),
                      SizedBox(height: 16),
                            
                      SizedBox(
                        width: double.infinity,
                        child: AppTextButton(
                          onPressed: _doLogin,
                          label: 'Masuk',
                          backgroundColor: Variables.colorPrimary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                            
                      SizedBox(height: _maxValue(size.height - logoSize - 460, 80)),
                      Text(
                        'Oleh Kelompok 3\n 19.5E.01',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Variables.colorMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}