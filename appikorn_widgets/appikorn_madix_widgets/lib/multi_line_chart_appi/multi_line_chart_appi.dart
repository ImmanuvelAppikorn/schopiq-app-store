library multiple_line_chart_appiv;

import 'dart:convert';
import 'dart:html' as html; // Required for IFrameElement
import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

class MultipleLineChartAppi extends StatelessWidget {
  const MultipleLineChartAppi({
    Key? key,
    required this.xData,
    required this.data,
    this.title,
    this.titleStyle,
    this.titleWidget,
    this.titleToolTip,
    this.bgCardStyle,
    this.filterWidget,
    this.interaction,
  }) : super(key: key);

  final List<String> xData;
  final List<MultiLineProductData> data;
  final String? title;
  final String? titleToolTip;
  final Widget? titleWidget;
  final Widget? filterWidget;
  final Style? titleStyle;
  final Style? bgCardStyle;
  final bool? interaction;

  String colorToHex(Color color) {
    int red = color.red;
    int green = color.green;
    int blue = color.blue;
    double alpha = color.opacity;

    return 'rgba($red, $green, $blue, $alpha)';
  }

  Widget web({required dat, required context}) {
    final String viewId = 'plotly-chart-\\${DateTime.now()}';
    platformViewRegistry.registerViewFactory(viewId, (int viewId) {
      final iframe = html.IFrameElement();
      iframe.src = Uri.dataFromString(
        dat,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString();
      iframe.style.border = 'none'; // Removes default iframe border
      iframe.style.pointerEvents = (interaction ?? false) ? 'auto' : 'none'; // Removes default iframe border

      return iframe;
    });

    // Render the HtmlElementView
    return HtmlElementView(viewType: viewId);
  }

  @override
  Widget build(BuildContext context) {
    String htmlContent = """
    <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Count Line Chart</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
             
        }
        canvas {
           
        }
    </style>
</head>
<body>
    <canvas id="salesLineChart"></canvas>
    <script>
        // Function to generate random color
        function getRandomColor() {
            const letters = '0123456789ABCDEF';
            let color = '#';
            for (let i = 0; i < 6; i++) {
                color += letters[Math.floor(Math.random() * 16)];
            }
            return color;
        }

        const xLabels =  ${json.encode(xData)}; 
        
        // Sample data: Sales count for each drink at every hour
        const rawDatasets = ${data.toString()};

        const maxValue = Math.max(...rawDatasets.flatMap(dataset => dataset.data));

        // Prepare datasets for Chart.js
        const datasets = rawDatasets.map(dataset => ({
            label: dataset.label,
            data: dataset.data, // Y-axis values are sales count
            borderColor: dataset.color || getRandomColor(), // Assign random color if color is null or empty
            borderDash: [10, 5], // Dashed line
            fill: false,
            tension: 0.4, // Smooth curve
            pointBackgroundColor: dataset.color || getRandomColor(), // Match points with line color
        }));

        const data = {
            labels: xLabels, // X-axis values are time intervals
            datasets: datasets
        };

        const options = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: true,
                    position: 'top',
                    labels: {
                        usePointStyle: true,
                    }
                },
                tooltip: {
                    callbacks: {
                        label: (context) => `\${context.dataset.label}: \${context.raw} sales`
                    }
                }
            },
            scales: {
                x: {
                    grid: {
                        display: true,
                        color: "#e9ecef"
                    },
                    ticks: {
                        color: "#6c757d"
                    }
                },
                y: {
                    grid: {
                        color: "#e9ecef", 
                    },
                    ticks: {
                        color: "#6c757d",
                        stepSize: 5, // Define step size based on expected sales
                    }
                }
            }
        };

        new Chart(document.getElementById('salesLineChart'), {
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
        // // Calculate 20% of the parent's height
        // final double topPadding = constraints.maxHeight * 0.2;

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

class MultiLineProductData {
  final String label; // The name of the drink
  final List<int> data; // The sales count for each time interval
  final String? color; // The color of the line (optional)

  MultiLineProductData({
    required this.label,
    required this.data,
    this.color,
  });

  // Factory method to create an instance from a JSON object
  factory MultiLineProductData.fromJson(Map<String, dynamic> json) {
    return MultiLineProductData(
      label: json['label'] as String,
      data: List<int>.from(json['data']),
      color: json['color'] as String?,
    );
  }

  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'data': data,
      'color': color,
    };
  }

  // Override toString for better readability
  @override
  String toString() {
    return '{label: "$label", data: $data, color: ${color == null ? null : "$color"}}';
  }
}
