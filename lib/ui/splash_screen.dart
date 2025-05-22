import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../utils/app_assets.dart';
import 'home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splash_screen';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        body: themeProvider.currentTheme == ThemeMode.light ?
        Image.asset(
          AppAssets.splashLight,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        )
            : Image.asset(
          AppAssets.splashDark,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        )
    );
  }
}
