public class Main : Gtk.Application {
  const string GETTEXT_PACKAGE = Manokwari.APP_SYS_NAME;
  private MainWindow main_window;
  
  private static bool print_version = false;
  private static bool enable_developer_extras = false;

  private Main() {
    Object (
      application_id: Manokwari.APP_ID, 
      flags: ApplicationFlags.HANDLES_COMMAND_LINE,
      register_session: true
    );
  }

  public static int main(string[] args) {
    Intl.setlocale(LocaleCategory.MESSAGES, "");
    Intl.textdomain(GETTEXT_PACKAGE); 
    Intl.bind_textdomain_codeset(GETTEXT_PACKAGE, "utf-8"); 
    Intl.bindtextdomain(GETTEXT_PACKAGE, "./locale");
    
    Main app = new Main();
    int status = app.run(args);
    return status;
  }

  public void show_window() {
    if (main_window != null) {
      main_window.present();
      return;
    }
    main_window = new MainWindow(this);
    main_window.show_all();
  }

  public override int command_line(ApplicationCommandLine command) {
    hold();
    int result = handle_command_line(command);
    release();
    return result;
  }

  private int handle_command_line(ApplicationCommandLine command) {
    var context = new OptionContext(Manokwari.APP_NAME);
    context.add_main_entries(entries, Manokwari.APP_SYS_NAME);
    context.add_group(Gtk.get_option_group(true));
    string[] args = command.get_arguments();

    try {
      unowned string[] tmp = args;
      context.parse(ref tmp);
    } catch (Error e) {
      stderr.printf("Error\n");
      return 0;
    }

    if (print_version) {
      stdout.printf("%s %s\n", Manokwari.APP_NAME, Manokwari.APP_VERSION);
      stdout.printf("WebKit %u.%u.%u\n", WebKit.get_major_version(), WebKit.get_minor_version(), WebKit.get_micro_version());
      // FIXME: add JavaScriptCore and Seed versions
    } else {
      show_window();
    }
    return 0;
  }
  
  static const OptionEntry[] entries = {
    { "version", 'v', 0, OptionArg.NONE, out print_version, N_("Print current app version."), null },
    { "debug", 'v', 0, OptionArg.NONE, out enable_developer_extras, N_("Enable developer extras."), null },
    { null }
  };
}
