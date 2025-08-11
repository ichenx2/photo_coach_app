import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class LearningChartPage extends StatelessWidget {
  const LearningChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            '學習圖表',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          centerTitle: false,
        ),
        body: const Center(
          child: Text(
            '這裡是學習圖表頁面\n(你可以在這裡實作圖表)',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
