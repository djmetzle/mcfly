# McFly - McRouter Reliable Delete Stream Replay

McRouter provides a reliable delete stream. This can keep your replication
pool consistent. The tool Facebook built to replay this stream, however, is
not open-source.

This is a service to replay the asynchronous delete stream from
McRouter to downstream replication nodes.
