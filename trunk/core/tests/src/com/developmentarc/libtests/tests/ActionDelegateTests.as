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
	import com.developmentarc.actions.actiontypes.AutomateBasicAction;
	import com.developmentarc.actions.commands.BasicCommand;
	import com.developmentarc.framework.controllers.ActionDelegate;
	
	import flexunit.framework.TestCase;

	public class ActionDelegateTests extends TestCase
	{
		public function ActionDelegateTests(methodName:String=null)
		{
			super(methodName);
		}
		
		/**
		 * Tests adding and removing of command types from the AbstractAction.
		 * 
		 */
		public function testAddingRemovingCommands():void {
			var action:AutomateBasicAction = new AutomateBasicAction();
			
			// add command types
			action.addCommand(BasicCommand.MY_BASIC_COMMAND);
			action.addCommand(BasicCommand.A_SECOND_COMMAND);
			action.addCommand(BasicCommand.A_THIRD_COMMAND);
			
			// verify the commands are in the right order
			assertTrue("The command length was incorret when all the commands where added.", action.commands.length == 3);
			assertTrue("The first command was not BasicCommand.MY_BASIC_COMMAND.", action.commands[0] == BasicCommand.MY_BASIC_COMMAND);
			assertTrue("The second command was not BasicCommand.A_SECOND_COMMAND.", action.commands[1] == BasicCommand.A_SECOND_COMMAND);
			assertTrue("The thrid command was not BasicCommand.A_THIRD_COMMAND.", action.commands[2] == BasicCommand.A_THIRD_COMMAND);
			
			// remove the first command
			action.removeCommand(BasicCommand.MY_BASIC_COMMAND);
			assertTrue("The command length was incorret when the first command was removed.", action.commands.length == 2);
			assertTrue("The first command was not BasicCommand.A_SECOND_COMMAND.", action.commands[0] == BasicCommand.A_SECOND_COMMAND);
			assertTrue("The second command was not BasicCommand.A_THIRD_COMMAND.", action.commands[1] == BasicCommand.A_THIRD_COMMAND);
			
			// add the first command back it should be the last
			action.addCommand(BasicCommand.MY_BASIC_COMMAND);
			assertTrue("The command length was incorret when all the commands where added.", action.commands.length == 3);
			assertTrue("The first command was not BasicCommand.A_SECOND_COMMAND.", action.commands[0] == BasicCommand.A_SECOND_COMMAND);
			assertTrue("The second command was not BasicCommand.A_THIRD_COMMAND.", action.commands[1] == BasicCommand.A_THIRD_COMMAND);
			assertTrue("The thrid command was not BasicCommand.MY_BASIC_COMMAND.", action.commands[2] == BasicCommand.MY_BASIC_COMMAND);
			
			// remove them all
			action.removeAllCommands();
			assertTrue("The command length was incorret when all the commands where added.", action.commands.length == 0);
		}
		
		/**
		 * Verifies that adding an Action to the delegate regiseters the
		 * action to the delegate and the action is called when the command
		 * is dispatched. 
		 * 
		 */
		public function testBasicActionRegisteration():void {
			var delegate:ActionDelegate = new ActionDelegate();
			
			// add an action and then call it
			var action:AutomateBasicAction = new AutomateBasicAction();
			action.addCommand(BasicCommand.MY_BASIC_COMMAND);
			delegate.addAction(action);
			
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
			var delegate:ActionDelegate = new ActionDelegate();
			
			// add an action
			var action:AutomateBasicAction = new AutomateBasicAction();
			action.addCommand(BasicCommand.MY_BASIC_COMMAND);
			delegate.addAction(action);
			
			// remove the action
			delegate.removeAction(action);
			
			// call the command
			var command:BasicCommand = new BasicCommand(BasicCommand.MY_BASIC_COMMAND);
			command.passed = true;
			command.dispatch();
			
			// verify that the action has been update
			assertFalse("The Action should not have been called.", action.passed);
			
			// add the action back and dispatch
			delegate.addAction(action);
			command.dispatch();
			
			// verify that the action has been update
			assertTrue("The Action was not called.", action.passed);
		}
		
		/**
		 * Verify that changing the commands for an action works correctly. 
		 * 
		 */
		public function testAddActionThenChangeCommand():void {
			var delegate:ActionDelegate = new ActionDelegate();
			
			// add an action
			var action:AutomateBasicAction = new AutomateBasicAction();
			action.addCommand(BasicCommand.MY_BASIC_COMMAND);
			delegate.addAction(action);
			
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
			var delegate:ActionDelegate = new ActionDelegate();
			
			// add an action
			var action:AutomateBasicAction = new AutomateBasicAction();
			delegate.addAction(action);
			
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
	}
}