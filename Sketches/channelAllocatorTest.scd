(
a = VTClientChannelAllocator.new(
	(1..32)
);
)
a.free('aaa');
a
a['aaa']
a['cccc']
a.allocate('aaa', 2);
a.allocate('aaa', 5);
a.allocate('cccc', 3);
a.allocate('cccc', 1);
a.free('cccc')

a.availableChannels
a.numAvailable;


a = SortedList.series(8);

i = a.remove(a.first);
a


~lydserver.clientChannelAllocators[\bbb].allocations





