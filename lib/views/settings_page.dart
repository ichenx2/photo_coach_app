import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text('設定', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // 頭像暱稱
            Column(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('assets/images/electric_god.png'), 
                ),
                const SizedBox(height: 8),
                RichText(
                  text: const TextSpan(
                    text: '康哲瑋好⚡️',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            //設丁
            sectionTitle('設定'),
            menuItem(Icons.translate, '更改語言'),

            const SizedBox(height: 16),
            //帳號
            sectionTitle('帳號'),
            menuItem(Icons.person_outline, '變更帳號名稱'),
            menuItem(Icons.key, '更改密碼'),
            menuItem(Icons.camera_alt_outlined, '更換大頭貼'),

            const SizedBox(height: 16),
            //other
            sectionTitle('其他功能'),
            menuItem(Icons.info_outline, '關於我們'),
            menuItem(Icons.help_outline, '常見問題'),
            menuItem(Icons.flash_on_outlined, '贊助與回饋'),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }

  Widget menuItem(IconData icon, String title) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0),
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // 67890
      },
    );
  }
}
