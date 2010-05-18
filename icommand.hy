/*
 * Questa è l'interfaccia dalla quale ogni comando dovrà
 * ereditare.
 */
class ICommand {
	public name;
	
	public method ICommand( name ){
		me.name = name;
	}

	public method help(){ }
	public method exec( args ){ }
}
