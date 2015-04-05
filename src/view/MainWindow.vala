class MainWindow : Gtk.ApplicationWindow {
  public MainWindow (Gtk.Application app_context) {
    Object(application: app_context);
    setup();
  }

  private void setup() {
    set_default_size(400, 400);
    title = "Manokwari";
  }
}
