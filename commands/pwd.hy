class Pwd extends ICommand {
	public method Pwd(){
		me.ICommand("pwd");
	}

	public method help(){
		println( "* pwd\t\t\t\t\t\t\t\t\t\tshow local folder" );
	}

	public method exec( args ){
		if (args.split(" ")[0] == "help"){
			me.help();
			return true;
		} 
		return `"pwd"`;
	}
}
/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Pwd();
