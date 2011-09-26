package  com.poc.gateway.view
{

	import com.poc.gateway.model.GatewayModel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class EntryLogMediator extends Mediator
	{
		[Inject]public var model:GatewayModel;
		[Inject]public var ui:EntryLog;
		
		override public function onRegister():void
		{
			/*eventMap.mapListener(ui.go,MouseEvent.CLICK,goClicked);
			eventMap.mapListener(eventDispatcher,EntryEvent.ENTRYLIST_UPDATED,onEntry );*/
			this.ui.entryLog.dataProvider=this.model._entries;
		}
		

		
	}
}