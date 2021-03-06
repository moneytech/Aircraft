namespace Aircraft {


    public class MainWindow : Gtk.Window {
        // Metadata
        private MetadataComponent mc;
        // Lists
        private ChatListView chats;
        // Properties of window
        private Gtk.Overlay overlay;
        private Granite.Widgets.Toast toast;
        private Gtk.Grid grid;
        private Gtk.Label apihash;
        private Gtk.Label demo;

        public Gtk.HeaderBar header;
        private Gtk.Spinner spinner;
        public weak Aircraft.Application app { get; construct; }

        // kbd and other actions
        public SimpleActionGroup actions { get; construct; }

        public const string ACTION_PREFIX = "win.";
        public const string ACTION_SHOW_FIND = "action_show_find";
        public const string ACTION_QUIT = "action_quit";

        public static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();

        private const ActionEntry[] action_entries = {
             { ACTION_QUIT, action_quit }
        };

        // Constructors
        public MainWindow (Aircraft.Application aircraft_app, MetadataComponent mc) {
            Object(application: aircraft_app,
                app: aircraft_app,
                icon_name: "com.github.suzamax.Aircraft",
                resizable: true
            );

            this.mc = mc;
        }
        static construct {
            action_accelerators.set (ACTION_QUIT, "<Control>q");
        }
        construct {
            actions = new SimpleActionGroup ();
            actions.add_action_entries (action_entries, this);
            insert_action_group ("win", actions);

            app.set_accels_for_action (ACTION_PREFIX + ACTION_QUIT, {"<Control>q", "<Control>w"});
            key_press_event.connect (on_key_pressed);

            Unix.signal_add (Posix.Signal.INT, quit_source_func, Priority.HIGH);
            Unix.signal_add (Posix.Signal.TERM, quit_source_func, Priority.HIGH);

        }

        public void build_ui () {
            var provider = new Gtk.CssProvider ();
            provider.load_from_resource("com/github/suzamax/Aircraft/app.css");
            provider.load_from_resource ("/com/github/suzamax/Aircraft/light.css");

            Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);


            spinner = new Gtk.Spinner();
            spinner.active = true;

            header = new Gtk.HeaderBar ();
            header.show_close_button = true;
            header.title = "Aircraft";
            header.show_all();

            this.chats.update_chats ();

            //this.apihash = new Gtk.Label (mc.get_account ().get_account ().api_hash);
            this.demo = new Gtk.Label ("It works!");
            grid = new Gtk.Grid();

            toast = new Granite.Widgets.Toast ("");
            overlay = new Gtk.Overlay();
            overlay.add_overlay(grid);
            overlay.add_overlay(toast);
            overlay.set_size_request (800, 600);
            add (overlay);

            grid.attach (this.demo, 1, 1);

            window_position = Gtk.WindowPosition.CENTER;
            set_titlebar(header);

            debug ("Creating window done!");

            show_all ();
            //app.toast.connect (on_toast);


        }

        /*private void on_toast (string msg){
            toast.title = msg;
            toast.send_notification();
        }*/

        private bool on_key_pressed (Gdk.EventKey event) {

            // propagate this event to child widgets
            return false;
        }

        public bool quit_source_func () {
            action_quit ();
            return false;
        }

        private void action_quit () {
            debug ("Quitting...");
            var client = this.mc.get_client ();
            if (client != null) {
                client.destroy_client ();
                destroy ();
                Process.exit (0);
            }
        }


    }
}
