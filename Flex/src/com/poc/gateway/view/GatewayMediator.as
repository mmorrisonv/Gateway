package  com.poc.gateway.view
{
	
	import com.poc.gateway.events.EntryEvent;
	import com.poc.gateway.model.GatewayModel;
	
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class GatewayMediator extends Mediator
	{
		[Inject]public var model:GatewayModel;
		[Inject]public var ui:GatewayView;
		
		public function GatewayMediator()
		{
			
		}
		
		override public function onRegister():void
		{
			eventMap.mapListener(ui.go,MouseEvent.CLICK,goClicked);
			eventMap.mapListener(eventDispatcher,EntryEvent.ENTRYLIST_UPDATED,onEntry );
	
		}
		
		private function onEntry(e:EntryEvent):void
		{
			//we have an entry
			ui.cardInput.text = '';
		}		
		
		private function goClicked(e:MouseEvent):void
		{
			this.model.addNewEtry1 = this.ui.cardInput.text
			//model.addNewEtry1('crunch');
		}
		
		
	}
}