
import 'package:flutter/material.dart';
import 'dart:math' as math;

class NativeLineChart extends StatefulWidget {
  final String title;
  final List<String> xData;
  final List<int> yData;
  final bool? interaction;
  final Color? primaryColor;
  final Color? secondaryColor;
  final double tension;
  final String? tooltipLabel;
  final String? tooltipDate;

  const NativeLineChart({
    Key? key,
    required this.title,
    required this.xData,
    required this.yData,
    this.interaction,
    this.primaryColor,
    this.secondaryColor,
    this.tension = 0.2,
    this.tooltipLabel,
    this.tooltipDate,
  }) : super(key: key);

  @override
  State<NativeLineChart> createState() => _NativeLineChartState();
}

class _NativeLineChartState extends State<NativeLineChart> {
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.primaryColor ?? const Color(0xFF0D6EFD);
    final secondaryColor = widget.secondaryColor ?? const Color(0xFF0D6EFD);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212529),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.info_outline, color: Colors.grey.shade400, size: 20),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return MouseRegion(
                    onHover: (event) {
                      final RenderBox box =
                          context.findRenderObject() as RenderBox;
                      final localPosition = box.globalToLocal(event.position);

                      final chartWidth = constraints.maxWidth - 80;
                      const chartLeft = 60.0;
                      final chartRight = chartLeft + chartWidth;

                      if (localPosition.dx >= chartLeft &&
                          localPosition.dx <= chartRight) {
                        final chartX = localPosition.dx - chartLeft;
                        final index =
                            ((chartX / chartWidth) * (widget.xData.length - 1))
                                .round();
                        if (index >= 0 && index < widget.xData.length) {
                          setState(() => hoveredIndex = index);
                        }
                      }
                    },
                    onExit: (event) => setState(() => hoveredIndex = null),
                    child: CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: LineChartPainter(
                        xData: widget.xData,
                        yData: widget.yData,
                        hoveredIndex: hoveredIndex,
                        primaryColor: primaryColor,
                        secondaryColor: secondaryColor,
                        tension: widget.tension,
                        tooltipLabel: widget.tooltipLabel,
                        tooltipDate: widget.tooltipDate,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<String> xData;
  final List<int> yData;
  final int? hoveredIndex;
  final Color primaryColor;
  final Color secondaryColor;
  final double tension;
  final String? tooltipLabel;
  final String? tooltipDate;

  LineChartPainter({
    required this.xData,
    required this.yData,
    this.hoveredIndex,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tension,
    this.tooltipLabel,
    this.tooltipDate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final chartRect = Rect.fromLTRB(60, 20, size.width - 20, size.height - 40);
    const maxY = 50.0; // Fixed max Y value
    const minY = 0.0; // Fixed min Y value

    // Draw grid lines and labels
    final yLabelStyle = TextStyle(
      color: Colors.grey[600],
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );

    // Draw horizontal grid lines
    const yStep = 10.0;
    for (var i = 0; i <= (maxY / yStep); i++) {
      final y = minY + (yStep * i);
      final yPos =
          chartRect.bottom - (y - minY) * chartRect.height / (maxY - minY);

      // Draw grid line
      canvas.drawLine(
        Offset(chartRect.left, yPos),
        Offset(chartRect.right, yPos),
        Paint()
          ..color = Colors.grey.shade200
          ..strokeWidth = 1,
      );

      // Draw Y-axis label
      final textPainter = TextPainter(
        text: TextSpan(
          text: y.toInt().toString(),
          style: yLabelStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(chartRect.left - textPainter.width - 8,
            yPos - textPainter.height / 2),
      );
    }

    // Calculate points and control points
    List<Offset> points = [];
    List<Offset> controlPoints1 = [];
    List<Offset> controlPoints2 = [];

    // Get points
    for (var i = 0; i < xData.length; i++) {
      final x = chartRect.left + i * chartRect.width / (xData.length - 1);
      final y = chartRect.bottom -
          (yData[i] - minY) * chartRect.height / (maxY - minY);
      points.add(Offset(x, y));
    }

    // Calculate control points
    for (var i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i < points.length - 2 ? points[i + 2] : p2;

      final len1 = (p2 - p0).distance;
      final len2 = (p3 - p1).distance;

      final cp1 = Offset(
        p1.dx + (p2.dx - p0.dx) * tension * (len1 / (len1 + len2)),
        p1.dy + (p2.dy - p0.dy) * tension * (len1 / (len1 + len2)),
      );

      final cp2 = Offset(
        p2.dx - (p3.dx - p1.dx) * tension * (len2 / (len1 + len2)),
        p2.dy - (p3.dy - p1.dy) * tension * (len2 / (len1 + len2)),
      );

      controlPoints1.add(cp1);
      controlPoints2.add(cp2);
    }

    // Draw fill
    final path = Path();
    final fillPath = Path();

    if (points.length > 1) {
      path.moveTo(points.first.dx, points.first.dy);
      fillPath.moveTo(points.first.dx, chartRect.bottom);
      fillPath.lineTo(points.first.dx, points.first.dy);

      for (var i = 0; i < points.length - 1; i++) {
        path.cubicTo(
          controlPoints1[i].dx,
          controlPoints1[i].dy,
          controlPoints2[i].dx,
          controlPoints2[i].dy,
          points[i + 1].dx,
          points[i + 1].dy,
        );
        fillPath.cubicTo(
          controlPoints1[i].dx,
          controlPoints1[i].dy,
          controlPoints2[i].dx,
          controlPoints2[i].dy,
          points[i + 1].dx,
          points[i + 1].dy,
        );
      }

      fillPath.lineTo(points.last.dx, chartRect.bottom);
      fillPath.close();

      // Draw fill
      canvas.drawPath(
        fillPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              secondaryColor.withOpacity(0.1),
              secondaryColor.withOpacity(0.02),
            ],
          ).createShader(chartRect),
      );

      // Draw line
      canvas.drawPath(
        path,
        Paint()
          ..color = primaryColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    // Draw points and labels
    for (var i = 0; i < points.length; i++) {
      final point = points[i];

      // Draw point
      if (hoveredIndex == i) {
        // Draw vertical dashed line
        const dashHeight = 4.0;
        var y = point.dy;
        while (y < chartRect.bottom) {
          canvas.drawLine(
            Offset(point.dx, y),
            Offset(point.dx, y + dashHeight),
            Paint()
              ..color = Colors.grey.shade300
              ..strokeWidth = 1,
          );
          y += dashHeight * 2;
        }

        // Draw point
        canvas.drawCircle(
          point,
          5,
          Paint()..color = Colors.white,
        );
        canvas.drawCircle(
          point,
          5,
          Paint()
            ..color = primaryColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );

        // Draw tooltip
        const tooltipHeight = 64.0;
        const tooltipWidth = 90.0;
        final tooltipRect = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(point.dx, point.dy - tooltipHeight / 2 - 20),
            width: tooltipWidth,
            height: tooltipHeight,
          ),
          const Radius.circular(8),
        );

        // Draw tooltip background
        canvas.drawRRect(
          tooltipRect,
          Paint()..color = const Color(0xFF212529),
        );

        // Draw tooltip content
        final labelPainter = TextPainter(
          text: TextSpan(
            text: 'Top ${yData[i]}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        final datePainter = TextPainter(
          text: TextSpan(
            text: '${xData[i]}, 15',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        labelPainter.paint(
          canvas,
          Offset(
            point.dx - labelPainter.width / 2,
            tooltipRect.top + 12,
          ),
        );

        datePainter.paint(
          canvas,
          Offset(
            point.dx - datePainter.width / 2,
            tooltipRect.top + tooltipHeight - 24,
          ),
        );
      } else {
        canvas.drawCircle(
          point,
          3,
          Paint()..color = Colors.white,
        );
        canvas.drawCircle(
          point,
          3,
          Paint()
            ..color = primaryColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }

      // Draw x-axis label
      final labelPainter = TextPainter(
        text: TextSpan(
          text: xData[i],
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      labelPainter.paint(
        canvas,
        Offset(point.dx - labelPainter.width / 2, chartRect.bottom + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    return oldDelegate.hoveredIndex != hoveredIndex;
  }
}
