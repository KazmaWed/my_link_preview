import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_link_preview/view/preview_screen_components.dart';
import 'package:my_link_preview/view/preview_screen_vm.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final viewModel = ref.watch(previewScreenViewModelProvider);

      final previewWidgetList = [
        DummyPreviewCard(url: viewModel.url),
        DummyPreviewCard(url: viewModel.url),
        DummyPreviewCard(url: viewModel.url),
        DummyPreviewCard(url: viewModel.url),
      ];

      return Scaffold(
        appBar: AppBar(
          title: const Text('LinkPreviewApp'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              ExpandedListView(widgetList: previewWidgetList),
              const SizedBox(height: 8),
              const TextFieldRow(),
              const SizedBox(height: 12),
              PreviewButton(callback: () => setState(() {})),
            ],
          ),
        ),
      );
    });
  }
}
