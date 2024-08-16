//
//  local_server.c
//  ObjectiveC
//
//  Created by zd on 14/8/2024.
//  Copyright © 2024 my. All rights reserved.
//

#include "local_server.h"
#include <string.h>
#include <errno.h>
#include <unistd.h> // read write
#include <stdlib.h>
#include <netinet/in.h>
#include <sys/socket.h> // socket
#include <sys/shm.h>
#include <fcntl.h>
#include <sys/stat.h>

#define PORT 9000
static int listen_max = 20; // 最大并发数量

static char file_path[0x100] = {0};
static char file_name[0x100] = {0};

int init_property(const char *path,const char *name) {
    if (path != NULL && name != NULL) {
        memset(file_path, 0, 0x100);
        memcpy(file_path, path, strlen(path));
        memset(file_name, 0, 0x100);
        memcpy(file_name, name, strlen(name));
        //        printf("%s:%d file_path:%s\n", __FILE__, __LINE__,file_path);
        //        printf("%s:%d file_name:%s\n", __FILE__, __LINE__,file_name);
        return 0;
    }
    return -1;
}

static void send_http_header(int sock_client, unsigned long http_body_length)
{
    char *http_header = (char *)malloc(BUFSIZ);
    memset(http_header, '\0', BUFSIZ);
    
    sprintf(http_header, "HTTP/1.1 200 OK\r\n");
    sprintf(http_header, "%sServer: Apache Server V1.0\r\n", http_header);
    sprintf(http_header, "%sAccept-Ranges: bytes\r\n", http_header);
    sprintf(http_header, "%sConnection: close\r\n", http_header);
    if (http_body_length > 0)
    {
        sprintf(http_header, "%sContent-Length: %lu\r\n", http_header, http_body_length);
    }
    sprintf(http_header, "%sContent-Disposition: %s%s\r\n", http_header, "attachment; filename=", file_name);
    sprintf(http_header, "%sContent-Type: %s\r\n", http_header, "application/octet-stream");
    sprintf(http_header, "%s\r\n", http_header); // \r\n 换行后是 body
    
    if (send(sock_client, http_header, strlen(http_header), 0) < 0)
    {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
    }
    free(http_header);
}

static int send_http_body(int sock_client)
{
    char buff[BUFSIZ] = {0};
    unsigned long size_count = 0;
    int status = 0;
    
    status = access(file_path, F_OK);
    if (status == -1)
    {
        fprintf(stderr, "%s:%d file_path:%s error: %s\n", __FILE__, __LINE__,file_path, strerror(errno));
        return -1;
    }
    
    status = access(file_path, R_OK);
    if (status == -1)
    {
        fprintf(stderr, "%s:%d file_path:%s error: %s\n", __FILE__, __LINE__,file_path, strerror(errno));
        return -1;
    }
    
    FILE *fp = fopen(file_path, "rb+");
    if (fp == NULL)
    {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
        return -1;
    }
    
    // 循环将文件 fp 中的内容读取到 buff 中
    while ((size_count = fread(buff, sizeof(char), BUFSIZ, fp)) > 0)
    {
        if (send(sock_client, buff, size_count, 0) < 0)
        {
            fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
        }
    }
    
    fclose(fp);
    return 0;
}

static void http_response(int sock_client, char *buff, unsigned long len)
{
    printf("%s\n", buff);
    
    if (strncmp(buff, "HEAD", 4) == 0)
    {
        send_http_header(sock_client, 0);
    }
    else if (strncmp(buff, "GET", 3) == 0)
    {
        struct stat buf;
        int fd, ret;
        fd = open(file_path, O_RDONLY);
        ret = fstat(fd, &buf);
        if (ret != 0)
        {
            fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
        }
        
        send_http_header(sock_client, buf.st_size);
        send_http_body(sock_client);
    }
}

int server_start(void)
{
    // 定义 socket
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    // 定义 sockaddr_in
    struct sockaddr_in skaddr;
    skaddr.sin_family = AF_INET; // ipv4
    skaddr.sin_port = htons(PORT);
    skaddr.sin_addr.s_addr = INADDR_ANY;
    // bind  绑定 socket 和 sockaddr_in
    if (bind(sockfd, (struct sockaddr *)&skaddr, sizeof(skaddr)) == -1)
    {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
        return -1;
    }
    
    // listen  开始添加端口
    if (listen(sockfd, listen_max) == -1)
    {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
        return -1;
    }
    
    // 客户端信息
    char buff[BUFSIZ] = {0};
    struct sockaddr_in claddr;
    socklen_t length = sizeof(claddr);
    
    while (1)
    {
        int sock_client = accept(sockfd, (struct sockaddr *)&claddr, &length);
        if (sock_client < 0)
        {
            fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
            close(sock_client);
            //            break;
            goto over_pro;
        }
        memset(buff, 0, sizeof(buff));
        unsigned long len = recv(sock_client, buff, sizeof(buff), 0);
        // printf("recv len:%d\n", len);
        if (len < 0)
        {
            fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
            close(sock_client);
            //            break;
            goto over_pro;
        }
        
        http_response(sock_client, buff, len);
        close(sock_client);
    }
    
over_pro:
    close(sockfd);
    return 0;
}
