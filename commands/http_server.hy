class Http_server extends ICommand {
	private parser;
	private http_class;
	private sd;
	
	public method Http_server(){
		me.ICommand("http_server");
		me.parser = new Parser("bh.conf");
		me.http_class = new Http_class(me.parser.http_server_port, me.parser.http_server_path);
	}

	public method help(){
		println( "* http_server [start|stop|status]\t\t\t\t\t\tstart http server" );
	}

	public method exec( args ){
		
		switch ( args ){
			
			case "start":
				println("Http server start");
				runner = new Runner( new Http_class() );
				me.sd = server( 8040);
				if( me.sd <= 0 ){
					return false;
				}

				while( (csd = accept(me.sd)) > 0 ){
					runner.go( new Socket(csd) );
				}
				runner.join();
				return true;
			break;
			
			case "stop":
				println("Http server start");
				
			break;
			
			case "status":
				a=1;
			break;
			
			default:
				println("Invalid argument " + args);
			break;
		}
		
	}
}

class Http_class extends Runnable{
	public port;
	public path;
	public response;
	
	private method run( s ){
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
				break;
			}
		}
		break;
	}
	
	
}

/*
 * Creo l'istanza da far caricare al gestore principale.
 */
__cmd_instance = new Http_server();


/*
private method http_response( s ){
		
	}
	*/




/*

include std.os.Runner;

class Prova extends Runnable { 
	public method run( n ){
		println( "Hello " + n );
	}
}

try{
	runner = new Runner( new Prova() );

	foreach( i of 1..100 ){
		runner.go( i );	
	}

	runner.join();
	
	println(runner);
}
catch( e ){
	println(e);
}

// http://github.com/evilsocket/hybris/blob/master/stdinc/std/io/network/tcp/ServerSocket.hy
*/