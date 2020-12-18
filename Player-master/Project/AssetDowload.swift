//
//  AssetDowload.swift
//  Player
//
//  Created by super on 2020/12/14.
//  Copyright © 2020 Patrick Piemonte. All rights reserved.
//

import UIKit
import AVFoundation
import CommonCrypto

extension URL {
    func url() -> URL {
        return URL(string: "http://www.w3school.com.cn/example/html5/mov_bbb.mp4")!
    }
    
}

extension String {
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
}

struct Address {
    var url: URL
    var path: String
}

class AssetDowload: NSObject, AVAssetResourceLoaderDelegate, URLSessionDelegate, URLSessionDataDelegate {

    override init() {
        super.init()
    }
    var asset: AVURLAsset?
    var address: Address?
    
    func asset(url: URL) -> AVURLAsset {
        let s = "\(url.absoluteString)+\(Date().timeIntervalSince1970)".md5()
        
        fileCachePath += "/\(s).mp4"
        address = Address(url: URL(string: "https://stream7.iqilu.com/10339/upload_transcode/202002/18/20200218114723HDu3hhxqIT.mp4")!, path: fileCachePath)
        asset = AVURLAsset(url: url)
        asset!.resourceLoader.setDelegate(self, queue: .main)
        return asset!
    }
    
    func asset(url: String) -> AVURLAsset? {
        guard let url = URL(string: url) else {
            return nil
        }
        return asset(url: url)
    }
    
    var session: URLSession?
    var initialScheme: URL?
    var pendingRequests: [AVAssetResourceLoadingRequest] = []
    var queue: DispatchQueue = DispatchQueue.init(label: "requestQueue")
    var tasks: [URLSessionDataTask: AVAssetResourceLoadingRequest] = [:]
    
    func processPendingRequests() {
        self.queue.async {
            let requestsFulfilled = Set<AVAssetResourceLoadingRequest>(self.pendingRequests.compactMap {
                if let res = self.response {
                    $0.response = res
                }
                self.fillInContentInformationRequest($0.contentInformationRequest)
                if self.haveEnoughDataToFulfillRequest($0.dataRequest!) {
                    if(!$0.isFinished){
                        $0.finishLoading()
                    }
                    //print("请求填充完成 结束本次请求")
                    return $0
                }
                return nil
            })
            _ = requestsFulfilled.map { _ in self.pendingRequests.removeFirst() }
        }
    }
    
    //填充请求
    func fillInContentInformationRequest(_ contentInformationRequest: AVAssetResourceLoadingContentInformationRequest?) {
        self.queue.async {
            guard let responseUnwrapped = self.response else {
                return
            }
            contentInformationRequest?.contentType = responseUnwrapped.mimeType
            contentInformationRequest?.contentLength = responseUnwrapped.expectedContentLength
            contentInformationRequest?.isByteRangeAccessSupported = true
        }
    }
    //判断是否完整
    func haveEnoughDataToFulfillRequest(_ dataRequest: AVAssetResourceLoadingDataRequest) -> Bool {
        
        let requestedOffset = Int(dataRequest.requestedOffset)
        let requestedLength = dataRequest.requestedLength
        let currentOffset = Int(dataRequest.currentOffset)
        //print("下载数据 = \(mediaData?.count) 当前偏差\(currentOffset)")
        guard let dataUnwrapped = mediaData,
            dataUnwrapped.count > currentOffset else {
                //没有新的内容可以填充
                return false
        }
        
        let bytesToRespond = min(dataUnwrapped.count - currentOffset, requestedLength)
        let dataToRespond = dataUnwrapped.subdata(in: Range(uncheckedBounds: (currentOffset, currentOffset + bytesToRespond)))
        dataRequest.respond(with: dataToRespond)
        //print("原始请求获得响应\(dataToRespond.count)")
        return dataUnwrapped.count >= requestedLength + requestedOffset
    }
    
    var initialUrl: URL?
    var loadingRequest: AVAssetResourceLoadingRequest?
    var sessionDatatask: URLSessionDataTask?
    // MARK: - AVAssetResourceLoaderDelegate
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        
//        if session == nil {
//
//            //由于使用了自定义UrlScheme，需要构造出原始的URL
////            guard let interceptedUrl = loadingRequest.request.url, interceptedUrl.scheme,
////                let initialUrl = interceptedUrl.withScheme(self.initialScheme) else {
////                    fatalError("internal inconsistency")
////            }
        guard let initUrl = self.address?.url else {
            return false
        }
        self.initialUrl = initUrl
        if self.session == nil {
            //构造Session
            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            configuration.networkServiceType = .video
            configuration.allowsCellularAccess = true
            self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        }
        
        //构造 保存请求
        var urlRequst = URLRequest.init(url: initialUrl!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20) // 20s超时
        urlRequst.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        urlRequst.httpMethod = "GET"
        //设置请求头
        guard let wrappedDataRequest = loadingRequest.dataRequest else{
            //本次请求没有数据请求
            return true
        }
        
        let range: NSRange = NSMakeRange(Int.init(wrappedDataRequest.requestedOffset), wrappedDataRequest.requestedLength)
        let rangeHeaderStr = "byes=\(range.location)-\(range.location+range.length)"
        urlRequst.setValue(rangeHeaderStr, forHTTPHeaderField: "Range")
        urlRequst.setValue(initialUrl!.host, forHTTPHeaderField: "Referer")
        guard let task = session?.dataTask(with: urlRequst) else{
            fatalError("cant create task for url")
        }
        print("开始任务")
        print(rangeHeaderStr)
        task.resume()
        self.tasks[task] = loadingRequest
        self.loadingRequest = loadingRequest
        self.sessionDatatask = task
        
        return true
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        //移除原始请求

    }
    
//    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForRenewalOfRequestedResource renewalRequest: AVAssetResourceRenewalRequest) -> Bool {
//
//        return true
//    }
    
    // MARK: - URLSession delegate
    var mediaData: Data?
    var response: URLResponse?
    var totalLength: Int = 0
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        //只会调用一次，在这里构造下载完成的数据
        //这里传allow告知session持续下载而不是当做下载任务
        print("开始下载")
        
        if let loadingReq = self.tasks[dataTask], let lenght = loadingReq.dataRequest?.requestedLength, lenght == 2 {
        } else {
            completionHandler(Foundation.URLSession.ResponseDisposition.allow)
        }
        
        //第一次请求成功会带回来视频总大小 在响应头里Content-Range: bytes 0-1/20955211
        self.queue.async {
            if let urlRsp = response as? HTTPURLResponse {
                
                var length = 0
                if let contentRange: String = urlRsp.allHeaderFields["Content-Range"] as? String {
                    let lengthStr = contentRange.sub(from: contentRange.firstIndex(of: "/")!)
                    length = Int(lengthStr) ?? 0
                } else if let contentLenght: String = urlRsp.allHeaderFields["Content-Length"] as? String {
                    length = Int(contentLenght) ?? 0
                }
                
                self.totalLength = length
                //这里需要构造length大小的文件
                if let path = self.address?.path {
                    FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
                    let hand = FileHandle.init(forWritingAtPath: path)
                    do {
                        if #available(iOS 13.0, *) {
                            try hand?.truncate(atOffset: UInt64(self.totalLength))
                        } else {
                            // Fallback on earlier versions
                        }
                    } catch let error {
                        print(error)
                    }
                    
                }
                
                print(urlRsp)
                //填充响应
                let loadingReq = self.tasks[dataTask]
                loadingReq?.contentInformationRequest?.isByteRangeAccessSupported = true
                loadingReq?.contentInformationRequest?.contentType = (urlRsp.allHeaderFields["Content-Type"] as! String)
                loadingReq?.contentInformationRequest?.contentLength = Int64(self.totalLength)
                if let lenght = loadingReq?.dataRequest?.requestedLength, lenght == 2 {
                    loadingReq?.finishLoading()
                }
                print("total: \(self.totalLength)")
            }
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.queue.async {
            self.didDownLoadMediaDat(dataTask: dataTask, data: data)
        }
    }
    var loadLenght = 0
    
    func didDownLoadMediaDat(dataTask: URLSessionDataTask, data: Data){
        //填充数据 写入文件
        
        if let loadingReq = self.tasks[dataTask] {
            loadingReq.dataRequest?.respond(with: data)
//            print(loadLenght)

            if let path = self.address?.path {
                let hand = FileHandle.init(forWritingAtPath: path)
                if #available(iOS 13.4, *) {
                    do {
                        try hand?.seek(toOffset: UInt64(loadLenght))
                        
                        hand?.write(data)
                        try hand?.close()
                    } catch let  error {
                        print(error)
                    }
                } else {
                    // Fallback on earlier versions
                }
        //        hand?.seekToFileOffset(loadingReq!.dataRequest!.requestedOffset+1)
                
            }
            loadLenght += data.count
            //结束本次请求
//            loadingReq.finishLoading()
//            print("offset: \(self.loadingRequest!.dataRequest!.requestedOffset) - \(self.loadingRequest!.dataRequest!.requestedLength), dataLenght: \(data.count)")
            //移除请求
//            self.tasks.removeValue(forKey: dataTask)
        }
        
    }
    
    var fileCachePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let errorUnwrapped = error {
            print("下载失败\(errorUnwrapped)")
            return
        }
        print("下载完成")
//        if let path = self.address?.path {
//            let hand = FileHandle.init(forWritingAtPath: path)
            
//            do {
//                if #available(iOS 13.4, *) {
//                    let data = hand?.availableData
////                    let data = hand?.readData(ofLength: self.totalLength)
////                    let data = try hand?.readToEnd()
//                    print("read: \(data?.count ?? 0)")
//                } else {
//                    // Fallback on earlier versions
//                }
                
//            } catch let error {
//                print(error)
//            }
//        }
        
//        self.processPendingRequests()
        //下载完成，保存文件
//        let fileName = self.fileCachePath
//        if let data = self.mediaData {
////            VideoCacheManager.share.saveData(data:data,url:self.url)
//            if !FileManager.default.isExecutableFile(atPath: self.fileCachePath) {
//                FileManager.default.createFile(atPath: self.fileCachePath, contents: data, attributes: nil)
//                let hand = FileHandle.init(forWritingAtPath: self.fileCachePath)
//                hand?.write(data)
//            }
//        }else{
//            print("数据为空")
//        }
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    func sub(from: Index) -> String {
        return String(self[from...])
    }
    
    func sub(to: Index) -> String {
        return String(self[..<to])
    }
    
    func substring(from: Int, length: Int) -> String {
        let fromIndex = index(from: from)
        let toIndex = index(from: from+length)
        return String(self[fromIndex...toIndex])
    }
}
