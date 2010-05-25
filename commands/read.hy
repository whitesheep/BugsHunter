class Read extends ICommand {
	private parser;
	
	public method Read(){
		me.ICommand("read");
		me.parser = new Parser("bh.conf");
	}

	public method help(){
		println( "* read <variable>\t\t\t\t\t\t\t\tread variable from config file" );
	}

	public method exec( args ){
		if (args.split(" ")[0] == "help"){
			me.help();
			return true;
		} 
		
		println(me.parser.read_conf(args));
	}
}
/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Read();