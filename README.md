### Instalation
	npm install i-status-linux

How to use?

### You can send an json object to the generate method, containing:
	require("i-status-linux").read(function(err,succ){
		// Do your magic here!
	});

### For debuggin, please use the {silent: false} attribute:
	require("i-status-linux").read({
		silent: false
	}, function(err,succ){
		// Do your magic here!
	});

### Credits
* [Neto Trevisan] - Backend/Frontend Web Developer

[Neto Trevisan]:http://netrevisanto.com
