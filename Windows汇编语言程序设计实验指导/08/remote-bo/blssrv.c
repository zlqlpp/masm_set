//;程序清单：blssrc.c(远程缓冲区溢出攻击)
#ifndef unix
#include <windows.h>
#include <winsock.h> 
#else
#define closesocket close
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#endif

#include <stdio.h>
#include <string.h>
#pragma  comment(lib,"ws2_32")

#define PROTOPORT       5193            /* default protocol port number */
#define QLEN            6               /* size of request queue        */

unsigned char jmpesp[]="\xff\xe4";
PBYTE func1 = (PBYTE)LoadLibrary;
PBYTE func2 = (PBYTE)GetProcAddress;
PBYTE func3 = (PBYTE)sendto;

void process(char *buf, int n)
{
	char	in[89];

	memcpy(in, buf, n);
    fprintf(stdout, "received bytes: %d\n", n);
    fprintf(stdout, "received data : %s\n", in);
	_asm nop;
}
/*------------------------------------------------------------------------
 * Program:   server
 *
 * Purpose:   allocate a socket and then repeatedly execute the following:
 *              (1) wait for the next connection from a client
 *              (2) send a short message to the client
 *              (3) close the connection
 *              (4) go back to step (1)
 *
 * Syntax:    server [ port ]
 *
 *               port  - protocol port number to use
 *
 * Note:      The port argument is optional.  If no port is specified,
 *            the server uses the default given by PROTOPORT.
 *
 *------------------------------------------------------------------------
 */
main(argc, argv)
int     argc;
char    *argv[];
{
        struct  protoent *ptrp;  /* pointer to a protocol table entry   */
        struct  sockaddr_in sad; /* structure to hold server's address  */
        struct  sockaddr_in cad; /* structure to hold client's address  */
        int     sd, sd2;         /* socket descriptors                  */
        int     port;            /* protocol port number                */
        int     alen;            /* length of address                   */
        char    buf[1000];       /* buffer for string the server sends  */
        int	n;

#ifdef WIN32
        WSADATA wsaData;
        WSAStartup(0x0101, &wsaData);
#endif
	printf("&jmpesp=0x%08x\n", jmpesp);
	printf("LoadLibrary=0x%08x\n", *(UINT *)(func1+2));
	printf("GetProcAddress=0x%08x\n", *(UINT *)(func2+2));
/*
&jmpesp=0x00406030
LoadLibrary=0x00405004
GetProcAddress=0x00405000
*/	
        memset((char *)&sad,0,sizeof(sad)); /* clear sockaddr structure */
        sad.sin_family = AF_INET;         /* set family to Internet     */
        sad.sin_addr.s_addr = INADDR_ANY; /* set the local IP address   */

        /* Check command-line argument for protocol port and extract    */
        /* port number if one is specified.  Otherwise, use the default */
        /* port value given by constant PROTOPORT                       */

        if (argc > 1) {                 /* if argument specified        */
                port = atoi(argv[1]);   /* convert argument to binary   */
        } else {
                port = PROTOPORT;       /* use default port number      */
        }
        if (port > 0)                   /* test for illegal value       */
                sad.sin_port = htons((u_short)port);
        else {                          /* print error message and exit */
                fprintf(stderr,"bad port number %s\n",argv[1]);
                exit(1);
        }

        /* Map TCP transport protocol name to protocol number */

        if ( ((int)(ptrp = getprotobyname("tcp"))) == 0) {
                fprintf(stderr, "cannot map \"tcp\" to protocol number");
                exit(1);
        }

        /* Create a socket */

        sd = socket(PF_INET, SOCK_STREAM, ptrp->p_proto);
        if (sd < 0) {
                fprintf(stderr, "socket creation failed\n");
                exit(1);
        }

        /* Bind a local address to the socket */

        if (bind(sd, (struct sockaddr *)&sad, sizeof(sad)) < 0) {
                fprintf(stderr,"bind failed\n");
                exit(1);
        }

        /* Specify size of request queue */

        if (listen(sd, QLEN) < 0) {
                fprintf(stderr,"listen failed\n");
                exit(1);
        }

        /* Main server loop - accept and handle requests */

        while (1) {
                alen = sizeof(cad);
                if ( (sd2=accept(sd, (struct sockaddr *)&cad, &alen)) < 0) {
                        fprintf(stderr, "accept failed\n");
                        exit(1);
                }
                n = recv(sd2, buf, sizeof(buf), 0);
				{
				   *(UINT *)(buf+0x61-1) = jmpesp;					// "jmp esp"
				   *(UINT *)(buf+0x7e-1) = jmpesp;					// "jmp esp"
				   *(UINT *)(buf+0xda-1) = *(UINT *)(func1+2);		// LoadLibrary()
				   *(UINT *)(buf+0xf1-1) = *(UINT *)(func2+2);		// GetProcAddress()
				}
                process(buf, n);
		closesocket(sd2);
        }
}

