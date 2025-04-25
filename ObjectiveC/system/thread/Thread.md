# 多线程

## 信号量

// 1、创建一个值为n信号量
dispatch_semaphore_t semaphore = dispatch_semaphore_create(n);

// 2、如果该信号量的值大于0，则使其信号量的值-1；否则阻塞线程直到该信号量的值大于0或者达到等待时间。
dispatch_semaphore_wait(semaphore，DISPATCH_TIME_FOREVER)；

// 3、释放信号量，使得该信号量的值加1
dispatch_semaphore_signal(信号量)
