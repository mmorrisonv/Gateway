package com.poc.gateway
{
	import com.poc.gateway.controller.SwipeCommand;
	import com.poc.gateway.controller.SwipeCommandTriggerEvent;
	import com.poc.gateway.model.GatewayModel;
	import com.poc.gateway.view.*;
	import com.poc.gateway.view.EntryLog;
	
	import flash.display.DisplayObjectContainer;
	
	import mx.containers.Panel;
	
	import org.robotlegs.mvcs.Context;
	
	public class GatewayContext extends Context
	{
		override public function startup():void
		{
			injector.mapSingleton(GatewayModel);
			
			mediatorMap.mapView(PanelSwipeEntry,SwipeEntryMediator);
			mediatorMap.mapView(EntryLog,EntryLogMediator);
			mediatorMap.mapView(LastSwipeInspectorPanel,LastSwipeInspectorMediator);
			mediatorMap.mapView(PanelPersonInspector,PanelPersonInspectorMediator);
			mediatorMap.mapView(PanelPersonCreator,PanelPersonCreatorMediator);
			
			this.commandMap.mapEvent(SwipeCommandTriggerEvent.PROCESS_CARD_SWIPE,SwipeCommand);
			
			super.startup();
		}
	}
}