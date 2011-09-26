package com.poc.gateway.vo
{
	import flash.events.EventDispatcher;

	public class EntryVO extends EventDispatcher
	{
		static public const UPDATED :String = 'UPDATED';
		
		public var cardID : String;
		public var time : Number;
		public var success : Boolean;
		
	}
	
}