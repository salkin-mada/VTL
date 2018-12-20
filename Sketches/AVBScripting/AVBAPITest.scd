//get the uid
a = "curl 1.2.3.231/datastore/uid".unixCmdGetStdOut;
a = "curl CCC.local/datastore/uid".unixCmdGetStdOut;
a = "curl ccc.local/datastore/uid".unixCmdGetStdOut;
a = "curl XXX.local/datastore/uid".unixCmdGetStdOut;

//Get all the dev(ice) uid on the AVB network
a = "curl 1.2.3.217/datastore/avb/devs".unixCmdGetStdOut;
//Get them into an array separated
~devUIDs = "curl 1.2.3.217/datastore/avb/devs".unixCmdGetStdOut.parseYAML["value"].asString.split($:);

//Get all the entity names for AVB devices on the network.
//Make a Dictionary with all these stored on entity names as keys
(
var uids = "curl BBB.local/datastore/avb/devs".unixCmdGetStdOut.parseYAML["value"].asString.split($:);
var avbDevices = Dictionary.new;
f = fork{
	var reply;
	var name;
	uids.do{arg uid;
		reply = "curl 1.2.3.217/datastore/avb/%/entity_name".format(uid).unixCmdGetStdOut;
		name = reply.parseYAML["value"];
		avbDevices.put(name, Dictionary.new);
	};
	avbDevices.keys.do{arg devKey;
		[
			\hostname,
			\firmware_version,
			\vendor_name,
			'model_name',


		]

	};
	~avbDevices = avbDevices;
};

)


a = "curl 1.2.3.217/datastore/avb".unixCmdGetStdOut;
a = "curl 1.2.3.217/datastore/ext".unixCmdGetStdOut;


a = "curl AAA.local/datastore/ext".unixCmdGetStdOut;

a = "curl ZZZ.local/datastore".unixCmdGetStdOut;
(
f = fork{
	var reply;
	reply = "curl CCC.local/datastore".unixCmdGetStdOut;
	reply = reply.asString.parseYAML;
	reply = reply.changeScalarValuesToDataTypes;
	reply.keysValuesChange({arg key, val;
		var result;
		if(val.isKindOf(String) and: {"^(.+):(.+)$".matchRegexp(val) }, {

			result = val.split($:).collect(VTMJSON.parseYAMLValue(_));
			[key, val, val.class].postln;
		}, {
			result = val;
		});
		result;
	});
	reply = reply.asIdentityDictionaryWithSymbolKeys;
	~reply = reply;
	"DONE".postln;
}
)

//[ dac_mode, host, dac_mode_valid, smpte, host_type, locked, firmware_version, mix, ext, uid, update_channel, avb ]
~reply.dictionary.keys;

~reply.writeArchive("~/Desktop/CCCReply".standardizePath);




~reply.at('dac_mode');
~reply.atPath('avb', );

(
var searchPath;
// searchPath = "uid";
searchPath = "ext/ibank/3";
// searchPath = "host";
~reply.select({arg val, key;
	var found = false;

	if("^%+.*$".format(searchPath).matchRegexp(key.asString), {
		"% - %".format(key, val).postln;
		found = true;
	});
	found;
});
)

"ext/obank/3/ch/3/src".asCompileString[0]

"curl --data 'json={%:%}' BBB.local/datastore".format("ext/obank/3/ch/3/src".asCompileString, "4:%".format(rrand(10,20)).asCompileString).unixCmdGetStdOut;

(
//this is how you script routing
"curl --data 'json={%:%}' BBB.local/datastore".format("ext/obank/3/ch/3/src".asCompileString, "4:%".format(27).asCompileString).unixCmdGetStdOut;
)

"curl BBB.local/datastore/ext/obank/3/ch/3/src".unixCmdGetStdOut;

"^%.+$".format("hello").matchRegexp("hello/baby/love");



//set channel name
"curl --data 'json={\"ext/ibank/3/ch/7/name\":\"ADAT IN 8\"}' BBB.local/datastore".unixCmdGetStdOut


(
var searchValue;
// searchPath = "uid";
searchValue = "From BBB 12";
// searchPath = "host";
~reply.select({arg val, key;
	var found = false;

	if("%+.*".format(searchValue).matchRegexp(val.asString), {
		"% - %".format(key, val).postln;
		found = true;
	});
	found;
});
)
(
~routeChannel = {arg from, to;
	var avbSource, avbDestination;

};
)





///Pseudo code

//
(
var deviceNames = [
	'AAA', 'BBB', 'CCC', 'QQQ', 'HANS', 'XXX', 'YYY', 'ZZZ', 'VIDEO'
];
var reply;
var devices = IdentityDictionary.new;
var query = {arg hostname, path, optionString = "";
	"curl % %/datastore/%".format(optionString, hostname, path).unixCmdGetStdOut;
};

var queryDeviceData = {arg hostname, devName, devDict;
	//Get the UID
	reply = query.value(hostname, "uid");
	devDict.put('uid', reply);

	//Get the ext data
	reply = query.value(hostname, "ext");
	devDict.put('data', reply);

	reply = query.value(hostname, "avb");
	devDict.put('avb', reply);


	devDict;
};
//Find all AVB device IPs
~avbDiscovery !? {"Stopping".postln;~avbDiscovery.stop;};
~avbDiscovery = fork{
	var ip, hostname, devDict;

	//for every device
	deviceNames.do{arg devName;
		"Querying %".format(devName).postln;
		devDict = IdentityDictionary.new;
		reply = query.value("%.local".format(devName), "uid", "-m 1");
		if(reply.notEmpty, {
			//get the ip using dscacheutil
			ip = "dscacheutil -q host -a name %.local | grep ip_address | sed s/ip_address:\\ //".format(devName).unixCmdGetStdOut;

			if(ip.notEmpty, {
				ip = ip.drop(-1);//remove the new line char NL
				devDict.put(\ip, ip);
				hostname = ip;
			}, {
				"Did not find IP address for AVB Device: '%'".format(devName).warn;
			});

			devDict = queryDeviceData.value(hostname, devName, devDict);


		}, {
			"AVB Device '%' not found!".format(devName).warn;
		});


		devices.put(devName, devDict);
	};
	////get the name and ip
	~avbDevices = devices;
	"AVB discovery done".postln;
	~avbDevices.postln;
};
)

~avbDevices['CCC']['data']

~avbDevices['XXX']['uid']


"dscacheutil -q host -a name %.local | grep ip_address: | sed s/ip_address:\ //".format("CCC").unixCmdGetStdOut;

a ="dscacheutil -q host -a name %.local | grep ip_address | sed s/ip_address:\\ //".format("CCC").unixCmdGetStdOut
a.drop(-1).size

a.isEmpty


~xxxDict = ~avbDevices['XXX'][\avb][\data].parseYAML;
~xxxDict["wordClockMode"]
~xxxDict.keys.select({arg item; "[cC]lock".matchRegexp(item)});

NetAddr(~avbDevices['BBB']['ip'], 9998).sendMsg('/ext/wordClockMode', false);

NetAddr(~avbDevices['BBB']['ip'], 9998).sendMsg('/ext/ibank/0/ch/0/48V', false);
NetAddr(~avbDevices['BBB']['ip'], 9998).sendMsg('/ext/ibank/0/ch/0/48V', true);
"ibank/3/name":"ADAT"
NetAddr(~avbDevices['CCC']['ip'], 9998).sendMsg('/ext/ibank/3/name', "Bnga");
NetAddr(~avbDevices['CCC']['ip'], 9998).sendMsg('/ext/ibank/3/name')

NetAddr(~avbDevices['CCC']['ip'], 9998).sendMsg('/ext/obank/3/name')
NetAddr(~avbDevices['CCC']['ip'], 9998).sendMsg('/ext/obank/3/ch/0/src', "4:25")

NetAddr(~avbDevices['CCC']['ip'], 9998).sendMsg('/ext/obank/3/ch/0/name', "Bingoboy")


OSCFunc.trace

a = "curl 1.2.3.231/datastore/ext/ibank/3".unixCmdGetStdOut;
a = "curl 1.2.3.231/datastore/ext/obank/3/ch/1".unixCmdGetStdOut;
a = "curl 1.2.3.231/datastore/ext/obank/4/ch/1".unixCmdGetStdOut;

(
~setAVB = {arg hostname, path, key, value;
"curl --data 'json={%:%}' %/datastore/%".format(
		key.asCompileString,
		value.asCompileString,
		hostname,
		path
	).unixCmdGetStdOut;
};
)

~setAVB.("CCC.local", "ext/ibank/3/ch/0", "name", "Bangoo");

~setAVB.("CCC.local", "ext/obank/4/ch/1", "name", "Guran");
~setAVB.("CCC.local", "ext/obank/4/ch/1", "name", "Booming");

~setAVB.("CCC.local", "ext/obank/4/ch/0", "src", "3:3");





(
var bankNumber = 3;
8.do{arg channelIndex;
	var num = channelIndex + 1;
	var channelName = "MONITOR.%".format(num);
	var hostname = "1.2.3.231";
	var io = "ibank";
	var queryString = "curl --data 'json={\"name\":%}' %/datastore/ext/%/%/ch/%";
	queryString = queryString.format(
		channelName.asCompileString,
		hostname,
		io,
		bankNumber,
		channelIndex;
	);
	queryString.unixCmdGetStdOut;
};
)

"curl --data 'json={\"name\":\"heisann\"}' 1.2.3.231/datastore/ext/ibank/3/ch/0".unixCmdGetStdOut;




(

)




a = "curl 1.2.3.231/datastore/ext".unixCmdGetStdOut;
a = "curl 1.2.3.231/datastore/uid".unixCmdGetStdOut;
a = "curl 1.2.3.231/datastore/avb/0001f2fffe002339".unixCmdGetStdOut;

a = "curl 1.2.3.231/datastore/mix".unixCmdGetStdOut;