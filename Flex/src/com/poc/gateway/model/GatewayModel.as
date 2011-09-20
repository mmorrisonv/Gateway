package com.poc.gateway.model
{
	import com.poc.gateway.events.EntryEvent;
	
	import org.robotlegs.mvcs.Actor;
	
	public class GatewayModel extends Actor
	{
		private var _entries:Array = [];
		private var _entryCount:uint = 0;
		
		public function GatewayModel()
		{
			
		}
		
		public function set addNewEtry1(value:String):void
		{
			_entries.push(value);
			_entryCount = _entries.length;
			dispatch( new EntryEvent(EntryEvent.ENTRYLIST_UPDATED) );
		}
		
		public function get entries():Array
		{
			return _entries;
		}
		
		public function set entries(value:Array):void
		{
			_entries = value;
		}
		public function get entryCount():uint
		{
			return _entryCount;
		}
		
		public function set entryCount(value:uint):void
		{
			_entryCount = value;
		}
		
		
	}
}