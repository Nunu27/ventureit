import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:ventureit/models/open_hours.dart';
import 'package:ventureit/models/range.dart';
import 'package:ventureit/models/time_hour.dart';
import 'package:ventureit/utils/utils.dart';
import 'package:ventureit/widgets/submission_card/open_hours_card.dart';
import 'package:ventureit/widgets/custom_dropdown.dart';
import 'package:ventureit/widgets/input/pressable_input.dart';
import 'package:ventureit/widgets/primary_button.dart';
import 'package:ventureit/widgets/secondary_button.dart';

class OpenHoursModal extends StatefulWidget {
  final List<OpenHours> state;
  final ScrollController scrollController;

  const OpenHoursModal({
    super.key,
    required this.state,
    required this.scrollController,
  });

  @override
  State<OpenHoursModal> createState() => _OpenHoursModalState();
}

class _OpenHoursModalState extends State<OpenHoursModal> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  bool open24Hours = false;
  int? from;
  int? to;
  TimeRange? timeRange;
  late List<OpenHours> current;
  late List<MapEntry<int, String>> closedDays;

  @override
  void initState() {
    super.initState();
    current = List.from(widget.state);
    closedDays = getClosedDays(current);
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  void selectTimeRange() async {
    if (open24Hours) return;

    TimeRange? result = await showTimeRangePicker(context: context);
    if (result != null) {
      setState(() {
        timeRange = result;
      });
    }
  }

  void add() {
    if (from == null || to == null || (!open24Hours && timeRange == null)) {
      showSnackBar('Please fill all required data');
      return;
    }

    current.add(
      OpenHours(
        days: Range(lowerBound: from!, upperBound: to!),
        hours: Range(
          lowerBound: open24Hours
              ? TimeHour(hours: 0, minute: 0)
              : TimeHour.fromTimeOfDay(timeRange!.startTime),
          upperBound: open24Hours
              ? TimeHour(hours: 0, minute: 0)
              : TimeHour.fromTimeOfDay(timeRange!.endTime),
        ),
      ),
    );
    closedDays = getClosedDays(current);

    fromController.clear();
    toController.clear();

    setState(() {
      from = null;
      to = null;
      open24Hours = false;
      timeRange = null;
    });
  }

  void confirm() {
    Navigator.of(context, rootNavigator: true).pop(current);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              controller: widget.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fill in open hours',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Day range',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: CustomDropdown(
                        controller: fromController,
                        hintText: 'From',
                        initialSelection: from,
                        onSelected: (p0) => setState(() {
                          from = p0;
                        }),
                        entries: closedDays
                            .where((e) => to == null || e.key < to!)
                            .map(
                              (e) => DropdownMenuEntry(
                                value: e.key,
                                label: e.value,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomDropdown(
                        controller: toController,
                        hintText: 'To',
                        initialSelection: to,
                        onSelected: (p0) => setState(() {
                          to = p0;
                        }),
                        entries: closedDays
                            .where((e) => from == null || e.key > from!)
                            .map(
                              (e) => DropdownMenuEntry(
                                value: e.key,
                                label: e.value,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ]),
                  CustomPressableInput(
                    onPress: selectTimeRange,
                    label: 'Hour range',
                    child: Text(
                      open24Hours
                          ? '24 Hours'
                          : timeRange == null
                              ? ''
                              : formatTimeRange(timeRange!),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: open24Hours,
                            onChanged: (value) => setState(() {
                              open24Hours = !open24Hours;
                            }),
                          ),
                          const Text('Open 24 hours'),
                        ],
                      ),
                      SecondaryButton(
                        onPressed: add,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ...current.map(
                    (e) => OpenHourCard(
                      text: '${e.daysString()}, ${e.timeString()}',
                      trailing: GestureDetector(
                        onTap: () {
                          current.remove(e);
                          setState(() {
                            closedDays = getClosedDays(current);
                          });
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  if (closedDays.isNotEmpty)
                    OpenHourCard(
                      isOpen: false,
                      text: getDays(closedDays),
                    )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: PrimaryButton(
              onPress: confirm,
              child: const Text('Confirm'),
            ),
          )
        ],
      ),
    );
  }
}
