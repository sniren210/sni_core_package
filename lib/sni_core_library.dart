library sni_core;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sni_core/sni_core_library.config.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'src/core/injector/injector.dart';
part 'src/core/injector/settings/settings.dart';
part 'src/core/helpers/sni.dart';
part 'src/presentation/providers/country/country_setting.dart';
part 'src/presentation/providers/currency/currency_setting.dart';
part 'src/presentation/providers/locale/locale_setting.dart';
part 'src/presentation/providers/motion/motion_setting.dart';
part 'src/presentation/providers/sound/sound_setting.dart';
part 'src/presentation/providers/splash_screen/splash_screen_setting.dart';
part 'src/presentation/providers/theme_mode/theme_mode_setting.dart';
part 'src/presentation/providers/vibration/vibration_setting.dart';
