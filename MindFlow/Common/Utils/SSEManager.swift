import Foundation

class SSEManager: NSObject {
    private var urlSession: URLSession!
    private var dataTask: URLSessionDataTask?
    private var buffer = Data()
    
    var onEvent: ((Data) -> Void)?
    var onError: ((Error) -> Void)?
    var onComplete: (() -> Void)?
    
    override init() {
        super.init()
        let config = URLSessionConfiguration.default
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: .main)
    }
    
    func connect(request: URLRequest) {
        print("SSEManager: 开始连接")
        dataTask = urlSession.dataTask(with: request)
        dataTask?.resume()
    }
    
    func disconnect() {
        print("SSEManager: 断开连接")
        dataTask?.cancel()
        dataTask = nil
        buffer.removeAll()
    }
}

extension SSEManager: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        buffer.append(data)
        print("SSEManager: 收到数据 \(data.count) 字节")
        
        // 处理接收到的数据
        if let string = String(data: data, encoding: .utf8) {
            print("SSEManager: 数据内容: \(string)")
        }
        
        // 调用回调
        onEvent?(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("SSEManager: 连接出错 - \(error.localizedDescription)")
            onError?(error)
        } else {
            print("SSEManager: 连接完成")
            onComplete?()
        }
        
        buffer.removeAll()
    }
}