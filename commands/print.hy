class Print_ extends ICommand {
	public method Print_(){
		me.ICommand("print");
	}

	public method help(){
		println( "ls - bla bla bla." );
	}

	public method exec( args ){
		foreach ( arg of args.split(" ") ){
			( name_var, var ) = ( arg ~= "/([^\s=]+)=([^\s]+)/");
			println(var);
		}
	}
}
/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Print_();
