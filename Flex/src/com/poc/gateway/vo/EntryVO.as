package com.poc.gateway.vo
{
	import flash.events.EventDispatcher;
	import flash.events.Event;

	public class EntryVO extends EventDispatcher
	{
		static public const UPDATED :String = 'UPDATED';
		
		public var cardID : String;
		public var time : Number;
		public var success : Boolean;
		public var person : PersonVO;
		public var present:Boolean;
		
		public function updated():void{
			this.dispatchEvent(new Event(EntryVO.UPDATED));
		}
	}
	
}