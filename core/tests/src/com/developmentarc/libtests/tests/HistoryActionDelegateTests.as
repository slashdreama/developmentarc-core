/* ***** BEGIN MIT LICENSE BLOCK *****
 * 
 * Copyright (c) 2009 DevelopmentArc LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *
 * ***** END MIT LICENSE BLOCK ***** */
package com.developmentarc.libtests.tests
{
	import com.developmentarc.actions.actiontypes.AdditionAction;
	import com.developmentarc.actions.actiontypes.AutomateBasicAction;
	import com.developmentarc.actions.actiontypes.TestHistoryAction;
	import com.developmentarc.actions.commands.BasicCommand;
	import com.developmentarc.actions.commands.TestHistoryCommand;
	import com.developmentarc.actions.commands.TestNoHistoryCommand;
	import com.developmentarc.core.actions.HistoryActionDelegate;
	import com.developmentarc.core.actions.actions.IAction;
	import com.developmentarc.core.actions.commands.HistoryCommand;
	
	import flexunit.framework.TestCase;

	public class HistoryActionDelegateTests extends TestCase
	{
		private var _delegate:HistoryActionDelegate;
		public function HistoryActionDelegateTests(methodName:String=null)
		{
			super(methodName);
		}
		
		
		override public function setUp():void {
			_delegate = new HistoryActionDelegate(); 
		}
		
		override public function tearDown():void {
			
			for each (var action:IAction in _delegate.actions) {
				_delegate.removeAction(action);
			}
			
			_delegate.undoCommands = [];
		}
		/**
		 * Verifies that adding an Action to the delegate regiseters the
		 * action to the delegate and the action is called when the command
		 * is dispatched. 
		 * 
		 */
		public function testBasicActionRegisteration():void {
			
			// add an action and then call it
			var action:AutomateBasicAction = new AutomateBasicAction();
			action.addCommand(BasicCommand.MY_BASIC_COMMAND);
			_delegate.addAction(action);
			
			var command:BasicCommand = new BasicCommand(BasicCommand.MY_BASIC_COMMAND);
			command.passed = true;
			command.dispatch();
			
			// verify that the action has been update
			assertTrue("The Action was not called.", action.passed);
		}
		
		/**
		 * Verify that actions can be added and removed. 
		 * 
		 */
		public function testAddingRemovingActions():void {
			
			// add an action
			var action:AutomateBasicAction = new AutomateBasicAction();
			action.addCommand(BasicCommand.MY_BASIC_COMMAND);
			_delegate.addAction(action);
			
			// remove the action
			_delegate.removeAction(action);
			
			// call the command
			var command:BasicCommand = new BasicCommand(BasicCommand.MY_BASIC_COMMAND);
			command.passed = true;
			command.dispatch();
			
			// verify that the action has been update
			assertFalse("The Action should not have been called.", action.passed);
			
			// add the action back and dispatch
			_delegate.addAction(action);
			command.dispatch();
			
			// verify that the action has been update
			assertTrue("The Action was not called.", action.passed);
		}
		
		/**
		 * Verify that changing the commands for an action works correctly. 
		 * 
		 */
		public function testAddActionThenChangeCommand():void {
			
			// add an action
			var action:AutomateBasicAction = new AutomateBasicAction();
			action.addCommand(BasicCommand.MY_BASIC_COMMAND);
			_delegate.addAction(action);
			
			// change the commands
			action.removeAllCommands();
			action.addCommand(BasicCommand.A_SECOND_COMMAND);
			
			// call the command
			var command:BasicCommand = new BasicCommand(BasicCommand.MY_BASIC_COMMAND);
			command.passed = true;
			command.dispatch();
			
			// verify that the action has been update
			assertFalse("The Action should not have been called.", action.passed);
			
			// call the correct command
			command = new BasicCommand(BasicCommand.A_SECOND_COMMAND);
			command.passed = true;
			command.dispatch();
			
			// verify that the action has been update
			assertTrue("The Action was not called.", action.passed);
		}
		
		/**
		 * Verify that actions can be modified after being added. 
		 * 
		 */
		public function testAddCommandAfterActionAdded():void {
			
			// add an action
			var action:AutomateBasicAction = new AutomateBasicAction();
			_delegate.addAction(action);
			
			// add the commands
			action.addCommand(BasicCommand.A_SECOND_COMMAND);
			
			// call the command
			var command:BasicCommand = new BasicCommand(BasicCommand.MY_BASIC_COMMAND);
			command.passed = true;
			command.dispatch();
			
			// verify that the action has been update
			assertFalse("The Action should not have been called.", action.passed);
			
			// call the correct command
			command = new BasicCommand(BasicCommand.A_SECOND_COMMAND);
			command.passed = true;
			command.dispatch();
			
			// verify that the action has been update
			assertTrue("The Action was not called.", action.passed);
		}
		
		/**
		 * Test verifies two actions will fired when one command is dispatched
		 */
		public function testAddingTwoActionsOneCommandType():void {
			// add FIRST action
			var firstAction:AutomateBasicAction = new AutomateBasicAction();
			_delegate.addAction(firstAction);
			// add the commands
			firstAction.addCommand(BasicCommand.MY_BASIC_COMMAND);


			// add SECOND action
			var secondAction:AutomateBasicAction = new AutomateBasicAction();
			_delegate.addAction(secondAction);
			// add the commands
			secondAction.addCommand(BasicCommand.MY_BASIC_COMMAND);	
					
			// call the command
			var command:BasicCommand = new BasicCommand(BasicCommand.MY_BASIC_COMMAND);
			command.passed = true;
			command.dispatch();
			
			// verify that FIRST action has been updated
			assertTrue("The First Action was not called.", firstAction.passed);
			
			// verify that SECOND action has been updated
			assertTrue("The Second Action was not called.", secondAction.passed);
		}
		
		/**
		 * Test verifies two actions will fire but only from two different commands
		 */
		public function testAddingTwoActionsTwoDifferentCommandType():void {
			
			// add FIRST action
			var firstAction:AutomateBasicAction = new AutomateBasicAction();
			_delegate.addAction(firstAction);
			// add the commands
			firstAction.addCommand(BasicCommand.MY_BASIC_COMMAND);

			// add SECOND action
			var secondAction:AutomateBasicAction = new AutomateBasicAction();
			_delegate.addAction(secondAction);
			// add the commands
			secondAction.addCommand(BasicCommand.A_SECOND_COMMAND);	
					
			// call BASIC COMMAND (associated with first action)
			var firstCommand:BasicCommand = new BasicCommand(BasicCommand.MY_BASIC_COMMAND);
			firstCommand.passed = true;
			firstCommand.dispatch();
			
			// verify that FIRST action has been updated
			assertTrue("The First Action was not called.", firstAction.passed);
			// verify that SECOND action was not called
			assertFalse("The Second Action was called.", secondAction.passed);

			// reset firstAction
			firstAction.passed = false;
			
			// call SECOND COMMAND (associated with secton action)
			var secondCommand:BasicCommand = new BasicCommand(BasicCommand.A_SECOND_COMMAND);
			secondCommand.passed = true;
			secondCommand.dispatch();
			
			// verify that FIRST action has been updated
			assertFalse("The First Action was called.", firstAction.passed);
			// verify that SECOND action was called
			assertTrue("The Second Action was not called.", secondAction.passed);
		}
		
		
		/**
		 * Method verifies that when two actions are added to delegate and one is removed, only the
		 * one left added is called when a common command is dispatched.
		 */
		public function testTwoActionsRemoveOneWithOneCommandType():void {
			
			// add FIRST action
			var firstAction:AutomateBasicAction = new AutomateBasicAction();
			_delegate.addAction(firstAction);
			// add the commands
			firstAction.addCommand(BasicCommand.MY_BASIC_COMMAND);


			// add SECOND action
			var secondAction:AutomateBasicAction = new AutomateBasicAction();
			_delegate.addAction(secondAction);
			// add the commands
			secondAction.addCommand(BasicCommand.MY_BASIC_COMMAND);	
			
			//remove FIRST action
			_delegate.removeAction(firstAction);
			
			// call the command
			var command:BasicCommand = new BasicCommand(BasicCommand.MY_BASIC_COMMAND);
			command.passed = true;
			command.dispatch();
			
			// verify that FIRST action has NOT been updated
			assertFalse("The First Action was called.", firstAction.passed);
			
			// verify that SECOND action has been updated
			assertTrue("The Second Action was not called.", secondAction.passed);
		}

// TEST UNDO LOGIC
		
		/**
		 * Test one command can be undone against one action
		 */
		public function testBasicUndoWithOneAction():void {
		 	
		 	// create one action same command
		 	var action:AdditionAction = new AdditionAction();
		 	action.addCommand(TestHistoryCommand.TYPE_FIRST);
			_delegate.addAction(action);		 	
		 	
		 	
		 	// dispatch command 1
		 	// call the command
			var command:TestHistoryCommand = new TestHistoryCommand(TestHistoryCommand.TYPE_FIRST);
			command.dispatch();
			
		 	 // verify action
		 	 assertTrue("The action does not have a value equal to 1", action.value == 1);
		 	 
		 	 // dispatch undo
		 	 var undoCommand:HistoryCommand = new HistoryCommand(HistoryCommand.UNDO);
		 	 undoCommand.dispatch();
		 	 
		 	 // verify action
		 	 assertTrue("The action does not have a value equal to 0", action.value == 0);
		 	 
		}
		
		/**
		 * Method verifies when two commands have been dispatched, the both can be undone.
		 * This test is against one action
		 */
		 public function testTwoUndosWithOneAction():void {
		 	// create one action same command
		 	var action:AdditionAction = new AdditionAction();
		 	action.addCommand(TestHistoryCommand.TYPE_FIRST);
			_delegate.addAction(action);		 	
		 	
		 	
		 	// dispatch command 1
		 	// call the command
			var command:TestHistoryCommand = new TestHistoryCommand(TestHistoryCommand.TYPE_FIRST);
			command.dispatch();
			// dispatch command 2
			command.dispatch();
			
		 	 // verify action
		 	 assertTrue("The action does not have a value equal to 2", action.value == 2);
		 	 
		 	 // dispatch undo 1
		 	 var undoCommand:HistoryCommand = new HistoryCommand(HistoryCommand.UNDO);
		 	 undoCommand.dispatch();
		 	 // dispatch undo 2
		 	 undoCommand.dispatch();
		 	 
		 	 // verify action
		 	 assertTrue("The action does not have a value equal to 0", action.value == 0);
		 }
		 
		 /**
		 * Test one command can be undone against two actions per the one command
		 */
		public function testBasicUndoWithTwoAction():void {
			// create two actions same command
		 	var firstAction:AdditionAction = new AdditionAction();
		 	firstAction.addCommand(TestHistoryCommand.TYPE_FIRST);
			_delegate.addAction(firstAction);
			
			var secondAction:AdditionAction = new AdditionAction();
		 	secondAction.addCommand(TestHistoryCommand.TYPE_FIRST);
			_delegate.addAction(secondAction);
			
		 	// dispatch command 1
		 	// call the command
			var command:TestHistoryCommand = new TestHistoryCommand(TestHistoryCommand.TYPE_FIRST);
			command.dispatch();

		 	  // verify action First
		 	 assertTrue("The First Action does not have a value equal to 1", firstAction.value == 1);
		 	 // verify action Second
		 	assertTrue("The Second Action does not have a value equal to 1", secondAction.value == 1);
		 	 
		 	 // dispatch undo 1
		 	 var undoCommand:HistoryCommand = new HistoryCommand(HistoryCommand.UNDO);
		 	 undoCommand.dispatch();
		 	 
		 	  // verify action First
		 	 assertTrue("The First Action does not have a value equal to 0", firstAction.value == 0);
		 	 // verify action Second
		 	 assertTrue("The Second Action does not have a value equal to 0", secondAction.value == 0);
		 	 
		}
		
		/**
		 * Method verifies when two commands have been dispatched, the both can be undone against two actions
		 * per command.
		 */
		 public function testTwoUndosWithTwoAction():void {
		 	// create two actions same command
		 	var firstAction:AdditionAction = new AdditionAction();
		 	firstAction.addCommand(TestHistoryCommand.TYPE_FIRST);
			_delegate.addAction(firstAction);
			
			var secondAction:AdditionAction = new AdditionAction();
		 	secondAction.addCommand(TestHistoryCommand.TYPE_FIRST);
			_delegate.addAction(secondAction);
			
		 	// dispatch command 1
			var command:TestHistoryCommand = new TestHistoryCommand(TestHistoryCommand.TYPE_FIRST);
			command.dispatch();
			// dispatch command 2
			command.dispatch();
			
			// verify action First
		 	assertTrue("The First Action does not have a value equal to 2", firstAction.value == 2);
		 	// verify action Second
		 	assertTrue("The Second Action does not have a value equal to 2", secondAction.value == 2);
		 	
		 	// dispatch undo 1
		 	var undoCommand:HistoryCommand = new HistoryCommand(HistoryCommand.UNDO);
		 	undoCommand.dispatch();
		 	// dispatch undo 2
		 	undoCommand.dispatch();
		 	
			// verify action First
		 	assertTrue("The First Action does not have a value equal to 0", firstAction.value == 0);
		 	// verify action Second
		 	assertTrue("The Second Action does not have a value equal to 0", secondAction.value == 0);
		 	
		 }
		 
		 /**
		 * Method tests an undo, then a new command, then an undo
		 */
		 public function testUndoNewCommandUndoOneAction():void {
		 	// create one action same command
		 	var action:AdditionAction = new AdditionAction();
		 	action.addCommand(TestHistoryCommand.TYPE_FIRST);
			_delegate.addAction(action);
		 	
		 	// call the command
			var command:TestHistoryCommand = new TestHistoryCommand(TestHistoryCommand.TYPE_FIRST);
			command.dispatch();
		 	// verify
		 	assertTrue("The action does not have a value equal to 1", action.value == 1);
		 	
		 	// undo command
		 	var undoCommand:HistoryCommand = new HistoryCommand(HistoryCommand.UNDO);
		 	undoCommand.dispatch();
		 	// verify
		 	assertTrue("The action does not have a value equal to 0", action.value == 0);
		 	
		 	// new command and dispatch
		 	command.dispatch();
		 	// verify
		 	assertTrue("The action does not have a value equal to 1", action.value == 1);
		 	
		 	// new command and dispatch
		 	command.dispatch();
		 	// verify
		 	assertTrue("The action does not have a value equal to 2", action.value == 2);
		 	
		 	// undo command
		 	undoCommand.dispatch();
		 	// verify
		 	assertTrue("The action does not have a value equal to 1", action.value == 1);
		 	
		 	// undo command
		 	undoCommand.dispatch();
		 	// verify
		 	assertTrue("The action does not have a value equal to 0", action.value == 0);
		 }
		 
		 /**
		 * Method test the storage of states inside of AbstarctHistoryCommand
		 */ 
		 public function testHistoryCommandPropertyStates():void {
			
			// Check one value
			var firstAction:AdditionAction = new AdditionAction();
			
			var command:TestHistoryCommand = new TestHistoryCommand(TestHistoryCommand.TYPE_FIRST);
			
			command.setPropertyState(firstAction, "firstProp", 4);
			command.setPropertyState(firstAction, "secondProp", "firstAction");
			
			assertTrue("First prop value should be 4", command.getPropertyState(firstAction, "firstProp") == 4);
			assertTrue("Second prop value should be 'firstAction'", command.getPropertyState(firstAction, "secondProp") == "firstAction");
			
			// Check one value
			var secondAction:AdditionAction = new AdditionAction();
			
			command.setPropertyState(secondAction, "firstProp", 8);
			command.setPropertyState(secondAction, "secondProp", "secondAction");
			
			assertTrue("First Action First prop value should be 4", command.getPropertyState(firstAction, "firstProp") == 4);
			assertTrue("Second Action First prop  should be 8", command.getPropertyState(secondAction, "firstProp") == 8);
			
			assertTrue("First Action Second prop value should be 'firstAction'", command.getPropertyState(firstAction, "secondProp") == "firstAction");
			assertTrue("Second Action Second prop value should be 'secondAction'", command.getPropertyState(secondAction, "secondProp") == "secondAction");
		 }	
		 /**
		 * Method tests the storage of states with a real undo
		 */
		 public function testHistoryCommandPropertiesWithUndoCommand():void {
		 	// create action
		 	var action:TestHistoryAction = new TestHistoryAction();
		 	action.addCommand(TestHistoryCommand.TYPE_FIRST);
		 	
		 	// add action to delegate
		 	_delegate.addAction(action);
		 	
		 	// create command and dispatch
		 	var command:TestHistoryCommand = new TestHistoryCommand(TestHistoryCommand.TYPE_FIRST);
		 	command.dispatch();
		 	
		 	// test
		 	assertTrue("Action name should be APPLIED value", action.name == TestHistoryAction.APPLIED_NAME);
		 	assertTrue("Action age should be APPLIED value", action.age == TestHistoryAction.APPLIED_AGE);
		 	
		 	// undo command
		 	var undoCommand:HistoryCommand = new HistoryCommand(HistoryCommand.UNDO);
		 	undoCommand.dispatch();
		 	
		 	// test
		 	assertTrue("Action name should be DEFAULT value", action.name == TestHistoryAction.DEFAULT_NAME);
		 	assertTrue("Action age should be DEFAULT value", action.age == TestHistoryAction.DEFAULT_AGE);
		 	
		 }
// TEST REDO LOGIC
		
		/**
		 * Method tests a basic command execution, undo command, redo command, and undo command
		 * after each the value of the internal action is verified.
		 */
	 	public function testBasicUndoToRedoToUndo():void {
	 		// create one action same command
		 	var action:AdditionAction = new AdditionAction();
		 	action.addCommand(TestHistoryCommand.TYPE_FIRST);
			_delegate.addAction(action);		 	
		 	
		 	
		 	// dispatch command 1
		 	// call the command
			var command:TestHistoryCommand = new TestHistoryCommand(TestHistoryCommand.TYPE_FIRST);
			command.dispatch();
			
		 	 // verify action
		 	 assertTrue("The action does not have a value equal to 1", action.value == 1);
		 	 
		 	 // dispatch undo
		 	 var undoCommand:HistoryCommand = new HistoryCommand(HistoryCommand.UNDO);
		 	 undoCommand.dispatch();
		 	 
		 	 // verify action
		 	 assertTrue("The action does not have a value equal to 0", action.value == 0);
		 	 
		 	  // dispatch redo
		 	 var redoCommand:HistoryCommand = new HistoryCommand(HistoryCommand.REDO);
		 	 redoCommand.dispatch();
			 
			 // verify action
		 	 assertTrue("The action does not have a value equal to 1", action.value == 1);
		 	 
		 	 // dispatch undo
		 	 undoCommand.dispatch();
		 	 
		 	 // verify action
		 	 assertTrue("The action does not have a value equal to 0", action.value == 0);
			
	 	}
		/**
		 * Method verifies after a command has been undone, that the next command
		 * will clear the redo stack so a redo command has no effect.
		 */
		public function testCommand_Undo_Command_Redo():void {
			// create one action same command
		 	var action:AdditionAction = new AdditionAction();
		 	action.addCommand(TestHistoryCommand.TYPE_FIRST);
			_delegate.addAction(action);		 	
		 	
		 	
		 	// dispatch command 1
		 	// call the command
			var command:TestHistoryCommand = new TestHistoryCommand(TestHistoryCommand.TYPE_FIRST);
			command.dispatch();
			
		 	 // verify action
		 	 assertTrue("The action does not have a value equal to 1", action.value == 1);
		 	 
		 	 // dispatch undo
		 	 var undoCommand:HistoryCommand = new HistoryCommand(HistoryCommand.UNDO);
		 	 undoCommand.dispatch();
		 	 
		 	 // verify action
		 	 assertTrue("The action does not have a value equal to 0", action.value == 0);
		 	 
		 	  // dispatch command again
			 command.dispatch();
			 
			 // verify action
		 	 assertTrue("The action does not have a value equal to 1", action.value == 1);
		 	 
		 	// dispatch redo
		 	 var redoCommand:HistoryCommand = new HistoryCommand(HistoryCommand.REDO);
		 	 redoCommand.dispatch();
			 
			 // verify action
		 	 assertTrue("The action should still havea  value of 1", action.value == 1);
		}
		
		/**
		 * Method verifies two redos will work back to back.
		 */
		public function testTwoRedos():void {
			// create one action same command
		 	var action:AdditionAction = new AdditionAction();
		 	action.addCommand(TestHistoryCommand.TYPE_FIRST);
			_delegate.addAction(action);		 	
		 	
		 	
		 	// dispatch command
		 	// call the command
			var command:TestHistoryCommand = new TestHistoryCommand(TestHistoryCommand.TYPE_FIRST);
			command.dispatch();
			// call the command again
			command.dispatch();
			
			// verify action
		 	 assertTrue("The action does not have a value equal to 2", action.value == 2);
		 	 
		 	 // dispatch undo twice
		 	 var undoCommand:HistoryCommand = new HistoryCommand(HistoryCommand.UNDO);
		 	 undoCommand.dispatch();
		 	 undoCommand.dispatch();
		 	 
		 	 // verify action
		 	 assertTrue("The action does not have a value equal to 0", action.value == 0);
		 	 
		 	 // dispatch redo
		 	 var redoCommand:HistoryCommand = new HistoryCommand(HistoryCommand.REDO);
		 	 redoCommand.dispatch();
		 	 redoCommand.dispatch();
		 	 
		 	 // verify action
		 	 assertTrue("The action does not have a value equal to 2", action.value == 2);
		}
		/**
		 * Method verifies the third redo has no effect when only two commands are available in redo stack
		 */
		public function testThreeRedosOnlyTwoCount():void {
			// create one action same command
		 	var action:AdditionAction = new AdditionAction();
		 	action.addCommand(TestHistoryCommand.TYPE_FIRST);
			_delegate.addAction(action);		 	
		 	
		 	
		 	// dispatch command
		 	// call the command
			var command:TestHistoryCommand = new TestHistoryCommand(TestHistoryCommand.TYPE_FIRST);
			command.dispatch();
			// call the command again
			command.dispatch();
			
		 	 // dispatch undo twice
		 	 var undoCommand:HistoryCommand = new HistoryCommand(HistoryCommand.UNDO);
		 	 undoCommand.dispatch();
		 	 undoCommand.dispatch();
		 	 
		 	 // dispatch redo
		 	 var redoCommand:HistoryCommand = new HistoryCommand(HistoryCommand.REDO);
		 	 redoCommand.dispatch();
		 	 redoCommand.dispatch();
		 	 redoCommand.dispatch();
		 	 
		 	 // verify action
		 	 assertTrue("The action does not have a value equal to 2", action.value == 2);
		}
		
		/**
		 * Method verifies that commands that are marked to NOT use history do not get triggered by an undo.
		 */
		public function testNoHistoryCommand():void {
			// create one action same command
		 	var action:AdditionAction = new AdditionAction();
		 	action.addCommand(TestNoHistoryCommand.TYPE_NO_HISTORY);
			_delegate.addAction(action);		 	
			
			// dispatch command
			var command:TestNoHistoryCommand = new TestNoHistoryCommand(TestNoHistoryCommand.TYPE_NO_HISTORY);
			command.dispatch();
			
			 // verify action
		 	 assertTrue("The action does not have a value equal to 1", action.value == 1);
		 	 
		 	 // dispatch undo twice
		 	 var undoCommand:HistoryCommand = new HistoryCommand(HistoryCommand.UNDO);
		 	 undoCommand.dispatch();
		 	 
		 	// verify action
		 	 assertTrue("The action does not have a value equal to 1", action.value == 1);
		}
		
		public function testClearHistory():void {
			// create one action same command
		 	var action:AdditionAction = new AdditionAction();
		 	action.addCommand(TestHistoryCommand.TYPE_FIRST);
			_delegate.addAction(action);		 	
		 	
		 	
		 	// dispatch command
		 	// call the command
			var command:TestHistoryCommand = new TestHistoryCommand(TestHistoryCommand.TYPE_FIRST);
			command.dispatch();
			// call the command again
			command.dispatch();
			
			// verify action
		 	 assertTrue("The action does not have a value equal to 2", action.value == 2);
		 	 
		 	 
		 	 // clear delegate
		 	 _delegate.clearHistory();
		 	 
		 	 // dispatch undo twice
		 	 var undoCommand:HistoryCommand = new HistoryCommand(HistoryCommand.UNDO);
		 	 undoCommand.dispatch();
		 	 undoCommand.dispatch();
		 	 
		 	 // verify action
		 	 assertTrue("The action does not have a value equal to 2", action.value == 2);
		}
	}
}