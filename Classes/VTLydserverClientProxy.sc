VTLydserverClientProxy{
	var <isRunning = false;
	var <name;
	var addr;

	lydserver{ ^VTLydserver.singleton; }

	*new{arg name, addr;
		^super.new.init(name, addr);
	}

	init{arg name_, addr_;
		name = name_;
		addr = addr_;
	}

	sendMsg{arg path ...args;
		addr.sendMsg(path, *args);
	}

}