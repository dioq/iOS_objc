#include "server.h"

static int receive_task(void)
{
	int ret;
	int listen_fd, socket_fd;

	socklen_t addr_len = sizeof(struct sockaddr_in);
	socklen_t option = 1;
	struct sockaddr_in server_addr;
	struct sockaddr_in client_addr;

	server_addr.sin_family = AF_INET; // ipv4
	server_addr.sin_port = htons(server_port);
	server_addr.sin_addr.s_addr = INADDR_ANY;

	listen_fd = socket(AF_INET, SOCK_STREAM, 0);

	ret = setsockopt(listen_fd, SOL_SOCKET, SO_REUSEADDR, &option, sizeof(option));
	if (ret != 0)
	{
		fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
		return -1;
	}

	if (bind(listen_fd, (struct sockaddr *)&server_addr, addr_len) == -1)
	{
		fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
		return -1;
	}
	// listen 端口
	if (listen(listen_fd, listen_max) == -1)
	{
		fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
		return -1;
	}

	while (1)
	{
		socket_fd = accept(listen_fd, (struct sockaddr *)&client_addr, &addr_len);
		if (socket_fd < 0)
		{
			fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
			break;
		}
		if (enqueue(qu, socket_fd) != 0) // socket_fd 放入队列
		{
			printf("%s:%d error: enter queue!\n", __FILE__, __LINE__);
		}
	}

	close(listen_fd);

	return 0;
}

static int do_task(int *socket_fd_ptr)
{
	int ret, socket_fd;
	unsigned long len = 0;
	char buff[BUFSIZ] = {0};
	char uri[BUFSIZ] = {0};
	CALLBACK callback;
	struct Router router;

	socket_fd = *socket_fd_ptr;

	len = recv(socket_fd, buff, BUFSIZ, MSG_PEEK);
	if (len == -1)
	{
		fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
		return -1;
	}
    
    for (unsigned long i = 0; i < len; i++) {
        printf("%c",buff[i]);
    }
    puts("");

	// 文件下载特殊处理
	if (strncmp(buff, download_flag, strlen(download_flag)) == 0)
	{
		for (unsigned long i = 0; i < 0x100; i++)
		{
			router = routers[i];
			if (router.uri == NULL)
			{
				continue;
			}
			// printf("%s:%d router:%s\n", __FUNCTION__, __LINE__, router.uri);
			if (strncmp(router.uri, download_flag, strlen(download_flag)) == 0) // 匹配路由
			{
				// printf("%s:%d router:%s\n", __FUNCTION__, __LINE__, router.uri);
				callback = (CALLBACK)(router.binding); // 绑定回调函数
				ret = callback(socket_fd);			   // 调用回调函数
				if (ret != 0)
				{
					printf("%s:%d callback fail!\n", __FUNCTION__, __LINE__);
				}
				break;
			}
		}
		goto end;
	}

	// 返回 html
	if (strncmp(buff, html_flag, strlen(html_flag)) == 0)
	{
		for (unsigned long i = 0; i < 0x100; i++)
		{
			router = routers[i];
			if (router.uri == NULL)
			{
				continue;
			}
			if (strncmp(router.uri, html_flag, strlen(html_flag)) == 0) // 匹配路由
			{
				// printf("%s:%d router:%s\n", __FUNCTION__, __LINE__, router.uri);
				callback = (CALLBACK)(router.binding); // 绑定回调函数
				ret = callback(socket_fd);			   // 调用回调函数
				if (ret != 0)
				{
					printf("%s:%d callback fail!\n", __FUNCTION__, __LINE__);
				}
				break;
			}
		}
		goto end;
	}

	// 返回 restfull api
	for (unsigned long i = 0; i < 0x100; i++)
	{
		router = routers[i];
		if (router.uri == NULL)
		{
			continue;
		}

		memset(uri, 0, BUFSIZ);
		sprintf(uri, "%s HTTP/1.1", router.uri);
		if (strncmp(buff, uri, strlen(uri)) == 0) // 匹配路由
		{
			callback = (CALLBACK)(router.binding); // 绑定回调函数
			ret = callback(socket_fd);			   // 调用回调函数
			if (ret != 0)
			{
				printf("%s:%d callback fail!\n", __FUNCTION__, __LINE__);
			}
			break;
		}
	}

end:
	close(socket_fd);
	return 0;
}

static int dispatcher(void) // 调度任务
{
	int ret, socket_fd;
	while (1)
	{
		ret = dequeue(qu, &socket_fd); // 从队列里去 socket_fd
		if (ret != 0)
		{
			return -1;
		}
		pthread_t tid;
		ret = pthread_create(&tid, NULL, (void *)do_task, &socket_fd);
		if (ret != 0)
		{
			fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
			return -1;
		}
	}

	return 0;
}

int server_run(char *ip, int port, struct Router *router_list)
{
	int ret;
	// 声明线程
	pthread_t thread1, thread2;

	server_ip = ip;
	server_port = port;

	routers = router_list;

	init_enqueue(&qu); // 初始化队列

	// 创建线程
	ret = pthread_create(&thread1, NULL, (void *)receive_task, NULL);
	if (ret != 0)
	{
		printf("thread-1 create failed: %d\n", ret);
	}

	// 创建线程
	ret = pthread_create(&thread2, NULL, (void *)dispatcher, NULL);
	if (ret != 0)
	{
		printf("thread-2 create failed: %d\n", ret);
	}

	pthread_join(thread1, NULL);
	pthread_join(thread2, NULL);

	return 0;
}
