package com.poc.gateway.controller
{
	import flash.events.Event;
	
	public class LogCommandTriggerEvent extends Event
	{
		public function LogCommandTriggerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}