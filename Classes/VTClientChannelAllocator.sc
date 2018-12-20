VTClientChannelAllocator{
	var <channelNumbers;
	var allocations;
	var availableIndexes;

	*new{arg channelNumbers;
		^super.new.init(channelNumbers);
	}

	init{arg channelNumbers_;
		channelNumbers = channelNumbers_;
		allocations = IdentityDictionary.new;
		availableIndexes = SortedList.series(channelNumbers.size);
	}

	availableChannels{
		^channelNumbers.atAll(availableIndexes);
	}

	numAvailable{
		^availableIndexes.size;
	}

	allocate{arg key, numChannels;
		var indexes;
		var result;
		if(allocations.includesKey(key), {
			if(allocations[key].size == numChannels, {
				result = channelNumbers.atAll(allocations[key]);
				^result;
			}, {
				//the key is found but the numchannels is different
				this.free(key);
				result = this.allocate(key, numChannels);
				^result;
			});
		}, {
			indexes = numChannels.collect{
				var index;
				index = availableIndexes.first;
				availableIndexes.remove(index);
			};
			allocations.put(key, indexes.asArray);
			allocations.postln;
		});
		result = channelNumbers.atAll(indexes);
		^result;
	}

	allocations{
		var result = IdentityDictionary.new;
		allocations.keysValuesDo({arg key, val;
			result.put(key, channelNumbers.atAll(val));
		});
		^result;
	}

	at{arg key;
		^channelNumbers.atAll(allocations[key]);
	}

	free{arg key;
		var indexes;
		if(allocations.includesKey(key), {
			indexes = allocations.removeAt(key);
			availableIndexes = availableIndexes.addAll(indexes);
		});
		^channelNumbers.atAll(indexes);
	}
}