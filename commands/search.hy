class Search extends ICommand {
	private var_map;
	private parser;
	private vulns;
	private align_out;
	
	public method Search(){
		/*
		 *	Search vulns in souce code 
		 */
		me.vulns = [:];
		me.var_map = ["dir" : "./" , "ftype" : "*" , "exclude" : "nothing"];
		me.parser = new Parser("bh.conf");
		me.align_out = "   ";
		
		foreach( vulType of me.parser.read_conf("php").split(",") ){
			me.vulns[vulType] = me.parser.read_conf(vulType);
		}
		
		me.ICommand("search");
	}

	public method help(){
		println("* search dir=\"path\" [ ftype=FileExtenction ] [ exclude=PatternToExclude ]\tsearch pattern in all founded file");
	}

	public method exec( args ){
		
		if (args.split(" ")[0] == "help"){
			me.help();
			println("Default ftype is " + me.var_map["ftype"],
				"Default exclude is " + me.var_map["exclude"], 
				"Default dir is " + me.var_map["dir"]);
		} 
		else {	
			if ( args != "" ) {
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
			}
			
			foreach ( name_var -> var of me.var_map ){
				println(name_var + " = \"" + var + "\"");
			}
			println("\nSearching Vulnz: ");
			println("   " + me.var_map["dir"]);
			me.rec_files(me.var_map["dir"], me.align_out);
		}
	}
	private method rec_files(dir, align){
		foreach ( file of readdir(dir,false) ){
			if ( file["name"] != "." && file["name"] != ".." ){
				if ( file["type"] == 4 ){
					println(align + "|+ " + file["name"]);
					tmp_align = "   |" + align; 
					me.rec_files(dir + "/" + file["name"], tmp_align);
				}
				else {
					
					type = ( file["name"] ~= "/\.([^\.]+)/" );   // estenzione dei file.
					
					if ( me.var_map["ftype"] == "*" ){
						println(align + "|- " + file["name"]);
					}
					else if ( me.var_map["ftype"] == type[0] ){
						println(align + "|- " + file["name"]);
					}
				}
			}
		}
		println(align + "|-----");
	}
}


/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Search();
