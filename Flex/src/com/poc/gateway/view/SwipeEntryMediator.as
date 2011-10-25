package  com.poc.gateway.view
{
	
	import com.poc.gateway.controller.SwipeCommandTriggerEvent;
	import com.poc.gateway.controller.events.CustomEvent;
	import com.poc.gateway.controller.events.EntryEvent;
	import com.poc.gateway.model.GatewayModel;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class SwipeEntryMediator extends Mediator
	{
		[Inject]public var model:GatewayModel;
		[Inject]public var ui:PanelSwipeEntry;
		
		override public function onRegister():void
		{
			/*eventMap.mapListener(ui.go,MouseEvent.CLICK,goClicked);
			eventMap.mapListener(eventDispatcher,EntryEvent.ENTRYLIST_UPDATED,onEntry );*/
			this.ui.addEventListener(PanelSwipeEntry.NEW_CARD_SWIPE,onNewCardSwiped);
			this.ui.addEventListener(KeyboardEvent.KEY_DOWN,checkKey);
		}
		
		protected function checkKey(event:KeyboardEvent):void
		{
			if(event.charCode == 13)
				onNewCardSwiped(null);
		}
		
		protected function onNewCardSwiped(event:CustomEvent):void
		{
			// Someone has swiped a card
			
			var e:SwipeCommandTriggerEvent = new SwipeCommandTriggerEvent(
				SwipeCommandTriggerEvent.PROCESS_CARD_SWIPE,this.ui.cardInput.text );
			this.ui.cardInput.text = "";
			this.dispatch( e );
		}
		
		/*delete
		private function onEntry(e:EntryEvent):void
		{
		//we have an entry
		ui.cardInput.text = '';
		}		
		
		private function goClicked(e:MouseEvent):void
		{
		this.model.addNewEtry1 = this.ui.cardInput.text
		//model.addNewEtry1('crunch');
		}*/
		
		
	}
}