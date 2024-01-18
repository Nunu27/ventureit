import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/business_controller.dart';
import 'package:ventureit/controllers/mission_controller.dart';
import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/models/mission.dart';
import 'package:ventureit/utils/utils.dart';
import 'package:ventureit/utils/validation.dart';
import 'package:ventureit/widgets/error_view.dart';
import 'package:ventureit/widgets/input/text_input.dart';
import 'package:ventureit/widgets/loader.dart';
import 'package:ventureit/widgets/loader_overlay.dart';

class PromoteScreen extends ConsumerStatefulWidget {
  final String id;
  const PromoteScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PromoteScreenState();
}

class _PromoteScreenState extends ConsumerState<PromoteScreen> {
  final _form = GlobalKey<FormState>();

  int review = 0;
  int contribution = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => checkGuest(context),
    );
  }

  void onReviewChanged(String? value) {
    setState(() {
      review = getNumber(value ?? '0');
    });
  }

  void onContributionChanged(String? value) {
    setState(() {
      contribution = getNumber(value ?? '0');
    });
  }

  void submit(Business business) {
    if (_form.currentState!.validate()) {
      ref.read(missionControllerProvider.notifier).promote(
            context: context,
            business: business,
            reviewCount: review,
            contributeCount: contribution,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(missionControllerProvider);

    return ref.watch(getBusinessByIdProvider(widget.id)).when(
          data: (business) => LoaderOverlay(
            isLoading: isLoading,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Promote business'),
                actions: [
                  IconButton(
                      onPressed: () => submit(business),
                      icon: const Icon(Icons.done))
                ],
              ),
              body: Form(
                key: _form,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextForm(
                        label: 'Review mission',
                        keyboardType: TextInputType.number,
                        placeholder: 'Mission count',
                        onChanged: onReviewChanged,
                        validator: validatePositiveNumber,
                        inputFormatters: [
                          CurrencyTextInputFormatter(
                            locale: 'id',
                            decimalDigits: 0,
                            symbol: '',
                          ),
                        ],
                      ),
                      CustomTextForm(
                        label: 'Contribution mission',
                        keyboardType: TextInputType.number,
                        placeholder: 'Mission count',
                        onChanged: onContributionChanged,
                        validator: validatePositiveNumber,
                        inputFormatters: [
                          CurrencyTextInputFormatter(
                            locale: 'id',
                            decimalDigits: 0,
                            symbol: '',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total cost'),
                          Text(
                              'Rp. ${numberFormatter.format(review * MissionType.review.reward + contribution * MissionType.contribute.reward)}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          error: (error, stackTrace) => ErrorView(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
