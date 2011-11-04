package com.poc.gateway.controller
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	
	import mx.controls.Alert;
	
	public class RFIDScanner
	{
		
		
		private var _socket:Socket;
		
		/**
		 * Constructor
		 */
		public function RFIDScanner()
		{
			// init socket connection for serial to tcp/ip bridge
			_socket = new Socket();
			_socket.addEventListener(Event.CONNECT, onConnect);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		/**
		 * connect to the biometric scanner socket.
		 */
		public function connect(scannerSocketIPAddr:String, scannerSocketPort:Number):void
		{
			_socket.connect(scannerSocketIPAddr, scannerSocketPort);
		}
		
		/**
		 * disconnect from the scanner.
		 */
		public function disconnect():void
		{
			_socket.close();
		}
		
		/**
		 * handles scanner connect successfult event.
		 */
		private function onConnect(event:Event):void
		{
			// dispatchEvent(...)
			trace('connect');
			Alert.show('connect');
		}
		
		/**
		 * on IO Error
		 */
		private function onIOError(event:IOErrorEvent):void
		{
			// dispatchEvent(...)  
			trace('fault');
			Alert.show('fault');
		}
		
		/**
		 * called when data received from the socket connection
		 * AKA the serial connection
		 */
		private function onSocketData(event:ProgressEvent):void
		{
			try
			{
				var temp:String = _socket.readMultiByte(_socket.bytesAvailable, "ISO-8859-1");
				trace('got something' + temp);
				Alert.show('got something' + temp);
				// process buffer, throw an event, whatever you want
				// processBuffer(temp);
			}
			catch(err:Error)
			{
				// TODO: throw exception or event
			}
		}
		
		/**
		 * send text command to scanner.
		 */
		public function sendSerialCommand(cmd:String):void
		{
			_socket.writeUTFBytes(cmd);
			_socket.flush();
		}
		
		
	}
}