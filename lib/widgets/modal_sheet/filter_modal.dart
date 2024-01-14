import 'package:flutter/material.dart';
import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/models/filter_options.dart';
import 'package:ventureit/widgets/filter_button.dart';
import 'package:ventureit/widgets/primary_button.dart';

class FilterModal extends StatefulWidget {
  final FilterOptions options;

  const FilterModal({super.key, required this.options});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late FilterOptions _options;

  @override
  void initState() {
    _options = widget.options.copyWith();
    super.initState();
  }

  void closeModal() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void confirm() {
    Navigator.of(context, rootNavigator: true).pop(_options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Filters'),
          forceMaterialTransparency: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text('Category'),
                      Wrap(
                        children: BusinessCategory.values
                            .map(
                              (category) => FilterButton(
                                isSelected: _options.category == category,
                                onPress: () => _options.setCategory(
                                  category,
                                  setState: setState,
                                ),
                                icon: category.icon,
                                label: category.text,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      const Text('Sort by'),
                      Wrap(
                        children: SortBy.values
                            .map(
                              (sortBy) => FilterButton(
                                isSelected: _options.sortBy == sortBy,
                                onPress: () => _options.setSortBy(
                                  sortBy,
                                  setState: setState,
                                ),
                                label: sortBy.name,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      const Text('Rating'),
                      Wrap(
                        children: MinRating.values
                            .map(
                              (minRating) => FilterButton(
                                isSelected: _options.minRating == minRating,
                                onPress: () => _options.setMinRating(
                                  minRating,
                                  setState: setState,
                                ),
                                icon: Icons.star,
                                iconSize: 15,
                                iconColor: Colors.amber,
                                label: minRating.name,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      const Text('Max distance'),
                      Wrap(
                        children: MaxDistance.values
                            .map(
                              (maxDistance) => FilterButton(
                                isSelected: _options.maxDistance == maxDistance,
                                onPress: () => _options.setMaxDistance(
                                  maxDistance,
                                  setState: setState,
                                ),
                                label: maxDistance.name,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      const Text('Last updated'),
                      Wrap(
                        children: LastUpdated.values
                            .map(
                              (lastUpdated) => FilterButton(
                                isSelected: _options.lastUpdated == lastUpdated,
                                onPress: () => _options.setLastUpdated(
                                  lastUpdated,
                                  setState: setState,
                                ),
                                label: lastUpdated.name,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      const Text('Open now'),
                      Wrap(
                        children: [
                          FilterButton(
                            isSelected: _options.openNow,
                            onPress: () => _options.setOpenNow(
                              true,
                              setState: setState,
                            ),
                            label: 'Yes',
                          ),
                          FilterButton(
                            isSelected: !_options.openNow,
                            onPress: () => _options.setOpenNow(
                              false,
                              setState: setState,
                            ),
                            label: 'No',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PrimaryButton(
                onPress: confirm,
                child: const Text('Confirm'),
              ),
            )
          ],
        ));
  }
}
