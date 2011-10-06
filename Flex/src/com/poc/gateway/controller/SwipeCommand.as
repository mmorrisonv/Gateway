package com.poc.gateway.controller
{
	import com.poc.gateway.model.GatewayModel;
	import com.poc.gateway.vo.EntryVO;
	import com.poc.gateway.vo.PersonVO;
	
	import org.robotlegs.mvcs.Command;
	
	public class SwipeCommand extends Command
	{
		[Inject] public var model:GatewayModel;
		[Inject] public var event:SwipeCommandTriggerEvent;
		
		override public function execute():void
		{
			if ( event.type == SwipeCommandTriggerEvent.PROCESS_CARD_SWIPE ) 
			{
				var validPerson:PersonVO;
				var validSwipe = false;
				//check against valid cards
				for each( var employee:PersonVO in this.model.Employees ){
					if(employee.cardID == event.cardID)
					{
						validSwipe = true;
						validPerson = employee;
						
					}
				}
				
				//look for this entry - means swipe out
				for each(var entry:EntryVO in this.model._entries)
				{
					if(entry.cardID == event.cardID)
					{
						entry.present = false;
						
						return;
					}
						
				}
				
				var entry : EntryVO = new EntryVO();
				var date:Date = new Date();
				entry.cardID = event.cardID;
				entry.time = date.getTime();
				entry.success = false;
				entry.person = validPerson;
				
				if(validSwipe)
				{
					entry.success = true;
					entry.present = true;
					this.model.lastSwipe = entry;
					this.model._entries.addItem(entry);
		
				}
				else
				{
					
				}
				
			}
		}
		
	}
}