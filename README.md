# tutaso
A stand-in of simple-obfs

## Usage

This is the simple-obfs docker image. It's based on alpine and only 4MB.

Since there are a lot of parameters and you may want to use simple-obfs in various ways, so I did not provide any entrypoint for this image.

You can run obfs-server or obfs-local in any way you wish.

Usage
The simple-obfs contains: obfs-server and obfs-local. obfs-server is the server side and obfs-local is the client side.

Suppose the shadowsocks is listening at $ip:$port, for example: 127.0.0.1:8388, or even on the other server.

**On the client side:**

```bash
docker run -d --restart=always --network=host --name tutaso tutacc/tutaso tutas -p 8443 --obfs tls -r 127.0.0.1:8388 --fast-open
```
Now your obfs-server will be listening on 0.0.0.0:8443. It will process the traffic from the client side. Deobfuscate it then send to the shadowsocks on 127.0.0.1:8388.

**On the client side:**

```bash
docker run -d --restart=always --network=host --name tutaso tutacc/tutaso tutal -s your_server_ip -p 8443 --obfs tls -l 8388 --obfs-host www.bing.com --fast-open
```

Then it will be listening at the 0.0.0.0:8388, communicating with the server. Once it receives the traffic from shadowsocks, it will obfuscate it and sent it to the server.

So the shadowsocks client or the ss-redir can treat it as a shadowsocks server.

If your shadowsocks are running on your host, listening at 127.0.0.0, and your container is not using --net=host. The IP address 127.0.0.1 is the loopback IP in the container,

You can use the docker0 IP or the host interface IP. But that depends on which IP the shadowsocks is listening on.
