// Login Verify Providers
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailProvider = StateProvider<String>((ref) => "");
final passwordProvider = StateProvider<String>((ref) => "");
final loginVerifyProvider = StateProvider<String?>((ref) => null);
final organisationNameProvider = StateProvider<String>((ref) => "");
