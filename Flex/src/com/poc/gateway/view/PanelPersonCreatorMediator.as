package  com.poc.gateway.view
{
	
	import com.poc.gateway.controller.SwipeCommandTriggerEvent;
	import com.poc.gateway.events.CustomEvent;
	import com.poc.gateway.events.EntryEvent;
	import com.poc.gateway.model.GatewayModel;
	import com.poc.gateway.model.ModelEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class PanelPersonCreatorMediator extends Mediator
	{
		[Inject]public var model:GatewayModel;
		[Inject]public var ui:PanelPersonCreator;
		
		override public function onRegister():void
		{
			
			//eventMap.mapListener(eventDispatcher,ModelEvent.CURRENT_INSPECTION_CHANGED,onNewInspection );
			this.ui.addEventListener(PanelPersonCreator.NEW_PERSON,onNewPersonCreated);
			
		}
		
		protected function onNewPersonCreated(event:CustomEvent):void
		{
			this.model.Employees.addItem(event.data);
			this.model.writeEmployees();
			
		}
		
		protected function onNewInspection(event:ModelEvent):void
		{
			// Someone has swiped a card - show the personVO
			ui.pname.text = this.model.currentSwipeInspection.person.Name;
		}

		
		
	}
}