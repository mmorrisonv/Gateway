package com.poc.gateway
{
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.Context;
	import com.poc.gateway.view.GatewayView;
	import com.poc.gateway.view.GatewayMediator;
	import com.poc.gateway.model.GatewayModel;
	
	public class GatewayContext extends Context
	{
		public function GatewayContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super();
		}
		
		override public function startup():void
		{
			
			injector.mapSingleton(GatewayModel);
			
			mediatorMap.mapView(GatewayView,GatewayMediator);
			super.startup();
		}
	}
}