class Edit extends ICommand {
	private parser;
	
	public method Edit(){
		me.ICommand("edit");
	}

	public method help(){
		println( "* edit <file>\t\t\t\t\t\t\t\t\tedit a specific file" );
	}

	public method exec( args ){
		
		me.parser = new Parser("bh.conf"); 					// dichiaro qui per evitare di riaprire il file ad ogni modifica
		
		if (args.split(" ")[0] == "help"){
			me.help();
			return true;
		} 
		
		if( fork() == 0 ){
			`"xterm -e \"" + me.parser.editor + " " + args + "\""`
		}
	}
}
/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Edit();
