class Parser {
	private conf;
	private conf_new;
	private file_path;

	public method Parser(file_path){
		try{
			me.conf = [:];
			me.conf_new = [:];
			me.file_path = file_path;
			data = file(file_path);
			foreach( line of data.split("\n") ){
				line = line.trim();
				
				/*
				* 	Salta righe vuote o commentate
				*/
				
				if( line ~= "/^[\s]*$/" || line ~= "/^#.*$/" ){
					next;
				}
				( name, value ) = (line ~= "/([^\s=]+)\s*=\s*([^\s]+)/");
				me.conf[name] = value;
			}
		}
		catch ( e ) {
			println("Cannot open file.");
		}
	}
    
	public method write_conf(){
		data_tow = "";
		
		data = file(me.file_path);
		
		var_map = [:];
		
		foreach( line of data.split("\n") ){
			line = line.trim();
			
				/*
				* 	Salta righe vuote o commentate
				*/
				
			if( line ~= "/^[\s]*$/" || line ~= "/^#.*$/" ){
				data_tow += line + "\n";
				next;
			}
			
			(name, value) = ( line ~= "/([^\s=]+)\s*=\s*([^\s]+)/" );
			if ( value != me.conf[name]) {
				data_tow += name + " = " + me.conf[name] + "\n";
			} else {
				data_tow += line + "\n";
			}
			
		}
		
		if ( me.conf_new ){
			data_tow += "## Configuration Added by BugsHunter.\n"
			foreach ( key -> value of me.conf_new ){
				data_tow += key + " = " + value + "\n";
			}
		}
		
		fp = fopen( me.file_path, "w+b" );
		
		if ( fp ){
			
			fwrite(fp, data_tow);
			fclose(fp);
			
		} else { println("Cannot open config file. "); }
	}
	
	public method _keys(){
		return me.conf.keys();
	}
	
	public method read_conf( name ){
		return me.conf[name];
	}
	
	public method __attribute( name ){
		return me.conf[name];
	}
    
	public method __attribute( name, value ){
		me.conf[name] = value;
		println(name + me.conf[name]);
	}
	
	public method set_conf( name, value ){
		if ( me.conf.has(name) ) {
			me.conf[name] = value;
			return true;
		} else { 
			me.conf_new[name] = value;
			return false; 
		}
	}
	
}
