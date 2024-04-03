import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => Locale(Intl.systemLocale);

  void setLocale(Locale locale) {
    state = locale;
  }
}
