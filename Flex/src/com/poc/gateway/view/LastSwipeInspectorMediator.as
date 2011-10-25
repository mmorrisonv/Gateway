package  com.poc.gateway.view
{
	
	import com.poc.gateway.controller.SwipeCommandTriggerEvent;
	import com.poc.gateway.controller.events.CustomEvent;
	import com.poc.gateway.controller.events.EntryEvent;
	import com.poc.gateway.model.GatewayModel;
	import com.poc.gateway.model.ModelEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class LastSwipeInspectorMediator extends Mediator
	{
		[Inject]public var model:GatewayModel;
		[Inject]public var ui:LastSwipeInspectorPanel;
		
		override public function onRegister():void
		{
			
			eventMap.mapListener(eventDispatcher,ModelEvent.VALID_SWIPE,onNewSwipe );
			
		}
		
		protected function onNewSwipe(event:ModelEvent):void
		{
			// Someone has swiped a card - show the personVO
			ui.pname.text = this.model.lastSwipe.person.Name;
			ui.swipeTime.text = this.model.lastSwipe.timeIN.timeStr;
			//ui.rate.text = this.model.lastSwipe.person.Rate.toString();
	
		}

		
		
	}
}