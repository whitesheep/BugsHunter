/*
 *
 *   Copyright 2010 Rondini Marco
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 *
 */

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
		println("* tree [ dir=<path> ] [ ftype=FileExtenction ] \t\t\t\t\tshow files in a tree");
	}

	public method exec( args ){
		
		if (args.split(" ")[0] == "help"){
			me.help();
			println("Default ftype is " + me.var_map["ftype"],
				"Default dir is " + me.var_map["dir"]);
			return true;
		} 
			
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
 
