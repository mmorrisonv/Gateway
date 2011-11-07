package  com.poc.gateway.view
{
	
	import com.poc.gateway.controller.SwipeCommandTriggerEvent;
	import com.poc.gateway.controller.events.CustomEvent;
	import com.poc.gateway.controller.events.EntryEvent;
	import com.poc.gateway.model.GatewayModel;
	import com.poc.gateway.model.ModelEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.events.EffectEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class LastSwipeInspectorMediator extends Mediator
	{
		[Inject]public var model:GatewayModel;
		[Inject]public var ui:LastSwipeInspectorPanel;
		
		private var initialHeight:Number;
		
		public var timer : Timer;
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher,ModelEvent.VALID_SWIPE,onNewSwipe );
			
			this.initialHeight = this.ui.height;
			this.ui.resizer.heightFrom = 0;
			this.ui.resizer.heightTo = this.initialHeight;
			this.ui.fxFader.alphaFrom = 0;
			this.ui.fxFader.alphaTo = 1;
			this.ui.fxFader.addEventListener(EffectEvent.EFFECT_END,faderComplete);
			timer = new Timer(3000,1);
			this.timer.addEventListener(TimerEvent.TIMER,this.onTimeUpdated);
			
			this.hide();
		}

		
		protected function onNewSwipe(event:ModelEvent):void
		{
			// Someone has swiped a card - show the personVO
			ui.pname.text = this.model.lastSwipe.person.Name;
			ui.swipeTime.text = this.model.lastSwipe.stopTime.timeStr;
			//ui.rate.text = this.model.lastSwipe.person.Rate.toString();
			
			this.show();
			

			this.timer.start();
		
		}
		
		protected function onTimeUpdated(event:Event):void
		{
			this.hide();
		}
		
		private function hide():void
		{
			//this.ui.height = 0;
			this.ui.resizer.play(null,true);
			this.ui.fxFader.play(null,true);
		}		

		private function show():void
		{
			this.ui.visible = true;
			//this.ui.height = this.initialHeight;
			this.ui.resizer.play();
			this.ui.fxFader.play();
		}		
		
		
		protected function faderComplete(event:EffectEvent):void
		{
			if(this.ui.alpha == 0)
				this.ui.visible = false;
		}
	}
}