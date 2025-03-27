//
//  NetworkManager.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import Foundation
import Alamofire
import UIKit

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
    
    // 设置token
    func setToken(_ token: String) {
        self.token = token
    }
    
    // 清除token
    func clearToken() {
        self.token = nil
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
    
    // 获取匿名用户ID
    private func getAnonymousId() -> String? {
        return DefaultsManager.shared.getAnonymousId()
    }
    
    // 设置匿名用户ID
    func setAnonymousId(_ id: String) {
        DefaultsManager.shared.setAnonymousId(id)
    }
    
    // 默认请求头
    private var defaultHeaders: HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Accept-Language": currentLanguage
        ]
        
        // 如果有token，添加到Authorization头
        if let token = token {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        // 添加设备信息
        for (key, value) in getDeviceInfo() {
            headers[key] = value
        }
        
        // 添加匿名用户ID
        if let anonymousId = getAnonymousId() {
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
}
