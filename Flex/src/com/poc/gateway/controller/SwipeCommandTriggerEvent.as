package com.poc.gateway.controller
{
	import flash.events.Event;
	
	public class SwipeCommandTriggerEvent extends Event
	{
		static public var PROCESS_CARD_SWIPE: String =  "PROCESS_CARD_SWIPE";
		
		public var cardID:String = ""; 
		
		public function SwipeCommandTriggerEvent(type:String,cardID:String)
		{
			this.cardID = cardID;
			super(type, bubbles, cancelable);
		}
	}
}