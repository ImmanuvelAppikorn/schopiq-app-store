// import 'package:appikorn_madix_widgets/table_widget_appi/table_widget_appi.dart';
// import 'package:appikorn_madix_widgets/text_field_appi/text_field_appi.dart';
// import 'package:appikorn_madix_widgets/table_appi/table_appi.dart';
// import 'package:appikorn_madix_widgets/table_widget_appi/table_widget_appi.dart'
//     as table_widget;
// import 'package:flutter/material.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   final List<String> items = [
//     'Item 1',
//     'Item 2',
//     'Item 3',
//     'Item 4',
//     'Item 5',
//     "selvam",
//     "kumar",
//     "tamil"
//   ];
//   String? selectedItem1;
//   String? selectedItem2;
//   final _formKey = GlobalKey<FormState>();
//   String _searchText = ''; // Add this field to _HomeState class

//   // Focus nodes for form fields
//   late final FocusNode _nameFocus;
//   late final FocusNode _addressFocus;
//   late final FocusNode _submitFocus;
//   late final FocusNode _dropDownFocus;
//   late final FocusNode _dropDownFocus2;

//   @override
//   void initState() {
//     super.initState();
//     _nameFocus = FocusNode();
//     _addressFocus = FocusNode();
//     _submitFocus = FocusNode();
//     _dropDownFocus = FocusNode();
//     _dropDownFocus2 = FocusNode();
//   }

//   @override
//   void dispose() {
//     _nameFocus.dispose();
//     _addressFocus.dispose();
//     _submitFocus.dispose();
//     _dropDownFocus.dispose();
//     _dropDownFocus2.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Contact Form'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//             key: _formKey,
//             child: Container(
//               height: MediaQuery.of(context).size.height,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     padding: const EdgeInsets.all(16),
//                     child: TableWidgetAppi(
//                       headers: [
//                         'ID',
//                         'Name',
//                         'Email',
//                         'Phone',
//                         'City',
//                         _buildStatusHeader(),
//                         'Join Date',
//                         Container(
//                           alignment: Alignment.center,
//                           child: const Text('Revenue'),
//                         ),
//                         'Plan',
//                         'Actions'
//                       ],
//                       rows: List.generate(
//                           50,
//                           (index) => [
//                                 '#${(index + 1).toString().padLeft(3, '0')}',
//                                 _buildNameCell('User ${index + 1}',
//                                     index % 2 == 0 ? 'Customer' : 'Partner'),
//                                 'user${index + 1}@example.com',
//                                 _buildPhoneCell(
//                                     '+1 ${(index * 123456 % 1000000).toString().padLeft(6, '0')}'),
//                                 index % 2 == 0 ? 'New York' : 'Los Angeles',
//                                 _buildStatusCell(
//                                     index % 3 == 0 ? 'Active' : 'Inactive'),
//                                 _buildDateCell(
//                                     '2024-01-${(index % 30 + 1).toString().padLeft(2, '0')}'),
//                                 _buildRevenueCell((index + 1) * 500.0),
//                                 _buildPlanCell(
//                                   index % 2 == 0 ? 'Premium' : 'Basic',
//                                   index % 2 == 0 ? Colors.green : Colors.orange,
//                                 ),
//                                 _buildActionsCell(() {
//                                   // Handle edit
//                                 }, () {
//                                   // Handle delete
//                                 }),
//                               ]),
//                       enablePagination: true,
//                       enableSearch: true,
//                       pageSize: 10,
//                       totalRecords: 50,
//                       availablePageSizes: [10, 20, 50],
//                       onPageChanged: (page, pageSize) {
//                         print('Page changed to: $page, Page size: $pageSize');
//                       },
//                       onPageSizeChanged: (newPageSize) {
//                         print('Page size changed to: $newPageSize');
//                       },
//                       columnFlexValues: const {
//                         0: 1, // ID
//                         1: 2, // Name
//                         2: 2, // Email
//                         3: 2, // Phone
//                         4: 1, // City
//                         5: 1, // Status
//                         6: 1, // Join Date
//                         7: 1, // Revenue
//                         8: 1, // Plan
//                         9: 1, // Actions
//                       },
//                       columnAlignments: const {
//                         0: TextAlign.left, // ID
//                         5: TextAlign.center, // Status
//                         7: TextAlign.center, // Revenue
//                         8: TextAlign.right, // Plan
//                         9: TextAlign.center, // Actions
//                       },
//                       onRowTap: (index) {
//                         print('Row tapped: $index');
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             )),
//       ),
//     );
//   }

//   Widget _buildStatusHeader() {
//     return const Row(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(Icons.circle, size: 12, color: Colors.green),
//         SizedBox(width: 4),
//         Text('Status'),
//       ],
//     );
//   }

//   Widget _buildNameCell(String name, String role) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           name,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 2),
//         Text(
//           role,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey[400],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPhoneCell(String phone) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(Icons.phone, size: 16, color: Colors.grey[400]),
//         const SizedBox(width: 4),
//         Text(phone),
//       ],
//     );
//   }

//   Widget _buildStatusCell(String status) {
//     final isActive = status.toLowerCase() == 'active';
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       width: 100,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: isActive
//             ? Colors.green.withOpacity(0.2)
//             : Colors.red.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.circle,
//             size: 8,
//             color: isActive ? Colors.green : Colors.red,
//           ),
//           const SizedBox(width: 4),
//           Text(
//             status,
//             style: TextStyle(
//               color: isActive ? Colors.green : Colors.red,
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateCell(String date) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(Icons.calendar_today, size: 16, color: Colors.grey[400]),
//         const SizedBox(width: 4),
//         Text(date),
//       ],
//     );
//   }

//   Widget _buildRevenueCell(double amount) {
//     return Container(
//       child: Text(
//         '\$${amount.toStringAsFixed(2)}',
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           color: Colors.green,
//         ),
//       ),
//     );
//   }

//   Widget _buildPlanCell(String plan, Color color) {
//     return Container(
//       width: 100,
//       alignment: Alignment.center,
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         plan,
//         style: TextStyle(
//           color: color,
//           fontWeight: FontWeight.bold,
//           fontSize: 12,
//         ),
//       ),
//     );
//   }

//   Widget _buildActionsCell(VoidCallback onEdit, VoidCallback onDelete) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           icon: const Icon(Icons.edit, size: 20),
//           color: Colors.blue,
//           onPressed: onEdit,
//           tooltip: 'Edit',
//         ),
//         IconButton(
//           icon: const Icon(Icons.delete, size: 20),
//           color: Colors.red,
//           onPressed: onDelete,
//           tooltip: 'Delete',
//         ),
//       ],
//     );
//   }
// }
