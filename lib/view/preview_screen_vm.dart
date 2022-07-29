import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final previewScreenViewModelProvider = StateProvider.autoDispose((ref) {
  return PreviewScreenViewModel();
});

class PreviewScreenViewModel {
  final controller = TextEditingController();
  String url = '';
}
