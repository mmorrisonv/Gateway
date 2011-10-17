package com.poc.gateway.controller.events
{
	import flash.events.Event;
	
	public class EntryEvent extends Event
	{
		public static const ENTRYLIST_UPDATED:String = "ENTRYLIST_UPDATEDED";
		
		public function EntryEvent(type:String)
		{
			super(type);
		}
		
		override public function clone():Event{
			return new EntryEvent(type );
		}
	}
}