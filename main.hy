import  std.*;
include std.io.Directory;
include class/icommand;
include class/Parser;
include class/bh_command;
include std.io.network.tcp.Socket;
include std.os.Runner;


bh = new BH_commands();
bh.ascii_art();
bh.intro();


while (1){
		
	// 0;37 light grey


	( cmd, args ) = readline("\033[0;37mbugsH $> \033[0m") ~= "/^([^\s]+)\s*(.*)$/";
	
	output = bh.exec( cmd, args );
	
	println(output) unless !isstring(output);
	
}

