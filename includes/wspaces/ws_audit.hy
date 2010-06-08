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

class WS_audit extends IWorkspace{					// WorkSpace per auditing
									// Per usarlo "use auditing"

	private hash_case;
	
	public method WS_audit(){
		
		
		me.hash_case = [ "import_command" 	: new MethodReference( me, "import_command") 		];
		
		
		me.IWorkspace("audit", "./commands/audit");
		me.description = "\t\t\t\tWorkspace for auditing of source code."
		
		/*
		 * 	Per ogni script che trovo nella dir, lo carico, prendo l'istanza
		 * 	della classe che crea quando viene caricato, e la inserisco nella 
		 * 	mappa dei comandi.
		 */
		 
		foreach( file of me.files ){
			if ( file["type"] != DT_DIR ){
				me.import_command("./commands/audit/" + file["name"]);
			}
		}
	}
	
	public method import_command(file){
		load(file);
		me.commands[__cmd_instance.name] = __cmd_instance;
	}
	
	public method help(){
		println("\t\t\t --------- Auditing Tool -----------",
			"* import_command <file>\t\t\t\t\t\t\t\timport external plugin");
		foreach( name -> cmd of me.commands ){
			cmd.help();
		}
	}
	
	
	public method exec( cmd, args ){
		
		if( me.commands.has(cmd) ){
			return me.commands[cmd].exec(args);
		} else {
			if ( me.hash_case.has(cmd) ){
				me.hash_case[cmd].call( [ me, args ] );
			} else {
				println( cmd + " unknown command" );
			}
		}
	}
	
	/*
	*		Inizio metodi MethodReference di sostituzione al case
	*/
	
	public method import_command(me, file){
		load(file);
		me.commands[__cmd_instance.name] = __cmd_instance;
	}
	
	/*
	*		Fine metodi ( Method Reference )
	*/
	
}

/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__workspace_instance = new WS_audit();
