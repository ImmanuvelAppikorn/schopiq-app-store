library pie_chart_appi;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'dart:math' as math;

class PieChartAppi extends StatefulWidget {
  const PieChartAppi({
    Key? key, 
    required this.data,
    this.title,
    this.titleStyle,
    this.titleWidget,
    this.titleToolTip,
    this.bgCardStyle,
    this.filterWidget,
    this.interaction,
    this.centerText,
    this.showLabels = true,
    this.showLegend = true,
    this.thickness = 0.2,
    this.animationDuration = const Duration(milliseconds: 800),
  }) : assert(thickness > 0 && thickness < 1, 'Thickness must be between 0 and 1'),
       super(key: key);

  final List<ProductData> data;
  final String? title;
  final String? titleToolTip;
  final Widget? titleWidget;
  final Widget? filterWidget;
  final Style? titleStyle;
  final Style? bgCardStyle;
  final bool? interaction;
  final String? centerText;
  final bool showLabels;
  final bool showLegend;
  /// The thickness of the pie chart ring, must be between 0 and 1.
  /// A value of 0.2 means the ring will take up 20% of the radius.
  final double thickness;
  final Duration animationDuration;

  @override
  State<PieChartAppi> createState() => _PieChartAppiState();
}

class _PieChartAppiState extends State<PieChartAppi> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int? hoveredIndex;
  Offset? hoverPosition;
  
  static const double kMobileBreakpoint = 480;
  static const double kTabletBreakpoint = 768;
  static const double kDesktopBreakpoint = 1024;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    
    // Add smooth easing curve
    _controller.forward().then((_) {
      if (mounted) {
        _controller.animateTo(
          1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
        );
      }
    });
  }

  @override
  void didUpdateWidget(PieChartAppi oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      // Animate when data changes
      _controller.reset();
      _controller.forward().then((_) {
        if (mounted) {
          _controller.animateTo(
            1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getResponsiveDimension(BoxConstraints constraints) {
    final minDimension = math.min(constraints.maxWidth, constraints.maxHeight);
    
    if (minDimension <= kMobileBreakpoint) {
      return minDimension;
    } else if (minDimension <= kTabletBreakpoint) {
      return minDimension * 0.95;
    } else if (minDimension <= kDesktopBreakpoint) {
      return minDimension * 0.9;
    }
    return minDimension * 0.85;
  }

  EdgeInsets _getResponsivePadding(BoxConstraints constraints) {
    final minDimension = math.min(constraints.maxWidth, constraints.maxHeight);
    if (minDimension <= kMobileBreakpoint) {
      return const EdgeInsets.all(12);
    } else if (minDimension <= kTabletBreakpoint) {
      return const EdgeInsets.all(16);
    }
    return const EdgeInsets.all(20);
  }

  double _getResponsiveFontSize(BoxConstraints constraints, {bool isTitle = false}) {
    final minDimension = math.min(constraints.maxWidth, constraints.maxHeight);
    // Cap the maximum font size
    final maxTitleSize = 42.0;
    final maxRegularSize = 24.0;
    
    double fontSize;
    if (minDimension <= kMobileBreakpoint) {
      fontSize = isTitle ? minDimension * 0.08 : minDimension * 0.045;
    } else if (minDimension <= kTabletBreakpoint) {
      fontSize = isTitle ? minDimension * 0.07 : minDimension * 0.04;
    } else {
      fontSize = isTitle ? minDimension * 0.06 : minDimension * 0.035;
    }
    
    // Cap the font size
    return math.min(fontSize, isTitle ? maxTitleSize : maxRegularSize);
  }

  void _updateHoverState(Offset? position, Size chartSize) {
    if (position == null) {
      setState(() => hoveredIndex = null);
      return;
    }

    final center = Offset(chartSize.width / 2, chartSize.height / 2);
    final radius = math.min(chartSize.width, chartSize.height) / 2;
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    
    // Check if pointer is outside the chart
    if (distance > radius || distance < radius * (1 - widget.thickness)) {
      setState(() => hoveredIndex = null);
      return;
    }

    // Calculate angle and find corresponding segment
    double angle = (math.atan2(dy, dx) + math.pi / 2) % (2 * math.pi);
    if (angle < 0) angle += 2 * math.pi;

    final total = widget.data.fold(0.0, (sum, item) => sum + item.value);
    double startAngle = 0;
    
    for (int i = 0; i < widget.data.length; i++) {
      final sweepAngle = (widget.data[i].value / total) * 2 * math.pi;
      if (angle >= startAngle && angle <= startAngle + sweepAngle) {
        setState(() => hoveredIndex = i);
        return;
      }
      startAngle += sweepAngle;
    }
    
    setState(() => hoveredIndex = null);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final aspectRatio = constraints.maxWidth / constraints.maxHeight;
        final isWide = aspectRatio > 1.5;
        final hasTitle = widget.title != null || widget.titleWidget != null;
        
        Widget mainContent;
        if (isWide) {
          // For wide containers, place legend on the right
          mainContent = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: _buildChartSection(constraints),
              ),
              Expanded(
                flex: 2,
                child: _buildLegendSection(constraints),
              ),
            ],
          );
        } else {
          // For taller containers, place legend at the bottom
          mainContent = Column(
            children: [
              Expanded(
                flex: 2,
                child: _buildChartSection(constraints),
              ),
              Expanded(
                flex: 1,
                child: _buildLegendSection(constraints),
              ),
            ],
          );
        }

        return Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasTitle) ...[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: _buildTitle(constraints),
                ),
              ],
              Expanded(
                child: mainContent,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(BoxConstraints constraints) {
    final titleFontSize = _getResponsiveFontSize(constraints, isTitle: true);
    final subtitleFontSize = _getResponsiveFontSize(constraints);
    
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: widget.titleWidget ?? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title!,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F1F1F),
                    height: 1.2,
                  ),
                ),
                if (widget.titleToolTip != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      widget.titleToolTip!,
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChartSection(BoxConstraints constraints) {
    final List<double> chartData = widget.data.map((e) => e.value.toDouble()).toList();
    final List<Color> chartColors = widget.data.map((e) => _hexToColor(e.color ?? '#4285F4')).toList();
    final double total = chartData.fold(0, (prev, curr) => prev + curr);
    
    return LayoutBuilder(
      builder: (context, chartConstraints) {
        final minDimension = math.min(chartConstraints.maxWidth, chartConstraints.maxHeight);
        // Cap the chart size for very large containers
        final size = math.min(minDimension, 600.0);
        final centerTextSize = _getResponsiveFontSize(constraints);
        
        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: MouseRegion(
              onHover: (event) => _updateHoverState(event.localPosition, Size(size, size)),
              onExit: (_) => _updateHoverState(null, Size(size, size)),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final value = CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeOutCubic,
                  ).value;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: -math.pi / 2,
                        child: CustomPaint(
                          size: Size(size, size),
                          painter: DonutChartPainter(
                            data: chartData,
                            colors: chartColors,
                            animation: value,
                            hoveredIndex: hoveredIndex,
                            thickness: widget.thickness,
                          ),
                        ),
                      ),
                      if (widget.centerText != null)
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: value,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.centerText!,
                                style: TextStyle(
                                  fontSize: centerTextSize,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegendSection(BoxConstraints constraints) {
    final double total = widget.data.fold(0, (prev, curr) => prev + curr.value.toDouble());
    final minDimension = math.min(constraints.maxWidth, constraints.maxHeight);
    final isSmallScreen = minDimension <= kTabletBreakpoint;
    final fontSize = _getResponsiveFontSize(constraints);
    final itemSpacing = math.max(4.0, math.min(minDimension * 0.015, 12.0));
    final aspectRatio = constraints.maxWidth / constraints.maxHeight;
    final isWide = aspectRatio > 1.5;
    
    return LayoutBuilder(
      builder: (context, legendConstraints) {
        final maxWidth = legendConstraints.maxWidth;
        final horizontalPadding = math.min(
          isSmallScreen ? minDimension * 0.05 : minDimension * 0.08,
          24.0
        );
        
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: math.min(itemSpacing, 8.0),
          ),
          child: Align(
            alignment: isWide ? Alignment.centerLeft : Alignment.center,
            child: Wrap(
              spacing: math.min(maxWidth * 0.05, 16.0),
              runSpacing: math.min(itemSpacing * 1.5, 12.0),
              alignment: isWide ? WrapAlignment.start : WrapAlignment.center,
              children: widget.data.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final percentage = (item.value / total * 100).toStringAsFixed(0);
                final color = _hexToColor(item.color ?? '#4285F4');
                
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 600 + (index * 100)),
                  curve: Curves.easeOutCubic,
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(20 * (1 - value), 0),
                      child: Opacity(
                        opacity: value,
                        child: IntrinsicWidth(
                          child: MouseRegion(
                            onEnter: (_) => setState(() => hoveredIndex = index),
                            onExit: (_) => setState(() => hoveredIndex = null),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                horizontal: math.min(itemSpacing * 1.2, 12.0),
                                vertical: math.min(itemSpacing * 0.8, 6.0),
                              ),
                              decoration: BoxDecoration(
                                color: hoveredIndex == index
                                    ? color.withOpacity(0.08)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(math.min(itemSpacing * 1.2, 8.0)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: math.min(minDimension * 0.02, 12.0),
                                    height: math.min(minDimension * 0.02, 12.0),
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: color.withOpacity(0.2),
                                          blurRadius: 3,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: math.min(itemSpacing, 8.0)),
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                      fontSize: math.min(fontSize * 0.9, 16.0),
                                      color: hoveredIndex == index
                                          ? const Color(0xFF1F1F1F)
                                          : Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: math.min(itemSpacing, 8.0)),
                                  Text(
                                    '$percentage%',
                                    style: TextStyle(
                                      fontSize: math.min(fontSize * 0.9, 16.0),
                                      color: const Color(0xFF1F1F1F),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Color _hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}

class DonutChartPainter extends CustomPainter {
  final List<double> data;
  final List<Color> colors;
  final double animation;
  final int? hoveredIndex;
  final double thickness;

  DonutChartPainter({
    required this.data,
    required this.colors,
    this.animation = 1.0,
    this.hoveredIndex,
    this.thickness = 0.2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startAngle = 0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = radius * thickness;
    final total = data.fold(0.0, (a, b) => a + b);
    
    // Draw background circle
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = Colors.grey[100]!;
    
    canvas.drawCircle(center, radius - (strokeWidth / 2), bgPaint);

    // Draw segments with animation and hover effect
    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i] / total) * 2 * math.pi * animation;
      final isHovered = hoveredIndex == i;
      final segmentPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth * (isHovered ? 1.1 : 1.0)
        ..color = isHovered ? colors[i] : colors[i].withOpacity(0.8);

      // Add subtle shadow for depth
      if (isHovered) {
        canvas.drawArc(
          Rect.fromCircle(
            center: center,
            radius: radius - (strokeWidth / 2),
          ),
          startAngle,
          sweepAngle,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth * 1.2
            ..color = Colors.black.withOpacity(0.1)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
      }

      // Draw segment
      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius - (strokeWidth / 2),
        ),
        startAngle,
        sweepAngle,
        false,
        segmentPaint,
      );

      // Add highlight effect
      if (isHovered) {
        final highlightPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.white.withOpacity(0.3);

        canvas.drawArc(
          Rect.fromCircle(
            center: center,
            radius: radius - strokeWidth + 1,
          ),
          startAngle,
          sweepAngle,
          false,
          highlightPaint,
        );
      }

      startAngle += sweepAngle;
    }

    // Draw inner circle for clean edge
    final innerCirclePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;
    
    canvas.drawCircle(
      center,
      radius - (strokeWidth * 1.2),
      innerCirclePaint,
    );
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) {
    return oldDelegate.animation != animation ||
           oldDelegate.hoveredIndex != hoveredIndex ||
           oldDelegate.data != data ||
           oldDelegate.colors != colors ||
           oldDelegate.thickness != thickness;
  }
}

class ProductData {
  final String name;
  final int value;
  final String? color;

  ProductData({
    required this.name,
    required this.value,
    this.color,
  });

  factory ProductData.fromMap(Map<String, dynamic> map) {
    return ProductData(
      name: map['name'] as String,
      value: map['value'] as int,
      color: map['color'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'value': value,
      'color': color,
    };
  }

  @override
  String toString() => '{name: "$name", value: $value, color: "$color"}';
}
