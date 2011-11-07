package com.poc.gateway.model
{
	import com.adobe.serialization.json.JSON;
	import com.poc.gateway.controller.events.EntryEvent;
	import com.poc.gateway.model.vo.EntryVO;
	import com.poc.gateway.model.vo.PersonVO;
	import com.poc.gateway.model.vo.RoleVO;
	import com.poc.gateway.model.vo.TimeVO;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Actor;
	
	import spark.formatters.DateTimeFormatter;
	
	public class GatewayModel extends Actor
	{
		public var _entries:ArrayCollection = new ArrayCollection();
		
		public var eventDate:String = new String();
		public var eventStartTime:TimeVO = new TimeVO();
		public var eventStopTime:TimeVO;
		public var eventRunning:Boolean = false;
		public var eventStaging:Boolean = true;
		
		public var Employees:ArrayCollection = new ArrayCollection();
		//public var Operatives:ArrayCollection = new ArrayCollection();
		public var Roles:ArrayCollection = new ArrayCollection();
		public var stagingRole:RoleVO = new RoleVO();
		
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
			readRoles();
			readEmployees();
			setupLog();
			
			//set eventDate
			var date:Date = new Date();
			var frmtr:spark.formatters.DateTimeFormatter = new spark.formatters.DateTimeFormatter();
			frmtr.dateTimePattern = 'hh.mm MM-dd-yy';
			frmtr.format(date);
			eventDate = frmtr.format(date);
		} 
		
		public function startEvent():void
		{
			
			//let other components know the event has started
			this.dispatch(new ModelEvent(ModelEvent.EVENT_STARTED) );
			
			var now:TimeVO = new TimeVO();
			now.dateObj = new Date();
			this.eventStartTime = now;
			this.eventRunning = true;
			//todo: tell everyoen to login
			if(this.eventStaging)
				swipeInAllEmployees();
			this.eventStaging = false;
		}
		public function stopEvent():void
		{
			//let other components know the event has started
			this.dispatch(new ModelEvent(ModelEvent.EVENT_STOPPED) );
			
			var now:TimeVO = new TimeVO();
			now.dateObj = new Date();
			this.eventStopTime = now;
			this.eventRunning = false;
			//todo: tell everyoen to login
			swipeOutAllEmployees();
		}
		
		private function swipeOutAllEmployees():void
		{
			// TODO: swipe out all employees
			
			for each(var entry:EntryVO in this._entries)
			{
				entry.stopTime = this.eventStartTime;
				if(entry.currentTask != null)
					entry.endCurrentTask(new Date);
				entry.updated();
			}
		}
		public function swipeInAllEmployees():void
		{
			// TODO: swipe in all employees
			for each(var entry:EntryVO in this._entries)
			{
				entry.startTime = this.eventStartTime;
				if(entry.currentTask != null)
					entry.endCurrentTask(new Date);
				entry.createNewTask(new Date);
				entry.updated();
			}
		}
		
		public function readEmployees():void
		{
			

			
			/*read employees.txt for each Employees JSON defintion*/
			var file:File = File.documentsDirectory.resolvePath("employees.txt");
			var fileStream:FileStream = new FileStream();
			var rawJSON:String;
			var _json:Object
			
			fileStream.open(file, FileMode.READ);
			try{
				rawJSON= fileStream.readUTFBytes(fileStream.bytesAvailable);
			}
			catch(e:Error){}
			fileStream.close();
			if(rawJSON != null)
				_json = JSON.decode(rawJSON);
			
			for each( var employeeImport:Object in _json.Employees  )
			{
				var employee:PersonVO = new PersonVO;
				employee.Name = employeeImport.name
				employee.cardID = employeeImport.cardid;
				employee.defaultRole = this.Roles[employeeImport.role];
				employee.created = employeeImport.created;
				employee.deleted = employeeImport.deleted;
					
				this.Employees.addItem(employee);
			}
			
			

			
		}
		public function writeEmployees():void
		{
			
			
			var file:File = File.documentsDirectory.resolvePath("employeesOUT"+this.eventDate+".csv");
			var fileStream:FileStream = new FileStream();
			
			var export:String = new String();
			export = "Name,CardID,Role,TimeIN,TimeOUT,TotalTime\r\n";
			for each(var entry:EntryVO in this._entries)
			{
				
				export += entry.person.Name + ',';
				export += entry.person.cardID+ ',';
				export += entry.person.defaultRole.Name+ ',';
				export += entry.startTime.timeStr+ ',';
				export += entry.stopTime.timeStr+ ',';
				var personSecondCount:Number = (entry.stopTime.timestamp - entry.startTime.timestamp);
				if( personSecondCount == 0 || isNaN(personSecondCount) )
				{
					export += 'inf';
				}
				else
				{
					var secStr:String = Math.floor( (personSecondCount%60) ).toString();
					if(secStr.length == 1)
						secStr = "0" + secStr;
					
					var minStr:String = Math.floor( ( (personSecondCount/60)%60 ) ).toString();
					if(minStr.length == 1)
						minStr = "0" + minStr
							
					var hourStr:String = Math.floor(  (personSecondCount/(60*60))%24 ).toString();
					if(hourStr.length == 1)
						hourStr = "0" + hourStr
					export += hourStr + ':' + minStr + ':' + secStr ;
				}
				export += '\r\n';
				
			}
			
			
			
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(export);
			fileStream.close();
		}
		public function setupLog():void
		{
			var date : Date = new Date();
			var filename:String = 'event' + date.getTime();
			var file:File = File.documentsDirectory.resolvePath(filename);
			var fileStream:FileStream = new FileStream();
			/*fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTF("test");
			fileStream.close();*/
		}

		public function readRoles():void
		{
			/*read roles.txt for Roles each employee can have*/
			var file:File = File.documentsDirectory.resolvePath("roles.txt");
			var fileStream:FileStream = new FileStream();
			var rawJSON:String;
			var _json:Object;
			
			fileStream.open(file, FileMode.READ);
			try{
				rawJSON = fileStream.readUTFBytes(fileStream.bytesAvailable);
			}
			catch(e:Error){}
			fileStream.close();
			if(rawJSON != null)
				_json = JSON.decode(rawJSON);
			
			for each( var roleImport:Object in _json.roles  )
			{
				var role:RoleVO = new RoleVO();
				role.Name = roleImport.label;
				role.Name_short = role.Name.substr(0,1);
				role.Index = roleImport.index;
				role.Rate = roleImport.rate;
				role.Color = roleImport.color;
				this.Roles.addItemAt(role,role.Index);
			}

			//add a role for being staged in an event
			var stagingRole:RoleVO = new RoleVO();
			stagingRole.Name = "staging";
			stagingRole.Name_short = "STG";
			stagingRole.Index = this.Roles.length;
			stagingRole.Rate = 0;
			stagingRole.Color = "ffffff";
			this.Roles.addItemAt(stagingRole,stagingRole.Index);
			this.stagingRole = stagingRole;
		}


		
		
	}
}