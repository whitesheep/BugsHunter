class Read extends ICommand {
	private parser;
	
	public method Read(){
		me.ICommand("read");
	}

	public method help(){
		println( "* read <variable>\t\t\t\t\t\t\t\tread variable from config file" );
	}

	public method exec( args ){
		
		me.parser = new Parser("bh.conf"); 					// dichiaro qui per evitare di riaprire il file ad ogni modifica
		
		if (args.split(" ")[0] == "help"){
			me.help();
			return true;
		} 
		if ( args.split(" ")[0] == "*" ){
			foreach ( key of me.parser._keys() ){
				println(key + " = " +me.parser.read_conf(key));
			}
		} else {
			println(me.parser.read_conf(args));
		}
	}
}
/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Read();