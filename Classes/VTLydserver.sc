VTLydserver{
	classvar <singleton;
	classvar <isRunning = false;
	var responders;
	var clients;

	*initClass{
		StartUp.add({ //StartUp.defer?
			OSCFunc({arg msg, time, addr, port;
				var theQuerier;
				theQuerier = NetAddr.newFromIPString(msg[1].asString);
				if(theQuerier.isKindOf(NetAddr), {
					theQuerier.sendMsg('/VTLydserver/running', isRunning);
				}, {
					"Got running? query without"
				});
			}, '/VTLydserver/running?');
		});
		//instanciate the singleton
		this.new;
	}

	*new{
		if(singleton.isNil, {
			singleton = super.new;
		});
		^singleton;
	}

	*start{
		if(isRunning.not, {
			singleton.makeResponders;
			isRunning = true;
			"VTLydserver started".postln;
			Window("VTLydserver").layout_(VLayout(
				VTLydserverView.new
			)).front;
		}, {
			"VTLydserver already running".warn;
		});
	}

	*stop{
		if(isRunning, {
			isRunning = false;
			"VTLydserver stopped".postln;
		}, {
			"VTLydserver not running".postln;
		});
	}

	restart{
		"VTLydserver restarting".postln;
	}

	makeResponders{
		if(responders.isNil, {
			responders = IdentityDictionary.new;
		}, {
			this.freeResponders;///fefuhefiuh
		});
		responders.put('/cue/json', OSCFunc({arg msg, time, addr, port;
			var jsonCue = msg[1].asString.parseYAML;
			jsonCue = jsonCue.changeScalarValuesToDataTypes.asIdentityDictionaryWithSymbolKeys;
			"Got /cue/json:".postln;
			jsonCue.postln;
		}, '/cue/json'));

		responders.put('/registerClient', OSCFunc({arg msg, time, addr, port;
			var jsonCue = msg[1].asString.parseYAML;
			jsonCue = jsonCue.changeScalarValuesToDataTypes.asIdentityDictionaryWithSymbolKeys;
			"Got clientRegister:".postln;
			jsonCue.postln;
		}, '/VTLydserver/registerClient'));

		responders.put('/unregisterClient', OSCFunc({arg msg, time, addr, port;
			var jsonCue = msg[1].asString.parseYAML;
			jsonCue = jsonCue.changeScalarValuesToDataTypes.asIdentityDictionaryWithSymbolKeys;
			"Got clientUnregister:".postln;
			jsonCue.postln;
		}, '/VTLydserver/unregisterClient'));
	}

	freeResponders{
		responders.do({arg it; it.free; it.remove; it.clear; });
		responders.clear;
	}
}