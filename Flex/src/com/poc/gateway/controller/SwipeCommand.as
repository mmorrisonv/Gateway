package com.poc.gateway.controller
{
	import com.poc.gateway.model.GatewayModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class SwipeCommand extends Command
	{
		[Inject] public var model:GatewayModel;
		[Inject] public var event:SwipeCommandTriggerEvent;
		
		override public function execute():void
		{
			if ( event.type == SwipeCommandTriggerEvent.PROCESS_CARD_SWIPE ) 
			{
				//check against valid cards
				//if valid card, add to entryfile
				//add cardID to entries array on model
				// 
			}
		}
		
	}
}