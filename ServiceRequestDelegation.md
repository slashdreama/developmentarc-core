# Introduction #

The Service Request Delegation (SRD) layer of DevelopmentArc<sup>TM</sup> Core provides a componentized architecture for solving your application’s data access needs.  The architecture breaks up your service layer into 4 distinct parts; Delegation, Requests, Dispatchers, and Parsers.   This model allows for a central theme of reuse throughout your application.
You will be able to combine Requests, Dispatchers, and Parsers in many different ways to solve various data communication and parsing needs that your application may encounter.   In one situation you may need to connect to a local database and retrieve and parse table data while other times the data store could be online via a Rest-ful API.  If in both cases your returning data is in a common format, the same parser could be reused to format your raw data into an application specific format.

**NOTE:** The 0.9 version of the provided HTTP Dispatcher is Flex only.  The SRD architecture is pure ActionScript 3.0, so that you can use the SRD in ActionScript only and Flash Professional projects but the following examples and default use cases of loading data via HTTP request require the Flex HTTPService.  We plan to build and release more dispatchers with subsequent releases.

## Why SRD? ##

The SRD architecture came about to solve a common problem Flex developers face when developing applications.  Flex provides a robust set of data services to manage accessing multiple data stores (Remote Object, HTTPService, etc.) yet the developer has to wrap these data services in a lot of custom code to handle data retrieval, error handling and data parsing.  As application become more complex, data retrieval also grows in complexity. How does the application handle data queueing or can the app handle it at all?  How does the service layer provide updates on the current state of the data retrieval?  How should the application handle data errors and inform the rest of the system?

At DevelopmentArc we continually had to solve these problems when building Flex Applications and over time we focused on creating a system that both provides abstraction to the process of loading data and unifies the process so that a clear and repeatable pattern for data loading can be applied.  The SRD is designed to provide a simple, yet robust way of managing data loading in your application.  It is also designed to be easily integrated into other elements of Core, such as the Task System so that data calls can be queued, prioritized and canceled when no longer required.  The SRD also provides a clear set of phases the request go through so that your application can provide user feedback and make adjustments as the data is being retrieved and processed. SRD is also designed so that it can be integrated into existing 3rd party solutions, such as Adobe Cairngorm or Mate.  Many of these frameworks are designed to support messaging throughout your application but do not solve data retrieval in a constant or complete way.

Another reason for SRD is creation of Mock data.  When developing applications we don't always have the benefit of live data for our data store.  To help support development the SRD provides a full Mock data system to allow developers to test their request and application with mock data and slowly integrate live data as it becomes available.  This is also a powerful system for QA testing to make sure the application handles bad data and states even though the live data is available.

# Component Definitions #

## Request ##

A Request object defines a particular instance for data retrieval from a data store or web service. A Request is responsible for defining all required arguments for retrieval such as the data's location (url/database), data path (uri/source/api/table), type of data (POST, AMF, etc.), and the SRD Dispatcher and SRD Parser that is used to carry out the request invocation.

## Delegation ##

The controller of the SRD is the RequestDelegate.  This singleton class is responsible for moving a particular Request through the various phases of the SRD's life cycle. The class will tie together the Request, it's Dispatcher and Parser and handle posting or retrieving data from the data store or service. _Note_: The application does not directly communicate with the RequestDelegate. Communication is encapsulated inside of Request (AbstractRequest) and invoked when the Request’s start() and stop() methods are called.

## Dispatcher ##

The Dispatcher component is responsible for the actual communication with the defined data store or service, which is defined by the Request.  Within SRD, the RequestDelegate will only keep one Dispatcher instance of a particular class type to manage memory and performance.  On subsequent Requests the Dispatcher instance is reused. When designing custom dispatchers, keep this in mind.


## Parser ##

A Parser is responsible for translating raw data from the data store or service into application formatted data, such as converting XML into an ActionScript Data Object.   The Parser does not store the data in the application, such as placing the data in a Model. This is the responsibility of the Request.  By requiring the Request to store the translated data, we can keep Parsers as generic utilities that can be reused by multiple Requests.


# LifeCycle #

SRD moves a particular Request through a series of phases that make up the life of that Request.  Below is a definition of each phase in order of it’s occurrence.  When the Request enters a new phase, a RequestEvent is dispatched from the Request with the type set to the phase.  This allows for application code to listen to various phase transitions and take the appropriate action.

## Created ##

When a Request is first instantiated it will initially enter the “Created” phase.  The Request dispatches the RequestEvent.CREATED event.


## Dispatched ##

Once a Request has started and been dispatched by it’s defined Dispatcher, the Request will enter the "Dispatched" phase.  This "Dispatched" phase indicates a particular request is being executed. The Request dispatches the RequestEvent.DISPATCHED event.


## Returned ##

The "Returned" phase indicates the Dispatcher has handled a successful response and the data is ready to be processed by the defined parser. The Request dispatches the RequestEvent.RETURNED event.

## Failure ##

If a Dispatcher encounters problems and/or faults, the Request will enter the "Failure" phase indicating there were issues with the dispatching of the Request.  At this point the Request will be halted and removed from the system. The Request dispatches the RequestEvent.FAILURE event which contains any error that the Dispatcher received or throws.

## Parsing ##

After data has returned, the RequestDelegate will pass the raw data off to the Request’s defined Parser.  At this point the Request enters the "Parsing" phase, indicating the Request’s returned data is being translated from a raw form into an application specific format. The Request dispatches the RequestEvent.PARSING event.


## Complete ##

Upon a successful parsing of the raw data and saving of the new data inside the application (via the Request.saveData() method), the Request will be marked as "Complete". This phase indicates the Request has completed its lifecycle inside of the application and has been removed from the RequestDelegate processing. The Request dispatches the RequestEvent.COMPLETE event.

## Error ##

If an error occurs during parsing of a result data, the Request will enter an "Error" phase and the Request's lifecycle will end. At this point the RequestDelegate removes the Request from it’s internals. The Request dispatches the RequestEvent.ERROR event.

## Cancel ##

If at any point during the lifecycle, a Request it stopped via Request.stop(), the Request will be marked as "Canceled" and the lifecycle will come to an end, removing it from the RequestDelegate. The Request dispatches the RequestEvent.CANCEL event.



# How-to #

In our basic how-to we will explore the creation of a Request that needs to communicate with a standard HTTP service with an XML response.  To accomplish this we will be responsible for creating a new Request (based on HTTPRequest) and Parser.  Out-of-box we can leverage the SRD HTTPRequestDispatcher, which encapsulates Flex’s HTTPService and provides us with all the means necessary to execute our request with reuse of a single Flex HTTPService instance.

## Create a Parser ##

The parser is responsible for taking our service's raw data and translating it into an application specific format such as a set of Data Objects (DOs).   All parsers must implement the IParser interface.  In our case we will extend the SRD AbstractParser (which implements IParser) so we can define a result format.  A result format is required when defining a Parser used by an HTTPService and will be leveraged by the Dispatcher.  The result format tells the Flex HTTPSerice how we want the data back, such as an ActionScript XML object, a String, a generic Object, an Array, etc.  For this reason it is recommended that all Parsers extend AbstractParser to gain this functionality. For our use case we will be receiving user data in XML and translating it into a single data object of type UserDO. First lets look at the XML returned by the server and the data object we want to convert it into.


### XML ###

```
<user>
	<id>4</id>
	<firstName>Aaron</firstName>
	<lastName>Pedersen</lastName>
	<address>123 Market St.</address>
	<city>San Francisco</city>
	<state>CA</state>
	<zipCode>94114</zipCode>
</user>

```

### UserDO.as ###


```
package com.developmentarc.dataobjects
{
	public class UserDO
	{
		public var id:uint;
		public var firstName:String;
		public var lastName:String;
		public var address:String;
		public var city:String;
		public var state:String;
		public var zipCode:String;
		
		public function UserDO()
		{
		}

	}
}

```

### The Parser ###

Our parser class must override and define one method called parse(). This method is the meat of the class and does all the translation. In our case, we will convert the generic object provided via the Interface definition into an XML instance (which our Dispatcher is returning) and then parse it into a UserDO.  Notice that we define the result format in the constructor of the Parser.  Because we extend the AbstractParser we can pass this value in.  Before our Dispatcher loads the data it check the !resultFormat property on the provide parser instance to determine how to format the data before sending it on.

### UserParser.as ###
```
package com.developmentarc.parsers
{
	import com.developmentarc.core.services.parsers.AbstractParser;
	import com.developmentarc.dataobjects.UserDO;

	public class UserParser extends AbstractParser
	{
		public function UserParser()
		{
			super(AbstractParser.RESULT_FORMAT_E4X);
		}
		
		override public function parse(data:*):* {
			// convert dynamc object into xml
			var xml:XML = data as XML;
			// create user object
			var user:UserDO = new UserDO;
			
			// parse and translate
			user.id = Number(xml.child("id").toString());
			user.firstName = xml.child("firstName").toString();
			user.lastName = xml.child("lastName").toString();
			user.address = xml.child("address").toString();
			user.city = xml.child("city").toString();
			user.state = xml.child("state").toString();
			user.zipCode = xml.child("zipCode").toString();
			
			return user;
		}
	}
} 

```

Notice each node of the xml is parsed (type converted if necessary) and then the new UserDO is returned. This is all the parser is responsible for. Saving the UserDO object to the application (most likely in a model) is the responsibility of the Request. This is to ensure the Parser is generic and only has logic regarding parsing, translating, and formatting.

## Request ##

Our Request will define a specific API for an HTTPService and will tie the required Dispatcher (HTTPServiceDispatcher), Parser (UserParser) to itself for processing.

To help provide a standard API, DevelopmentArc<sup>TM</sup> Core provides an HTTPRequest Class to assist in building all your HTTPService requests on top of. This class extends AbstractRequest and adds to the constructor arguments to include properties specific to an HTTPService.

For our use case, we will be requesting data from DevelopmentArc’s test service.   The full url will be 'http://test.developmentarc.com/users/1' (Note: The '1' is our user id and will be provided in the UserRequest constructor).

Our constructor will take one parameters for the user id and the method itself will pass all the static data used to request a user from the testing service up to the parent hierarchy.    That data includes:

**Type** - String used to define a specific type this request will be. Parameter allows for forking requests when data and service urls are similar but there is a need for some uniqueness. This is an advanced topic and is not used in our basic example.

**URI** - String for root address to use for this request. In our case http://test.developmentarc.com/.

**Source** - String for unique parts of the address that may be unique for a particular instance.  For our class ‘users/’ + userId (passed in constructor).

**Dispatcher Class** -  Class reference to the dispatcher used by this request. HTTPServiceDispatcher for our use case.

**Parser Class** - Class reference to the parser used to translate raw data from the result of this request in to application specific data.  UserParser for our use case.

**Mode** - String defining if Request is in Mock or Live mode.  See Mock section below for details.

**Mock Dispatcher Class** - Class reference to dispatcher that mocks data from a live API.  See Mock section below for details.

### UserRequest.as ###

```
package com.developmentarc.requests
{
	import com.developmentarc.core.services.dispatchers.HTTPRequestDispatcher;
	import com.developmentarc.core.services.requests.HTTPRequest;
	import com.developmentarc.dataobjects.UserDO;
	import com.developmentarc.parsers.UserParser;
	
	import mx.core.Application;

	public class UserRequest extends HTTPRequest
	{
		public function UserRequest(userId:uint)
		{
			super(
				'', // Type 
				'http://test.developmentarc.com/',  // URI
				'users/' + userId, // Source url (api + user id)
				HTTPRequestDispatcher, 	// Dispatcher
				UserParser // Parser
				);
		}
		
		override public function saveData(data:*):void {
			// save data to our application... it's our pretend model
			Application.application.user = data as UserDO;
		}
		
	}
}

```

In our class we define two methods The first is our constructor which passes up the hierarchical chain the static properties needed to construct and execute an HTTPService request to the User api at test.developmentarc.com.

It’s the responsibility of the Request class to store the formatted data that was parsed by the Dispatcher. This is the second method.  saveData() will save our new UserDO object to the Application to mimic a central location for our application data (our model).

It's worth noting here, that AbstractRequest provides a params property to supply parameters to the Request.  When HTTPServiceDispatcher creates the HTTPService and executes the request, parameters are converted into either url parameters for GET requests or for Post requests they are converted into POST Form parameters.  In our case, since we are connecting to a Rest-ful Rails API, parameters are not used and we pass the user id via the constructor.


## Application ##

Our main application file will construct and execute our UserRequest when a user clicks on a “Get User” button.

### main.mxml ###
```
<?xml version="1.0" encoding="utf-8"?>
<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute">
	
	<mx:Script>
		<![CDATA[
			import com.developmentarc.dataobjects.UserDO;
			import com.developmentarc.core.services.events.RequestEvent;
			import com.developmentarc.requests.UserRequest;
			import com.developmentarc.mocks.UserMock;
			
			
			[Bindable] public var welcome:String;
			[Bindable] public var address:String;
			[Bindable] public var city:String;
			[Bindable] public var state:String;
			[Bindable] public var zipCode:String;
			
			// stored by UserRequest
			public var user:UserDO;
			
			public function getUser():void {
				var userRequest:UserRequest = new UserRequest(1);
				
				// listen to complete event
				userRequest.addEventListener(RequestEvent.COMPLETE, handleUserRequestComplete);
				// listen to error event
				userRequest.addEventListener(RequestEvent.ERROR, handleUserRequestError);
				// start request
				userRequest.start();
			}
			
			protected function handleUserRequestComplete(event:RequestEvent):void {
				welcome_message.visible = true;
				welcome = "Welcome " + user.firstName + " " + user.lastName + ".  Your address is";
				address = user.address;
				city = user.city + ",";
				state = user.state + " ";
				zipCode = user.zipCode;
			}
			
			protected function handleUserRequestError(event:RequestEvent):void {
				welcome_message.visible = true;
				welcome = "An error has occured during your request!";
				address = "";
				city = "";
				state = "";
				zipCode = "";
			}
		]]>
	</mx:Script>
	
	<mx:VBox>
		<mx:VBox id="welcome_message" visible="false">
			<mx:Text text="{welcome}" />
			<mx:Text text="{address}" />
			<mx:HBox>
				<mx:Text text="{city}" /><mx:Text text="{state}" /><mx:Text text="{zipCode}" /> 
			</mx:HBox>
		</mx:VBox>
		<mx:Button label="Get User" click="getUser()"/>
	</mx:VBox>
</mx:Application>

```

Our application class will listen to the "Complete" and "Error" events on the UserRequest and respond accordingly.  When a "Complete" event is dispatched, the application will take the new UserDO object stored in the application and display it with a welcome message. An error will cause the application to display an error message.

Notice, once all setup, the application will only interact with the Request. The Dispatcher, Parsers, and the RequestDelegate are all utilized behind the scenes.  This provides us with a light interaction layer that keeps our server logic isolated.


## Mocks ##

In many cases server APIs are developed in parallel with the client application. In these cases it is necessary to create your client application’s service layer without a development or live data store APIs. To assist in this use case, SRD provides a mock system to allow developers to use a “test” Dispatcher to fake data.

The mock system allows Requests to designate a Mock Dispatcher. The goal of your mock dispatcher is to mimic your data request with static data.  This data can be a xml file on the server or the file system or could be hard coded inside of the Class itself.  Mock Dispatcher are also great for unit testing your Parser.  Below is a Mock Dispatcher that hard codes a the User XML that is returned from the live server.

### MockDispatcher.as ###
```
package com.developmentarc.mocks
{
	import com.developmentarc.core.services.mocks.AbstractMockDispatcher;
	import com.developmentarc.core.services.parsers.IParser;
	import com.developmentarc.core.services.requests.IRequest;

	public class UserMockDispatcher extends AbstractMockDispatcher
	{
		public function UserMockDispatcher()
		{
			super();
		}
		
	override public function dispatch(request:IRequest, parser:IParser):* {
			
			var response:XML =
			<user>
				<id>4</id>
				<firstName>Aaron</firstName>
				<lastName>Pedersen</lastName>
				<address>123 Market St.</address>
				<city>San Francisco</city>
				<state>CA</state>
				<zipCode>94114</zipCode>
			</user>;

			return super.dispatch(request, parser);
		}
		
	}
}
```

Developers can turn on and off the system via two levels. At an application level developers can set a static property on the RequestDelegate.  This would turn on the mock system application wide.  If a Request has also been switched to Mock, the system would leverage the Mock Dispatcher inside of that request.  This means you need switch both the RequestDelegate's and an individual Request's flag in order for the mock system to be leveraged. The goal of two switches is to allow Developers a way to turn on individual Requests as development is integrated.  Some could be live before others.  And when testing, it's nice to be able to activate mock mode on Requests, with a simple flip of a flag.

By default AbstractRequest assigns all Requests as Live and with no Dispatcher. It is up to the child class to define within its constructor when calling super().  Below is our adjustments to the UserRequest with a mock class and set to Mock mode.

### UserRequest.as ###
```
package com.developmentarc.requests
{
	import com.developmentarc.core.services.dispatchers.HTTPRequestDispatcher;
	import com.developmentarc.core.services.requests.AbstractRequest;
	import com.developmentarc.core.services.requests.HTTPRequest;
	import com.developmentarc.dataobjects.UserDO;
	import com.developmentarc.mocks.UserMock;
	import com.developmentarc.parsers.UserParser;
	
	import mx.core.Application;

	public class UserRequest extends HTTPRequest
	{
		public function UserRequest(userId:uint)
		{
			super(
				'', // Type 
				'http://test.developmentarc.com/',  // URI
				'users/' + userId, // Source url (api + user id)
				HTTPRequestDispatcher, 	// Dispatcher
				UserParser, // Parser
				AbstractRequest.MODE_MOCK, // Turning On Mock Mode
				UserMock // Mock Dispatcher
				);
		}
		
		override public function saveData(data:*):void {
			// save data to our application... it's our pretend model
			Application.application.user = data as UserDO;
		}
		
	}
}

```

Remember just because we made these adjustments doesn't mean mock mode is turned on.   We have to activate it at an application level by setting the RequestDelegate’s mock property inside of the application class. Below is an adjusted main.mxml to illustrate.

### main.mxml ###
```
<?xml version="1.0" encoding="utf-8"?>
<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute">
	
	<mx:Script>
		<![CDATA[
			import com.developmentarc.core.services.RequestDelegate;
			import com.developmentarc.dataobjects.UserDO;
			import com.developmentarc.core.services.events.RequestEvent;
			import com.developmentarc.requests.UserRequest;
			import com.developmentarc.mocks.UserMock;
			
			[Bindable] public var welcome:String;
			[Bindable] public var address:String;
			[Bindable] public var city:String;
			[Bindable] public var state:String;
			[Bindable] public var zipCode:String;
			
			// stored by UserRequest
			public var user:UserDO;
			
			public function getUser():void {
				
				// set request delegate to mock mode for application level
				RequestDelegate.mode = RequestDelegate.MODE_MOCK;
				
				var userRequest:UserRequest = new UserRequest(1);
				
				// listen to complete event
				userRequest.addEventListener(RequestEvent.COMPLETE, handleUserRequestComplete);
				// listen to error event
				userRequest.addEventListener(RequestEvent.ERROR, handleUserRequestError);
				// start request
				userRequest.start();
			}
			
			protected function handleUserRequestComplete(event:RequestEvent):void {
				welcome_message.visible = true;
				welcome = "Welcome " + user.firstName + " " + user.lastName + ".  Your address is";
				address = user.address;
				city = user.city + ",";
				state = user.state + " ";
				zipCode = user.zipCode;
			}
			
			protected function handleUserRequestError(event:RequestEvent):void {
				welcome_message.visible = true;
				welcome = "An error has occured during your request!";
				address = "";
				city = "";
				state = "";
				zipCode = "";
			}
		]]>
	</mx:Script>
	
	<mx:VBox>
		<mx:VBox id="welcome_message" visible="false">
			<mx:Text text="{welcome}" />
			<mx:Text text="{address}" />
			<mx:HBox>
				<mx:Text text="{city}" /><mx:Text text="{state}" /><mx:Text text="{zipCode}" /> 
			</mx:HBox>
		</mx:VBox>
		<mx:Button label="Get User" click="getUser()"/>
	</mx:VBox>
</mx:Application>

```

Mock modes can be used to help speed up development.  We encourage you to discuss and architect a data format with your server engineers up front and then implement via a mock system until the APIs are ready.


## Example Code ##

We have provided a Flex Project Archive [here](http://www.developmentarc.com/examples/Example-ServiceLayer/Example-ServiceLayer.zip) of the above example.  Download and explore the features.