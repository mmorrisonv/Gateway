package  com.poc.gateway.view
{
	
	import com.poc.gateway.controller.SwipeCommandTriggerEvent;
	import com.poc.gateway.controller.events.CustomEvent;
	import com.poc.gateway.controller.events.EntryEvent;
	import com.poc.gateway.model.GatewayModel;
	import com.poc.gateway.model.ModelEvent;
	import com.poc.gateway.model.vo.TimeVO;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class PanelEventManagmentMediator extends Mediator
	{
		[Inject]public var model:GatewayModel;
		[Inject]public var ui:PanelEventManagment;
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher,ModelEvent.EVENT_STARTED,onEventStarted);
			eventMap.mapListener(eventDispatcher,ModelEvent.EVENT_STOPPED,onEventStopped);
			this.ui.addEventListener(PanelEventManagment.EXPORT_EVENT,onExportEvent);
			this.ui.addEventListener(PanelEventManagment.START_EVENT,onEventStarted);
		}
		
		protected function onEventStarted(event:Event):void
		{
			this.ui.timer.start();
		}
		protected function onEventStopped(event:Event):void
		{
			this.ui.timer.stop();
		}		
		protected function onExportEvent(event:Event):void
		{
			this.model.writeEmployees();
		}

		
		
	}
}