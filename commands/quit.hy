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

class Quit extends ICommand {
	public method Quit(){
		me.ICommand("quit");
	}

	public method help(){
		println( "* quit\t\t\t\t\t\t\t\t\t\tquit from BugsHunter" );
	}

	public method exec( args ){
		exit( println("\t\t\t\t\t\t\t\t\t\t\t\x1b[0;37m ,---@>  --| < mbe`!? > | ",
			      "\t\t\t\t\t\t\t\t\t\t\t  W-W'\x1b[0m") );
	}
}
/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Quit();
