import 'dart:async';

import 'package:feature_core/feature_core.dart';

class TogglingFeatureSourceWrapper implements FeatureSource {
  final FeatureSource source;
  final bool enableToggling;

  @override
  String name;

  TogglingFeatureSourceWrapper({
    required this.source,
    this.name = '',
    this.enableToggling = true,
  });

  @override
  bool containsFeature(String key) => source.containsFeature(key);

  @override
  void dispose() => source.dispose();

  @override
  Map<String, Feature> get features => source.features;

  @override
  Feature? getFeature(String key) => source.getFeature(key);

  @override
  T? getFeatureByType<T extends Feature>() => source.getFeatureByType<T>();

  @override
  FutureOr<void> pull() async => updateAllFeatures(await pullFeatures());

  @override
  FutureOr<Iterable<Feature>> pullFeatures() => source.pullFeatures();

  @override
  FutureOr<void> reset() => source.reset();

  @override
  Stream<Map<String, Feature>> get stream => source.stream;

  @override
  FutureOr<void> updateAllFeatures(Iterable<Feature> features) =>
      source.updateAllFeatures(features);

  @override
  FutureOr<void> updateFeature(Feature feature) =>
      source.updateFeature(feature);

  @override
  void notifyNeedUpdate() => source.notifyNeedUpdate();

  @override
  FutureOr<void> onReceiveNeedUpdate() {}

  void toggle(String key) {
    final feature = getFeature(key);
    if (feature != null && enableToggling) {
      setEnable(key, !feature.enabled);
    }
  }

  void toggleByType<T extends Feature>() {
    final feature = getFeatureByType<T>();
    if (feature != null && enableToggling) {
      setEnable(feature.key, !feature.enabled);
    }
  }

  void setEnable(String key, bool value) {
    final feature = getFeature(key);
    if (feature != null && enableToggling) {
      final newFeature = feature.copyWith(enabled: value);
      updateFeature(newFeature);
    }
  }
}
