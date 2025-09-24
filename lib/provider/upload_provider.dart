
import 'package:appikorn_software/model/Upload.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadProvider = StateNotifierProvider<UploadModelNotifier, UploadModel>((ref){
  return UploadModelNotifier(UploadModel());
});

class UploadModelNotifier extends StateNotifier<UploadModel>{
  UploadModelNotifier(super.state);

  void update(UploadModel data){
    state = state.merge(data);
  }
}