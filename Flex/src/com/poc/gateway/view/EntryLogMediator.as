package  com.poc.gateway.view
{

	import com.poc.gateway.controller.events.CustomEvent;
	import com.poc.gateway.model.GatewayModel;
	import com.poc.gateway.model.vo.EntryVO;
	import com.poc.gateway.model.vo.PersonVO;
	
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
			
			//test data
			/*for ( var i : int = 0 ; i < 100; i++ ) 
			{
				var l : EntryVO = new  EntryVO()
					l.person = new PersonVO()
						l.person.Name = 'jues'
				this.model._entries.addItem( l ) 
			}*/
		}
		
		protected function onChange(event:CustomEvent):void
		{
			var selectedIndex:int = int( event.data );
			this.model.currentSwipeInspection = this.model._entries.getItemAt(selectedIndex ) as EntryVO;
			
		}		

		
	}
}