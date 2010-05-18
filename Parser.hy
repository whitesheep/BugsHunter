class Parser {
	private conf;
	private file_path;

	public method Parser(file_path){
		me.conf = [:];
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
			( name, value ) = (line ~= "/([^\s=]+)\s*=\s*([^\s*]+)/");
			me.conf[name] = value;
		}
	}
	
	public method _keys(){
		return me.conf.keys();
	}
	
	public method read_conf( name ){
		return me.conf[name];
	}
    
	public method write_conf(){
		data = "";
		fp = fopen( me.file_path, "w+b" );

		foreach( key -> value of me.conf){
			data += key + " = " + value + "\n";
		}

		fwrite(fp,data);
		fclose(fp);
	}
 
	public method __attribute( name ){
		return me.conf[name];
	}
    
	public method __attribute( name, value ){
		me.conf[name] = value;
	}
	
}
