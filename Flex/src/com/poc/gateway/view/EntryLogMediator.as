package  com.poc.gateway.view
{

	import com.poc.gateway.events.CustomEvent;
	import com.poc.gateway.model.GatewayModel;
	import com.poc.gateway.vo.EntryVO;
	
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
			this.ui.addEventListener(EntryLog.LIST_CHANGED,onChange);
		}
		
		protected function onChange(event:CustomEvent):void
		{
			var selectedIndex:int = int( event.data );
			this.model.currentSwipeInspection = this.model._entries.getItemAt(selectedIndex ) as EntryVO;
			
		}		

		
	}
}