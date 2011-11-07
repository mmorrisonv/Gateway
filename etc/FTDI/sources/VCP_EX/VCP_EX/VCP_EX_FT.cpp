/*
 * This software is supplied on an as-is basis and no warranty as to their suitability for any particular purpose is either 
 * made or implied. Future Technology Devices International Ltd. will not accept any claim for damages howsoever arising as 
 * a result of use or failure of this software. Your statutory rights are not affected. This software or any variant of it 
 * is not intended for use in any medical appliance, device or system in which the failure of the product might reasonably be 
 * expected to result in personal injury. This document provides preliminary information that may be subject to change 
 * without notice.
 * 
 */

/*
 * The following code assumes a FT232R chip is connected to a PC with the RXD pin and the TXD pin shorted together.
 * The FTDI VCP driver must be installed on the PC.
 * The first part of the code determines the com port assigned to the device automatically, so the user does not have to
 * check in device manager.
 *
 * This com port number is then then opened with the standard W32 Serial COM API calls.
 * Data is then sent to the device which will loop back on the wire used to short RXD to TXD and the application reads the
 * data to prove it looped round.
 */


#include "stdafx.h"
#include <windows.h>
#include <stdio.h>
#include "ftd2xx.h"

int main(int argc, char* argv[])
{
	FT_HANDLE fthandle;
	FT_STATUS res;
	LONG COMPORT;

	char COMx[5];
	int n;

	DCB dcb;
	BOOL fSuccess;	


/***********************************************************************
//Find the com port that has been assigned to your device.
/***********************************************************************/
	
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
	

/********************************************************/
// Search for (again) and Open the com port assigned to your device
/********************************************************/		
	FT_STATUS ftStatus; 
	FT_HANDLE ftDEVICEHandle; 
	char Buf[64]; 

	ftStatus = FT_ListDevices(0,Buf,FT_LIST_BY_INDEX|FT_OPEN_BY_DESCRIPTION); 

	//n = sprintf(COMx, "COM%d",COMPORT);

	ftDEVICEHandle = FT_W32_CreateFile(
		Buf,
		GENERIC_READ | GENERIC_WRITE,
		0,
		NULL,
		OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL | FT_OPEN_BY_DESCRIPTION,
		NULL
    );

	if (ftDEVICEHandle == INVALID_HANDLE_VALUE) 
	{
	
		printf("Help - failed to open\n");
		return(1);

	}	
			

	printf("Hello World!\n");
		
		
/********************************************************/
// Configure the UART interface parameters
/********************************************************/
		FTDCB ftDControlBlock; 
		if (!FT_W32_GetCommState(ftDEVICEHandle,&ftDControlBlock)){
		   // FT_W32_GetCommState ok, device state is in ftDCB 
			printf("GetCommStateFailed \n", FT_W32_GetLastError(ftDEVICEHandle));
			return (2);
		}



		//set parameters.
		
		ftDControlBlock.BaudRate = 2400;
		ftDControlBlock.ByteSize = 8;
		ftDControlBlock.Parity = NOPARITY;
		ftDControlBlock.StopBits = ONESTOPBIT;
		
		fSuccess = FT_W32_SetCommState(ftDEVICEHandle, &ftDControlBlock);
		

		if (!fSuccess) 
		{
			printf("SetCommStateFailed %s \n", FT_W32_GetLastError(ftDEVICEHandle));
			return (3);

		}

		FTTIMEOUTS ftTS;
		if (FT_W32_GetCommTimeouts(ftDEVICEHandle,&ftTS))
			; // FT_W32_GetCommTimeouts OK
		else
		; // FT_W32_GetCommTimeouts failed


		FT_W32_GetCommState(ftDEVICEHandle, &ftDControlBlock);

	
		ftTS.ReadIntervalTimeout = 0;
		ftTS.ReadTotalTimeoutMultiplier = 0;
		ftTS.ReadTotalTimeoutConstant = 1000;
		ftTS.WriteTotalTimeoutMultiplier = 0;
		ftTS.WriteTotalTimeoutConstant = 200;
		//set timeouts
		if (FT_W32_SetCommTimeouts(ftDEVICEHandle,&ftTS))
		; // FT_W32_SetCommTimeouts OK
		else
		; // FT_W32_SetCommTimeouts failed

	
		if (FT_W32_GetCommTimeouts(ftDEVICEHandle,&ftTS))
			; // FT_W32_GetCommTimeouts OK
		else
		; // FT_W32_GetCommTimeouts failed


		printf("Port configured \n");


/********************************************************/
// Writing data to the USB to UART converter
/********************************************************/

	/*DWORD dwwritten = 0, dwErr;
	char data_out[12] = "HELLO WORLD";
	DWORD w_data_len = 12;
			

	fSuccess = WriteFile(hCommPort, &data_out, w_data_len, &dwwritten, NULL);
	
		
		if (!fSuccess) 

		{
			dwErr = GetLastError();
			printf("Write Failed \n", GetLastError());
			return (4);

		}

		
		printf("bytes written = %d\n", dwwritten);*/
			
/********************************************************/
//Reading data from the USB to UART converter
/********************************************************/
		bool running = true;
		//while(hCommPort != INVALID_HANDLE_VALUE)
		//{
		char buf[12];
		DWORD dwActuallyRead;
		DWORD dwToRead = 12;
		bool result = false;
		OVERLAPPED osWrite = { 0 };
		memset(buf,0,12);

		//while(ftDEVICEHandle != INVALID_HANDLE_VALUE && running)
		//{

			if( FT_W32_ReadFile(ftDEVICEHandle, buf, dwToRead, &dwActuallyRead, NULL) )
			{
					
				if(dwActuallyRead != 0)
				{
					printf("data read = %s\n", &buf);

				}
				else
				{
					printf("read not what we want %s - error=%s\n",buf,FT_W32_GetLastError(ftDEVICEHandle));
				}
			}
			else
			{
				//FT_Readfile failed							
				printf("read failed %s - error=%s\n",buf,FT_W32_GetLastError(ftDEVICEHandle));
				running = false;
			}
				
		//}

/********************************************************/
//Closing the device at the end of the program
/********************************************************/


    FT_W32_CloseHandle(ftDEVICEHandle);

	getchar();
	return 0;
}