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
	
	public class PanelEventSettingsMediator extends Mediator
	{
		[Inject]public var model:GatewayModel;
		[Inject]public var ui:PanelEventSettings;
		
		override public function onRegister():void
		{
			this.ui.addEventListener(PanelEventSettings.EXPORT_EVENT,onExportEvent);
			this.ui.addEventListener(PanelEventSettings.STARTSTOP_EVENT,onStartStopPressed);
			switchStartStopButton();
		}
		

		protected function onStartStopPressed(event:Event):void
		{
			if(model.eventRunning)
			{
				this.model.stopEvent();
				/*var e:Event = new Event(ModelEvent.EVENT_STOPPED,true,false);
				this.dispatch(e);*/
			}
			else
			{
				this.model.startEvent();
				/*var e:Event = new Event(ModelEvent.EVENT_STARTED,true,false);
				this.dispatch(e);*/
			}

			switchStartStopButton();
		}
		
		protected function onExportEvent(event:Event):void
		{
			this.model.writeEmployees();
		}
		
		private function switchStartStopButton():void{
			if(this.model.eventRunning)
			{
				//show stop button
				this.ui.startstopButton.label = "stop event";
				this.ui.startstopButton.icon = "assets/images/icons/icon_stop.png";
				this.ui.startstopButton.bgcolor=0xf43a3a;
			}
			else{
				this.ui.startstopButton.label = "start event";
				this.ui.startstopButton.icon = "assets/images/icons/icon_play.png";
				this.ui.startstopButton.bgcolor=0xa1cf00;
			}

		}


		
		
	}
}