import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../core/colors.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        title: const Text(
          "Mood Analytics",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            icon: Image.asset(
              "assets/images/relax.png",
              width: 24,
              color: Colors.white,
            ),
            onPressed: () => context.push('/relax'),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(user!.uid)
                  .collection("chats")
                  .orderBy("timestamp")
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            var docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(
                child: Text(
                  "No data yet",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            List<FlSpot> points = [];
            double totalRisk = 0;

            for (int i = 0; i < docs.length; i++) {
              double risk = (docs[i]["risk"] ?? 0).toDouble();
              totalRisk += risk;
              points.add(FlSpot(i.toDouble(), risk));
            }

            double avgRisk = totalRisk / docs.length;

            String moodLabel;
            Color moodColor;

            if (avgRisk < 3) {
              moodLabel = "Stable";
              moodColor = Colors.green;
            } else if (avgRisk < 6) {
              moodLabel = "Moderate";
              moodColor = Colors.orange;
            } else {
              moodLabel = "High Risk";
              moodColor = Colors.red;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _infoCard(
                      title: "Avg Risk",
                      value: avgRisk.toStringAsFixed(1),
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    _infoCard(
                      title: "Status",
                      value: moodLabel,
                      color: moodColor,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Mood Trend",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.info_outline, color: Colors.white54),
                  ],
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1F20),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: 10,

                        gridData: FlGridData(
                          show: true,
                          getDrawingHorizontalLine:
                              (value) =>
                                  FlLine(color: Colors.white10, strokeWidth: 1),
                        ),

                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget:
                                  (value, meta) => Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 10,
                                    ),
                                  ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget:
                                  (value, meta) => Text(
                                    "Day ${value.toInt() + 1}",
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 10,
                                    ),
                                  ),
                            ),
                          ),
                        ),

                        borderData: FlBorderData(show: false),

                        lineBarsData: [
                          LineChartBarData(
                            spots: points,
                            isCurved: true,
                            barWidth: 3,
                            color: AppColors.primary,
                            dotData: FlDotData(show: true),

                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "This graph shows your emotional risk trend over time. Higher values indicate increased stress or negative emotional patterns.",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1F20),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
