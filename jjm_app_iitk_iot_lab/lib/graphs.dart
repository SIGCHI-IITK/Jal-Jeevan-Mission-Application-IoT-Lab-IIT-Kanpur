import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'admin_dashboard.dart';

class GraphsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graphs'),
      ),
      drawer: const MenuDrawer('/admin_dashboard'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildPieChart(context: context, title: 'Pie Chart 1', pieData: [
              PieChartSection(title: 'Hello', value: 30),
              PieChartSection(title: 'Hola', value: 20),
              PieChartSection(title: 'Sionara', value: 20),
              PieChartSection(title: 'Bonjour', value: 15),
              PieChartSection(title: 'Hi', value: 15)
            ]),
            SizedBox(height: 20),
            _buildPieChart(context: context, title: 'Pie Chart 2', pieData: [
              PieChartSection(title: 'Section 1', value: 10),
              PieChartSection(title: 'Section 2', value: 40),
              PieChartSection(title: 'Section 3', value: 50)
            ]),
            SizedBox(height: 20),
            _buildPieChart(context: context, title: 'Pie Chart 3', pieData: [
              PieChartSection(title: 'Section 1', value: 15),
              PieChartSection(title: 'Section 2', value: 25),
              PieChartSection(title: 'Section 3', value: 60)
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart({required BuildContext context, required String title, required List<PieChartSection> pieData}) {
    List<Color> colors = _getUniquePieChartColors(pieData.length);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 1,
              child: Builder(
                builder: (context) => PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null ||
                            pieTouchResponse.touchedSection!.touchedSectionIndex == -1) {
                          return;
                        }
                        final section = pieTouchResponse.touchedSection;
                        final index = section!.touchedSectionIndex;

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(pieData[index].title),
                            content: Text('Value: ${pieData[index].value}'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    sections: List.generate(
                      pieData.length,
                          (index) => PieChartSectionData(
                        color: colors[index],
                        value: pieData[index].value,
                        title: '',
                        radius: 70,
                      ),
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 50,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  List<Color> _getUniquePieChartColors(int count) {
    List<Color> usedColors = [];
    List<Color> colors = [];

    for (int i = 0; i < count; i++) {
      Color color;
      do {
        color = _getRandomColor();
      } while (usedColors.contains(color));
      usedColors.add(color);
      colors.add(color);
    }

    return colors;
  }
}

class PieChartSection {
  final String title;
  final double value;

  PieChartSection({required this.title, required this.value});
}
