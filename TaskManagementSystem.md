# Introduction #

Task System is a priority queuing system that enables an application to execute specific bundles of business and/or server logic in a specific order based on priority and overrides.   These bundles are encapsulated inside of Tasks, which can be bundled inside of a specific data structure called TaskGroups.  Tasks and task groups have the ability to take priority over other tasks or task groups inside of the queue, as well as replace existing tasks in the queue based on a set of overrides an individual task can define.


## TaskController ##

The TaskController class is the main manager of the task system framework. This class is responsible for managing current and new tasks in a task system. The class is used as an instance to allow for multiple task to run in the same application.

The TaskController, by default, is not a singleton and the goal of the framework is to allow multiple Task systems to be running in any given application. For example, one task system can be created to manage server requests while another can be used to control internal business operations. To create multiple systems, simply create multiple instances of the TaskController.

To use the TaskController as a singleton, utilize the SingletonFactory utility class within DevelopmentArc<sup>TM</sup> Core.

The controller starts a set of tasks based on the active task limit set on the controller. By default 2 tasks can be concurrently active within the controller, however this is configurable in the task controller instance.  When a task is complete the controller will remove the task from the active list and start the next one in the queue, if any.

The TaskController is also responsible for managing overrides.  When a task is added to the controller, the tasks overrides are applied removing any existing tasks from the queue that matches an override. Overrides do pertain to tasks that are currently active, those will be canceled and removed from the queue. Next the task is added to the internal priority queue in the proper order.

## Task ##

To create a task one can extend from the AbstractTask, which is the base class that defines basic types, events, and common methods implementations of the required ITask interface. The TaskController does not require a Task to extend from AbstractTask, instead only the ITask interface is required.

## TaskGroup ##

The TaskGroup is a data structure that allows a set of tasks to be grouped together as a collection. The TaskGroup can then be added to the TaskController and all of the grouped task will be executed first before the next task in the controller queue is processed.

When an override is provided to the TaskController, the TaskGroup acts as a parent type and the TaskGroup will remove all tasks if the provided override matches the group type. The individual type of the task is ignored in this case. However, Tasks added to the group can override the same way as if they were added directly to the TaskController. Upon adding a task, the TaskGroup will evaluate the tasks overrides and the tasks selfOverrding value. After this evaluation the TaskGroup will take appropriate action depending on the different settings. The functionality is similar to the TaskController's override mechanism.  Please note, TaskGroups can not contain other TaskGroups.


# How To #

## Create a Task ##
As mentioned above under the introduction a task is a bundle of business logic that a developer wishes to run in a queue. One of the best examples of a task implementation is wrapping a server call to be executed in a particular order under the control of a thread count.  In systems that execute large number of service calls a Task system can provide the detailed control to stop, override, and swap order of the queue adding valuable efficiency throughout the system.  Below we will create two tasks that execute service calls to two factitious api on DevelopmentArc's domain. The first will pull details of a company and the second will pull a list of users from the same company id.  Neither task is dependent on the other, however they are related in that the same company id is used by both.

There are a couple things to point out with our classes below, in most cases the API the AbstractTask defines can be removed from the constructor signature of your class and define those properties inside of your class. In our case below, we define the task type and task priority inside of the custom class and pass those constants into the super constructor. The rest of the API is left to the defaults defined by AbstractTask. To see a detailed description of each property, see the ASDoc on the AbstractTask class itself.

Second, note that all business logic is defined inside of the start method. This method is what the task controller calls when a task is executed.

```

/**
 * Company details task
 **/
public class CompanyDetailsTask extends AbstractTask {
	public static const TASK_TYPE:String = "COMPANY_DETAILS";
	public static const TASK_PRIORITY:int = 1;
	
	private var _httpService:HTTPService;

	public var companyId:uint;
	
	public function CompanyDetailsTask(id:uint){
		// Set company id
		companyId = id;
		
		// Call AbstractTask constructor passing in type and priority 
		super(TASK_TYPE, TASK_PRIORITY);
	}
		
	// Method invoked when task system executes task 
	override public function start():void {
		_httpService = new HTTPService();
			
		_httpService.url = 'http://www.developmentarc.com/company/details.xml';
		
		_httpService.send({companyId:companyId});

                // AbstractTask will send event
                super.start()
	}
        // Method invoked when task system cancels task that has been started
        override public function cancel():void {
		_httpService.cancel();
		super.cancel();
	}
}
/**
 * Company users task
 **/
public class CompanyUsersTask extends AbstractTask {
	public static const TASK_TYPE:String = "COMPANY_USERS";
	public static const TASK_PRIORITY:int = 2;
	
	private var _httpService:HTTPService;

	public var companyId:uint;
		
	public function CompanyUsersTask(id:uint) {
		// Set company id
		companyId = id;
		
		// Call AbstractTask constructor passing in type and priority 
		super(TASK_TYPE, TASK_PRIORITY);
	}
		
	// Method invoked when task system executes task 
	override public function start():void {
		_httpService = new HTTPService();
			
		_httpService.url = 'http://www.developmentarc.com/company/users.xml';
			
		_httpService.send({companyId:companyId});

                // AbstractTask will send event
                super.start()
	}

        // Method invoked when task system cancels task that has been started
        override public function cancel():void {
		_httpService.cancel();
		super.cancel();
	}
}		
```

## Add Task to TaskController ##
In most systems you will add tasks at a middle-tier layer of your application code such as Cairngorm's command framework.   This allows for all business logic or in our case construction of business logic to occur in one level of your application. DevelopmentArc has a similar layer in it's framework which we call the Action/Command System.  In a given action, an `applyAction` method is called when a command is dispatched in the system.  For more information about the [Action/Command pattern](CommandActionDelegation.md).  In our example below we will illustrate a simple `applyAction` method that creates our two tasks, based on the company id supplied by the action event and then add both tasks to the task controller. In our example, we have one task controller in the application which we manage via the SingletonFactory.

```
public function applyAction(event:CompanyCommand):void {
	var companyId:uint = event.companyId;
		
	// Create tasks
	var taskCompanyDetails:ITask = new CompanyDetailsTask(companyId);
	var taskCompanyUsers:ITask = new CompanyUsersTask(companyId);
	 
	// Retrieve application task controller (we only have one in this example)
	var taskController:TaskController = SingletonFactory.getSingletonInstance(TaskController);
			
	// Add tasks (If no tasks are in queue, tasks are executed the moment they are added to the queue)
	taskController.addTask(taskCompanyDetails);
	taskController.addTask(taskCompanyUsers);
}

```

## Using a TaskGroup ##
In the above example we add two tasks to the controller independently of each other.  In some case we want to group items together to insure each task is run in a particular order related to it's group of tasks. To accomplish this we can add our task to a group and then add that group to the task controller. This will insure no task that enters the system can cut in front of an individual task of the group as the group is executed.  The task group itself can define a priority, that way when added to the system it can cut in front of less important tasks of other groups. Priority goes both ways, if a task group has not started executing a task with higher priority can jump in front of the entire group.  If the group has started, a task or task group with high priority will wait behind the task group until all it's tasks have completed.

Notice, below we create the task group and define the type and priority. A task group is handled as a task inside of the task controller, so the same properties apply as that of a task.  Also note, we define the task group dynamically for simplicity sake. If you see the need, extend the TaskGroup class and add the type and priority similar to how we defined our tasks above.

```
public function applyAction(event:ActionEvent):void {
	var companyId:uint = event.companyId;
	
	// Create task group
	var taskGroup:TaskGroup = new TaskGroup("COMPANY_GROUP", 2);
	
       // Create tasks
	var taskCompanyDetails:ITask = new CompanyDetailsTask(companyId);
	var taskCompanyUsers:ITask = new CompanyUsersTask(companyId);
			 
	// Retrieve application task controller (we only have one in this example)
	var taskController:TaskController = SingletonFactory.getSingletonInstance(TaskController);
			
	// Add tasks to group
        taskGroup.addTask(taskCompanyDetails);
	taskGroup.addTask(taskCompanyUsers);

	// Add task group
	taskController.addTask(taskGroup);	
}
```

## Applying Overrides ##
One of the most important features one gains by using the Task System is the ability to override other tasks (business logic).  This becomes very useful when user actions drive the execution of these tasks. If a user is "click happy" and clicks on multiple items on a UI, each of which execute a set of business tasks, the system can get overloaded and slow down or pummel the server with unneccessary calls.  The task system helps allievate such use cases by providing the ability for tasks to define a set of overrides. These overrides are Task types. When a task or task group is added to a task system, the overrides types are processed and all tasks that match are removed from the task system.  Tasks or groups that are currently active are stopped and then removed.

In our example below, we will define one new task that defines our previous tasks are overrides. AbstractTask defines a protected property currentOverrides which you can set during construction.  Upon added an instance of the task to the controller, the other tasks are removed.

```

/**
 * User details task
 **/
public class UserDetailsTask extends AbstractTask {
	public static const TASK_TYPE:String = "USER_DETAILS";
	public static const TASK_PRIORITY:int = 1;
	
	private var _httpService:HTTPService;

	public var userId:uint;
	
	public function UserDetailsTask(id:uint){
               
               // Task overrides both CompanyDetailsTask and CompanyUserTask
               currentOverrides = [CompanyDetailsTask.TASK_TYPE, CompanyUsersTask.TASK_TYPE]

		// Set user id
		userId = id;
		
		// Call AbstractTask constructor passing in type and priority 
		super(TASK_TYPE, TASK_PRIORITY);
	}
		
	// Method invoked when task system executes task 
	override public function start():void {
		_httpService = new HTTPService();
			
		_httpService.url = 'http://www.developmentarc.com/user/details.xml';
		
		_httpService.send({userId:userId});
	}
}

```

In our revised applyAction method, we will add our old tasks as we did before and then add our new task right after. This will result in our first two tasks being canceled and then removed from the task controller. Note we are using individual task and not the task group as we did in the last section (although you can override a task group too).

```
public function applyAction(event:CompanyCommand):void {
	var companyId:uint = event.companyId;
	var userId:uint = event.userId;
	
	// Create tasks
	var taskCompanyDetails:ITask = new CompanyDetailsTask(companyId);
	var taskCompanyUsers:ITask = new CompanyUsersTask(companyId);

        // Override task
        var taskUserDetails:ITask = new UserDetailsTask(userId);
	 
	// Retrieve application task controller (we only have one in this example)
	var taskController:TaskController = SingletonFactory.getSingletonInstance(TaskController);
			
	// Add tasks (If no tasks are in queue, tasks are executed the moment they are added to the queue)
	taskController.addTask(taskCompanyDetails);
	taskController.addTask(taskCompanyUsers);

       // Add overriding task
       taskController.addTask(taskUserDetails);

      // Verify only one task is in task system
      Alert.show(taskController.
}

```
## Task Events ##
All tasks that extend from AbstractTask or a TaskGroup dispatch a series of TaskEvents based on their current state in the task systems. Below is a  bullet point list of each of those task and when they are dispatched.  As well the current state is stored in a public property currentPhase.

  * TASK\_WAITING\_FOR\_READY - Dispatched when a task is waiting for its ready state to change to true.
  * TASK\_READY - Dispatched when a task enters its ready state.
  * TASK\_QUEUED - Dispatched when a task is in either in the TaskController Queue or a TaskGroup queue.
  * TASK\_START - Dispatched when a task has been started.
  * TASK\_PAUSED - Dispatched when a task has been paused.
  * TASK\_CANCEL - Dispatched when a task has been cancelled.
  * TASK\_IGNORE - Dispatched when a task is set to ignore.
  * TASK\_COMPLETE - Dispatched when a task has been completed.
  * TASK\_ERROR - Dispatched when a task has entered an error state.