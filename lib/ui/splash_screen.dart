import 'package:apotek_flutter/repository/pengguna_repository.dart';
import 'package:apotek_flutter/ui/login.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:apotek_flutter/widget/angular_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isWidgetRebuilt = false;
  bool _loadingComplete = false;
  bool _containerExpanded = false;
  bool _moveLogo = false;
  bool _showLogoText = false;

  @override
  void initState() {
    _createAdminUserIfNeeded();
    _changeStatusbarColor(Brightness.light);
    _initAnimationStep();

    super.initState();
  }

  void _initAnimationStep() {
    Future.delayed(Duration(seconds: 3), () async {
      setState(() {
        _loadingComplete = true;
        _containerExpanded = true;
      });

      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _moveLogo = true;
      });

      await Future.delayed(Duration(milliseconds: 300));
      setState(() {
        _showLogoText = true;
      });

      await Future.delayed(Duration(milliseconds: 400));
      _changePage();
    });
  }

  void _changePage() {
    final nextPage = Login();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextPage,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _changeStatusbarColor(Brightness brightness) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: brightness,
        statusBarBrightness: brightness,
      ),
    );
  }

  void _createAdminUserIfNeeded() {
    PenggunaRepository().createAdminUserIfNeeded();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted && !_isWidgetRebuilt) {
      _isWidgetRebuilt = true;
    }
    super.setState(fn);
  }

  double _minValue(double a, double b) => a < b ? a : b;
  double _maxValue(double a, double b) => a > b ? a : b;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final defaltContainerSize = _minValue(size.width / 2, 200);
    final containerSize = _containerExpanded
        ? _maxValue(
            size.width + (size.width / 2),
            size.height + (size.height / 2),
          )
        : defaltContainerSize;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Variables.colorSecondary, Variables.colorPrimary],
                ),
              ),
            ),
          ),

          // White background
          AnimatedPositioned(
            onEnd: () {
              _changeStatusbarColor(Brightness.dark);
            },
            top: (size.height / 2) - (containerSize / 2),
            left: (size.width / 2) - (containerSize / 2),
            duration: Duration(milliseconds: 800),
            child: AnimatedContainer(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              duration: Duration(milliseconds: _isWidgetRebuilt ? 800 : 0),
            ),
          ),

          // Loading
          Center(
            child: SizedBox(
              width: defaltContainerSize - 16,
              height: defaltContainerSize - 16,
              child: Center(
                child: AnimatedOpacity(
                  opacity: _loadingComplete ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: AngularLoading(),
                ),
              ),
            ),
          ),

          // Main Icon
          Center(
            child: SizedBox(
              width: defaltContainerSize * 2 - 48,
              child: Stack(
                children: [
                  AnimatedAlign(
                    alignment: _moveLogo
                        ? Alignment.centerRight
                        : Alignment.center,
                    duration: Duration(milliseconds: 600),
                    child: AnimatedOpacity(
                      opacity: _showLogoText ? 1 : 0,
                      duration: Duration(milliseconds: 300),
                      child: Image.asset(
                        'assets/images/logo-text only (dark).png',
                        width: defaltContainerSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  AnimatedAlign(
                    alignment: _moveLogo
                        ? Alignment.centerLeft
                        : Alignment.center,
                    duration: Duration(milliseconds: 600),
                    child: Image.asset(
                      'assets/images/logo-icon only.png',
                      width: defaltContainerSize - 48,
                      height: defaltContainerSize - 48,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
