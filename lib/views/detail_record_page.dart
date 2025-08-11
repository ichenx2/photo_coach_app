import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/skill_service.dart';
import '../themes/app_theme.dart';
import 'learning_chart_page.dart';

class DetailRecordPage extends StatefulWidget {
  const DetailRecordPage({super.key});

  @override
  State<DetailRecordPage> createState() => _DetailRecordPageState();
}

class _DetailRecordPageState extends State<DetailRecordPage> {
  late Future<List<dynamic>> recordDataFuture;

  @override
  void initState() {
    super.initState();
    recordDataFuture = ApiService.fetchUserSkills(1); // user id
  }

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
          title: const Text('詳細記錄',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)),
          centerTitle: false,
        ),
        

        body: FutureBuilder<List<dynamic>>(
          future: recordDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('錯誤：${snapshot.error}'));
            }

            final List<dynamic> data = snapshot.data ?? [];

            if (data.isEmpty) {
              return const Center(child: Text('無資料'));
            }

            final records = data.map((item) {
              final title = item['skill_name']?.toString() ?? '無標題';
              final progress = (item['progress'] ?? 0) as num;
              final level = (item['level'] ?? 1) as int;
              return RecordData(title, _iconFor(title), progress.toDouble(), level);
            }).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                          foregroundColor: Colors.grey.shade800,
                          elevation: 0,
                          side: const BorderSide(color: Color.fromARGB(81, 255, 193, 7), width: 3),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.bar_chart),
                        label: const Text('查看我的學習圖表',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LearningChartPage()),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  _buildCategorySection('構圖技巧', records.where((r) => _isComposition(r.title)).toList()),
                  const SizedBox(height: 24),
                  _buildCategorySection('光線運用', records.where((r) => _isLighting(r.title)).toList()),
                  const SizedBox(height: 24),
                  _buildCategorySection('拍攝角度', records.where((r) => _isAngle(r.title)).toList()),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 4,
          onPressed: () {},
          child: const Icon(Icons.camera_alt, color: Colors.black),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 6.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: const Icon(Icons.home), onPressed: () {}),
                IconButton(icon: const Icon(Icons.calendar_today), onPressed: () {}),
                const SizedBox(width: 40),
                IconButton(icon: const Icon(Icons.photo_library), onPressed: () {}),
                IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(String title, List<RecordData> items) {
    if (items.isEmpty) return const SizedBox();

    return LayoutBuilder(
      builder: (context, constraints) {
        const double spacing = 28;
        final double cardWidth = MediaQuery.of(context).size.width /2* 0.75;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 18),
            Center(
              child: Wrap(
                spacing: spacing,
                runSpacing: spacing,
                alignment: WrapAlignment.center,
                children: items.map((record) {
                  return SizedBox(
                    width: cardWidth, 
                    child: RecordCard(data: record, width: cardWidth),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }



  bool _isComposition(String title) {
    return [
      "三分法", "對角線構圖", "中心構圖", "引導線", "框架構圖",
      "留白構圖", "對稱構圖", "填滿畫面"
    ].contains(title);
  }

  bool _isLighting(String title) {
    return [
      "順光", "逆光", "側光", "頂光", "柔光", "人工光源"
    ].contains(title);
  }

  bool _isAngle(String title) {
    return [
      "特寫", "廣角", "仰角", "俯角", "平視", "鳥瞰", "蟻視"
    ].contains(title);
  }

  IconData _iconFor(String title) {
    switch (title) {
      case "三分法": return Icons.grid_3x3;
      case "對角線構圖": return Icons.stacked_line_chart;
      case "中心構圖": return Icons.adjust;
      case "框架構圖": return Icons.crop_din;
      case "引導線": return Icons.show_chart;
      case "留白構圖": return Icons.space_bar;
      case "對稱構圖": return Icons.view_column;
      case "填滿畫面": return Icons.fullscreen;
      case "順光": return Icons.wb_sunny;
      case "逆光": return Icons.cloud;
      case "側光": return Icons.wb_twilight;
      case "頂光": return Icons.wb_incandescent;
      case "柔光": return Icons.wb_cloudy;
      case "人工光源": return Icons.lightbulb;
      case "特寫": return Icons.photo_camera;
      case "廣角": return Icons.photo_camera_back;
      case "仰角": return Icons.vertical_align_top;
      case "俯角": return Icons.vertical_align_bottom;
      case "平視": return Icons.remove_red_eye;
      case "鳥瞰": return Icons.map;
      case "蟻視": return Icons.stairs;
      default: return Icons.help_outline;
    }
  }
}

class RecordData {
  final String title;
  final IconData icon;
  final double progress;
  final int level;
  const RecordData(this.title, this.icon, this.progress,this.level);
}

class RecordCard extends StatelessWidget {
  final RecordData data;
  final double width;

  const RecordCard({super.key, required this.data, required this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        data.title,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 50),
                      Text(
                        _getDescription(data.title),
                        style: const TextStyle(fontSize: 18, height: 1.4, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            elevation: 0,
                            side: BorderSide(color: Colors.grey.shade300, width: 3),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('關閉', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        width: width,
        height: 220,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(data.icon, size: 60, color: Colors.grey.shade600),
            const SizedBox(height: 10),
            Text(
              data.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '等級：${data.level}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: data.progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            )
          ],
        ),
      ),
    );
  }

  String _getDescription(String title) {
    switch (title) {
      case "三分法": return "將畫面分為 3×3 九宮格，將主體置於線條交會處，強化畫面張力";
      case "對角線構圖": return "主體或動線沿對角線排列，營造動感與深度";
      case "中心構圖": return "主體置中，強調穩定與對稱";
      case "引導線": return "利用道路、欄杆、光影等線條帶出主體，強化導引效果";
      case "框架構圖": return "利用門框、窗框、樹枝等自然元素包圍主體，引導視線集中";
      case "留白構圖": return "留下大量空白區域，營造簡約、寧靜或突顯主體";
      case "對稱構圖": return "利用建築、水面等創造畫面對稱，提升平衡與美感";
      case "填滿畫面": return "主體佔滿整個畫面，強化細節或表現力量感";
      case "順光": return "光線從相機後方照射主體，色彩還原準確，適合紀錄類拍攝";
      case "逆光": return "光線從主體背後來，容易產生剪影或光暈效果，增添戲劇感";
      case "側光": return "光線從側面照射，產生陰影與立體感，常用於人像";
      case "頂光": return "從正上方照射，容易產生強烈陰影，適合創造戲劇性氛圍";
      case "柔光": return "使用窗簾、雲層、反光板柔化光線，使畫面柔和自然";
      case "人工光源": return "使用閃燈、燈具補光，可控制光源方向與強度，常用於靜物與人像拍攝";
      case "特寫": return "聚焦小範圍或主體細節，如花、食物，常用於產品攝影與情感傳達";
      case "廣角": return "使用廣角鏡頭，拉出空間感，常見於風景或建築攝影";
      case "仰角": return "從下往上拍，使主體顯得宏偉或強勢";
      case "俯角": return "從上往下拍，展現空間關係或營造小巧可愛的視角";
      case "平視": return "與主體平行，最自然直觀的視角，常用於人像與紀錄";
      case "鳥瞰": return "高空俯拍，如航拍或建築全景";
      case "蟻視": return "極低視角拍攝，放大主體氣勢或營造童話感";
      default: return "別問 我不知道";
    }
  }
}
