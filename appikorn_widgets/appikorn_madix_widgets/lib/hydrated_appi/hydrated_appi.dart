library hydrated_appi;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A base class for creating hydrated state notifiers with Riverpod 2.0
/// 
/// This class extends StateNotifier and provides persistence capabilities
/// through FlutterSecureStorage.
abstract class HydratedAppi<T> extends StateNotifier<T> {
  final Ref ref;

  HydratedAppi(this.ref, super.state) {
    hyderate();
  }

  /// Convert JSON map to state object
  T fromJson(Map<String, dynamic> json);

  /// Storage key for persistence
  String get key;

  /// Convert state object to JSON map
  Map<String, dynamic> toJson(T state);

  /// Provider for FlutterSecureStorage instance
  /// This is kept as a regular Provider (not autoDispose) to maintain a single instance
  @protected
  final flutterSecureStorageProvider = Provider<FlutterSecureStorage>(
    (ref) {
      AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
      return FlutterSecureStorage(
        aOptions: getAndroidOptions(),
      );
    },
  );

  /// Factory method to create a StateNotifierProvider for this HydratedAppi
  /// 
  /// Usage:
  /// ```dart
  /// class MyHydratedAppi extends HydratedAppi<MyState> {
  ///   // implementation...
  /// }
  /// 
  /// final myProvider = MyHydratedAppi.provider((ref) => MyHydratedAppi(ref, MyState()));
  /// ```
  @protected
  static StateNotifierProvider<N, T> provider<N extends HydratedAppi<T>, T>(
    N Function(Ref ref) create,
  ) {
    return StateNotifierProvider<N, T>((ref) => create(ref));
  }

  /// Loads the state from secure storage
  /// 
  /// This method is automatically called in the constructor
  @protected
  Future<void> hyderate() async {
    try {
      // Using read instead of watch to avoid unnecessary rebuilds
      // This follows the Riverpod 2.0 best practice for one-time reads
      final storage = ref.read(flutterSecureStorageProvider);
      final value = await storage.read(key: key);
      
      if (value != null) {
        Map<String, dynamic> jsonValue = json.decode(value);
        T ins = fromJson(jsonValue);
        
        // Using state setter with mounted check to prevent updates after disposal
        if (mounted) {
          state = ins;
        }
        
        if (kDebugMode) {
          print("State successfully hydrated for key: $key");
        }
      } else if (kDebugMode) {
        print("No value found in storage for key: $key, state remains unchanged.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("An error occurred during hydration for key: $key, error: $e");
      }
    }
  }

  /// Updates the state and persists it to secure storage
  /// 
  /// This method should be used for all state updates that need persistence
  Future<void> store(T newState) async {
    try {
      if (mounted) {
        // Update state first (follows unidirectional data flow)
        state = newState;
        
        // Then persist to storage
        Map<String, dynamic> value = toJson(newState);
        String encVal = json.encode(value);
        
        // Using read for one-time access to the provider
        final storage = ref.read(flutterSecureStorageProvider);
        await storage.write(key: key, value: encVal);
        
        if (kDebugMode) {
          print("State stored and persisted for key: $key");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("An error occurred while storing state for key: $key, error: $e");
      }
    }
  }

  /// Updates the provider state without persisting to secure storage.
  /// Use this when you want to update the state temporarily without hydration.
  void storeNoHydrate(T newState) {
    try {
      if (mounted) {
        state = newState;
        if (kDebugMode) {
          print("State updated without hydration for key: $key");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("An error occurred while updating state without hydration for key: $key, error: $e");
      }
    }
  }
  
  @override
  void dispose() {
    if (kDebugMode) {
      print("Disposing HydratedAppi for key: $key");
    }
    super.dispose();
  }
}
