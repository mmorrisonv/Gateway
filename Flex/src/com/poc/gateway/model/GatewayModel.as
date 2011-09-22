package com.poc.gateway.model
{
	import com.adobe.serialization.json.JSON;
	import com.poc.gateway.events.EntryEvent;
	import com.poc.gateway.vo.PersonVO;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Actor;
	
	public class GatewayModel extends Actor
	{
		private var _entries:Array = [];
		private var _entryCount:uint = 0;
		
		public var Employees:ArrayCollection = new ArrayCollection();
		
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
			try{
				var rawJSON = fileStream.readUTFBytes(fileStream.bytesAvailable);
			}
			catch(e:Error){
				
			}
			if(rawJSON != null)
				var _json:Object = JSON.decode(rawJSON);
			
			for each( var employeeImport:Object in _json.Employees  )
			{
				var employee:PersonVO = new PersonVO;
				employee.Name = employeeImport.name
				employee.cardID = employeeImport.cardid;
				employee.Rate = 5
				this.Employees.addItem(employee);
			}
			
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
