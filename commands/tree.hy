class Tree extends ICommand {
	private var_map;
	private tree_search;
	private align_out;
	
	public method Tree(){
		/*
		 *	Show File in Treeeee 
		 */
		me.tree_search = [:];
		me.var_map = ["dir" : "./" , "ftype" : "php" ];
		me.align_out = "   ";
		
		me.ICommand("tree");
	}

	public method help(){
		println("* search dir=\"path\" [ ftype=FileExtenction ] \t\t\t\t\tshow files in a tree");
	}

	public method exec( args ){
		
		if (args.split(" ")[0] == "help"){
			me.help();
			println("Default ftype is " + me.var_map["ftype"],
				"Default dir is " + me.var_map["dir"]);
		} 
		else {	
			if ( args != "" ) {
				foreach ( arg of args.split(" ") ){
					if ( arg ~= "/[dir|ftype][^\s=]+=[^\s]+/" ){			// sono argomenti giusti?
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
			println("\nFiles: ");
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
							
						}									
						else if ( me.var_map["ftype"] == type[0] ){
							println(align + "|- " + file["name"]);
							
						}
					}
					catch (e){	next;	}  // se type[0] non è dichiarato.
				}
			}
		}
		println(align + "|-----");
	}
}


/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Tree();
 
