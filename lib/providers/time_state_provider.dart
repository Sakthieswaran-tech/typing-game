import 'package:flutter/widgets.dart';
import 'package:typeracer/models/time_state.dart';

class TimeStateProvider extends ChangeNotifier {
  TimeState timeState = TimeState(timer: {'count': '', 'message': ''});

  Map<String, dynamic> get getTimeState => timeState.toJson();

  setTimeState(timer) {
    timeState = TimeState(timer: timer);
    notifyListeners();
  }
}
