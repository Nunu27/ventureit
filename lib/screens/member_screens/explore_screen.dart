import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/business_controller.dart';
import 'package:ventureit/controllers/modal_controller.dart';
import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/models/filter_options.dart';
import 'package:ventureit/widgets/cards/business_card.dart';
import 'package:ventureit/widgets/error_view.dart';
import 'package:ventureit/widgets/filter_button.dart';
import 'package:ventureit/widgets/loader.dart';
import 'package:ventureit/widgets/user_location.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  FilterOptions options = FilterOptions();

  void openFilter() async {
    final newOptions = await ref
        .read(modalControllerProvider)
        .showFilterOptions(context, options);

    if (newOptions != null) {
      setState(() {
        options = newOptions;
      });
    }
  }

  void onSearchSubmit(String value) {
    setState(() {
      options = options.copyWith(keyword: value);
    });
  }

  void selectCategory(BusinessCategory category) {
    setState(() {
      options = options.copyWith(category: category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const UserLocation(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SearchBar(
                  padding: const MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 14, vertical: 8)),
                  leading: const Icon(Icons.search),
                  backgroundColor: MaterialStatePropertyAll(
                    theme.colorScheme.primaryContainer,
                  ),
                  elevation: const MaterialStatePropertyAll(0),
                  hintText: 'Search places',
                  onSubmitted: onSearchSubmit,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.onBackground.withAlpha(64),
                      blurRadius: 3,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 8),
                        child: FilterButton(
                          onPress: openFilter,
                          icon: Icons.filter_list,
                        ),
                      ),
                      const VerticalDivider(
                        width: 1,
                      ),
                      Expanded(
                        child: ShaderMask(
                          shaderCallback: (Rect rect) {
                            return LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.purple.withAlpha(170),
                                Colors.purple
                              ],
                              stops: const [0.1, 0.95, 0.97, 1.0],
                            ).createShader(rect);
                          },
                          blendMode: BlendMode.dstOut,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 8, right: 12),
                            itemCount: BusinessCategory.values.length,
                            itemBuilder: (context, index) {
                              final category = BusinessCategory.values[index];

                              return FilterButton(
                                isSelected: options.category == category,
                                onPress: () {
                                  selectCategory(category);
                                },
                                icon: category.icon,
                                label: category.text,
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: ref.watch(filterBusinessProvider(options)).when(
            data: (businesses) => businesses.isEmpty
                ? const Center(
                    child: Text('No result found'),
                  )
                : ListView.builder(
                    itemCount: businesses.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) =>
                        BusinessCard(business: businesses[index]),
                  ),
            error: (error, stackTrace) {
              return ErrorView(error: error.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}
