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
	
	public class PanelPersonInspectorMediator extends Mediator
	{
		[Inject]public var model:GatewayModel;
		[Inject]public var ui:PanelPersonInspector;
		
		override public function onRegister():void
		{
			
			eventMap.mapListener(eventDispatcher,ModelEvent.CURRENT_INSPECTION_CHANGED,onNewInspection );
			this.ui.rate.dataProvider = this.model.Roles;
		}
		
		protected function onNewInspection(event:ModelEvent):void
		{
			// Someone has swiped a card - show the personVO
			ui.pname.text = this.model.currentSwipeInspection.person.Name;
			ui.swipeTime.text = this.model.currentSwipeInspection.time.timeStrSml;
			ui.rate.selectedItem = this.model.currentSwipeInspection.person.Role;
			
	
		}

		
		
	}
}