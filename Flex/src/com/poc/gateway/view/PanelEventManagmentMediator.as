package  com.poc.gateway.view
{
	
	import com.poc.gateway.controller.SwipeCommandTriggerEvent;
	import com.poc.gateway.controller.events.CustomEvent;
	import com.poc.gateway.controller.events.EntryEvent;
	import com.poc.gateway.model.GatewayModel;
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
			this.ui.addEventListener(PanelEventManagment.EXPORT_EVENT,onExportEvent);
			this.ui.addEventListener(PanelEventManagment.START_EVENT,onEventStarted);
		}
		
		protected function onEventStarted(event:Event):void
		{
			this.model.startEvent();
		}
		
		protected function onExportEvent(event:Event):void
		{
			this.model.writeEmployees();
		}

		
		
	}
}