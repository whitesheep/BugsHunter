class Search extends ICommand {
	private var_map;
	private parser;
	private vulns_search;
	private align_out;
	
	public method Search(){
		/*
		 *	Search vulns in souce code 
		 */
		me.vulns_search = [:];
		me.var_map = ["dir" : "./" , "ftype" : "php" , "exclude" : "nothing"];
		me.parser = new Parser("bh.conf");
		me.align_out = "   ";
		
		foreach( vulType of me.parser.read_conf("php").split(",") ){
			me.vulns_search[vulType] = me.parser.read_conf(vulType);
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
					if ( arg ~= "/^[dir|ftype|exclude][^\s=]+=[^\s]+/" ){			// sono argomenti giusti?
						( name_var, var ) = ( arg ~= "/([^\s=]+)=([^\s]+)/");
						me.var_map[name_var] = var;
					}
					else if ( arg != "" ){
						println("Invalid argument " + arg );
						break;
						
					}
				}
			}
			
			foreach ( name_var -> var of me.var_map ){				// per ogni variabile settata dall'utente, faccio un print 
				println(name_var + " = \"" + var + "\"");			// del suo contenuto
			}
			println("\nSearching Vulnz: ");
			println("   " + me.var_map["dir"]);
			me.rec_files(me.var_map["dir"], me.align_out);
			println("");
		}
	}
	
	
	private method rec_files(dir, align){         						 // metodo ricorsivo per la ricerca di tutti i file e il print in output a mo di albero
		foreach ( file of readdir(dir,false) ){
			if ( file["name"] != "." && file["name"] != ".." ){
				if ( file["type"] == 4 ){
					println(align + "|+ " + file["name"]);
					tmp_align = "   |" + align;  				// allineamento per l'albero
					me.rec_files(dir + "/" + file["name"], tmp_align);
				}
				else {
					
					type = ( file["name"] ~= "/\.([^\.]+)/" );   		// estenzione dei file.
					try { 
						if ( me.var_map["ftype"] == "*" ){
							println(align + "|- " + file["name"]);
							me.search_vulz(dir + "/" + file["name"], align);		// ricorsione su mestesso, con 
						}									// passaggio nome file e allineamento
						else if ( me.var_map["ftype"] == type[0] ){
							println(align + "|- " + file["name"]);
							me.search_vulz(dir + "/" + file["name"], align);
						}
					}
					catch (e){	next;	}  // se type[0] non è dichiarato.
				}
			}
		}
		println(align + "|-----");
	}

	
	
	private method search_vulz(file, align){        					// metodo di ricerca dei bug nei file.
		i = 1;
		data = file(file);
		
		
		
		foreach( line of data.split("\n") ){
			foreach ( vuls_type of me.vulns_search.keys() ){      //foreach per tutte le tipologie di vulnerabilità settate nel file di configurazuone.
				
				regex_search  = "/.*(" + me.vulns_search[vuls_type].split(",").join("|") + ").*/";			// regex per la ricerca di vulnz
				
				regex_show = "/(\s.*|.|)(" + me.vulns_search[vuls_type].split(",").join("|") + ")(.*\s|.*|.|)/i";			// regex per la visualizzazione della riga    "/(.*|)(SELECT|include)(.*\s)(\"|\'|)/"
				
				
				if ( line ~= regex_search ){
					println(align + "|   " + "|>>>> line: \x1b[0;34m" + i + "\x1b[0m, vuls type: \"\x1b[1;37m" + vuls_type + "\x1b[0m\", vuls : \"\x1b[1;31m ... " + ( line ~= regex_show ).join("") + " ... \x1b[0m\"");  
				}
				
			}
			
			i++; //riga + 1
		}
	}
}


/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Search();
