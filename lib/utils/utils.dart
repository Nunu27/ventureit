import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ventureit/models/failure.dart';
import 'package:ventureit/models/open_hours.dart';
import 'package:ventureit/providers/add_submission_provider.dart';
import 'package:ventureit/providers/edit_business_provider.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

final currencyFormatter = CurrencyTextInputFormatter(
  locale: 'id',
  decimalDigits: 0,
  symbol: 'Rp. ',
);

final numberFormatter = NumberFormat.decimalPatternDigits(
  locale: 'in',
  decimalDigits: 0,
);

bool isGuest() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return true;
  user.reload();
  return false;
}

bool isVerified() {
  final user = FirebaseAuth.instance.currentUser;

  return user!.emailVerified;
}

void showSnackBar(String message) {
  if (!snackbarKey.currentState!.mounted) return;

  snackbarKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

Future<T?> showConfirmationDialog<T>({
  required BuildContext context,
  required String title,
  bool isDismissable = false,
  String? body,
  String? optionOne,
  VoidCallback? onOptionOne,
  String? optionTwo,
  VoidCallback? onOptionTwo,
  bool useRootNavigator = true,
}) async {
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: body == null ? null : Text(body),
    actions: [
      if (optionOne != null)
        TextButton(
          onPressed: onOptionOne ??
              () {
                Navigator.of(context).pop(false);
              },
          child: Text(optionOne),
        ),
      if (optionTwo != null)
        TextButton(
          onPressed: onOptionTwo,
          child: Text(optionTwo),
        ),
    ],
  );

  return await showDialog(
    context: context,
    barrierColor: Colors.black.withAlpha(50),
    barrierDismissible: isDismissable,
    builder: (BuildContext context) {
      return alert;
    },
    useRootNavigator: useRootNavigator,
  );
}

void checkGuest(BuildContext context) {
  if (isGuest()) {
    showConfirmationDialog(
      context: context,
      title: 'Account required',
      body: 'Please login to use this feature.',
      isDismissable: false,
      optionOne: 'Login',
      onOptionOne: () => Routemaster.of(context).replace('/login'),
      optionTwo: 'Register',
      onOptionTwo: () => Routemaster.of(context).replace('/register'),
      useRootNavigator: false,
    );
  } else if (!isVerified()) {
    showConfirmationDialog(
      context: context,
      isDismissable: false,
      useRootNavigator: false,
      title: 'Account not verified',
      body: 'Please verify your account first to use this feature.',
    );
  }
}

bool modalShown = false;

Future<bool> showDiscardData(BuildContext context, WidgetRef ref) async {
  modalShown = true;
  final res = await showConfirmationDialog(
    context: context,
    title: 'Discard data',
    body: 'Are you sure to go back?',
    optionOne: 'Cancel',
    optionTwo: 'Discard',
    onOptionTwo: () {
      ref.read(addSubmissionProvider.notifier).update((state) => null);
      ref.read(editBusinessProvider.notifier).update((state) => null);
      Navigator.of(context).pop(true);
    },
  );
  modalShown = false;
  return res;
}

void openUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    showSnackBar('Failed to open url');
  }
}

int getNumber(String str) {
  try {
    return int.parse(str.replaceAll(RegExp(r'[^\-\d]'), ''));
  } catch (e) {
    return 0;
  }
}

Failure getError(Object e) {
  if (e is FirebaseAuthException) {
    return Failure(message: e.message!);
  } else if (e is FirebaseException) {
    return Failure(message: e.message!);
  } else if (e is String) {
    return Failure(message: e);
  }

  print(e);

  return Failure(message: 'Something went wrong');
}

String padTime(int num) {
  return num.toString().padLeft(2, '0');
}

String formatTimeRange(TimeRange range) {
  return '${padTime(range.startTime.hour)}:${padTime(range.startTime.minute)} - ${padTime(range.endTime.hour)}:${padTime(range.endTime.minute)}';
}

List<MapEntry<int, String>> getClosedDays(List<OpenHours> openHours) {
  Map<int, String> data = Map<int, String>.from(daysMap);

  for (var openHour in openHours) {
    data.removeWhere(
      (key, value) =>
          key >= openHour.days.lowerBound && key <= openHour.days.upperBound,
    );
  }

  return data.entries.toList();
}

String getDays(List<MapEntry<int, String>> daysList) {
  String? startDay;
  MapEntry<int, String>? lastEntry;
  List<String> days = [];

  for (var entry in daysList) {
    startDay ??= entry.value;
    if (lastEntry == null || lastEntry.key == entry.key - 1) {
      lastEntry = entry;
    } else {
      days.add(startDay == lastEntry.value
          ? startDay
          : '$startDay-${lastEntry.value}');

      startDay = entry.value;
      lastEntry = entry;
    }
  }

  if (startDay != null && lastEntry != null) {
    days.add(startDay == lastEntry.value
        ? startDay
        : '$startDay-${lastEntry.value}');
  }

  return days.join(", ");
}
