package com.poc.gateway.model
{
	import com.adobe.serialization.json.JSON;
	import com.poc.gateway.events.EntryEvent;
	import com.poc.gateway.vo.EntryVO;
	import com.poc.gateway.vo.PersonVO;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Actor;
	
	public class GatewayModel extends Actor
	{
		public var _entries:ArrayCollection = new ArrayCollection();
		
		public var Employees:ArrayCollection = new ArrayCollection();
		
		private var employeeFile:File;
		private var entryFile:File;
		
		private var _lastSwipe:EntryVO;
		
/*		private var time:Timer;
		private var currentTime:Date;
		public function set lastSwipe(param:EntryVO):void
		{
			
			this.currentTime = param;
			var e : ModelEvent = new ModelEvent(
				ModelEvent.VALID_SWIPE);
			dispatch( e );
		}
		
		}*/
		private var _currentSwipeInspection:EntryVO;

		public function get currentSwipeInspection():EntryVO
		{
			return _currentSwipeInspection;
		}

		public function set currentSwipeInspection(value:EntryVO):void
		{
			_currentSwipeInspection = value;
			var e : ModelEvent = new ModelEvent(
				ModelEvent.CURRENT_INSPECTION_CHANGED);
			dispatch( e );
		}
		
		
		public function set lastSwipe(param:EntryVO):void
		{
			this._lastSwipe = param;
			var e : ModelEvent = new ModelEvent(
				ModelEvent.VALID_SWIPE);
				dispatch( e );
		}
		
		public function get lastSwipe():EntryVO
		{
			
			return _lastSwipe;
		}
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
				employee.Rate = 5;
				employee.created = employeeImport.created;
				employee.deleted = employeeImport.deleted;
					
				this.Employees.addItem(employee);
			}
			
			fileStream.close();
		}
		public function writeEmployees()
		{
			
			
			var file:File = File.documentsDirectory.resolvePath("employeesOUT.txt");
			var fileStream:FileStream = new FileStream();
			
			var export:Object = new Object();
			export.Employees = new Array();
			for each(var person:PersonVO in this.Employees)
			{
				var newperson:Object = new Object();
				newperson.name = person.Name;
				newperson.cardid = person.cardID;
				newperson.rate = person.Rate;
				newperson.created = person.created;
				newperson.deleted = person.deleted;
				
				(export.Employees as Array).push(newperson);
			}
			
			var exportstring:String = JSON.encode(export);
			
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTF(exportstring);
			fileStream.close();
		}
		public function setupLog()
		{
			var date : Date = new Date();
			var filename = 'event' + date.getTime();
			var file:File = File.documentsDirectory.resolvePath(filename);
			var fileStream:FileStream = new FileStream();
			/*fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTF("test");
			fileStream.close();*/
		}

		
		
	}
}