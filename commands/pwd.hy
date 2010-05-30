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

class Pwd extends ICommand {
	public method Pwd(){
		me.ICommand("pwd");
	}

	public method help(){
		println( "* pwd\t\t\t\t\t\t\t\t\t\tshow local folder" );
	}

	public method exec( args ){
		if (args.split(" ")[0] == "help"){
			me.help();
			return true;
		} 
		return `"pwd"`;
	}
}
/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Pwd();
