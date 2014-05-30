CBSDS
=====

Cloud Based Scent Distribution System

Prerequisites
---

*	[Node JS](http://nodejs.org)
*	An iDevice which supports [Scentee](http://www.scentee.com)
*	An iOS developer program subscription


To Install
---

1. Download/Clone the repository
2. open terminal, cd to the location of the downloaded repository and into the Sever directory
3. run

		npm install
		node app
		
4. leaving that running, open finder, navigate to the iOS app directory, open CBSDS.xcodeproj 
5. open the ViewController.m file, go to line 29 which should read 

		[socketIO connectToHost:@"cloudbasedscentdistributionsystem.com" onPort:80];

6. change the domain and port number to your domain and port number
7. run it on your device (it won't work in the simulator)