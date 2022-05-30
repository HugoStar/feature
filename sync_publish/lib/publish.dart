import 'dart:io';

import 'version.dart';
import 'package.dart';
import 'extension.dart';

class Entrypoint {
  final Directory _workdir;

  Entrypoint(Directory? workdir) : _workdir = workdir ?? Directory.current;

  /// Updates installation guides with new version.
  Future<void> updateReadmeCoreVersion({
    required Package package,
    required Version version,
  }) async {
    final readme = await package.readme.readAsString();
    final updated = readme.replaceAll(
      RegExp(r'feature_core: &feature_version (.+)'),
      'feature_core: &feature_version ^$version',
    );
    await package.readme.writeAsString(updated);
  }

  Future<void> publishPackage(Package package) async {}

  Iterable<Directory> getDirsOfPackages() {
    final featurePackagesPath = _workdir
        .listSync()
        .whereType<Directory>()
        .where((e) => !e.uri.lastPathSegment.contains('.'));
    return featurePackagesPath;
  }

  List<Package> getPackages() {
    final packagesDirs = getDirsOfPackages();
    final packages = packagesDirs.map((e) {
      return Package(
        directory: e,
      );
    }).toList();

    return packages.excludeSync;
  }

  Future<void> syncPackagesByMax() async {
    final packages = getPackages();
    final maxVersion = packages.maxVersion;
    if (maxVersion != null) {
      for (final package in packages) {
        await package.setVersion(version: maxVersion);
      }
    }
  }

  Future<void> incrementAllPatch() async {
    final packages = getPackages();
    for (final package in packages) {
      await package.incrementPatch();
    }
  }

  Future<void> incrementAllMinor() async {
    final packages = getPackages();
    for (final package in packages) {
      await package.incrementMinor();
    }
  }

  Future<void> incrementAllMajor() async {
    final packages = getPackages();
    for (final package in packages) {
      await package.incrementMajor();
    }
  }
}
