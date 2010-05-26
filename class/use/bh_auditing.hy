class BH_auditing extends IWorkspace{					// WorkSpace per auditing
									// Per usarlo "use auditing"
	public method BH_auditing(){
		
		me.IWorkspace("auditing", "./commands/auditing");
		
		/*
		 * 	Per ogni script che trovo nella dir, lo carico, prendo l'istanza
		 * 	della classe che crea quando viene caricato, e la inserisco nella 
		 * 	mappa dei comandi.
		 */
		 
		foreach( file of me.files ){
			if ( file["type"] != DT_DIR ){
				me.import_command("./commands/auditing/" + file["name"]);
			}
		}
	}
	
	public method import_command(file){
		load(file);
		me.commands[__cmd_instance.name] = __cmd_instance;
	}
	
	public method help(){
		println("\t\t\t --------- Auditing Tool -----------",
			"* import_command <file>\t\t\t\t\t\t\t\timport external plugin");
		foreach( name -> cmd of me.commands ){
			cmd.help();
		}
	}
	
	
	public method exec( cmd, args ){
		
		if( me.commands.has(cmd) ){
			return me.commands[cmd].exec(args);
		}
		
		else {
			switch ( cmd ) {
				
				case "import_command" :
					me.import_command(args);
				break;
				
				case "help" :
					me.help();
				break;
				
				default: 
					println( cmd + " unknown command" );
			}
		}
	}
	
}

/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__workspace_instance = new BH_auditing();