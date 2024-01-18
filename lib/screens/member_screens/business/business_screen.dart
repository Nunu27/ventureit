import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/business_controller.dart';
import 'package:ventureit/controllers/location_controller.dart';
import 'package:ventureit/widgets/error_view.dart';
import 'package:ventureit/widgets/loader.dart';
import 'package:ventureit/widgets/rating.dart';

class BusinessScreen extends ConsumerWidget {
  final String businessId;
  const BusinessScreen({
    super.key,
    required this.businessId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabPage = TabPage.of(context);
    final location = ref.watch(locationProvider)!;
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    return ref.watch(getBusinessByIdProvider(businessId)).when(
          data: (business) {
            final openHours = business.getOpenHours();

            return Scaffold(
              appBar: AppBar(
                scrolledUnderElevation: 0,
                backgroundColor: theme.colorScheme.primaryContainer,
                actions: [
                  PopupMenuButton(
                    onSelected: (value) {
                      if (value == "edit") {
                        Routemaster.of(context)
                            .push("/member/business/${business.id}/edit");
                      } else if (value == "promote") {
                        Routemaster.of(context)
                            .push("/member/business/${business.id}/promote");
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      const PopupMenuItem(
                        value: "promote",
                        child: Text('Promote'),
                      ),
                      const PopupMenuItem(
                        value: "edit",
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
                                          "Closed  ",
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
                                              "Closed  ",
                                              style: TextStyle(
                                                color:
                                                    theme.colorScheme.tertiary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                  if (openHours != null)
                                    Text(
                                      openHours.timeString(),
                                      style: TextStyle(
                                        color: theme
                                            .colorScheme.onPrimaryContainer,
                                        fontSize: 12,
                                      ),
                                    ),
                                  const VerticalDivider(),
                                  Column(
                                    children: [
                                      Rating(
                                        business.rating,
                                        scale: 1.2,
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
              body: NestedScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverSafeArea(
                      top: false,
                      sliver: SliverAppBar(
                        scrolledUnderElevation: 0,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        pinned: true,
                        floating: true,
                        automaticallyImplyLeading: false,
                        titleSpacing: 0,
                        toolbarHeight: 221,
                        title: Image.network(
                          business.cover,
                          height: 221,
                          width: media.size.width,
                          fit: BoxFit.cover,
                        ),
                        bottom: TabBar(
                          controller: tabPage.controller,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          tabs: const [
                            Tab(text: 'Products'),
                            Tab(text: 'Reviews'),
                            Tab(text: 'Gallery'),
                            Tab(text: 'Details'),
                            Tab(text: 'Contents'),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
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
          loading: () => Container(
            color: theme.colorScheme.background,
            child: const Loader(),
          ),
        );
  }
}
