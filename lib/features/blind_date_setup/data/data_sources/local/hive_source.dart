import 'package:hive_flutter/hive_flutter.dart';
import 'package:redting/core/data/hive_names.dart';
import 'package:redting/features/blind_date_setup/data/data_sources/local/local_source.dart';

class HiveBlindDateSource implements LocalBlindDateSource {
  final Box _blindDatesSetupStatBox = Hive.box<bool?>(canMakeBlindDatesBox);

  @override
  Future<bool> hasReachedMaxSetups() async {
    return _blindDatesSetupStatBox.get(canMakeBlindDatesBoxKey,
        defaultValue: false);
  }

  @override
  Future setHasReachedMaxSetups() async {
    await _blindDatesSetupStatBox.put(canMakeBlindDatesBoxKey, true);
  }
}
