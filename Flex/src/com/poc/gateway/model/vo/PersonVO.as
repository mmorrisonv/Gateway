package com.poc.gateway.model.vo
{
	import flash.events.EventDispatcher;

	public class PersonVO extends EventDispatcher
	{
		public function PersonVO()
		{
			
		}
		public var cardID : String;
		public var Name   : String;
		public var Role   : RoleVO;
		public var created: Number;
		public var deleted: Number;
	}
}