class Sh extends ICommand {
	public method Sh(){
		me.ICommand("sh");
	}

	public method help(){
		println( "* sh \"command\"\t\t\t\t\t\t\t\t\texec command" );
	}

	public method exec( args ){
		return `args`;
	}
}
/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Sh();
