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


//#include "ftd2xx.h"

#include "rfidScanner.h"



using namespace std;
using boost::asio::ip::tcp;

int main(int argc, char* argv[])
{

	try
	{
		boost::asio::io_service io_service;

		tcp::endpoint endpoint(tcp::v4(), 5524);
		tcp::acceptor acceptor(io_service, endpoint);
		tcp::iostream stream;

		//block-wait for user to connect
		acceptor.accept(*stream.rdbuf());
		printf("User Connected");
		for (;;)
		{
			//ReadFromDevice();
			stream << "test";
			Sleep(2000);
		}
	}
	catch (std::exception& e)
	{
		std::cerr << e.what() << std::endl;
	}
	return 0;
}