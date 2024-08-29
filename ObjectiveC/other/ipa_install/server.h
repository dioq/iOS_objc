#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <unistd.h> // read write
#include <stdlib.h>
#include <netinet/in.h>
#include <sys/socket.h> // socket
#include <sys/shm.h>
#include "lnkqueue.h"

struct Router
{
    char *uri;
    void *binding;
};

static char *server_ip;
static int server_port;

static int listen_max = 0x100; // 最大并发数量
static queue *qu;
static struct Router *routers;

static char *download_flag = "GET /download/";
static char *html_flag = "GET /html/";

typedef int (*CALLBACK)(int socket_fd);

int server_run(char *ip, int port, struct Router *router_list);
