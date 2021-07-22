extension Request {
     public func webSocket(
         maxFrameSize: WebSocketMaxFrameSize = .`default`,
         shouldUpgrade: @escaping ((Request) -> EventLoopFuture<HTTPHeaders?>) = {
             $0.eventLoop.makeSucceededFuture([:])
         },
         onUpgrade: @escaping (Request, WebSocket) -> ()
     ) -> Response {
         return self.webSocket(
            outboundMaxFrameSize: maxFrameSize,
            inboundMaxFrameSize: maxFrameSize,
            shouldUpgrade: shouldUpgrade,
            onUpgrade: onUpgrade
         )
     }
    
    public func webSocket(
        outboundMaxFrameSize: WebSocketMaxFrameSize = .`default`,
        inboundMaxFrameSize: WebSocketMaxFrameSize = .`default`,
        shouldUpgrade: @escaping ((Request) -> EventLoopFuture<HTTPHeaders?>) = {
            $0.eventLoop.makeSucceededFuture([:])
        },
        onUpgrade: @escaping (Request, WebSocket) -> ()
    ) -> Response {
        let res = Response(status: .switchingProtocols)
        res.upgrader = .webSocket(
            outboundMaxFrameSize: outboundMaxFrameSize,
            inboundMaxFrameSize: inboundMaxFrameSize,
            shouldUpgrade: {
                shouldUpgrade(self)
            }, onUpgrade: { ws in
                onUpgrade(self, ws)
            }
        )
        return res
    }
 }
