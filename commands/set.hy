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

class Set extends ICommand {
	private parser;
	
	public method Set(){
		me.ICommand("set");
	}

	public method help(){
		println( "* set name=value\t\t\t\t\t\t\t\tset variables in config files" );
	}

	public method exec( args ){
		
		me.parser = new Parser("bh.conf"); 					// dichiaro qui per evitare di riaprire il file ad ogni modifica
		
		if (args.split(" ")[0] == "help"){
			me.help();
			return true;
		} 
		
		if ( args != "" ) {
			foreach ( arg of args.split(" ") ){
				if ( arg ~= "/[^\s=]+=[^\s]+/" ){			// sono argomenti giusti?
					( name, value ) = ( arg ~= "/([^\s=]+)=([^\s]+)/");
					me.parser.set_conf(name ,value);
				}
				else if ( arg != "" ){
					println("Invalid argument " + arg );
					break;
					
				}
			}
		}
		me.parser.write_conf();
	}
}
/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Set();
