class Main {
	private commands;
	private workspaces;
	private using;
	private files;
	private workspace_files;

	public method Main(){
		
		me.files = readdir("./commands", false);
		me.workspace_files = readdir("./class/wspaces", false);
		me.commands = [:];
		me.workspaces = [:];
		me.using = "";
		
		/*
		 * 	Per ogni script che trovo nella dir, lo carico, prendo l'istanza
		 * 	della classe che crea quando viene caricato, e la inserisco nella 
		 * 	mappa dei comandi.
		 */
		 
		foreach( file of me.files ){
			if ( file["type"] != DT_DIR ){
				me.import("./commands/" + file["name"]);
			}
		}
		me.import_workspaces();
		
	}
	
	private method import(file){
		load(file);
		me.commands[__cmd_instance.name] = __cmd_instance;
	}
	
	private method import_workspaces(){
		foreach( file of me.workspace_files ){
			if ( file["type"] != DT_DIR ){
				load("./class/wspaces/" + file["name"]);
				me.workspaces[__workspace_instance.name] = __workspace_instance;
			}
		}
	}

	private method help(){
		me.intro();
		println("All commands: ",
			"* help\t\t\t\t\t\t\t\t\t\tshow this message",
			"* use [workspace]\t\t\t\t\t\t\t\tselect workspace ( \"use\" to show all workspaces) ");
		foreach( name -> cmd of me.commands ){
			cmd.help();
		}
	}

	public method exec( cmd, args ){
		switch ( cmd ) {
			
			case "help" :
				me.help();
				if ( me.using != "" ){ 
					me.workspaces[me.using].help();
				}
			break;
			
			case "use" :
				
				if ( me.workspaces.has(args) ){
					me.using = args;
					println("Using \" " + args + " \" WorkSpace.");
				} 
				else { 
					if ( args == "" ){
						foreach ( name -> ws of me.workspaces ){
							println("+ " + name + " " + ws.description);
						}
					} else {
						println( args + " workspace not found." ); 
					}
				}
				
			break;
			
			default: 
				if ( me.commands.has(cmd) ){
					return me.commands[cmd].exec(args);
				} else if ( me.using != "" ){ 
					me.workspaces[me.using].exec(cmd, args);
				} else if ( me.using == "" ){
					println( cmd + " unknown command" );
				}
		}
	}
	
	
	
	
	public method intro(){
		//0;34 blue
		println( "\x1b[0;34m\n\tBugs Hunter 0.2 Web Exploiting Framework",
			 "\n\thttp://ihteam.net\n\n\x1b[0m" );
	}
	
	
	public method ascii_art(){ 
		random = `"echo $(($RANDOM%4+1))"`.trim();
		switch (random){
			case "1":
				println("\x1b[34m\n\t\t  __                                              ",
					"\t\t|/  |                /  |           /             ",
					"\t\t|___|      ___  ___ (___|      ___ (___  ___  ___ ",
					"\t\t|   )|   )|   )|___ |   )|   )|   )|    |___)|   )",
					"\t\t|__/ |__/ |__/  __/ |  / |__/ |  / |__  |__  |    ",
					"\t\t          __/                                     \x1b[0m");
			break;
			
			case "2":
				println("\x1b[34m\n\t\t.__          .  .       ,       ",
					"\t\t[__). . _  __|__|. .._ -+- _ ._.",
					"\t\t[__)(_|(_]_) |  |(_|[ ) | (/,[  ",
					"\t\t       ._|                      \x1b[0m");
			break;
			
			case "3":
				println("\x1b[34m\n\t\t ___              _  _          _           ",
					"\t\t| _ )_  _ __ _ __| || |_  _ _ _| |_ ___ _ _ ",
					"\t\t| _ \ || / _` (_-< __ | || | ' \  _/ -_) '_|",
					"\t\t|___/\_,_\__, /__/_||_|\_,_|_||_\__\___|_|  ",
					"\t\t         |___/                              \x1b[0m");
			break;
			
			case "4":
				println("\x1b[34m\n\t\t      < BuuuuuugsHunter! >",
					"\t\t  -------------------------- ",
					"\t\t         \   ^__^",
					"\t\t          \  (oo)\_______",
					"\t\t             (__)\       )\/",
					"\t\t                 ||----w |",
					"\t\t                 ||     ||\x1b[0m");
			break;
		}
	}
		
} 
