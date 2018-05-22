# [![Build Status](https://travis-ci.com/djmetzle/mcfly.svg?branch=master)](https://travis-ci.com/djmetzle/mcfly) McFly - McRouter Reliable Delete Stream Replay

McRouter provides a reliable delete stream. This can keep your replication
pool consistent. The tool Facebook built to replay this stream, however, is
not open-source.

This is a service to replay the asynchronous delete stream from
McRouter to downstream replication nodes.

### How it Works

[McRouter](https://github.com/facebook/mcrouter) sends all failed `delete` commands to an "Async Delete Spool".
Read about that [here](https://github.com/facebook/mcrouter/wiki/Features#reliable-delete-stream).

The directory structure for this is:

> files under the async spool root, organized into hourly directories. Each directory will contain multiple spool files (one per mcrouter process per thread per 15 minutes of log).

![img](http://yuml.me/78064931.png)


#### DeleteQueue
McFly ingests the McRouter delete logs into the `DeleteQueue`.
This `DeleteQueue` is a hash of FIFOs kept in memory.
The hash is keyed by destination (the "host" field in the delete record).
Each record in the FIFO is a `delete` for a key that has yet to be issued.

![img](http://yuml.me/e44da816.png)
<!-- https://yuml.me/diagram/scruffy;dir:LR/class/edit/[DeleteQueue],[DeleteQueue]->[Destination%20c],[Destination%20C]->[Delete%20FIFO%20C],[DeleteQueue]->[Destination%20B],[Destination%20B]->[Delet%20e%20FIFO%20B],[DeleteQueue]->[Destination%20A],[Destination%20A]->[Delete%20FIFO%20A] -->

#### DeleteIssuer
The queue is drained by the `DeleteIssuer`.
The `DeleteIssuer` attempts to connect every destination with queued deletes.
The standard case is that the `DeleteIssuer` will not be able connect to the destination.
If the `DeleteIssuer` can connect, however, it replays the queued deletes to the destination host.

![img](http://yuml.me/44b8e39a.png)
<!-- http://yuml.me/diagram/scruffy/class/edit/[Delete FIFO{bg:lightyellow}]-.-^[DeleteIssuer],[DeleteIssuer]->[MemcachedConnector],[MemcachedConnector]-.-^[Destination Host{bg:green}] -->
