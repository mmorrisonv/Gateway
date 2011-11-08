//
// async_tcp_echo_server.cpp
// ~~~~~~~~~~~~~~~~~~~~~~~~~
//
// Copyright (c) 2003-2008 Christopher M. Kohlhoff (chris at kohlhoff dot com)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//

#include <cstdlib>
#include <iostream>
#include <boost/bind.hpp>
#include <boost/asio.hpp>

#include <windows.h>
#include <stdio.h>


#include "ftd2xx.h"

#include "rfidScanner.h"



using namespace std;
using boost::asio::ip::tcp;

int main(int argc, char* argv[])
{

	try
	{
		
		tcp::iostream stream;
		
		/*-------------------------------------------------------*/
		//setup server and wait for user
		/*-------------------------------------------------------*/
		boost::asio::io_service io_service;
		tcp::endpoint endpoint(tcp::v4(), 5524);
		tcp::acceptor acceptor(io_service, endpoint);
		

		//block-wait for user to connect
		acceptor.accept(*stream.rdbuf());
		printf("User Connected");

		/*-------------------------------------------------------*/
		//setup rfid
		/*-------------------------------------------------------*/
		char COMx[5];
		HANDLE hCommPort;

		LONG PortToOpen = findFTDIPortNumber();
		

		//open port
		sprintf_s(COMx, "COM%d",PortToOpen);
		hCommPort = CreateFile( COMx, GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL );

		if (hCommPort == INVALID_HANDLE_VALUE) 
		{
			printf("Help - failed to open\n");
			return(1);
		}	

		/*-------------------------------------------------------*/
		//configure serial device
		/*-------------------------------------------------------*/
			
		if(!configureFTDIDevice(hCommPort))
		{
			printf("GetCommStateFailed \n", GetLastError());
			return (2);
		}
		/*-------------------------------------------------------*/
		//report all rfid events
		/*-------------------------------------------------------*/
		DWORD data_len = 12;
		char buf[256];
		DWORD dwRead;

		Sleep(200);

		for (;;)
		{
			while(hCommPort != INVALID_HANDLE_VALUE)
			{

				memset(buf,0,256);
				EscapeCommFunction(hCommPort,SETDTR); // send DTR to device

				if (ReadFile(hCommPort, buf, data_len, &dwRead, NULL))
				{//block until read found
					printf("data read = %s\n", buf);
					stream<<buf;
				}
				EscapeCommFunction(hCommPort,CLRDTR); // send DTR to device

			}
		}
	}
	catch (std::exception& e)
	{
		std::cerr << e.what() << std::endl;
	}
	return 0;
}