//
//  service.c
//  iOS_ipa
//
//  Created by zd on 16/8/2024.
//

#include "service.h"

int test_get(int socket_fd)
{
    struct HTTP *request = (struct HTTP *)malloc(sizeof(struct HTTP));
    get_HTTP(socket_fd, request);
    printf("%s\n", request->header);
    
    struct HTTP *response = (struct HTTP *)malloc(sizeof(struct HTTP));
    
    char *http_body = "{\"code\":200,\"msg\":\"This is GET return data\"}";
    char *http_header = (char *)malloc(BUFSIZ);
    memset(http_header, 0, BUFSIZ);
    add_http_header(http_header, "application/json", strlen(http_body));
    
    response->header_length = strlen(http_header);
    response->header = http_header;
    response->body_length = strlen(http_body);
    response->body = (char *)malloc(response->body_length);
    memcpy(response->body, http_body, response->body_length);
    
    send_HTTP(socket_fd, response);
    
    free(response->body);
    free(response->header);
    free(response);
    
    free(request->header);
    free(request);
    
    return 0;
}

int test_post(int socket_fd)
{
    struct HTTP *request = (struct HTTP *)malloc(sizeof(struct HTTP));
    get_HTTP(socket_fd, request);
    printf("%s\n", request->header);
    printf("%s\n", request->body);
    
    struct HTTP *response = (struct HTTP *)malloc(sizeof(struct HTTP));
    
    char *http_body = "{\"code\":200,\"msg\":\"This is POST return data\"}";
    char *http_header = (char *)malloc(BUFSIZ);
    memset(http_header, 0, BUFSIZ);
    add_http_header(http_header, "application/json", strlen(http_body));
    
    response->header_length = strlen(http_header);
    response->header = http_header;
    response->body_length = strlen(http_body);
    response->body = (char *)malloc(response->body_length);
    memcpy(response->body, http_body, response->body_length);
    
    send_HTTP(socket_fd, response);
    
    free(response->body);
    free(response->header);
    free(response);
    
    free(request->header);
    free(request->body);
    free(request);
    
    return 0;
}

int test_download(int socket_fd)
{
    struct HTTP *request = (struct HTTP *)malloc(sizeof(struct HTTP));
    get_HTTP(socket_fd, request);
    printf("%s\n", request->header);
    
    char *file_name = NULL;
    parse_http_url(request->header, &file_name);
    // printf("%d file_name:%s\n", __LINE__, file_name);
    
    downlod_file(socket_fd, file_name);
    
    free(file_name);
    free(request->header);
    free(request);
    
    return 0;
}

int test_upload(int socket_fd)
{
    struct HTTP *request = (struct HTTP *)malloc(sizeof(struct HTTP));
    
    char *file_name = "test.png";
    char file_path[0x100] = {0};
    sprintf(file_path, "./upload/%s", file_name);
    receive_http_file(socket_fd, request, file_path);
    
    printf("%s\n", request->header);
    
    struct HTTP *response = (struct HTTP *)malloc(sizeof(struct HTTP));
    
    char *http_body = "{\"code\":200,\"msg\":\"file upload success\"}";
    char *http_header = (char *)malloc(BUFSIZ);
    memset(http_header, 0, BUFSIZ);
    add_http_header(http_header, "application/json", strlen(http_body));
    
    response->header_length = strlen(http_header);
    response->header = http_header;
    response->body_length = strlen(http_body);
    response->body = (char *)malloc(response->body_length);
    memcpy(response->body, http_body, response->body_length);
    
    send_HTTP(socket_fd, response);
    
    free(response->body);
    free(response->header);
    free(response);
    
    free(request->header);
    free(request);
    
    return 0;
}

int get_html(int socket_fd)
{
    struct HTTP *request = (struct HTTP *)malloc(sizeof(struct HTTP));
    get_HTTP(socket_fd, request);
    printf("%s\n", request->header);
    
    char *file_name = NULL;
    parse_http_url(request->header, &file_name);
    
    return_html(socket_fd, file_name);
    
    free(file_name);
    free(request->header);
    free(request);
    
    return 0;
}


int server_start(void) {
    struct Router routers[0x100] = {0};
    
    routers[0].uri = "GET /test_get";
    routers[0].binding = &test_get;
    
    routers[1].uri = "POST /test_post";
    routers[1].binding = &test_post;
    
    routers[2].uri = "GET /download/";
    routers[2].binding = &test_download;
    
    routers[3].uri = "POST /upload";
    routers[3].binding = &test_upload;
    
    routers[4].uri = "GET /html/";
    routers[4].binding = &get_html;
    
    server_run("0.0.0.0", 9001, routers);
    
    return 0;
}
