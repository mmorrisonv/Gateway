package  com.poc.gateway.view
{
	
	import com.poc.gateway.controller.SwipeCommandTriggerEvent;
	import com.poc.gateway.events.CustomEvent;
	import com.poc.gateway.events.EntryEvent;
	import com.poc.gateway.model.GatewayModel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class SwipeEntryMediator extends Mediator
	{
		[Inject]public var model:GatewayModel;
		[Inject]public var ui:SwipeEntryPanel;
		
		override public function onRegister():void
		{
			this.ui.addEventListener(SwipeEntryPanel.NEW_CARD_SWIPE,onNewCardSwiped);
		}
		
		protected function onNewCardSwiped(event:CustomEvent):void
		{
			// Someone has swiped a card
			var e:SwipeCommandTriggerEvent = new SwipeCommandTriggerEvent(
				SwipeCommandTriggerEvent.PROCESS_CARD_SWIPE,event.data.toString() );
			this.dispatch( e );
		}
		

		
		
	}
}