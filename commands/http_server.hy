class Http_server extends ICommand {
	private parser;
	
	public method Http_server(){
		me.ICommand("http_server");
		me.parser = new Parser("bh.conf");
	}

	public method help(){
		println( "* http_server\t\t\t\t\t\t\t\t\tstart http server" );
	}

	public method exec( args ){
		
		switch ( args ){
			
			case "start":
				http_class = new Http_class(me.parser.http_server_port, me.parser.http_server_path);
			break;
			
			case "stop":
				a="1";
			break;
			
			default:
			break;
		}
		
	}
}

class Http_class {
	public port;
	public path;
	
	public method Http_class(port, path){
	      ss = new ServerSocket( 8040, "me.acceptor_thread" );
	      ss.start();
	}
	
	private method acceptor_thread( s ){
		println( "New client thread started + " );
		line = "";
		page = "";
		while( line = s.readline() ){
			if( (matches = (line ~= "\s*GET ([^\s]+) HTTP + +")) ){
				page = matches[0];
			} else if( line == "\r\n" ){
				filename = path + page;
				println( "Sending " + filename );
				fp = fopen( filename, "rt" );
				if( fp ){
					s.write( "HTTP/1 + 1 200 OK\r\n" +
						 "Content-Length: " + fsize(filename) + "\r\n\r\n" );
       					byte = ' ';
					
					while( fread( fp, byte ) ){
						s.write( byte );
					}
       						fclose(fp);
				} else{
					s.write( "HTTP/1 + 1 404 Not Found\r\n" +
					"Content-Length: 3\r\n\r\nlol" );
				}
				pthread_exit();
			}
		}
		pthread_exit();
	}
}

/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Http_server();