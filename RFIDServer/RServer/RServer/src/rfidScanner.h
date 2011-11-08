#include <windows.h>
#include <stdio.h>


#include "ftd2xx.h"

LONG findFTDIPortNumber()
{
	FT_HANDLE fthandle;
	FT_STATUS res;
	LONG COMPORT;

	res = FT_Open(0, &fthandle);

	if(res != FT_OK){
		printf("opening failed! with error %d\n", res);
		return 1;
	}
	
	res = FT_GetComPortNumber(fthandle,&COMPORT);

	if(res != FT_OK){
		printf("get com port failed %d\n", res);
		return 1;
	}

	if (COMPORT == -1){
		printf("no com port installed \n");
	}

	else{
		printf("com port number is %d\n", COMPORT);
	}

	FT_Close(fthandle);

	return COMPORT;
}

BOOL configureFTDIDevice(HANDLE hCommPort)
{
			DCB dcb;
		BOOL fSuccess;	

		fSuccess = GetCommState(hCommPort, &dcb);

		if (!fSuccess) 
		{
			return false;
		}

		//set parameters.

		dcb.BaudRate = 2400;
		dcb.ByteSize = 8;
		dcb.Parity = NOPARITY;
		dcb.StopBits = ONESTOPBIT;
		//dcb.fDsrSensitivity = 1;
		dcb.fDtrControl = DTR_CONTROL_ENABLE;

		fSuccess = SetCommState(hCommPort, &dcb);

		//set TimeOuts
		COMMTIMEOUTS timeouts;
 
		timeouts.ReadIntervalTimeout = 0; 
		timeouts.ReadTotalTimeoutMultiplier = 0;
		timeouts.ReadTotalTimeoutConstant = 0;
		timeouts.WriteTotalTimeoutMultiplier = 0;
		timeouts.WriteTotalTimeoutConstant = 100;
 
		fSuccess = SetCommTimeouts(hCommPort, &timeouts);
		
		if (!fSuccess) 
		{
			return false;
		}

		printf("Port configured \n");

		return true;
}