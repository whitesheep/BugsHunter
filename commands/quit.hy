class Quit extends ICommand {
	public method Quit(){
		me.ICommand("quit");
	}

	public method help(){
		println( "* quit\t\t\t\t\t\t\t\t\t\tquit from BugsHunter" );
	}

	public method exec( args ){
		exit( println(" Bye :) ") );
	}
}
/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Quit();
