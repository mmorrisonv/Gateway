package com.poc.gateway.controller
{
	import com.poc.gateway.model.GatewayModel;
	import com.poc.gateway.model.vo.EntryVO;
	import com.poc.gateway.model.vo.PersonVO;
	import com.poc.gateway.model.vo.TaskVO;
	
	import flash.events.Event;
	import flash.globalization.DateTimeFormatter;
	
	import mx.formatters.DateFormatter;
	
	import org.robotlegs.mvcs.Command;
	
	import spark.formatters.DateTimeFormatter;
	
	public class SwipeCommand extends Command
	{
		[Inject] public var model:GatewayModel;
		[Inject] public var event:SwipeCommandTriggerEvent;
		
		override public function execute():void
		{

			var date:Date = new Date();
			
			if ( event.type == SwipeCommandTriggerEvent.PROCESS_CARD_SWIPE ) 
			{
				
				var validPerson:PersonVO;
				var validSwipe:Boolean = false;
				//check against valid cards
				for each( var employee:PersonVO in this.model.Employees ){
					if(employee.cardID == event.cardID)
					{
						validSwipe = true;
						validPerson = employee;
					}
				}
				if(validSwipe)
				{
					
		
					//look for this entry - means swipe out
					var previousEntry:EntryVO = lookForEntry(event.cardID)
					if( previousEntry != null )
					{
						if(previousEntry.present == true && previousEntry.currentTask != null)
						{
							//end this Entries current task, and add an endTime
							previousEntry.present = false;
							previousEntry.stopTime.dateObj = date;
							
							previousEntry.currentTask.timeOUT.dateObj = date;
							previousEntry.currentTask.updated();
							previousEntry.currentTask = null;
							previousEntry.updated();
							return;
						}
						else //create new task
						{
							//reset the endTime of this entry
							previousEntry.present = true;
							previousEntry.stopTime.dateObj = null;
							
							previousEntry.currentTask = createNewTask(event.cardID,validPerson);
							previousEntry.Tasks.addItemAt(previousEntry.currentTask,0);
							previousEntry.updated();
							return;
						}
					}
					else
					{
						var newEntry:EntryVO = createNewEntry(event.cardID,validPerson);
						newEntry.present = true;
						newEntry.currentTask = createNewTask(event.cardID,validPerson);
						newEntry.Tasks.addItemAt(newEntry.currentTask,0);
						
						this.model.lastSwipe = newEntry;
						this.model._entries.addItemAt(newEntry,0);
					}

				

				}

			}
		}
		
		private function createNewTask(cardID:String,validPerson:PersonVO):TaskVO
		{
			//create task
			var date:Date = new Date();
			
			var newTask:TaskVO = new TaskVO();
			newTask.cardID = cardID;
			newTask.current = true;
			newTask.Role = validPerson.Role;
			newTask.timeIN.dateObj = date;

			return newTask;
		}
		
		public function createNewEntry(cardID:String, person:PersonVO):EntryVO
		{
			var entry:EntryVO = new EntryVO();
			var date:Date = new Date();

			
			entry.cardID = cardID;
			
			entry.startTime.dateObj = date;
			
			entry.success = false;
			entry.person = person;
			
			return entry;
		}
		
		
		public function lookForEntry(cardID:String):EntryVO{
			for each(var preventry:EntryVO in this.model._entries)
			{
				if(preventry.cardID == cardID )
					return preventry;
			}
			return null;
		}
		
	}
}