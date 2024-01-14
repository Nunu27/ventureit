import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:ventureit/screens/member_screens/business/edit_business_screen.dart';
import 'package:ventureit/utils/utils.dart';

class AddSubmissionScreen extends ConsumerStatefulWidget {
  const AddSubmissionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddSubmissionScreenState();
}

class _AddSubmissionScreenState extends ConsumerState<AddSubmissionScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _form = GlobalKey();
  late TabController _tabController;
  final PreloadPageController _pageController = PreloadPageController(
    initialPage: 0,
    keepPage: true,
    viewportFraction: 0.99,
  );

  Map<String, dynamic> _formData = {};

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        changePage(_tabController.index, page: true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void save() {
    if (_form.currentState!.validate()) {
    } else {
      showSnackBar('Please resolve all error');
    }
  }

  void changePage(index, {page = false, tab = false}) async {
    if (page) {
      await _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      _tabController.animateTo(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Business Data'),
        actions: [IconButton(onPressed: save, icon: const Icon(Icons.done))],
        bottom: TabBar(
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          controller: _tabController,
          tabs: const [
            Tab(text: "General"),
            Tab(text: "Products"),
            Tab(text: "Gallery"),
            Tab(text: "Content"),
            Tab(text: "External Links"),
          ],
        ),
      ),
      body: Form(
        key: _form,
        child: PreloadPageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: const [
            EditBusinessScreen(),
            EditBusinessScreen(),
            EditBusinessScreen(),
            EditBusinessScreen(),
            EditBusinessScreen(),
          ],
        ),
      ),
    );
  }
}
