import  std.*;
include std.io.Directory;
include class/icommand;
include class/Parser;
include class/bh_command;


bh = new BH_commands();
bh.ascii_art();
bh.intro();


while (1){
		
	// 0;37 light grey

	print("\033[0;37mbugsH $> \033[0m");

	( cmd, args ) = readline() ~= "/^([^\s]+)\s*(.*)$/";
	
	output = bh.exec( cmd, args );
	
	println(output) unless !isstring(output);
	
}

