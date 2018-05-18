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
