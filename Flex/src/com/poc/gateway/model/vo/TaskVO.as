package com.poc.gateway.model.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	public class TaskVO extends EventDispatcher
	{
		public function TaskVO(){
			
			timeIN = new TimeVO();
			timeOUT = new TimeVO();
		}
		static public const UPDATED :String = 'UPDATED';
		
		public var cardID : String;
		public var timeIN : TimeVO;
		public var timeOUT : TimeVO;
		public var Role : RoleVO;
		public var current:Boolean;
		
		public function updated():void{
			this.dispatchEvent(new Event(TaskVO.UPDATED));
		}
	}
	
}