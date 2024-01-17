import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/business_controller.dart';
import 'package:ventureit/widgets/content_view.dart';
import 'package:ventureit/widgets/error_view.dart';
import 'package:ventureit/widgets/loader.dart';

class ContentsScreen extends ConsumerWidget {
  final String id;
  const ContentsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getBusinessByIdProvider(id)).when(
          data: (business) => business.contents.tiktok.isEmpty &&
                  business.contents.instagram.isEmpty
              ? const Center(
                  child: Text('No contents'),
                )
              : SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        if (business.contents.tiktok.isNotEmpty)
                          ContentView(
                              source: 'TikTok',
                              items: business.contents.tiktok),
                        if (business.contents.instagram.isNotEmpty)
                          ContentView(
                              source: 'Instagram',
                              items: business.contents.tiktok),
                      ],
                    ),
                  ),
                ),
          error: (error, stackTrace) => ErrorView(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
