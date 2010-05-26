/*
 * 	Questa è l'interfaccia che ogni workspace dovrà editare.
 */

class IWorkspace {
	
	private commands;
	private files;
	public name;
	
	public method IWorkspace ( name, commands_path ) {
		me.name = name;
		me.commands = [:];
		me.files = readdir(commands_path, false);
	}
	
	public method help(){ }
	public method exec( args ){ }	
}
