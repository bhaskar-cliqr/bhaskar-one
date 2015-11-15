/*******************************************************************************
* <COPYRIGHT_START>
*
*                               NOTICE
*
*                    COPYRIGHT 1998...2002 GADZOOX NETWORKS
*                          ALL RIGHTS RESERVED
*
*  This computer program is copyrighted and contains confidential and
*  proprietary information and is a TRADE SECRET of GADZOOX NETWORKS.
*  The receipt or possession of this program does not convey
*  rights to reproduce or disclose its contents, or to manufacture, use,
*  or sell anything that it may describe, in whole or in part, outside of a
*  specific written licensing agreement with GADZOOX NETWORKS.
*  Any reproduction of this program outside the specifications of a
*  licensing agreement with GADZOOX NETWORKS is a violation of the copyright
*  laws and may subject you to criminal prosecution.
*
*  Although efforts have been made to assure that this source code is correct,
*  reliable, and technically accurate, the source code is licensed to Licensee
*  as is and without warranties as to performance of merchantability, fitness
*  for a particular purpose or use, or any other warranties whether expressed
*  or implied. Licensee's organization and all users of the source code assume
*  all risks when using it.  Gadzoox Networks shall not be liable for any
*  consequential, incidental, punitive or special damages arising out of the
*  use of or inability to use the source code.
*
*
*  Identification: $Id: EventTransporter.c,v 1.0 2003/08/14 11:03:10 cvsadmin Exp $
*
*  Modules:
*
*  Description:
*
*  History:
*
*  $Log: EventTransporter.c,v $
*  Revision 1.0  2003/08/14 11:03:10  cvsadmin
*  After following proper indentation ( removing hard tabs ) and
*  adding the history ( with copyright of Gadzoox ) in each file.
*
*
* </COPYRIGHT_END>
******************************************************************************/

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h> 
#include <fcntl.h>
#include <netinet/tcp.h>
#include <sys/poll.h>
#include <sys/select.h>
#include <sys/time.h>

#define NUM_OF_EVENTS 12
#define MIN_ARGS      5
#define SwMaxNumDomains 256
/* BaseManagerPortId, the base value of the linux port id 
 * that is opened to establish a connection with 
 * the Event-Receiver. This macro-value should not 
 * be changed. If changed, then the same value has to
 * to be duplicated in the header file, "head.h" of Event-
 * Receiver ( where files such as mainDriver.c, transport.c 
 * and head.h files are there ) also.
 */
#define BaseManagerPortId 9000
/* SwMaxDomains should be same as the macro-value of
 * SwMaxNumDomains defined in alFab.h */
#define SwMaxDomains SwMaxNumDomains

struct mngrData
{
    uint32_t srcSwId;
    uint32_t nbrSwId;
    uint32_t srcDomainId;
    uint32_t sourcePort;
    uint32_t nbrDomainId;
    uint32_t nbrPort;
    char     destIpAddr[16];
    uint32_t eventType;
} data;

typedef enum { 
               EventEportUp=4,
               EventEportDown,
               EventBrdcastPortMask,
	       EventDomainAssigned,
               EventDomainInvalid,
	       TimerExpired,
               EventRtReqNumEntries=17,
               EventRtTable=19,
               EventGetRoute,
               EventPortUpMask,
               EventSnapshot,
               EventPortUp = 29,
               EventPortDown
}event_t;

struct eventList
{
    char *str;
    event_t eventType;
    
} events[] = { {"EventDomainAssigned",      EventDomainAssigned      },
               {"EventDomainInvalid",       EventDomainInvalid       },
               {"EventPortUp",              EventPortUp              },
               {"EventPortDown",            EventPortDown            },
               {"EventEportUp",             EventEportUp             },
               {"EventEportDown",           EventEportDown           },
               {"EventRtReqNumEntries",     EventRtReqNumEntries     },
               {"EventRtTable",             EventRtTable             },
               {"EventGetRoute",            EventGetRoute            },
               {"EventPortUpMask",          EventPortUpMask          },
               {"EventBrdcastPortMask",     EventBrdcastPortMask     }, 
               {"EventSnapshot",            EventSnapshot            } 
             };

/**************************************************************************
* function    : send_data 
* Description : This function  creates a socket to by getting the 
*               domainId of the neighbour.This function sends the message to 
*               another switch through socket interface.
*               next staus pf the port
*
* Input       : message 

* Output      : success/Failure    
*************************************************************************/

int send_data ( struct mngrData *message, char *destIpAddr ) 
{
     int sockfd,ret ;
     struct sockaddr_in servAddr;
     struct hostent *h;
     uint16_t portId; 
   
     if ( message->srcDomainId < 0 ) 
         portId = BaseManagerPortId +  ( -message->srcDomainId ) % SwMaxDomains;
     else
         portId = BaseManagerPortId + message->srcDomainId % SwMaxDomains;
     /* create socket */
     sockfd = socket ( AF_INET, SOCK_DGRAM, 0 );
     if ( sockfd < 0 ) 
     {
        perror ( "SOCKET sending " );
        return ( -1 );
     }

     /* Get the hostname by Ipaddress */     
     h = gethostbyname ( destIpAddr );
     if ( h == NULL ) 
     {
        return 1;
     }
     servAddr.sin_family = h->h_addrtype;
     memcpy ( ( char * ) &servAddr.sin_addr.s_addr, h->h_addr_list[0],h->h_length );
     servAddr.sin_port = htons ( portId );
     /*
      * send the message now: two sendto calls are made to ensure the both payld 
      * and payld length sre sent properly at the recv end two recvfrom calls are 
      * made to recv it in proper order 
      */ 
      ret = sendto ( sockfd, message, sizeof ( struct mngrData ) , 0 ,
                   ( struct sockaddr * ) &servAddr, sizeof ( servAddr ) );
      /* close socket and exit */
      close ( sockfd );
      return ( ret );
} /* End of send_data ( ) */


/* Main Starts here */        
int main ( int argc, char * argv[] ) 
{
    struct   mngrData data;
    uint32_t srcDomainId, sourcePort, nbrDomainId, nbrPort, event;
    int      count = 1;

    data.srcSwId = data.nbrSwId = 0;

    /* Check if we got atleast minimum number of arguments */
    if ( argc < MIN_ARGS ) 
    return -1;
    
    count=0;
    while ( ( strcmp ( argv[1], events[count].str ) != 0 ) 
            && count < NUM_OF_EVENTS ) 
    {
        count++;
    }
    
    if ( count == NUM_OF_EVENTS ) 
        return -1;
    
    event = data.eventType = events[count].eventType;
    srcDomainId = atoi ( argv[2] );
    
    switch ( events[count].eventType ) 
    {
        case EventDomainAssigned      : /* All these 7 events are sent to only one Agent */
        case EventDomainInvalid       : 
        case EventRtTable             :
        case EventPortUpMask          :
        case EventBrdcastPortMask     : 
        case EventRtReqNumEntries     :
        case EventSnapshot            :
            data.srcDomainId = srcDomainId;
	    data.sourcePort  = atoi ( argv[4] );
            send_data ( &data, argv[3] );
            break;
            
        case EventPortUp              :  /* ALL These 4 Events are send to Both Agents */
        case EventPortDown            :  /* SrcDomainID-Agent and DestDomainId-Agent   */
        case EventEportUp             :
        case EventEportDown           :
            sourcePort = atoi ( argv[4] );
            nbrDomainId = atoi ( argv[5] );
            nbrPort = atoi ( argv[7] );
            /* Send to Second Agent */
            data.srcDomainId = nbrDomainId;
            data.sourcePort = nbrPort;
            data.nbrDomainId = srcDomainId;
            data.nbrPort = sourcePort;
            strcpy ( data.destIpAddr, argv[3] );
            send_data ( &data, argv[6] );
        case EventGetRoute            :
            sourcePort = atoi ( argv[4] );
            nbrDomainId = atoi ( argv[5] );
            nbrPort = atoi ( argv[7] );
            /* Send to First Agent  */    
            bzero ( &data, sizeof ( data ) );
            data.eventType = event;
            data.srcDomainId = srcDomainId;
            data.sourcePort = sourcePort;
            data.nbrDomainId = nbrDomainId;
            data.nbrPort = nbrPort;
            strcpy ( data.destIpAddr, argv[6] );
            send_data ( &data, argv[3] );
            break;
        default                       :
            break;
    }
  return 0;
}
