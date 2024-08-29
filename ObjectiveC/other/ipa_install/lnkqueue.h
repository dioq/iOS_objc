#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>

typedef int datatype;

typedef struct link_node
{
    datatype data;			// 节点保存的数据
    struct link_node *next; // 下一个节点
} node;

typedef struct
{
    node *front;					 // 队首指针
    node *rear;						 // 队尾指针
    pthread_mutex_t mutex;			 // 锁
    pthread_cond_t cond_for_dequeue; // 线程等待条件
} queue;

// init queue
int init_enqueue(queue **qu);
// 进队列
int enqueue(queue *qu, datatype item);
// 出队列
int dequeue(queue *qu, datatype *item);

// display all item
void display(queue *qu);
