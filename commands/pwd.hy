class Pwd extends ICommand {
	public method Pwd(){
		me.ICommand("pwd");
		println("loaded");
	}

	public method help(){
		println( "* pwd\t\t\t\t\t\t\t\t\t\tshow local folder" );
	}

	public method exec( args ){
		return `"pwd"`;
	}
}
/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Pwd();
