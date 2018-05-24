# [![Build Status](https://travis-ci.com/djmetzle/mcfly.svg?branch=master)](https://travis-ci.com/djmetzle/mcfly) McFly - McRouter Reliable Delete Stream Replay

McRouter provides a reliable delete stream.
This can keep your replication pool consistent.
The tool Facebook built to replay this stream, however, is not open-source.
This is a service to replay the asynchronous delete stream from
McRouter to downstream replication nodes.

### Background
---

[McRouter](https://github.com/facebook/mcrouter) a tool that allows complex routing of Memcached requests.
[Replication](https://github.com/facebook/mcrouter/wiki/Replicated-pools-setup) and [Sharding](https://github.com/facebook/mcrouter/wiki/Sharded-pools-setup) facilities allow Memcached to become Highly-Available and scalable.

Availability and consitency are achieved by McRouter's [Reliable Delete Stream](https://github.com/facebook/mcrouter/wiki/Features#reliable-delete-stream).
By logging and replaying deletes, we can ensure that downstream Memcached instances are kept consistent across a replica set.
This "async spool" is streamed from McRouter to a directory of directories containing log files.

The tooling Facebook developed to replay this async stream has not been open-sourced.
To fill the gap, we have developed a simple replay implementation for this delete stream.

### How to use McFly
---

Point McFly at a McRouter "async spool" and go!

```shell
$ ./mcfly /var/spool/mcrouter
```

Run McFly in a Docker container!
```shell
$ docker build . -t mcfly
$ docker run -v /var/spool/mcrouter:/var/spool/mcrouter mcfly
```

### How McFly Works
---

From the bird's eye perspective, McFly listens to the McRouter async delete logs, queues them for replay.
When a destination host comes back online, McFly re-issues the queued deletes to the destination host.
Each tick of the main loop, McFly looks for new log entries and tries to replay the currently queued entries.

![img](http://yuml.me/21ba8195.png)
<!-- http://yuml.me/diagram/scruffy;dir:LR/class/edit/[DeleteStream]->[DeleteQueue{bg:lightblue}], [Async Log Files{bg:lightyellow}]-.->[DeleteStream], [DeleteQueue]->[DeleteIssuer], [DeleteIssuer]-.-^[Destination Hosts{bg:palegreen}] -->

#### The DeleteStream
McRouter sends all failed `delete` commands to the "async spool".
Read about that [here](https://github.com/facebook/mcrouter/wiki/Features#reliable-delete-stream).

The directory structure for this is:

> The log is written into files under the async spool root, organized into hourly directories.
> Each directory will contain multiple spool files (one per mcrouter process per thread per 15 minutes of log).

The entries in these log files contain the host that failed to accept the delete, and the key from that command.

An example (v2) log entry:
```
["AS2.0",1410611229.747,"C",{"k":"key","p":"A","h":"[127.0.0.1]:5001","f":"5000"}]
```

```
[version (always "AS2.0"), timestamp, command (always "C"),
  {"k": key,
   "p": pool name,
   "h": "[destination host]:destination port",
   "f": "mcrouter port or instance name"}]
```

The `DeleteStream` walks these files, looking for new entries.
When new data is found, the new entries are queued for replay later.

![img](http://yuml.me/78064931.png)


#### The DeleteQueue
McFly ingests the McRouter delete logs into the `DeleteQueue`.
This `DeleteQueue` is a hash of FIFOs kept in memory.
The hash is keyed by destination (the "host" field in the delete record).
Each record in the FIFO is a `delete` for a key that has yet to be issued.

![img](http://yuml.me/e44da816.png)
<!-- https://yuml.me/diagram/scruffy;dir:LR/class/edit/[DeleteQueue],[DeleteQueue]->[Destination%20c],[Destination%20C]->[Delete%20FIFO%20C],[DeleteQueue]->[Destination%20B],[Destination%20B]->[Delet%20e%20FIFO%20B],[DeleteQueue]->[Destination%20A],[Destination%20A]->[Delete%20FIFO%20A] -->

#### The DeleteIssuer
The `DeleteQueue` is drained by the `DeleteIssuer`.
The `DeleteIssuer` attempts to connect to every destination with queued deletes.
The standard case is that the `DeleteIssuer` will not be able connect to the destination.
If the `DeleteIssuer` can connect, however, it replays the queued deletes to the destination host.

![img](http://yuml.me/44b8e39a.png)
<!-- http://yuml.me/diagram/scruffy/class/edit/[Delete FIFO{bg:lightyellow}]-.-^[DeleteIssuer],[DeleteIssuer]->[MemcachedConnector],[MemcachedConnector]-.-^[Destination Host{bg:green}] -->

### Caveats
---
This solution is not general purpose, and makes a few strong assumptions:
- The queue will be short, and fit in memory.
- Historical (unneeded) log entries will be removed by the operator.
- Deletes can consistently be replayed directly back to the downstream memcached instances.

### License
---
GPL v3.0.

https://github.com/djmetzle/mcfly/blob/master/LICENSE
