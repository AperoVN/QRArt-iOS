//
//  BaseAPI.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation
import Alamofire
import Combine

class BaseAPI<T: TargetType> {
    typealias AnyPublisherResult<M> = AnyPublisher<M?, APIError>
    typealias FutureResult<M> = Future<M?, APIError>
    
    private let networking: AFNetworking
    
    init(networking: AFNetworking = AFNetworking()) {
        self.networking = networking
    }
    
    func fetch<M: Decodable>(target: T, responseClass: M.Type) -> AnyPublisherResult<M> {
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let body = buildBody(body: target.body)
        let targetPath = buildPath(param: target.params)
        let url = target.baseURL.desc + targetPath
        
        return FutureResult<M> { promise in
            self.networking.session.request(url,
                                            method: method,
                                            parameters: body,
                                            headers: headers,
                                            requestModifier: { $0.timeoutInterval = TIME_OUT })
                .validate(statusCode: 200..<500)
                .responseDecodable(of: SuccessResponse<M>.self) { response in
                    switch response.result {
                    case .success(let value):
                        guard let statusCode = response.response?.statusCode else { return promise(.failure(.General)) }
                        if statusCode >= 200 && statusCode < 300 {
                            promise(.success(value.data))
                        } else {
                            if let data = response.data {
                                do {
                                    let error = try JSONDecoder().decode(FailureResponse.self, from: data)
                                    promise(.failure(APIError(rawValue: error.error.errorCode) ?? .General))
                                } catch {
                                    promise(.failure(.Decode_Failed))
                                }
                            }
                        }
                    case .failure(let error):
                        guard !error.isTimeout else { return promise(.failure(.Time_Out)) }
                        guard !error.isConnectedToTheInternet else { return promise(.failure(.No_Network)) }
                        return promise(.failure(.General))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func uploadFile(target: T) -> AnyPublisherResult<Data> {
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let targetPath = buildPath(param: target.params)
        let urlString = target.baseURL.desc + targetPath
        return FutureResult<Data> { promise in
            guard let url = URL(string: urlString) else {return promise(.failure(.General))}
            self.networking.session.upload(multipartFormData: { multipartFromData in
                switch target.body {
                case .requestPlainBody:
                    break
                case .requestBody(let body):
                    body.forEach { key, value in
                        if let data = value as? Data {
                            let image = UIImage(data: data)
                            multipartFromData.append(data, withName: "file", fileName: "file.png", mimeType: "image/png")
                        } else {
//                            multipartFromData.append(self.convertToData(value), withName: key)
                        }
                    }
                    multipartFromData.append("abc".data(using: .utf8)!, withName: "qrText")
                    multipartFromData.append("abc".data(using: .utf8)!, withName: "positivePrompt")
                    multipartFromData.append("abc".data(using: .utf8)!, withName: "negativePrompt")
                    multipartFromData.append("1".data(using: .utf8)!, withName: "guidanceScale")
                    multipartFromData.append("1".data(using: .utf8)!, withName: "numInferenceSteps")
                    multipartFromData.append("1".data(using: .utf8)!, withName: "controlnetConditioningScale")
                }
            }, to: url, method: method, headers: headers).response { response in
                switch response.result {
                case .success(let data):
                    return promise(.success(data))
                case .failure(let error):
                    guard !error.isTimeout else { return promise(.failure(.Time_Out)) }
                    guard !error.isConnectedToTheInternet else { return promise(.failure(.No_Network)) }
                    return promise(.failure(.General))
                }
            }
        }.eraseToAnyPublisher()
    }
}
