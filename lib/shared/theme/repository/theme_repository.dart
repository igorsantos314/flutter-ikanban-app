abstract class ThemeRepository {
  Future<bool> isDarkModeEnabled();
  Future<void> setDarkModeEnabled(bool isEnabled);
}
