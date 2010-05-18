import  std.*;
include std.io.Directory;
include icommand;

/*
 * 	Eredito da Directory così posso loopare su me stessa.
 */
 
class BH_commands extends Directory {
	private commands;

	public method BH_commands(){
		me.Directory("./commands");
		me.commands = [:];
		
		/*
		 * 	Per ogni script che trovo nella dir, lo carico, prendo l'istanza
		 * 	della classe che crea quando viene caricato, e la inserisco nella 
		 * 	mappa dei comandi.
		 */
		 
		foreach( command of me ){
			me.import("./commands/" + command);
		}
	}
	
	public method import(script){
		load(script);
		me.commands[__cmd_instance.name] = __cmd_instance;
	}

	public method help(){
		println( "Bugs Hunter 0.1 hybris version",
			 	 "coded by white_sheep & evilsocket",
			 	 "http://ihteam.net\n" );
	
		foreach( name -> cmd of me.commands ){
			cmd.help();
		}
	}

	public method quit(){
		exit( println("bye :)") );
	}

	public method exec( cmd, args ){
		if( me.commands.has(cmd) ){
			return me.commands[cmd].exec(args);
		}
		else if( cmd == "help" ){
			me.help();
		}
		else if( cmd == "import" ){
			me.import(args);
		}
		else{
			println( cmd + " unknown command" );
		}
	}
}


bh = new BH_commands();

while (1){

	print("[ BH ]-> " + env()["USER"] + " #: " );

	( cmd, args ) = readline() ~= "/^([^\s]+)\s*(.*)$/";
	
	output = bh.exec( cmd, args );
	
	println(output) unless !isstring(output);
	
}

