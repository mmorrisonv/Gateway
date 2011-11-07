These are a bunch of files downloaded to figure out how to communicate with the FTDI device.
on the weekend of 11/05/2011

VCP_EX.zip
This example shows how to use Visual C++.NET to communicate with FTDI devices through FTD2XX.DLL.  This includes using FT_ListDevices, FT_Write and FT_Read with a loop-back connector to write data to the device and then read it back
I used this as a base to figure out how to open up the device and use it. Code was taken from here and placed in the final RFIDReaderProgram
from: http://www.ftdichip.com/Support/SoftwareExamples/CodeExamples/VC.htm
dlpvcc2.zip
Our thanks to DLP Design for contributing this application source code which illustrates how to integrate D2XX drivers into a Visual C++ project and use some of the basic functions available.
from:http://www.ftdichip.com/Support/SoftwareExamples/CodeExamples/VC.htm
RFID_Reader
Is a visual basic project, specifically for communicating wity my RFID device. taught me that baud needed to be 2400 etc.