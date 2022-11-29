class SettingsData {
  bool enableTime = false;
  int timeoutSeconds = 60;
  SettingsData({required this.enableTime, required this.timeoutSeconds});

  static SettingsData globalSettings =
      SettingsData(enableTime: true, timeoutSeconds: 20);
}
