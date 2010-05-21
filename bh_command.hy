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
		me.intro();
		println("All commands: ",
			"* help\t\t\t\t\t\t\t\t\t\tshow this message",
			"* import\t\t\t\t\t\t\t\t\timport external plugin");
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
		
		else {
			switch ( cmd ) {
				
				case "help" :
					me.help();
				break;
				
				case "import" :
					me.import(args);
				break;
				
				default: 
					println( cmd + " unknown command" );
				break;
			}
		}
	}
	
	
	
	
	public method intro(){
		//0;34 blue
		println( "\x1b[0;34m\n\tBugs Hunter 0.1 Web Exploiting Framework",
			 "\n\thttp://ihteam.net\n\n\x1b[0m" );
	}
	
	
	public method ascii_art(){ 
		random = `"echo $(($RANDOM%4+1))"`;
		switch (random){
			case "1\n":
				println("\x1b[34m\n\t\t  __                                              ",
					"\t\t|/  |                /  |           /             ",
					"\t\t|___|      ___  ___ (___|      ___ (___  ___  ___ ",
					"\t\t|   )|   )|   )|___ |   )|   )|   )|    |___)|   )",
					"\t\t|__/ |__/ |__/  __/ |  / |__/ |  / |__  |__  |    ",
					"\t\t          __/                                     \x1b[0m");
			break;
			
			case "2\n":
				println("\x1b[34m\n\t\t.__          .  .       ,       ",
					"\t\t[__). . _  __|__|. .._ -+- _ ._.",
					"\t\t[__)(_|(_]_) |  |(_|[ ) | (/,[  ",
					"\t\t       ._|                      \x1b[0m");
			break;
			
			case "3\n":
				println("\x1b[34m\n\t\t ___              _  _          _           ",
					"\t\t| _ )_  _ __ _ __| || |_  _ _ _| |_ ___ _ _ ",
					"\t\t| _ \ || / _` (_-< __ | || | ' \  _/ -_) '_|",
					"\t\t|___/\_,_\__, /__/_||_|\_,_|_||_\__\___|_|  ",
					"\t\t         |___/                              \x1b[0m");
			break;
			
			case "4\n":
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
