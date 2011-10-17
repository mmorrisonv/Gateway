package com.poc.gateway.controller
{
	import com.poc.gateway.model.GatewayModel;
	import com.poc.gateway.model.vo.EntryVO;
	import com.poc.gateway.model.vo.PersonVO;
	
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
				
				//look for this entry - means swipe out
				for each(var preventry:EntryVO in this.model._entries)
				{
					if(preventry.cardID == event.cardID )
					{
						if(preventry.present == true){
							preventry.present = false;
							preventry.updated();
						return;
						}
						else{
							preventry.present = true;
							preventry.updated();
							return;
						}
					}
					
						
				}
				
				var entry:EntryVO = new EntryVO();
				var date:Date = new Date();
				var frmtr:spark.formatters.DateTimeFormatter = new spark.formatters.DateTimeFormatter();
				
				frmtr.dateTimePattern = "h:mm:ssa MM/dd";
				entry.cardID = event.cardID;
				
				entry.time.timestamp = Math.floor(date.getTime()/1000);
				entry.time.timeStr = frmtr.format(date);
				entry.time.dateObj = date;
				frmtr.dateTimePattern = 'h:mm a';
				entry.time.timeStrSml = frmtr.format(date);
				
				entry.success = false;
				entry.person = validPerson;
				
				if(validSwipe)
				{
					entry.success = true;
					entry.present = true;
					this.model.lastSwipe = entry;
					this.model._entries.addItemAt(entry,0);
		
				}
				else
				{
					
				}
				
			}
		}
		
	}
}