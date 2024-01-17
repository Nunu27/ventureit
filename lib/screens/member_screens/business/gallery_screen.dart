import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ventureit/controllers/review_controller.dart';
import 'package:ventureit/widgets/error_view.dart';
import 'package:ventureit/widgets/loader.dart';
import 'package:ventureit/widgets/remote_image.dart';

class GalleryScreen extends ConsumerWidget {
  final String id;
  const GalleryScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getMediaByBusinessIdProvider(id)).when(
          data: (data) => data.isEmpty
              ? const Center(
                  child: Text('The gallery is still empty'),
                )
              : MasonryGridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return RemoteImage(url: data[index].url);
                  },
                ),
          error: (error, stackTrace) => ErrorView(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
