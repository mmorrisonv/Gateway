package  com.poc.gateway.view
{
	
	import com.poc.gateway.controller.SwipeCommandTriggerEvent;
	import com.poc.gateway.controller.events.CustomEvent;
	import com.poc.gateway.controller.events.EntryEvent;
	import com.poc.gateway.model.GatewayModel;
	import com.poc.gateway.model.ModelEvent;
	import com.poc.gateway.model.vo.PersonVO;
	
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
			this.ui.pRole.dataProvider = this.model.Roles;
		}
		
		protected function onNewPersonCreated(event:CustomEvent):void
		{	
			
			var newPerson:PersonVO = new PersonVO;
			var date:Date = new Date();
			newPerson.created = Math.floor( date.time / 1000 );
			newPerson.deleted = 0;
			newPerson.Name = this.ui.pname.text;
			newPerson.cardID = this.ui.pID.text;
			//newPerson.Role = this.model.Roles[int( this.ui.pRate.text )];
			newPerson.Role = this.ui.pRole.selectedItem;
			
			this.model.Employees.addItem(newPerson);
			this.model.writeEmployees();
		}
		
		protected function onNewInspection(event:ModelEvent):void
		{
			// Someone has swiped a card - show the personVO
			ui.pname.text = this.model.currentSwipeInspection.person.Name;
		}

		
		
	}
}