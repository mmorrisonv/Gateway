package com.poc.gateway.model.vo
{
	import flash.events.EventDispatcher;
	
	import spark.formatters.DateTimeFormatter;

	public class TimeVO extends EventDispatcher
	{
		public var timestamp : Number;
		public var timeStr : String;
		public var timeStrSml : String;
		private var _dateObj : Date;

		public function set dateObj(value:Date):void
		{
			var frmtr:spark.formatters.DateTimeFormatter = new spark.formatters.DateTimeFormatter();
			frmtr.dateTimePattern = "h:mm:ssa MM/dd";
			
			_dateObj = value;
			if(_dateObj!= null)
			{
				this.timestamp = Math.floor(_dateObj.getTime()/1000);
				this.timeStr = frmtr.format(_dateObj);
				
				frmtr.dateTimePattern = 'h:mm a';
				this.timeStrSml = frmtr.format(_dateObj);
			}
			else
			{
				this.timestamp = 0;
				this.timeStr = "inf";
				this.timeStrSml = "inf";
			}
		}


	}
}