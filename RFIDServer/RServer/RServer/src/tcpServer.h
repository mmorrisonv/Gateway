
#include <cstdlib>
#include <iostream>
#include <boost/bind.hpp>
#include <boost/asio.hpp>
#include <boost/smart_ptr.hpp>
#include <boost/thread.hpp>

using boost::asio::ip::tcp;
const int max_length = 1024;

typedef boost::shared_ptr<tcp::socket> socket_ptr;

void session(socket_ptr sock)
{
  try
  {
    for (;;)
    {
      char data[max_length];

      boost::system::error_code error;
      size_t length = sock->read_some(boost::asio::buffer(data), error);
      if (error == boost::asio::error::eof)
        break; // Connection closed cleanly by peer.
      else if (error)
        throw boost::system::system_error(error); // Some other error.

      boost::asio::write(*sock, boost::asio::buffer(data, length));
    }
  }
  catch (std::exception& e)
  {
    std::cerr << "Exception in thread: " << e.what() << "\n";
  }
}

socket_ptr server(boost::asio::io_service& io_service, short port)
{
  tcp::acceptor a(io_service, tcp::endpoint(tcp::v4(), port));
  //for (;;)//only get one client
    socket_ptr sock(new tcp::socket(io_service));
	
    a.accept(*sock);
    //boost::thread t(boost::bind(session, sock));
	return sock;
}