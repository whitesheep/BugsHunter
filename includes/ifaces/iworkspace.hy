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

/*
 * 	Questa è l'interfaccia che ogni workspace dovrà editare.
 */

class IWorkspace {
	
	private commands;
	private files;
	public name;
	public description;
	public used;
	
	public method IWorkspace ( name, commands_path ) {
		me.used = false;
		me.name = name;
		me.commands = [:];
		me.files = readdir(commands_path, false);
	}
	
	public method using(){ }
	public method help(){ }
	public method exec( args ){ }	
}
