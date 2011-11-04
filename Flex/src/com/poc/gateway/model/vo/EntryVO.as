package com.poc.gateway.model.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	public class EntryVO extends EventDispatcher
	{
		public function EntryVO(){
			
			setupTime = new TimeVO();
			startTime = new TimeVO();
			stopTime = new TimeVO();
		}
		static public const UPDATED :String = 'UPDATED';
		
		public var cardID : String;
		public var setupTime : TimeVO; //if person swipes in before the event starts or before billable hours
		public var startTime : TimeVO;
		public var stopTime : TimeVO;
		public var success : Boolean;
		public var person : PersonVO;
		public var present:Boolean;
		public var Tasks:ArrayCollection = new ArrayCollection();
		public var currentTask:TaskVO;
		
		public function updated():void{
			this.dispatchEvent(new Event(EntryVO.UPDATED));
		}
		
		public function endCurrentTask(time:Date):void{
			this.present = false;
			this.stopTime.dateObj = time;
			
			this.currentTask.timeOUT.dateObj = time;
			this.updated();
			this.currentTask.updated();
			this.currentTask = null;
		}
		
		
		public function createNewTask(time:Date,role:RoleVO = null):void
		{
			this.present = true;
			this.stopTime.dateObj = null;
			
			//create task
			var newTask:TaskVO = new TaskVO();
			newTask.cardID = person.cardID;
			newTask.current = true;
			if(role == null)
				newTask.Role = person.defaultRole;
			else
				newTask.Role = role;
			newTask.timeIN.dateObj = time;
			
			
			this.currentTask = newTask;
			this.Tasks.addItemAt(currentTask,0);
			this.updated();
		}
	}
	
}