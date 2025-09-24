library table_widget_appi;

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TableWidgetAppi extends StatefulWidget {
  final List<dynamic> headers;
  final List<List<dynamic>> rows;
  final int pageSize;
  final bool enableSearch;
  final bool enablePagination;
  final Function(int)? onRowTap;
  final double? maxHeight;
  final Color? headerBackgroundColor;
  final Color? rowBackgroundColor;
  final Color? alternateRowBackgroundColor;
  final Color? selectedRowColor;
  final TextStyle? headerTextStyle;
  final TextStyle? rowTextStyle;
  final double borderRadius;
  final Map<int, int>? columnFlexValues;
  final Map<int, TextAlign>? columnAlignments;
  final Function(int page, int pageSize)? onPageChanged;
  final Function(int newPageSize)? onPageSizeChanged;
  final int? totalRecords;
  final List<int>? availablePageSizes;
  final Color? scrollbarColor;
  final double scrollbarThickness;
  final double scrollbarRadius;
  final bool scrollbarAlwaysVisible;
  final Color? backgroundColor;
  final Widget? emptyWidget;

  const TableWidgetAppi({
    Key? key,
    required this.headers,
    required this.rows,
    this.pageSize = 10,
    this.enableSearch = true,
    this.enablePagination = true,
    this.onRowTap,
    this.maxHeight,
    this.headerBackgroundColor,
    this.rowBackgroundColor,
    this.alternateRowBackgroundColor,
    this.selectedRowColor,
    this.headerTextStyle,
    this.rowTextStyle,
    this.borderRadius = 8.0,
    this.columnFlexValues,
    this.columnAlignments,
    this.onPageChanged,
    this.onPageSizeChanged,
    this.totalRecords,
    this.availablePageSizes,
    this.scrollbarColor,
    this.scrollbarThickness = 8.0,
    this.scrollbarRadius = 8.0,
    this.scrollbarAlwaysVisible = true,
    this.backgroundColor,
    this.emptyWidget,
  }) : super(key: key);

  @override
  _TableWidgetAppiState createState() => _TableWidgetAppiState();
}

class _TableWidgetAppiState extends State<TableWidgetAppi> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<List<dynamic>> _filteredRows = [];
  int _currentPage = 0;
  int? _selectedRowIndex;
  late double _tableWidth;
  late List<int> _columnWidths;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _filteredRows = List.from(widget.rows); // Create a copy to avoid reference issues
    _calculateColumnWidths();
  }

  void _calculateColumnWidths() {
    _columnWidths = List.generate(widget.headers.length, (index) {
      int maxLength = 0;
      for (var row in widget.rows) {
        if (row[index] != null) {
          if (row[index] is String) {
            maxLength = max(maxLength, row[index].length);
          } else {
            maxLength = max(maxLength, row[index].toString().length);
          }
        }
      }
      if (widget.headers[index] is String) {
        maxLength = max(maxLength, widget.headers[index].length);
      } else {
        maxLength = max(maxLength, widget.headers[index].toString().length);
      }
      return max(maxLength ~/ 2, 1);
    });
  }

  int _getColumnFlex(int columnIndex) {
    if (widget.columnFlexValues?.containsKey(columnIndex) ?? false) {
      return widget.columnFlexValues![columnIndex]!;
    }
    return _columnWidths[columnIndex];
  }

  TextAlign _getColumnAlignment(int columnIndex) {
    return widget.columnAlignments?.containsKey(columnIndex) ?? false
        ? widget.columnAlignments![columnIndex]!
        : TextAlign.left;
  }

  Widget _buildHeader(dynamic header, int columnIndex) {
    return Expanded(
      flex: _getColumnFlex(columnIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[700]!),
          ),
        ),
        child: header is Widget
            ? header
            : Text(
                header,
                style: widget.headerTextStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                textAlign: _getColumnAlignment(columnIndex),
              ),
      ),
    );
  }

  Widget _buildCell(dynamic value, int columnIndex) {
    return Expanded(
      flex: _getColumnFlex(columnIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: value is Widget
            ? value
            : Text(
                value?.toString() ?? '',
                style: widget.rowTextStyle ??
                    const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                textAlign: _getColumnAlignment(columnIndex),
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }

  void _handleRowTap(int rowIndex) {
    if (_isDisposed) return;
    
    // Use a try-catch block to handle any potential state errors
    try {
      if (mounted) {
        setState(() {
          _selectedRowIndex = rowIndex;
        });
        widget.onRowTap?.call(rowIndex);
      }
    } catch (e) {
      // Ignore state errors during disposal
      print('Warning: Error handling row tap - $e');
    }
  }

  void _handlePageChange(int newPage) {
    if (_isDisposed) return;
    
    try {
      if (mounted) {
        setState(() {
          _currentPage = newPage;
        });
        widget.onPageChanged?.call(newPage, widget.pageSize);
      }
    } catch (e) {
      print('Warning: Error handling page change - $e');
    }
  }

  void _handleSearch(String query) {
    if (_isDisposed) return;
    
    try {
      if (mounted) {
        setState(() {
          _filteredRows = widget.rows.where((row) {
            return row.any((cell) =>
                cell.toString().toLowerCase().contains(query.toLowerCase()));
          }).toList();
          _currentPage = 0;
        });
      }
    } catch (e) {
      print('Warning: Error handling search - $e');
    }
  }

  Widget _buildRow(List<dynamic> row, int rowIndex) {
    final isSelected = _selectedRowIndex == rowIndex;
    final isEven = rowIndex % 2 == 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onRowTap != null
            ? () => _handleRowTap(rowIndex)
            : null,
        hoverColor: Colors.blue.withOpacity(0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected
                ? (widget.selectedRowColor ?? Colors.blue.withOpacity(0.3))
                : (isEven
                    ? widget.alternateRowBackgroundColor ?? Colors.grey[800]
                    : widget.rowBackgroundColor ?? Colors.grey[900]),
            border: isSelected
                ? Border.all(color: Colors.blue.withOpacity(0.5), width: 1)
                : null,
          ),
          child: Row(
            children: row.asMap().entries.map((entry) {
              return _buildCell(entry.value, entry.key);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        border: Border(
          bottom: BorderSide(color: Colors.grey[700]!),
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onChanged: (query) => _handleSearch(query),
      ),
    );
  }

  Widget _buildPagination() {
    final totalRecords = widget.totalRecords ?? _filteredRows.length;
    final totalPages = (totalRecords / widget.pageSize).ceil();
    final startIndex = _currentPage * widget.pageSize + 1;
    final endIndex = min((_currentPage + 1) * widget.pageSize, totalRecords);
    final pageSizes = widget.availablePageSizes ?? [10, 25, 50, 100];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 700;

        return Container(
          width: constraints.maxWidth,
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 8 : 24,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            border: Border(
              top: BorderSide(color: Colors.grey[700]!),
            ),
          ),
          child: isSmallScreen
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildPageButton(
                              icon: Icons.first_page,
                              onPressed: _currentPage > 0
                                  ? () => _handlePageChange(0)
                                  : null,
                              tooltip: 'First Page',
                            ),
                            const SizedBox(width: 8),
                            _buildPageButton(
                              icon: Icons.chevron_left,
                              onPressed: _currentPage > 0
                                  ? () => _handlePageChange(_currentPage - 1)
                                  : null,
                              tooltip: 'Previous Page',
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '$startIndex-$endIndex of $totalRecords',
                                style: TextStyle(color: Colors.grey[400], fontSize: 14),
                              ),
                            ),
                            _buildPageButton(
                              icon: Icons.chevron_right,
                              onPressed: _currentPage < totalPages - 1
                                  ? () => _handlePageChange(_currentPage + 1)
                                  : null,
                              tooltip: 'Next Page',
                            ),
                            const SizedBox(width: 8),
                            _buildPageButton(
                              icon: Icons.last_page,
                              onPressed: _currentPage < totalPages - 1
                                  ? () => _handlePageChange(totalPages - 1)
                                  : null,
                              tooltip: 'Last Page',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Show',
                              style: TextStyle(color: Colors.grey[400], fontSize: 14),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              height: 36,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[700]!),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: widget.pageSize,
                                  dropdownColor: Colors.grey[900],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
                                  items: pageSizes.map((size) {
                                    return DropdownMenuItem<int>(
                                      value: size,
                                      child: Text('$size'),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      widget.onPageSizeChanged?.call(value);
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'entries',
                              style: TextStyle(color: Colors.grey[400], fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Rows per page:',
                          style: TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[700]!),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: widget.pageSize,
                              dropdownColor: Colors.grey[900],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              icon: Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
                              items: pageSizes.map((size) {
                                return DropdownMenuItem<int>(
                                  value: size,
                                  child: Text('$size'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  widget.onPageSizeChanged?.call(value);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Text(
                          '$startIndex-$endIndex of $totalRecords',
                          style: TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPageButton(
                          icon: Icons.first_page,
                          onPressed: _currentPage > 0
                              ? () => _handlePageChange(0)
                              : null,
                          tooltip: 'First Page',
                        ),
                        const SizedBox(width: 8),
                        _buildPageButton(
                          icon: Icons.chevron_left,
                          onPressed: _currentPage > 0
                              ? () => _handlePageChange(_currentPage - 1)
                              : null,
                          tooltip: 'Previous Page',
                        ),
                        const SizedBox(width: 16),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: _buildPageNumbers(totalPages),
                        ),
                        const SizedBox(width: 16),
                        _buildPageButton(
                          icon: Icons.chevron_right,
                          onPressed: _currentPage < totalPages - 1
                              ? () => _handlePageChange(_currentPage + 1)
                              : null,
                          tooltip: 'Next Page',
                        ),
                        const SizedBox(width: 8),
                        _buildPageButton(
                          icon: Icons.last_page,
                          onPressed: _currentPage < totalPages - 1
                              ? () => _handlePageChange(totalPages - 1)
                              : null,
                          tooltip: 'Last Page',
                        ),
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildPageButton({
    required IconData icon,
    VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: 20,
            color: onPressed == null ? Colors.grey[600] : Colors.white70,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageNumbers(int totalPages) {
    const maxVisiblePages = 5;
    List<Widget> pageNumbers = [];
    int startPage;
    int endPage;

    if (totalPages <= maxVisiblePages) {
      startPage = 0;
      endPage = totalPages - 1;
    } else {
      if (_currentPage <= 2) {
        startPage = 0;
        endPage = 4;
      } else if (_currentPage >= totalPages - 3) {
        startPage = totalPages - 5;
        endPage = totalPages - 1;
      } else {
        startPage = _currentPage - 2;
        endPage = _currentPage + 2;
      }
    }

    for (int i = startPage; i <= endPage; i++) {
      pageNumbers.add(
        _buildPageNumberButton(i, i == _currentPage),
      );
      if (i < endPage) {
        pageNumbers.add(const SizedBox(width: 4));
      }
    }

    return pageNumbers;
  }

  Widget _buildPageNumberButton(int page, bool isSelected) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.transparent,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSelected
              ? null
              : () {
                  _handlePageChange(page);
                },
          borderRadius: BorderRadius.circular(4),
          child: Center(
            child: Text(
              '${page + 1}',
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    
    // Dispose controllers immediately
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    _searchController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentRows = _filteredRows
        .skip(_currentPage * widget.pageSize)
        .take(widget.pageSize)
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        _tableWidth = constraints.maxWidth;
        return Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              if (widget.enableSearch) _buildSearchBar(),
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    scrollbarTheme: ScrollbarThemeData(
                      thumbColor: MaterialStateProperty.all(
                        widget.scrollbarColor ?? Theme.of(context).primaryColor,
                      ),
                      trackColor: MaterialStateProperty.all(
                        widget.scrollbarColor?.withOpacity(0.1) ?? 
                        Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                      thickness: MaterialStateProperty.all(widget.scrollbarThickness),
                      radius: Radius.circular(widget.scrollbarRadius),
                      thumbVisibility: MaterialStateProperty.all(widget.scrollbarAlwaysVisible),
                      trackVisibility: MaterialStateProperty.all(widget.scrollbarAlwaysVisible),
                    ),
                  ),
                  child: Scrollbar(
                    controller: _horizontalScrollController,
                    child: SingleChildScrollView(
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: IntrinsicWidth(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: _tableWidth,
                          ),
                          child: Column(
                            children: [
                              Container(
                                color: widget.headerBackgroundColor ?? Colors.grey[850],
                                child: Row(
                                  children: widget.headers
                                      .asMap()
                                      .entries
                                      .map((entry) =>
                                          _buildHeader(entry.value, entry.key))
                                      .toList(),
                                ),
                              ),
                             currentRows.isEmpty
                                    ? Container(
                                        width: _tableWidth,
                                        child: Center(
                                          child: widget.emptyWidget ?? const Text(
                                            'No data available',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                    :  Expanded(
                                child: Scrollbar(
                                        controller: _verticalScrollController,
                                        child: SingleChildScrollView(
                                          controller: _verticalScrollController,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: currentRows
                                                .asMap()
                                                .entries
                                                .map((entry) =>
                                                    _buildRow(entry.value, entry.key))
                                                .toList(),
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.enablePagination &&
                  _filteredRows.length > widget.pageSize)
                _buildPagination(),
            ],
          ),
        );
      },
    );
  }
}
