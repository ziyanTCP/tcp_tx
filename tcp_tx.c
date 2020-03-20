#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <time.h>

#include <rte_ethdev.h>


//change it to the path for the ziyan_tcpstack
#include "/home/ziyan/Dropbox/mylibrary/ziyan_tcpstack/lib/dpdk_utility.h"

static time_t t1;
static uint64_t packet_count = 0;

static void exit_stats(int sig)
{
	time_t total_time;
	total_time = time(NULL) - t1;
	printf("Caught signal %d\n", sig);
	printf("\n=============== Stats =================\n");
	printf("Total packets: %lu\n", packet_count);
	printf("Total transmission time: %ld seconds\n", total_time);
	printf("Average transmission rate: %lu pps\n", packet_count / total_time);
	printf("                           %lu Mbps\n", ((packet_count * TX_PACKET_LENGTH * 8) / total_time) / 1000000);
	printf("=======================================\n");
    printf("Free the space\n");
	exit(0);
}





int main(int argc, char **argv)
{

	int mac_flag=0,ip_src_flag=0,ip_dst_flag=0;

	signal (SIGINT, exit_stats);

    rte_be32_t ip_src_addr, ip_dst_addr;
    struct rte_ether_addr my_addr; // SRC MAC address of NIC
    struct rte_ether_addr eth_dst_addr;
    struct rte_mempool* mbuf_pool;
    mbuf_pool= dpdk_init(&argc,&argv);

    int c=0;
	while ((c = getopt(argc, argv, "m:s:d:h")) != -1)
		switch(c) {
		case 'm':
            eth_dst_addr=mac_string_to_rte_ether_addr(optarg);
			mac_flag=1;
			break;
		case 's':
            ip_src_addr= ip_string_to_rte_be32_t(optarg);
			ip_src_flag=1;
			break;
        case 'd':
            ip_dst_addr = ip_string_to_rte_be32_t(optarg);
            ip_dst_flag=1;
            break;
		case 'h':
			printf("usage -- -m [dst MAC] -s [src IP] -d [dst IP]\n");
			exit(0);
		}

	if(mac_flag==0) {
		fprintf(stderr, "missing -m for destination MAC adress\n");
		exit(1);
	}
	if(ip_src_flag==0) {
                fprintf(stderr, "missing -s for IP source adress\n");
                exit(1);
        }
    if(ip_dst_flag==0) {
            fprintf(stderr, "missing -d for IP destination adress\n");
            exit(1);
    }


    struct rte_mbuf * pkt= rte_mbuf_raw_alloc( mbuf_pool);
    struct rte_mbuf *recv_pkt= rte_mbuf_raw_alloc( mbuf_pool);
    char data[]="hello world this is my tcp stack from song";

    t1 = time(NULL);



    do {
        menu(pkt,recv_pkt, data, ip_src_addr,ip_dst_addr,my_addr, eth_dst_addr);
    } while (c != '.');

    //send_ip_packet(pkt,data,ip_src_addr,ip_dst_addr,my_addr,eth_dst_addr);
    while(1){
        //send_ip_packet(pkt,data,src_addr,dst_addr,my_addr,eth_dst_addr);
        //packet_count++;
        exit(1);
    }
	return(0);
}
