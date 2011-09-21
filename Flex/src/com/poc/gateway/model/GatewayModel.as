package com.poc.gateway.model
{
	import com.poc.gateway.events.EntryEvent;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.robotlegs.mvcs.Actor;
	
	public class GatewayModel extends Actor
	{
		private var _entries:Array = [];
		private var _entryCount:uint = 0;
		
		private var employeeFile:File;
		private var entryFile:File;
		
		public function GatewayModel()
		{
			readEmployees();
			setupLog();
		}
		public function readEmployees()
		{
			var file:File = File.documentsDirectory.resolvePath("employees.txt");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var rawJSON = fileStream.readUTF();
			
			fileStream.close();
		}
		public function setupLog()
		{
			var date : Date = new Date();;
			var filename = 'event' + date.getTime();
			var file:File = File.documentsDirectory.resolvePath(filename);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTF("test");
			fileStream.close();
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
