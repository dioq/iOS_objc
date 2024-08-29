#include "http_handler.h"

int set_server_docment(const char *document) {
    if (document != NULL) {
        memset(server_document, 0, 0x100);
        memcpy(server_document, document, strlen(document));
    }
    return 0;
}

int parse_http_url(char *http_header, char **param)
{
    char *end_vaddr = strstr(http_header, " HTTP/1.1");
    if (end_vaddr == NULL)
    {
        printf("%s:%d enter not match\n", __FILE__, __LINE__);
        return -1;
    }
    unsigned long url_len = (unsigned long)(end_vaddr - http_header);
    
    char *url = (char *)malloc(0x100);
    memset(url, 0, 0x100);
    memcpy(url, http_header, url_len);
    
    char *ptr = strsep(&url, "/");
    // printf("%d: %s\n", __LINE__, ptr);
    ptr = strsep(&url, "/");
    // printf("%d: %s\n", __LINE__, ptr);
    ptr = strsep(&url, "/");
    // printf("%d: %s\n", __LINE__, ptr);
    
    *param = (char *)malloc(0x100);
    memset(*param, 0, 0x100);
    memcpy(*param, ptr, strlen(ptr));
    
    free(url);
    return 0;
}

unsigned long get_content_length_http_header(char *header)
{
    unsigned long content_length = 0;
    char *content_info = strstr(header, "Content-Length:");
    if (content_info == NULL)
    {
        //        printf("%s:%d Content-Length not match\n", __FILE__, __LINE__);
        return 0;
    }
    content_info += strlen("Content-Length:");
    content_length = strtoul(content_info, NULL, 10);
    if (content_length == 0)
    {
        printf("%s:%d Content-Length is not a vaild number\n", __FILE__, __LINE__);
    }
    
    return content_length;
}

void add_http_header(char *header, char *content_type, unsigned long content_length)
{
    strcat(header, "HTTP/1.1 200 OK\r\n");
    strcat(header, "Server: Apache Server V1.0\r\n");
    strcat(header, "Accept-Ranges: bytes\r\n");
    strcat(header, "Connection: close\r\n");
    if (content_length > 0)
    {
        sprintf(header, "%sContent-Length: %lu\r\n", header, content_length);
    }
    if (content_type != NULL)
    {
        sprintf(header, "%sContent-Type: %s\r\n", header, content_type);
    }
    
    strcat(header, "\r\n");
}

int get_HTTP(int socket_fd, struct HTTP *http)
{
    char buff[BUFSIZ] = {0};
    unsigned long index = 0, len = 0;
    len = recv(socket_fd, buff, BUFSIZ, MSG_PEEK);
    if (len == -1)
    {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
        return -1;
    }
    char *header_end_position = strstr(buff, "\r\n\r\n"); // http header 和 http body 以 \r\n\r\n 作为分割
    if (header_end_position == NULL)
    {
        printf("%s:%d enter not match\n", __FILE__, __LINE__);
        return -1;
    }
    header_end_position += strlen("\r\n\r\n"); // header 结束的位置
    http->header_length = (unsigned long)(header_end_position - buff);
    http->header = (char *)malloc(http->header_length);
    
    len = recv(socket_fd, http->header, http->header_length, 0);
    if (len == -1)
    {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
        return -1;
    }
    
    // 获取 header Content-Length
    http->body_length = get_content_length_http_header(http->header);
    if (http->body_length <= 0)
    {
        return 0;
    }
    
    http->body = (char *)malloc(http->body_length);
    char *body = http->body;
    while (index < http->body_length)
    {
        len = recv(socket_fd, body + index, BUFSIZ, 0);
        if (len == -1)
        {
            fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
            return -1;
        }
        index += len;
    }
    
    return 0;
}

static int send_response_data(int socket_fd, char *buff, unsigned long buff_len)
{
    unsigned long index = 0, len = 0, order_len = 0;
    while (index < buff_len)
    {
        order_len = buff_len - index;
        // printf("%s:%d order_len:%lu\n", __FILE__, __LINE__, order_len);
        len = send(socket_fd, buff + index, order_len, 0);
        if (len == -1)
        {
            fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
            return -1;
        }
        index += len;
    }
    return 0;
}

int send_HTTP(int socket_fd, struct HTTP *http)
{
    if (http->header != NULL)
    {
        send_response_data(socket_fd, http->header, http->header_length);
    }
    
    if (http->body != NULL)
    {
        send_response_data(socket_fd, http->body, http->body_length);
    }
    return 0;
}

int send_file(int socket_fd, char *file_path)
{
    char buff[BUFSIZ] = {0};
    int fd = open(file_path, O_RDONLY);
    if (fd == -1)
    {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
        return -1;
    }
    unsigned long len = 0;
    // 循环将文件 fd 中的内容读取到 buff 中
    while ((len = read(fd, buff, BUFSIZ)) != 0)
    {
        if (len == -1) // I/O 错误
        {
            fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
            break;
        }
        if (send(socket_fd, buff, len, 0) == -1)
        {
            fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
            return -1;
        }
    }
    close(fd);
    
    return 0;
}

int downlod_file(int socket_fd, char *file_name)
{
    char file_path[0x100] = {0};
    sprintf(file_path, "%s/%s",server_document, file_name);
    printf("%s:%d file_path:%s\n",__FUNCTION__,__LINE__,file_name);
    struct stat buf;
    int status = stat(file_path, &buf);
    if (status == -1)
    {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
        return -1;
    }
    
    char *http_header = (char *)malloc(BUFSIZ);
    memset(http_header, 0, BUFSIZ);
    strcat(http_header, "HTTP/1.1 200 OK\r\n");
    strcat(http_header, "Server: Apache Server V1.0\r\n");
    strcat(http_header, "Accept-Ranges: bytes\r\n");
    strcat(http_header, "Connection: close\r\n");
    sprintf(http_header, "%sContent-Length: %lld\r\n", http_header, buf.st_size);
    sprintf(http_header, "%sContent-Type: %s\r\n", http_header, "application/octet-stream");
    sprintf(http_header, "%sContent-Disposition: attachment; filename=%s\r\n", http_header, file_name);
    strcat(http_header, "\r\n");
    
    struct HTTP *response = (struct HTTP *)malloc(sizeof(struct HTTP));
    response->header_length = strlen(http_header);
    response->header = http_header;
    
    send_HTTP(socket_fd, response);
    send_file(socket_fd, file_path);
    
    free(response->header);
    free(response);
    
    return 0;
}

int receive_http_file(int sockect_fd, struct HTTP *http, char *save_path)
{
    char buff[BUFSIZ] = {0};
    unsigned long index = 0, len = 0, header_len = 0, content_length = 0, write_len = 0;
    len = recv(sockect_fd, buff, BUFSIZ, MSG_PEEK);
    // printf("%s:%d len:%lu\n", __FILE__, __LINE__, len);
    if (len == -1)
    {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
        return -1;
    }
    char *header_end_position = strstr(buff, "\r\n\r\n"); // http header 和 http body 以 \r\n\r\n 作为分割
    if (header_end_position == NULL)
    {
        printf("%s:%d enter not match\n", __FILE__, __LINE__);
        return -1;
    }
    header_end_position += strlen("\r\n\r\n"); // header 结束的位置
    header_len = (unsigned long)(header_end_position - buff);
    
    len = recv(sockect_fd, buff, header_len, 0);
    // printf("%s:%d len:%lu\n", __FILE__, __LINE__, len);
    if (len == -1)
    {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
        return -1;
    }
    if (http != NULL)
    {
        http->header_length = header_len;
        http->header = (char *)malloc(http->header_length);
        memcpy(http->header, buff, http->header_length);
    }
    // for (int i = 0; i < len; i++)
    // {
    //     printf("%c", buff[i]);
    // }
    
    // 准备把接收的数据写到本地文件里
    int fd = open(save_path, O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
    if (fd == -1)
    {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
        return -1;
    }
    
    // 获取 header Content-Length
    content_length = get_content_length_http_header(buff);
    
    while (index < content_length)
    {
        len = recv(sockect_fd, buff, BUFSIZ, 0);
        // printf("%s:%d len:%lu\n", __FILE__, __LINE__, len);
        if (len == -1)
        {
            fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
            return -1;
        }
        write_len = write(fd, buff, len);
        if (write_len == -1)
        {
            fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
            return -1;
        }
        index += len;
    }
    close(fd);
    
    return 0;
}

int return_html(int socket_fd, char *file_name)
{
    char file_path[0x100] = {0};
    sprintf(file_path, "%s/%s",server_document, file_name);
    struct stat buf;
    int status = stat(file_path, &buf);
    if (status == -1)
    {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
        return -1;
    }
    
    struct HTTP *response = (struct HTTP *)malloc(sizeof(struct HTTP));
    
    char *http_header = (char *)malloc(BUFSIZ);
    memset(http_header, 0, BUFSIZ);
    add_http_header(http_header, "text/html; charset=utf-8", buf.st_size);
    response->header_length = strlen(http_header);
    response->header = http_header;
    
    send_HTTP(socket_fd, response);
    send_file(socket_fd, file_path);
    
    free(response->header);
    free(response);
    
    return 0;
}
