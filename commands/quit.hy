class Quit extends ICommand {
	public method Quit(){
		me.ICommand("quit");
	}

	public method help(){
		println( "quit" );
	}

	public method exec( args ){
		exit( println(" Bye :) ") );
	}
}
/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Quit();
