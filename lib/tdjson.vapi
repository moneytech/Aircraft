/* tdjson.vapi generated by vapigen, do not modify. */

[CCode (cprefix = "Td_json", gir_namespace = "Td_json", lower_case_cprefix = "td_json_")]
namespace Td_json {
	[CCode (cheader_filename = "td/telegram/td_json_client.h")]
	public static void* client_create ();
	[CCode (cheader_filename = "td/telegram/td_json_client.h")]
	public static void client_destroy (void* client);
	[CCode (cheader_filename = "td/telegram/td_json_client.h")]
	public static unowned string client_execute (void* client, string request);
	[CCode (cheader_filename = "td/telegram/td_json_client.h")]
	public static unowned string client_receive (void* client, double timeout);
	[CCode (cheader_filename = "td/telegram/td_json_client.h")]
	public static void client_send (void* client, string request);
}
