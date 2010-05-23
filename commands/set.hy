class Set extends ICommand {
	public method Set(){
		me.ICommand("set");
	}

	public method help(){
		println( "* set name=value\t\t\t\t\t\t\t\tset variables in config files" );
	}

	public method exec( args ){
		parser = new Parser("bh.conf");
		if (args.split(" ")[0] == "help"){
			me.help();
		} 
		else {	
			if ( args != "" ) {
				foreach ( arg of args.split(" ") ){
					if ( arg ~= "/[^\s=]+=[^\s]+/" ){			// sono argomenti giusti?
						( name, value ) = ( arg ~= "/([^\s=]+)=([^\s]+)/");
						parser.set_conf(name ,value);
					}
					else if ( arg != "" ){
						println("Invalid argument " + arg );
						break;
						
					}
				}
			}
			parser.write_conf();
		}
	}
}
/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Set();
