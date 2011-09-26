package com.poc.gateway
{
	import com.poc.gateway.controller.SwipeCommand;
	import com.poc.gateway.controller.SwipeCommandTriggerEvent;
	import com.poc.gateway.model.GatewayModel;
	import com.poc.gateway.view.EntryLog;
	import com.poc.gateway.view.*;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.Context;
	
	public class GatewayContext extends Context
	{
		override public function startup():void
		{
			injector.mapSingleton(GatewayModel);
			mediatorMap.mapView(SwipeEntryPanel,SwipeEntryMediator);
			mediatorMap.mapView(EntryLog,EntryLogMediator);
			
			this.commandMap.mapEvent(SwipeCommandTriggerEvent.PROCESS_CARD_SWIPE,SwipeCommand);
			
			super.startup();
		}
	}
}