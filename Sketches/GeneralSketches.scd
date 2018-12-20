a = VTLydserver.new; //uhef

b = VTLydserver()


VTLydserver.start;
VTLydserver.stop;

OSCFunc.trace
OSCFunc.trace(false)
NetAddr("127.0.0.1", 57120).sendMsg('/VTLydserver/running?', "127.0.0.1:57120");
NetAddr("127.0.0.1", 57120).sendMsg('/VTLydserver/running?', "127.0.0.1:57120");