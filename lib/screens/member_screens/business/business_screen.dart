import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/business_controller.dart';
import 'package:ventureit/controllers/location_controller.dart';
import 'package:ventureit/widgets/error_view.dart';
import 'package:ventureit/widgets/loader.dart';

class BusinessScreen extends ConsumerStatefulWidget {
  final String businessId;
  const BusinessScreen({
    super.key,
    required this.businessId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends ConsumerState<BusinessScreen> {
  @override
  Widget build(BuildContext context) {
    final tabPage = TabPage.of(context);
    final location = ref.watch(locationProvider)!;
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    return ref.watch(getBusinessByIdProvider(widget.businessId)).when(
          data: (business) {
            final openHours = business.getOpenHours();

            return Scaffold(
              appBar: AppBar(
                backgroundColor: theme.colorScheme.primaryContainer,
                actions: [
                  PopupMenuButton(
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      const PopupMenuItem(
                        child: Text('Promote'),
                      ),
                      const PopupMenuItem(
                        child: Text('Edit data'),
                      ),
                    ],
                  ),
                ],
                title: Text(
                  business.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                ),
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(56),
                    child: Transform.translate(
                      offset: const Offset(0, 16),
                      child: Container(
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: const BorderRadiusDirectional.only(
                            bottomEnd: Radius.circular(16),
                            bottomStart: Radius.circular(16),
                          ),
                        ),
                        child: Transform.translate(
                          offset: const Offset(0, -18),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              height: 45,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: Row(
                                children: [
                                  openHours == null
                                      ? Text(
                                          "Close  ",
                                          style: TextStyle(
                                            color: theme.colorScheme.tertiary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      : openHours.isOpen()
                                          ? Text(
                                              "Open  ",
                                              style: TextStyle(
                                                color:
                                                    theme.colorScheme.tertiary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          : Text(
                                              "Close  ",
                                              style: TextStyle(
                                                color:
                                                    theme.colorScheme.tertiary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                  if (openHours != null)
                                    Text(
                                      openHours.toString(),
                                      style: TextStyle(
                                        color: theme
                                            .colorScheme.onPrimaryContainer,
                                        fontSize: 12,
                                      ),
                                    ),
                                  const VerticalDivider(),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.star,
                                              color: Colors.amber),
                                          Text(
                                            business.rating.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        '(${business.ratedBy.toString()})',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const VerticalDivider(),
                                  const Icon(Icons.fmd_good),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        business.placemark.street ?? '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        business.getDistance(location.position),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const VerticalDivider(),
                                  const Icon(Icons.attach_money),
                                  const Text(
                                    "15k - 20k",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
              body: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(270),
                  child: Column(
                    children: [
                      Image.network(
                        business.cover,
                        height: 221,
                        width: media.size.width,
                        fit: BoxFit.cover,
                      ),
                      TabBar(
                        controller: tabPage.controller,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        tabs: const [
                          Tab(
                            text: 'Products',
                          ),
                          Tab(
                            text: 'Reviews',
                          ),
                          Tab(
                            text: 'Gallery',
                          ),
                          Tab(
                            text: 'Details',
                          ),
                          Tab(
                            text: 'Contents',
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                body: TabBarView(
                  controller: tabPage.controller,
                  children: [
                    for (final stack in tabPage.stacks)
                      PageStackNavigator(stack: stack),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) => ErrorView(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
