class Set extends ICommand {
	private parser;
	
	public method Set(){
		me.ICommand("set");
		me.parser = new Parser("bh.conf");
	}

	public method help(){
		println( "* set name=value\t\t\t\t\t\t\t\tset variables in config files" );
	}

	public method exec( args ){
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
