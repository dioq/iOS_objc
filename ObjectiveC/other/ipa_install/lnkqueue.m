#include "lnkqueue.h"

int init_enqueue(queue **qu)
{
    *qu = (queue *)malloc(sizeof(queue));
    (*qu)->front = NULL;
    (*qu)->rear = NULL;
    
    // 初始化锁与条件等待条件
    pthread_mutex_init(&((*qu)->mutex), NULL);
    pthread_cond_init(&((*qu)->cond_for_dequeue), NULL);
    
    return 0;
}

int enqueue(queue *qu, datatype item)
{
    pthread_mutex_lock(&(qu->mutex)); // lock
    node *n;
    n = (node *)malloc(sizeof(node));
    n->data = item;
    n->next = NULL;
    if (qu->front == NULL) // 当前队列为空，新插入的结点为队列中的唯一结点
    {
        qu->front = qu->rear = n;
    }
    else
    {
        qu->rear->next = n;
        qu->rear = n;
    }
    pthread_cond_signal(&(qu->cond_for_dequeue)); // 通知阻塞的消费者
    
    pthread_mutex_unlock(&(qu->mutex)); // unlock
    return 0;
}

int dequeue(queue *qu, datatype *item)
{
    pthread_mutex_lock(&(qu->mutex)); // lock
    while (!(qu->front))              // 队列为空
    {
        pthread_cond_wait(&(qu->cond_for_dequeue), &(qu->mutex)); // 阻塞当前线程
    }
    node *n = qu->front;
    *item = n->data;
    
    qu->front = n->next;
    free(n);
    
    pthread_mutex_unlock(&(qu->mutex)); // unlock
    
    return 0;
}

// display all item
void display(queue *qu)
{
    node *n;
    n = qu->front;
    if (!n)
    {
        printf("The link queue is empty!\n");
        return;
    }
    while (n)
    {
        printf("%5d ", n->data);
        n = n->next;
    }
    puts("");
}
