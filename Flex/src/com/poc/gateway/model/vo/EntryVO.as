package com.poc.gateway.model.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	public class EntryVO extends EventDispatcher
	{
		public function EntryVO(){
			
			startTime = new TimeVO();
			stopTime = new TimeVO();
		}
		static public const UPDATED :String = 'UPDATED';
		
		public var cardID : String;
		public var startTime : TimeVO;
		public var stopTime : TimeVO;
		public var success : Boolean;
		public var person : PersonVO;
		public var present:Boolean;
		public var Tasks:ArrayCollection = new ArrayCollection();
		public var currentTask:TaskVO;
		
		public function updated():void{
			this.dispatchEvent(new Event(EntryVO.UPDATED));
		}
	}
	
}