import 'package:flutter/material.dart';
import 'package:money_saver/models/chart_data.dart';
import 'package:money_saver/widgets/empty_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChart extends StatelessWidget {
  final List<ChartData> chartData;
  final String textEmpty;

  const PieChart({super.key, required this.chartData, required this.textEmpty});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: (chartData.isNotEmpty)
            ? SfCircularChart(
                legend: const Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    overflowMode: LegendItemOverflowMode.wrap),
                series: <CircularSeries>[
                    // Render pie chart
                    DoughnutSeries<ChartData, String>(
                      dataSource: chartData,
                      pointColorMapper: (ChartData data, _) => data.color,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        labelIntersectAction: LabelIntersectAction.shift,
                        labelAlignment: ChartDataLabelAlignment.top,
                        connectorLineSettings: ConnectorLineSettings(
                          length: '10',
                          type: ConnectorType.curve,
                          width: 2,
                        ),
                        labelPosition: ChartDataLabelPosition.outside,
                      ),
                    ),
                  ])
            : EmptyStateWidget(
                text: textEmpty,
              ));
  }
}
