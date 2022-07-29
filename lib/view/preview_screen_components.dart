import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_link_preview/view/preview_screen_vm.dart';

class DummyPreviewCard extends StatelessWidget {
  const DummyPreviewCard({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    final text = url == '' ? 'No URL.' : url;
    return Card(
      child: Container(
        padding: const EdgeInsets.all(12),
        alignment: Alignment.center,
        child: Text(text),
      ),
    );
  }
}

class ExpandedListView extends StatelessWidget {
  const ExpandedListView({Key? key, required this.widgetList}) : super(key: key);
  final List<Widget> widgetList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widgetList.length,
        itemBuilder: (context, index) {
          return widgetList[index];
        },
      ),
    );
  }
}

class TextFieldRow extends ConsumerWidget {
  const TextFieldRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(previewScreenViewModelProvider);

    return SizedBox(
      height: 48,
      child: TextField(
        controller: viewModel.controller,
        decoration: const InputDecoration(hintText: 'Enter URL'),
      ),
    );
  }
}

class PreviewButton extends ConsumerWidget {
  const PreviewButton({Key? key, required this.callback}) : super(key: key);
  final Function callback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(previewScreenViewModelProvider);

    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: () {
          viewModel.url = viewModel.controller.text;
          callback();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Preview'),
          ],
        ),
      ),
    );
  }
}
