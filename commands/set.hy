class Set extends ICommand {
	private parser;
	
	public method Set(){
		me.ICommand("set");
	}

	public method help(){
		println( "* set name=value\t\t\t\t\t\t\t\tset variables in config files" );
	}

	public method exec( args ){
		
		me.parser = new Parser("bh.conf"); 					// dichiaro qui per evitare di riaprire il file ad ogni modifica
		
		if (args.split(" ")[0] == "help"){
			me.help();
			return true;
		} 
		
		if ( args != "" ) {
			foreach ( arg of args.split(" ") ){
				if ( arg ~= "/[^\s=]+=[^\s]+/" ){			// sono argomenti giusti?
					( name, value ) = ( arg ~= "/([^\s=]+)=([^\s]+)/");
					me.parser.set_conf(name ,value);
				}
				else if ( arg != "" ){
					println("Invalid argument " + arg );
					break;
					
				}
			}
		}
		me.parser.write_conf();
	}
}
/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Set();
