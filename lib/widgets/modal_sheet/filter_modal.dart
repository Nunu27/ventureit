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
  void closeModal() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void confirm() {
    Navigator.of(context, rootNavigator: true).pop(widget.options);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: closeModal,
              icon: const Icon(Icons.arrow_back),
            ),
            const Text(
              'Filters',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        Padding(
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
                        isSelected: widget.options.category == category,
                        onPress: () => widget.options.setCategory(
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
                        isSelected: widget.options.sortBy == sortBy,
                        onPress: () => widget.options.setSortBy(
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
                        isSelected: widget.options.minRating == minRating,
                        onPress: () => widget.options.setMinRating(
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
                        isSelected: widget.options.maxDistance == maxDistance,
                        onPress: () => widget.options.setMaxDistance(
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
                        isSelected: widget.options.lastUpdated == lastUpdated,
                        onPress: () => widget.options.setLastUpdated(
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
                    isSelected: widget.options.openNow,
                    onPress: () => widget.options.setOpenNow(
                      true,
                      setState: setState,
                    ),
                    label: 'Yes',
                  ),
                  FilterButton(
                    isSelected: !widget.options.openNow,
                    onPress: () => widget.options.setOpenNow(
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
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: PrimaryButton(
            onPress: confirm,
            child: const Text('Confirm'),
          ),
        )
      ],
    );
  }
}
