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

class Search extends ICommand {
	private var_map;
	private parser;
	private vulns_search;
	private align_out;
	private vulns_vars;
	
	public method Search(){
		/*
		 *	Search vulns in souce code 
		 */
		me.vulns_search = [:];
		
		me.var_map = ["dir" : "./" , "ftype" : "php" , "level" : "all"];	// variabili di default
		
		me.align_out = "   ";			// allineamento per visualizzazione
		
		me.set_var();
		
		me.ICommand("search");
	}
	
	
	private method set_var(){							// metodo per il settaggio delle variabili globali definite per il search.
		
		me.parser = new Parser("bh.conf");
		
		foreach( vulType of me.parser.read_conf("php").split(",") ){		// prendo tutte le tipologie di vulnerabilità per ogni linguaggio
			me.vulns_search[vulType] = me.parser.read_conf(vulType);	// dal file di configurazione
		}
		
		me.vulns_vars = me.parser.read_conf("php_vars");
	}
	

	public method help(){
		println("* search [ dir=<path> ] [ ftype=FileExtenction ] [ level=all|critical ]\t\tsearch pattern in all founded file");
	}

	public method exec( args ){
		
		me.set_var();									// setto gli argomenti di default.
		
		if (args.split(" ")[0] == "help"){
			me.help();
			println("Default ftype is " + me.var_map["ftype"],			// printo in output tutti gli argomenti di default.
				"Default level is " + me.var_map["level"], 
				"Default dir is " + me.var_map["dir"]);
			return true;
		} 
			
		if ( args != "" ) {
			foreach ( arg of args.split(" ") ){
				if ( arg ~= "/^[dir|ftype|level][^\s=]+=[^\s]+/" ){			// sono argomenti giusti?
					( name_var, var ) = ( arg ~= "/([^\s=]+)=([^\s]+)/");
					me.var_map[name_var] = var;
				}
				else if ( arg != "" ){					// argomento del comando search inesistente.
					println("Invalid argument " + arg );
					return false;
					
				}
			}
		}
		
		
		try {							// controllo se esiste la directory
			readdir( me.var_map["dir"] , false );		
		}
		catch (e){
			println(e);
			me.var_map["dir"] = "./";
			return false;					// se non esiste, printo l'errore, setto la directory di default e return false.
		}
		
		
		if ( me.var_map["level"] ~= "/^(all|critical)\b/" ) {
			;
		} else {
			println("Invalid level " + me.var_map["level"] );		// livello non trovato, setto livello all.
			me.var_map["level"] = "all";
			return false;
		}
		
		foreach ( name_var -> var of me.var_map ){				// per ogni variabile settata dall'utente, faccio un print 
			println(name_var + " = \"" + var + "\"");			// del suo contenuto
		}
		println("\nSearching Vulnz: ");
		println("   " + me.var_map["dir"]);
		me.rec_files(me.var_map["dir"], me.align_out);
		println("");
	}
	
	
	private method rec_files(dir, align){					 // metodo ricorsivo per la ricerca di tutti i file e il print in output a mo di albero
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

	
	
	private method search_vulz(file, align){   			// metodo di ricerca dei bug nei file.
		i = 1;
		data = file(file);
		
		foreach( line of data.split("\n") ){
			foreach ( vuls_type of me.vulns_search.keys() ){      //foreach per tutte le tipologie di vulnerabilità settate nel file di configurazuone.
				
				vars = me.vulns_vars.replace(",", "|").replace("$", "\$");		// preparo le "vulns_var" per inserirle nella regex		
				
				regex_search_critical = "/.*(" + me.vulns_search[vuls_type].replace(",", "|") + ")\b.*(" + vars + ")/i";			// regex per la ricerca di vulnz tipo critiche ( trova anche quelle inserite nel file di configurazuone )
				
				regex_search_medium = "/.*(" + me.vulns_search[vuls_type].replace(",", "|") + ")\b.*\$/i";				// regex per la ricerca di vulnz tipo medie ( controlla se ci sono inserimento variabili )
				
				regex_show = "/(.?.?.?.?.?.?.?)(\s?)(" + me.vulns_search[vuls_type].replace(",", "|") + ")(\s?)(.?.?.?.?.?.?.?)/i";	// regex per la visualizzazione della riga  
				
				
											
					
				if ( me.var_map["level"] == "all" ){		// controllo livello di ricerca: all -> tutti i livelli.
					
					if ( line ~= regex_search_critical ){		// regex search critical
						
						me.print_out( align, i, vuls_type, "\033[4;31mcritical\033[0m", ( line ~= regex_show ).join("").trim() );  
						
					} else if ( line ~= regex_search_medium ){	// regex search medium
					
						me.print_out( align, i, vuls_type, "\033[4;32mmedium\033[0m", ( line ~= regex_show ).join("").trim() );  
					} 
					
				} else if ( me.var_map["level"] == "critical" ){  // controllo livello di ricerca: critical -> solo critici.
					
					if ( line ~= regex_search_critical ){
						
						me.print_out( align, i, vuls_type, "\033[4;31mcritical\033[0m", ( line ~= regex_show ).join("").trim() );  
					}
				}
			}
			
			i++; //riga + 1
		}
	}
	
	
	private method print_out( align, n_line, vuls_type, level, line ){		// metodo per visualizzazione della possibile vunerabilità trovata
		
		println(align + "|   |>>>> line: \033[4;34m" + n_line + "\033[0m, vuls type: \"\033[4;37m" + vuls_type + "\033[0m\", level: \"" + level + "\", vuls : \"\033[1;31m ... " + line + " ... \033[0m\"");
		
	}
}


/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Search();
