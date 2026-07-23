# RabbitMQ wiht Spring Boot

Compile all projects from root folder

```bash
mvn clean install
```

## RabbitMQ features

RabbitMQ offers two primary queue types, _Classic Queues_ and _Quorum Queues_. Classic Queues are the original type, designed for high throughput but vulnerable to data loss in clusters. Quorum Queues are the modern, recommended standard, built for high data safety and fault tolerance.

Here is a quick breakdown of both queue types:

1. Classic Queues

&nbsp;&nbsp;&nbsp;&nbsp;Classic Queues are the lightweight, traditional FIFO (First-In, First-Out) queues.

- _How they work:_ The queue resides entirely on a single node. If that specific node goes down, the messages become unavailable or are lost unless specifically mirrored.
- _Best used for:_ Single-node setups, high-throughput systems, low-latency messaging, or stateless, non-critical tasks.
- _Legacy feature warning:_ Older mirrored classic queues have been deprecated in RabbitMQ and completely removed in modern major versions.

2. Quorum Queues

&nbsp;&nbsp;&nbsp;&nbsp;Quorum Queues are the modern, replicated queue type built upon the Raft consensus algorithm.

- How they work: Messages are automatically copied across multiple nodes in a cluster. One node acts as the "leader" that handles traffic, while the others are "followers". A message is only considered accepted once a "quorum" (majority) of nodes confirms it. If the leader crashes, the followers hold an election to choose a new leader.

- Best used for: Mission-critical workloads, financial transactions, distributed systems, and any scenario where message loss is unacceptable.

- Trade-off: Because every message is safely replicated and written to disk across multiple nodes, they are slightly slower than non-replicated classic queues.

### Summary Comparison

| Feature                    | Classic Queues                                                                          | Quorum Queues                                         |
| :------------------------- | :-------------------------------------------------------------------------------------- | :---------------------------------------------------- |
| Replication                | Node-local (no native replication)                                                      | Replicated across nodes automatically                 |
| Fault Tolerance            | Low                                                                                     | High (survives node failures)                         |
| Throughput                 | High                                                                                    | Lower than classic                                    |
| Data Safety                | Low in clusters                                                                         | High (guarantees no data loss)                        |
| Primary Use                | Speed and simple workloads                                                              | Critical apps, data safety                            |
| Non-durable<br>(temporary) | Yes, queue can be temporary queue that<br>automatically deleted when RabbitMQ restarted | Always durable, queue not deleted on RabbitMQ restart |
| Message<br>durability      | Set per message                                                                         | All messages always durable                           |
| Lazy mode                  | Can lazy (data stored in-disk) or <br>no (data stored in-memory)                        | Always lazy (data stored in-disk)                     |
