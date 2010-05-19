class Search extends ICommand {
	private var_map;
	private parser;
	private vulns;
	
	public method Search(){
		/*
		 *	Search vulns in souce code 
		 */
		me.vulns = [:];
		me.var_map = ["dir" : "./" , "ftype" : ".*" , "exclude" : "nothing"];
		me.parser = new Parser("bh.conf");
		
		foreach( vulType of me.parser.read_conf("php").split(",") ){
			me.vulns[vulType] = me.parser.read_conf(vulType);
		}
		
		me.ICommand("search");
	}

	public method help(){
		println("* search dir=\"path\" [ ftype=FileExtenction ] [ exclude=PatternToExclude ]\tsearch pattern in all founded file");
	}

	public method exec( args ){
		
		if ( args.split(" ")[0] == "help" ){
			me.help();
			println("Default ftype is " + me.var_map["ftype"],
				"Default exclude is " + me.var_map["exclude"], 
				"Default dir is " + me.var_map["dir"]);
		} 
		else {		
			foreach ( arg of args.split(" ") ){
				if ( arg ~= "/[dir|ftype|exclude][^\s=]+=[^\s]+/" ){
					( name_var, var ) = ( arg ~= "/([^\s=]+)=([^\s]+)/");
					me.var_map[name_var] = var;
				}
				else {
					println("Invalid argument " + arg );
					break;
				}
			}
			
			foreach ( name_var -> var of me.var_map ){
				println(name_var + " = \"" + var + "\"");
			}
		}
		
		search_ = new Search_(me.var_map["dir"]);
		search_.all_file();
	}
}

/*
 *	Classe per la ricerca dei file 
 */

class Search_ extends Directory {
	private dir;
	private files;
	
	public method Search_ ( dir ) {
		me.dir = dir;
		me.Directory(me.dir);
		files = [:];
	}
	
	public method all_file() {
		foreach ( file of me ) {
			old_folder = "";
			foreach ( path of file.split("/") ) {
				old_folder = me.file_mapper(old_folder , path);
			}
		}
		
	}
	
	private method file_mapper( old_folder , file ){
		me.files[old_folder] = file;
		return me.files;
	}
	
}


/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Search();
