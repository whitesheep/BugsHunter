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

class Main {
	private commands;
	private workspaces;
	private using;
	private files;
	private workspace_files;
	private hash_case;

	public method Main(){
		
		me.hash_case = ["help" : new MethodReference( me, "help"),
				"use"  : new MethodReference( me, "use")   ];	// popolamento della mappa "hash_case" per i comandi interni. ( come evitare i "case" )
		
		
		me.files = readdir("./commands", false);			// leggo tutti i file di una cartella, non ricorsivamente.
		me.workspace_files = readdir("./includes/wspaces", false);	// leggo tutti i file di una cartella, non ricorsivamente.
		me.commands = [:];
		me.workspaces = [:];
		me.using = "";
		
		/*
		 * 	Per ogni script che trovo nella dir, lo carico, prendo l'istanza
		 * 	della classe che crea quando viene caricato, e la inserisco nella 
		 * 	mappa dei comandi.
		 */
		 
		foreach( file of me.files ){						// scorro tutti i file, e importo i comandi "standard"
			if ( file["type"] != DT_DIR ){
				me.import("./commands/" + file["name"]);
			}
		}
		me.import_workspaces();					// richiamo il metodo "import_workspaces"
		
	}
	
	private method import(file){					// metodo per importare comandi esterni "standard"
		load(file);						// carico il file
		me.commands[__cmd_instance.name] = __cmd_instance;	// e inserisco all'interno di una mappa, la classe del comando selezionato.
	}
	
	private method import_workspaces(){				// metodo per importare i workspaces
		foreach( file of me.workspace_files ){			// per tutti i file all'interno della cartella "wpaces"
			if ( file["type"] != DT_DIR ){			// controllo se è un file
				load("./includes/wspaces/" + file["name"]);	// lo carico
				me.workspaces[__workspace_instance.name] = __workspace_instance;	// e inserisco all'interno di una mappa, la classe del workspace selezionato.
			}
		}
	}

	public method exec( cmd, args ){
		
		if ( me.hash_case.has(cmd) ){				// controllo se esiste un comando cmd interno all'interno di hash_case
			me.hash_case[cmd].call( [me, args] ); 		// se esiste avvio il metodo call della classe MethodReference
		} else {
			if ( me.commands.has(cmd) ){			// controllo se esiste un comando cmd esterno standard all'interno di commands
				return me.commands[cmd].exec(args);
			} else if ( me.using != "" ){ 
				me.workspaces[me.using].exec(cmd, args);	// controllo se esiste un comando cmd esterno del workspace selezionato all'interno di commands
			} else if ( me.using == "" ){
				println( cmd + " unknown command" );		// Comando non trovato
			}
		}
	}
	
	
	
	
	public method intro(){				// messaggio introduttivo 
		//0;34 blue
		println( "\x1b[0;34m\n\tBugs Hunter 0.2 Web Exploiting Framework",
			 "\n\thttp://ihteam.net\n\n\x1b[0m" );
	}
	
	
	public method ascii_art(){ 			// metodo che, all'avvio, printa in output, randomicamente, un asciiart.
		random = `"echo $(($RANDOM%4+1))"`.trim();	
		switch (random){			// purtroppo non posso fare a meno del case.
			case "1":
				println("\x1b[34m\n\t\t  __                                              ",
					"\t\t|/  |                /  |           /             ",
					"\t\t|___|      ___  ___ (___|      ___ (___  ___  ___ ",
					"\t\t|   )|   )|   )|___ |   )|   )|   )|    |___)|   )",
					"\t\t|__/ |__/ |__/  __/ |  / |__/ |  / |__  |__  |    ",
					"\t\t          __/                                     \x1b[0m");
			break;
			
			case "2":
				println("\x1b[34m\n\t\t.__          .  .       ,       ",
					"\t\t[__). . _  __|__|. .._ -+- _ ._.",
					"\t\t[__)(_|(_]_) |  |(_|[ ) | (/,[  ",
					"\t\t       ._|                      \x1b[0m");
			break;
			
			case "3":
				println("\x1b[34m\n\t\t ___              _  _          _           ",
					"\t\t| _ )_  _ __ _ __| || |_  _ _ _| |_ ___ _ _ ",
					"\t\t| _ \ || / _` (_-< __ | || | ' \  _/ -_) '_|",
					"\t\t|___/\_,_\__, /__/_||_|\_,_|_||_\__\___|_|  ",
					"\t\t         |___/                              \x1b[0m");
			break;
			
			case "4":
				println("\x1b[34m\n\t\t      < BuuuuuugsHunter! >",
					"\t\t  -------------------------- ",
					"\t\t         \   ^__^",
					"\t\t          \  (oo)\_______",
					"\t\t             (__)\       )\/",
					"\t\t                 ||----w |",
					"\t\t                 ||     ||\x1b[0m");
			break;
		}
	}
	
	
	/*
	*		Inizio metodi di sostituzione al "case" per MethodReference
	*/
	
	
	private method help( me ){
		
		println("All commands: ",
			"* help\t\t\t\t\t\t\t\t\t\tshow this message",
			"* use [workspace]\t\t\t\t\t\t\t\tselect workspace ( \"use\" to show all workspaces) ");
		
		foreach( name -> cmd of me.commands ){
			cmd.help();
		}
		
		if ( me.using != "" ){ 
			me.workspaces[me.using].help();
		}
		
	}
	
	private method use( me, args ){
		if ( me.workspaces.has(args.trim()) ){
			me.using = args.trim();
			println("Using \" " + args.trim() + " \" WorkSpace.");
			me.workspaces[me.using].using();
		} 
		else { 
			if ( args == "" ){
			
				foreach ( name -> ws of me.workspaces ){
					println("+ " + name + " " + ws.description);
				}
				
			} else {
				println( args.trim() + " workspace not found." ); 
			}
		}
	}
	
	
	
	/*
	*		Fine metodi ( MethodReference )
	*/
		
} 
