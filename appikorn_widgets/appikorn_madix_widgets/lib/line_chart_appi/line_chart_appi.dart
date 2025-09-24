library line_chart_appi_flutter;

import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

class LineChartAppi extends StatelessWidget {
  const LineChartAppi({
    Key? key,
    required this.xData,
    required this.yData,
    this.title,
    this.titleStyle,
    this.titleWidget,
    this.titleToolTip,
    this.bgCardStyle,
    this.filterWidget,
    this.primaryColor,
    this.interaction,
    this.secondaryColor,
  }) : super(key: key);

  final List<String> xData;
  final List<int> yData;
  final String? title;
  final String? titleToolTip;
  final Widget? titleWidget;
  final Widget? filterWidget;
  final Style? titleStyle;
  final Style? bgCardStyle;
  final Color? primaryColor;
  final Color? secondaryColor;
  final bool? interaction;

  String colorToHex(Color color) {
    int red = color.red;
    int green = color.green;
    int blue = color.blue;
    double alpha = color.opacity;
    return 'rgba($red, $green, $blue, $alpha)';
  }

  Widget web({required dat, required context}) {
    final String viewId = 'plotly-chart-${DateTime.now()}';

    platformViewRegistry.registerViewFactory(viewId, (int viewId) {
      final iframe = html.IFrameElement()
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.pointerEvents = 'auto'; // Enable pointer events

      iframe.src = Uri.dataFromString(
        dat,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString();

      return iframe;
    });

    return MouseRegion(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 800, // Fixed width to enable horizontal scrolling
          child: HtmlElementView(viewType: viewId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var primaryColorDefault = Theme.of(context).colorScheme.primary;
    var secondaryColorDefault = Theme.of(context).colorScheme.secondary;
    String htmlContent = """
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Custom Chart.js Design</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-annotation"></script>
  <style>
    body, html {
      margin: 0;
      padding: 0;
      width: 100%;
      height: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
      touch-action: none;
    }
    .chart-container {
      width: 100%;
      height: 100%;
      position: relative;
      min-width: 800px;
      touch-action: none;
      user-select: none;
      -webkit-user-select: none;
    }
    canvas {
      width: 100% !important;
      height: 100% !important;
      touch-action: none;
    }
  </style>
</head>
<body>
  <div class="chart-container">
    <canvas id="myChart"></canvas>
  </div>
  <script>
    const ctx = document.getElementById('myChart').getContext('2d');
    const gradient = ctx.createLinearGradient(0, 0, 0, 400);
    gradient.addColorStop(0, 'rgba(58, 123, 213, 0.5)');
    gradient.addColorStop(1, 'rgba(58, 123, 213, 0)');

    const data = {
      labels: ${json.encode(xData)},
      datasets: [{
        data: $yData,
        borderColor: '${colorToHex(primaryColor ?? primaryColorDefault)}',
        backgroundColor: '${colorToHex(secondaryColor ?? secondaryColorDefault)}',
        fill: true,
        tension: 0.4,
        pointBackgroundColor: 'rgba(255, 255, 255, 0.6)',
        pointBorderColor: '#3A7BD5',
        pointBorderWidth: 1,
        pointRadius: 4,
        hoverRadius: 6,
        hoverBackgroundColor: '#3A7BD5',
        hoverBorderWidth: 2,
        hoverBorderColor: '#fff',
      }]
    };

    const options = {
      plugins: {
        title: {
          display: true,
          text: '${title ?? ""}',
          color: '#333',
          font: {
            size: 18,
            weight: 'bold'
          }
        },
        tooltip: {
          enabled: true,
          mode: 'index',
          intersect: false,
          callbacks: {
            label: function(tooltipItem) {
              return `Value: \${tooltipItem.raw} (\${tooltipItem.label})`;
            }
          }
        },
        legend: {
          display: false
        }
      },
      scales: {
        x: {
          grid: {
            display: false
          },
          ticks: {
            color: '#333',
            autoSkip: false,
            maxRotation: 45,
            minRotation: 45
          }
        },
        y: {
          grid: {
            color: 'rgba(200, 200, 200, 0.2)'
          },
          ticks: {
            color: '#333'
          },
          border: {
            display: false
          }
        }
      },
      responsive: true,
      maintainAspectRatio: false,
      interaction: {
        mode: 'nearest',
        axis: 'x',
        intersect: false
      },
      hover: {
        mode: 'index',
        intersect: false
      },
      events: ['mousemove', 'mouseout', 'click', 'touchstart', 'touchmove']
    };

    const chart = new Chart(ctx, {
      type: 'line',
      data: data,
      options: options
    });
  </script>
</body>
</html>
""";

    return LayoutBuilder(
      builder: (context, constraints) {
        Style titleTextWidgetStyle = Style.combine([
          Style(
            $text.style.color.black(),
            $text.style.fontSize(19),
            $text.style.fontWeight(FontWeight.w700),
          )
        ]);

        Style bgCardWidgetStyle = Style.combine([
          Style(
            $box.color.white(),
            $box.borderRadius.all(15),
            $box.elevation(4),
          )
        ]);

        return Box(
          style: bgCardWidgetStyle.merge(bgCardStyle ?? const Style.empty()),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                titleWidget ??
                    Row(
                      children: [
                        StyledText(title ?? "", style: titleTextWidgetStyle.merge(titleStyle ?? const Style.empty())),
                        const SizedBox(width: 10),
                        IconButton(
                            tooltip: titleToolTip, // Add your tooltip text here
                            onPressed: () {},
                            icon: const Icon(
                              Icons.info_outline,
                              color: Colors.grey,
                            )),
                        const Spacer(),
                        filterWidget ?? Container()
                      ],
                    ),
                Expanded(child: web(dat: htmlContent, context: context)),
              ],
            ),
          ), // Your child widget
        );
      },
    );
  }
}
