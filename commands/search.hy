class Search extends ICommand {
	public method Search(){
		me.ICommand("search");
	}

	public method help(){
		println( "search dir=\"path\" [] []" );
	}

	public method exec( args ){
		
		if ( args.split(" ")[0] == "help" ){
			me.help();
		} 
		else {		
			foreach ( arg of args.split(" ") ){
				( name_var, var ) = ( arg ~= "/([^\s=]+)=([^\s]+)/");
				println(name_var + " = " + var );
			}
		}
	}
}
/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Search();
