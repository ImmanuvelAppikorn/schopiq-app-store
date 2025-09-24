import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/UploadItem.dart';

class UploadedItemsNotifier extends StateNotifier<List<UploadedItem>> {
  UploadedItemsNotifier() : super([]);

  void addItem(UploadedItem item) {
    state = [...state, item];
  }
}

final uploadedItemsProvider =
StateNotifierProvider<UploadedItemsNotifier, List<UploadedItem>>(
        (ref) => UploadedItemsNotifier());
