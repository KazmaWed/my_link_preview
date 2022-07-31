import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:my_link_preview/view/preview_screen_vm.dart';
import 'package:url_launcher/url_launcher.dart';

// プレビューのタイプ分岐用enum
enum LinkPreviewType { basic, noImage, largeImage, fullText }

// class DummyPreviewCard extends StatelessWidget {
//   const DummyPreviewCard({Key? key, required this.url}) : super(key: key);
//   final String url;

//   @override
//   Widget build(BuildContext context) {
//     final text = url == '' ? 'No URL.' : url;
//     return Card(
//       child: Container(
//         // padding: const EdgeInsets.all(12),
//         height: 114,
//         alignment: Alignment.center,
//         child: Text(text),
//       ),
//     );
//   }
// }

// プレビューの本体Widget
class LinkPreviewCard extends StatelessWidget {
  const LinkPreviewCard({Key? key, required this.url, this.type = LinkPreviewType.basic})
      : super(key: key);
  final String url;
  final LinkPreviewType type;

  @override
  Widget build(BuildContext context) {
    // URLのフォーマットが正しいか確認
    bool isUrlValid = Uri.parse(url).isAbsolute;

    if (url == '') {
      // URLが空白の場合
      const text = 'No URL.';
      return Card(
        child: Container(
          // padding: const EdgeInsets.all(12),
          height: 114,
          alignment: Alignment.center,
          child: const Text(text),
        ),
      );
    } else if (!isUrlValid) {
      // URLのフォーマットが不正の場合
      const text = 'Invalid URL format.';
      return Card(
        child: Container(
          // padding: const EdgeInsets.all(12),
          height: 114,
          alignment: Alignment.center,
          child: const Text(text),
        ),
      );
    } else {
      // URLのフォーマットが正の場合
      final futureMeta = MetadataFetch.extract(url);
      // metaデータ取得状況で分岐するFutureBuilder
      return FutureBuilder(
        future: futureMeta,
        builder: (context, AsyncSnapshot<Metadata?> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            // metaデータ取得中
            const text = 'Fetching...';
            return Card(
              child: Container(
                // padding: const EdgeInsets.all(12),
                height: 114,
                alignment: Alignment.center,
                child: const Text(text),
              ),
            );
          } else if (!snapshot.hasData || snapshot.hasError) {
            // metaデータが取得できなかった場合
            const text = 'Couldn\'t Fetch Data.';
            return Card(
              child: Container(
                // padding: const EdgeInsets.all(12),
                height: 114,
                alignment: Alignment.center,
                child: const Text(text),
              ),
            );
          } else {
            // metaデータ取得できた場合
            final title = snapshot.data!.title;
            final description = snapshot.data!.description;
            final imageUrl = snapshot.data!.image;
            // LinkPreviewTypeで分岐
            if (type == LinkPreviewType.noImage) {
              return PreviewBodyNoImage(
                url: url,
                title: title,
                description: description,
              );
            } else if (type == LinkPreviewType.largeImage) {
              return PreviewBodyLargeImage(
                url: url,
                title: title,
                description: description,
                imageUrl: imageUrl,
              );
            } else if (type == LinkPreviewType.fullText) {
              return PreviewBodyFullText(
                url: url,
                title: title,
                description: description,
                imageUrl: imageUrl,
              );
            } else {
              return PreviewBodyDefailt(
                url: url,
                title: title,
                description: description,
                imageUrl: imageUrl,
              );
            }
          }
        },
      );
    }
  }
}

// LinkPreviewType.basicの時の表示、中サイズ画像
class PreviewBodyDefailt extends StatelessWidget {
  const PreviewBodyDefailt(
      {Key? key, required this.url, this.title, this.description, this.imageUrl})
      : super(key: key);
  final String url;
  final String? title;
  final String? description;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleSmall!;
    final descriptionStyle = Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black54);
    return Card(
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(url)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 96,
                    width: 96,
                    color: Colors.black12,
                    child: Image.network(imageUrl!, fit: BoxFit.cover),
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? 'No title',
                      style: titleStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description ?? 'No desctiption',
                      style: descriptionStyle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// LinkPreviewType.fullTextの時の表示、小サイズ画像とtitle, body全文
class PreviewBodyLargeImage extends StatelessWidget {
  const PreviewBodyLargeImage(
      {Key? key, required this.url, this.title, this.description, this.imageUrl})
      : super(key: key);
  final String url;
  final String? title;
  final String? description;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleSmall!;
    final descriptionStyle = Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black54);
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      color: Colors.black12,
                      child: Image.network(imageUrl!, fit: BoxFit.cover),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                title ?? 'No title',
                style: titleStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                description ?? 'No desctiption',
                style: descriptionStyle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// LinkPreviewType.noImageの時の表示、画像なし
class PreviewBodyFullText extends StatelessWidget {
  const PreviewBodyFullText(
      {Key? key, required this.url, this.title, this.description, this.imageUrl})
      : super(key: key);
  final String url;
  final String? title;
  final String? description;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleSmall!;
    final descriptionStyle = Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black54);
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  if (imageUrl != null)
                    SizedBox(
                      width: 48,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            color: Colors.black12,
                            child: Image.network(imageUrl!, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      title ?? 'No title',
                      style: titleStyle,
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description ?? 'No desctiption',
                style: descriptionStyle,
                maxLines: 200,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
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

// LinkPreviewType.largeImageの時の表示、大サイズ画像
class PreviewBodyNoImage extends StatelessWidget {
  const PreviewBodyNoImage({Key? key, required this.url, this.title, this.description})
      : super(key: key);
  final String url;
  final String? title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleSmall!;
    final descriptionStyle = Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black54);
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? 'No title',
                      style: titleStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description ?? 'No desctiption',
                      style: descriptionStyle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
