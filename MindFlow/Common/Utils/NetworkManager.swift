//
//  NetworkManager.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import Foundation
import Alamofire
import UIKit
import ObjectiveC

class NetworkManager {
    
    // 单例模式
    static let shared = NetworkManager()
    
    private init() {}
    
    // 存储token
    private var token: String?
    
    // 存储当前语言
    private var currentLanguage: String = "en" // 默认英文
    
    // 设置语言
    func setLanguage(_ language: String) {
        self.currentLanguage = language
    }
    
    // 获取设备信息
    private func getDeviceInfo() -> [String: String] {
        let screenSize = UIScreen.main.bounds.size
        let deviceInfo: [String: String] = [
            "X-Device-Platform": "iOS",
            "X-Device-Version": UIDevice.current.systemVersion,
            "X-Device-Screen": "\(Int(screenSize.width))x\(Int(screenSize.height))",
            "X-Device-Model": UIDevice.current.model,
            "X-App-Bundle-ID": Bundle.main.bundleIdentifier ?? ""
        ]
        
        // 获取应用版本和构建号
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            var versionInfo = ["X-App-Version": version]
            
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                versionInfo["X-App-Build"] = build
            }
            
            return deviceInfo.merging(versionInfo) { (_, new) in new }
        }
        
        return deviceInfo
    }
    
    // 默认请求头
    private var defaultHeaders: HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Accept-Language": currentLanguage
        ]
        
        if let token = DefaultsManager.shared.getAccessToken() {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        // 添加设备信息
        for (key, value) in getDeviceInfo() {
            headers[key] = value
        }
        
        // 添加匿名用户ID
        if let anonymousId = DefaultsManager.shared.getAnonymousId() {
            headers["X-Anonymous-ID"] = anonymousId
        }
        
        return headers
    }
    
    // MARK: - 通用请求方法
    private func request<T: Decodable>(
        _ url: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let requestHeaders = headers ?? defaultHeaders
        
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: requestHeaders)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - GET 请求
    func get<T: Decodable>(
        _ url: String,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        request(url, method: .get, parameters: parameters, headers: headers, encoding: URLEncoding.default, completion: completion)
    }
    
    // MARK: - POST 请求
    func post<T: Decodable>(
        _ url: String,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        request(url, method: .post, parameters: parameters, headers: headers, completion: completion)
    }
    
    // MARK: - PUT 请求
    func put<T: Decodable>(
        _ url: String,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        request(url, method: .put, parameters: parameters, headers: headers, completion: completion)
    }
    
    // MARK: - DELETE 请求
    func delete<T: Decodable>(
        _ url: String,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        request(url, method: .delete, parameters: parameters, headers: headers, completion: completion)
    }
    
    // MARK: - 上传文件
    func upload<T: Decodable>(
        _ url: String,
        fileURL: URL,
        fileName: String? = nil,
        mimeType: String? = nil,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let requestHeaders = headers ?? defaultHeaders
        
        AF.upload(
            multipartFormData: { multipartFormData in
                // 添加文件
                let actualFileName = fileName ?? fileURL.lastPathComponent
                let actualMimeType = mimeType ?? "application/octet-stream"
                
                multipartFormData.append(
                    fileURL,
                    withName: "file",
                    fileName: actualFileName,
                    mimeType: actualMimeType
                )
                
                // 添加其他参数
                if let parameters = parameters {
                    for (key, value) in parameters {
                        if let data = "\(value)".data(using: .utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                }
            },
            to: url,
            method: .post,
            headers: requestHeaders
        )
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 下载文件
    func download(
        _ url: String,
        destination: URL,
        headers: HTTPHeaders? = nil,
        progress: ((Double) -> Void)? = nil,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        let requestHeaders = headers ?? defaultHeaders
        
        let destination: DownloadRequest.Destination = { _, _ in
            return (destination, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(url, headers: requestHeaders, to: destination)
            .downloadProgress { progressValue in
                progress?(progressValue.fractionCompleted)
            }
            .validate()
            .responseURL { response in
                switch response.result {
                case .success(let url):
                    completion(.success(url))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - 流式请求
    func streamRequest(
        _ url: String,
        method: HTTPMethod = .post,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil,
        onDataStream: @escaping (Data, HTTPURLResponse) -> Void,
        onError: @escaping (Error) -> Void,
        onCompletion: @escaping () -> Void
    ) -> DataRequest {
        print("NetworkManager: 开始流式请求 - \(url)")
        
        // 获取默认 headers
        var requestHeaders = headers ?? defaultHeaders
        
        // 添加流式请求特定的 headers
        requestHeaders["Accept"] = "text/event-stream"
        requestHeaders["Cache-Control"] = "no-cache"
        
        // 创建URLRequest
        guard let requestURL = URL(string: url) else {
            let error = NSError(domain: "NetworkManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            onError(error)
            return AF.request("https://example.com") // 返回一个虚拟请求
        }
        
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = method.rawValue
        
        // 添加headers
        for (key, value) in requestHeaders.dictionary {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        // 添加参数
        if let parameters = parameters {
            do {
                urlRequest = try encoding.encode(urlRequest, with: parameters)
                if let httpBody = urlRequest.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
                    print("NetworkManager: 请求参数 - \(bodyString)")
                }
            } catch {
                print("NetworkManager: 参数编码错误 - \(error.localizedDescription)")
                onError(error)
            }
        }
        
        // 创建自定义的URLSessionDataDelegate来处理SSE
        class SSEDelegate: NSObject, URLSessionDataDelegate {
            var onDataStream: ((Data, HTTPURLResponse) -> Void)?
            var onError: ((Error) -> Void)?
            var onCompletion: (() -> Void)?
            var httpResponse: HTTPURLResponse?
            var buffer = Data()
            
            func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
                print("SSEDelegate: 收到响应头")
                if let httpResponse = response as? HTTPURLResponse {
                    self.httpResponse = httpResponse
                    print("SSEDelegate: 状态码: \(httpResponse.statusCode)")
                }
                completionHandler(.allow)
            }
            
            func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
                print("SSEDelegate: 收到数据块: \(data.count) 字节")
                
                // 将新数据添加到缓冲区
                buffer.append(data)
                
                // 检查是否有完整的SSE事件
                if let string = String(data: data, encoding: .utf8) {
                    print("SSEDelegate: 数据内容: \(string)")
                    
                    // 处理接收到的数据
                    if let httpResponse = self.httpResponse {
                        // 在主线程上调用回调，确保UI更新
                        DispatchQueue.main.async {
                            self.onDataStream?(data, httpResponse)
                        }
                    }
                }
            }
            
            func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
                if let error = error {
                    print("SSEDelegate: 请求出错 - \(error.localizedDescription)")
                    onError?(error)
                } else {
                    print("SSEDelegate: 请求完成")
                    onCompletion?()
                }
                buffer.removeAll()
            }
        }
        
        // 创建并配置SSEDelegate
        let sseDelegate = SSEDelegate()
        sseDelegate.onDataStream = onDataStream
        sseDelegate.onError = onError
        sseDelegate.onCompletion = onCompletion
        
        // 创建URLSession并启动任务
        let session = URLSession(configuration: .default, delegate: sseDelegate, delegateQueue: .main)
        let task = session.dataTask(with: urlRequest)
        task.resume()
        
        // 创建一个虚拟的DataRequest作为返回值
        let dummyRequest = AF.request("https://example.com")
        
        // 保存delegate的引用，防止被提前释放
        objc_setAssociatedObject(dummyRequest, "sseDelegate", sseDelegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return dummyRequest
    }
    
    // MARK: - 取消请求
    func cancelRequest(_ request: DataRequest) {
        request.cancel()
    }
}
