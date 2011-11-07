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
				this.model._entries.refresh();
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
					{//user has previously swiped in
						
						if(previousEntry.present == true && previousEntry.currentTask != null)
						{//end this Entries current task, and add an endTime
							previousEntry.endCurrentTask(new Date);
							return;
						}
						else 
						{//use has already worked this event, but is currently taskless - create new task
							
							if( this.model.eventStartTime.undefined )//check to see if event has started yet
							{ //create an staging task
								previousEntry.createNewTask(date,this.model.stagingRole);
							}
							else
							{//reset the endTime of this entry
								previousEntry.createNewTask(date,validPerson.defaultRole);
							}
							
							return;
						}
					}
					else
					{//user NOT previsouly swiped in, create a new operative, and new task
						
						var newEntry:EntryVO = createNewEntry(event.cardID,validPerson);
						if( this.model.eventStartTime.undefined )//check to see if event has started yet
						{ //create an staging task
							newEntry.createNewTask(date,this.model.stagingRole);
						}
						else
						{//reset the endTime of this entry
							newEntry.createNewTask(date,validPerson.defaultRole);
						}
						this.model.lastSwipe = newEntry;
						this.model._entries.addItemAt(newEntry,0);
					}

				

				}

			}
		}
		

		
		public function createNewEntry(cardID:String, person:PersonVO):EntryVO
		{
			var entry:EntryVO = new EntryVO();
			var date:Date = new Date();

			
			entry.cardID = cardID;
			
			if( this.model.eventStartTime.undefined )
			{//event NOT started - record staging time
				entry.setupTime.dateObj = date;
			}
			else
			{//event STARTED - initiate from startTime
				entry.startTime.dateObj = date;
			}
			
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