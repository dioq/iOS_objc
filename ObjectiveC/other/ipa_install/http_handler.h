#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <string.h>
#include <errno.h>
#include <unistd.h> // read write
#include <stdlib.h>
#include <netinet/in.h>
#include <sys/socket.h> // socket
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

struct HTTP
{
    char *header;
    unsigned long header_length;
    char *body;
    unsigned long body_length;
};

static char server_document[0x100];
int set_server_docment(const char *document);

unsigned long get_content_length_http_header(char *header);
void add_http_header(char *header, char *content_type, unsigned long content_length);

// 解释 GET url 上的参数
int parse_http_url(char *http_header, char **param);

// 解析获取到的 http 请求
int get_HTTP(int socket_fd, struct HTTP *http);

// 给客护端发送 http 数据
int send_HTTP(int socket_fd, struct HTTP *http);

// 下载文件
int downlod_file(int socket_fd, char *file_name);
int send_file(int socket_fd, char *file_path);

// 接受文件
int receive_http_file(int sock_client, struct HTTP *http, char *save_path);

// 返回 html 网页
int return_html(int socket_fd, char *file_name);
