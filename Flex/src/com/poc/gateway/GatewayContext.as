package com.poc.gateway
{
	import com.poc.gateway.controller.SwipeCommand;
	import com.poc.gateway.controller.SwipeCommandTriggerEvent;
	import com.poc.gateway.model.GatewayModel;
	import com.poc.gateway.view.SwipeEntryMediator;
	import com.poc.gateway.view.SwipeEntryPanel;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.Context;
	
	public class GatewayContext extends Context
	{
		override public function startup():void
		{
			injector.mapSingleton(GatewayModel);
			mediatorMap.mapView(SwipeEntryPanel,SwipeEntryMediator);
			
			this.commandMap.mapEvent(SwipeCommandTriggerEvent.PROCESS_CARD_SWIPE,SwipeCommand);
			
			super.startup();
		}
	}
}