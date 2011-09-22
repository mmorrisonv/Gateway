package com.poc.gateway.controller
{
	import com.poc.gateway.model.GatewayModel;
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
				var validSwipe = false;
				//check against valid cards
				for each( var Employee:PersonVO in this.model.Employees ){
					if(Employee.cardID == event.cardID)
						validSwipe = true;
				}
				
				//if valid card, add to entryfile
				
				//add cardID to entries array on model
				// 
			}
		}
		
	}
}