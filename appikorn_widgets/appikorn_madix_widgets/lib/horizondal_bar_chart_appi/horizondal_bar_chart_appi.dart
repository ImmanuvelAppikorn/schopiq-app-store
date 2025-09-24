library horizondal_bar_chart_appi;

import 'dart:convert';
import 'dart:html' as html; // Required for IFrameElement
import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

class HorizondalBarChartAppi extends StatelessWidget {
  const HorizondalBarChartAppi(
      {Key? key,
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
      this.secondaryColor})
      : super(key: key);

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

// Construct the RGBA string
    return 'rgba($red, $green, $blue, $alpha)';
  }

  Widget web({required dat, required context}) {
    final String viewId = 'plotly-chart-${DateTime.now()}';

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
    <title>Responsive Horizontal Bar Chart</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            height: 100vh;
         }

        .chart-container {
            display: flex;
            flex-direction: row;
            width: 90%;
            height: 80%;
        }

        .chart-wrapper {
            flex: 3;
            min-width: 0;
            overflow-x: auto;
        }

        canvas {
            width: 100%;
            height: 100%;
        }

        .custom-legend {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            justify-content: flex-start;
            padding-left: 20px;
        }

        .legend-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }

        .legend-color-box {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 10px;
        }

        .legend-label {
            font-size: 13px;
            color: #697565;
            font-weight: 400;
        }

        .legend-value {
            font-size: 15px;
            color: #6c757d;
            font-weight: 600;
        }

        @media (max-width: 630px) {
            .custom-legend {
                display: none;
            }

            .chart-container {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="chart-container">
        <div class="chart-wrapper">
            <canvas id="horizontalBarChart"></canvas>
        </div>
        <div id="customLegend" class="custom-legend"></div>
    </div>
    <script>
        const labels = ${json.encode(xData)};
        const dataValues = $yData;

        function getRandomColor() {
            const letters = '0123456789ABCDEF';
            let color = '#';
            for (let i = 0; i < 6; i++) {
                color += letters[Math.floor(Math.random() * 16)];
            }
            return color + 'CC'; // Add transparency if needed
        }

        const backgroundColors = labels.map(() => getRandomColor());

        // Dynamically calculate bar thickness and spacing
        const parentHeight = window.innerHeight * 0.9; // 80% of viewport height
        const barCount = labels.length;
        const barThickness = Math.min(parentHeight / (barCount * 2), 50); // Max 30px per bar
        const spacing = Math.min(parentHeight / (barCount * 3), 10); // Dynamic spacing

        const data = {
            labels: labels,
            datasets: [{
                label: 'Performance',
                data: dataValues,
                backgroundColor: backgroundColors,
                borderRadius: 8,
                borderWidth: 0,
                barThickness: barThickness,
                categoryPercentage: 1,
                barPercentage: 1,
            }]
        };

        const options = {
            responsive: true,
            maintainAspectRatio: false,
            indexAxis: 'y',
            layout: {
                padding: {
                    top: spacing,
                    bottom: spacing,
                },
            },
            scales: {
                x: {
                    grid: {
                        color: "#e9ecef",
                    },
                    ticks: {
                        color: "#6c757d",
                        stepSize: 10,
                    },
                },
                y: {
                    grid: {
                        display: false,
                    },
                    ticks: {
                        color: "#6c757d",
                        font: {
                            size: 14,
                        },
                    },
                },
            },
            plugins: {
                legend: {
                    display: false,
                },
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            return `\${context.raw}`;
                        },
                    },
                },
            },
        };

        const config = {
            type: 'bar',
            data: data,
            options: options,
        };

        // Render the chart
        const chart = new Chart(
            document.getElementById('horizontalBarChart'),
            config
        );

        // Generate Custom Legend
        const customLegendContainer = document.getElementById('customLegend');
        labels.forEach((label, index) => {
            const legendItem = document.createElement('div');
            legendItem.classList.add('legend-item');

            const colorBox = document.createElement('div');
            colorBox.classList.add('legend-color-box');
            colorBox.style.backgroundColor = backgroundColors[index];

            const labelText = document.createElement('span');
            labelText.classList.add('legend-label');
            labelText.textContent = `\${label} : `;

            const valueText = document.createElement('span');
            valueText.classList.add('legend-value');
            valueText.textContent = dataValues[index];

            legendItem.appendChild(colorBox);
            legendItem.appendChild(labelText);
            legendItem.appendChild(valueText);

            customLegendContainer.appendChild(legendItem);
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
