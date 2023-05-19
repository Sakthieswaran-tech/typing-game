class TimeState {
  Map<String, dynamic> timer;

  TimeState({required this.timer});

  Map<String, dynamic> toJson() => {'timer': timer};
}
