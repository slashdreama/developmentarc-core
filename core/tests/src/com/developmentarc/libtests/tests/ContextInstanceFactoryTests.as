package com.developmentarc.libtests.tests
{
	import com.developmentarc.core.utils.ContextInstanceFactory;
	import com.developmentarc.libtests.elements.instances.InstanceClass;
	import com.developmentarc.libtests.elements.instances.InstanceClassTwo;
	
	import flexunit.framework.TestCase;
	
	public class ContextInstanceFactoryTests extends TestCase
	{
		public function ContextInstanceFactoryTests(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void
		{
			super.setUp();
			
			ContextInstanceFactory.clearAllInstance();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
		}
		
		
		public function testSingleInstance():void {
			var context:String = "SINGLE CONTEXT";			
			var instance:InstanceClass = ContextInstanceFactory.getContextInstance(InstanceClass,context) as InstanceClass;
			
			
			assertTrue("Instance should be the same as what is in the context", instance === ContextInstanceFactory.getContextInstance(InstanceClass,context));
		}
		
		public function testSingleInstanceDifferentContext():void {
			var context1:String = "CONTEXT 1";
			var context2:String = "CONTEXT 2";
			
			var instance1:InstanceClass = ContextInstanceFactory.getContextInstance(InstanceClass,context1) as InstanceClass;
			var instance2:InstanceClass = ContextInstanceFactory.getContextInstance(InstanceClass,context2) as InstanceClass;
			
			assertFalse("Instance from different contexts should not be the same", instance1 === instance2);
		}
		
		
		public function testDifferentInstancesSameContext():void {
			var context:String = "CONTEXT 1";
			
			var instance1:InstanceClass = ContextInstanceFactory.getContextInstance(InstanceClass,context) as InstanceClass;
			var instance2:Object = ContextInstanceFactory.getContextInstance(Object,context) as Object;
			
			assertFalse("Instance from different contexts should not be the same", instance1 === instance2);
		}
		
		
		public function testClearInstancesFromContext():void {
			var context:String = "CONTEXT 1";
			
			var instanceBeforeClear:InstanceClass = ContextInstanceFactory.getContextInstance(InstanceClass,context) as InstanceClass;
			
			ContextInstanceFactory.clearAllInstancesInContext(context);
			
			var instanceAfterClear:InstanceClass = ContextInstanceFactory.getContextInstance(InstanceClass,context) as InstanceClass;
			
			assertFalse("Instance before and after clear context should not be the same", instanceBeforeClear === instanceAfterClear);
		}
		
		public function testClearAllInstances():void {
			var context:String = "CONTEXT 1";
			
			var instanceBeforeClear:InstanceClass = ContextInstanceFactory.getContextInstance(InstanceClass,context) as InstanceClass;
			
			ContextInstanceFactory.clearAllInstance();
			
			var instanceAfterClear:InstanceClass = ContextInstanceFactory.getContextInstance(InstanceClass,context) as InstanceClass;
			
			assertFalse("Instance before and after clear context should not be the same", instanceBeforeClear === instanceAfterClear);
		}
	}
}