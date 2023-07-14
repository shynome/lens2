## 一个简易消息传递服务

原始目标是 webrtc 的信令服务器, 但后面想了想, 其实可以做成简易的消息传递服务,
于是提取出来了作为单独的一个库/标准.

是 <https://github.com/rabbitmq/amqp091-go> 的简化版/弱化版

### 使用

```sh
# subscribe task and dial
curl -i https://test:test@signaler.slive.fun?t=q
# call task and get result
curl -i -X POST https://test@signaler.slive.fun?t=q -d "req body\n"
# dial task with id from subscribe
curl -i -X DELETE https://test@signaler.slive.fun?t=q -d "res body\n" -H 'X-CSRF-Token: xxxxxx'
```

**注意:** 该服务器仅用于测试, 请勿依赖该服务器作为生产用途

### 启动信令服务器

```sh
# 开发用
mix phx.server

# build for prod
MIX_ENV=prod mix release
# copy to your service directory
rsync -Pr --checksum _build/prod/rel/lens/ /opt/lens/
```

```service
#/etc/systemd/system/lens.service
# systemd service example
[Unit]
Description=lens signaler server
After=network.target

[Service]
ExecStart=/opt/lens/bin/lens start
Restart=always
Environment="SECRET_KEY_BASE=xxxxxxxx"
Environment="PHX_SERVER=1"

[Install]
WantedBy=default.target
```
