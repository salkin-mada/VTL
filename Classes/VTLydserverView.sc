VTLydserverView : View{
	classvar singleton;
	var lydserver;

	var headerView;
	var clientListView;
	var modulesView;

	*new{
		if(singleton.isNil, {
			singleton = super.new.initVTLydserverView;
		});
		^singleton;
	}

	initVTLydserverView{
		lydserver = VTLydserver();
		headerView = this.makeHeaderView;
		clientListView = this.makeClientListView;
		modulesView = this.makeModulesView;
	}

	makeHeaderView{

	}

	makeClientListView{

	}

	makeModulesView{

	}

}