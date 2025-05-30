//
//  NetworkBase.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 08.05.2025.
//

import Foundation


class NetworkBase: INetworkBase {
    
    struct NetResponse {
        let data: Data?
        let request:  URLRequest?
        let response: URLResponse?
        let error: Error?
        let meta: NetworkMetadata
    }
    
    private let logger         = NetworkLogger()

    private (set) var metadata = NetworkMetadata()
    private (set) var resp: NetResponse?
    var fullLink: String {
        guard let url = self.resp?.request?.url else { return "UNKNOWN" }
        return "\(url)"
    }
    
    private var commandLink: String {
        guard let url = self.resp?.request?.url else { return "UNKNOWN" }
        return "\(url.relativePath)"
    }

    var succeeded: Bool {
        return self.metadata.succeeded
    }

    var command : String { return "" }
    
    func adjust<T: Encodable>(_ type:HttpType = .POST, _ params:T? = nil) -> Self {
        self.metadata.httpType = type
        
        guard let params = params else { return self }
        self.metadata.encoded = params

        do {
            let data = try JSONEncoder().encode(params)
            self.metadata.params = data
        } catch (let e) {
            Task(priority: .background) { [weak self] in
                await self?.logger.log(e)
            }
        }

        return self
    }
    
    func setup(_ ns: NetworkSetup) -> Self {
        self.metadata.setup = ns
        return self
    }
    
    func execute(_ callback:NetworkCallback? = nil) {
        self.metadata.callback = callback
        
        Task(priority: .background) {
            
//            Здесь НЕЛЬЗЯ проверять ссылку.
//            [weak self] in
//            guard let self = self else { return }
            
            await self.executeTask()
        }
    }
    
    func execute() async {
        await self.executeTask()
    }

    private func executeTask() async {
        let (req, err) = await self.createRequest()
        await self.logger.started(req?.url, self.metadata, err)
        let response = await self.executeRequest(req)
        await self.handle(response)
        await self.commit()
    }

    func parse<T:Decodable>(data: Data) async -> T? {
        guard let data = await self.checkEmptyDataParse(data) else { return nil }
        guard let data = await self.checkMistakeParse(data) else { return nil }
        return await self.finalParse(data)
    }

    // MARK: - VIRTUAL
    /// This method overrides in children classes.
    func receiveData(data: Data) async {
        print(String(data: data, encoding: .utf8)!)
    }
    
    func testData(data: Data) async {
        print(String(data: data, encoding: .utf8)!)
    }

    // MARK: - PRIVATE
    private func createRequest() async -> (URLRequest?, Error?) {
        let params = self.metadata.params
        let type   = self.metadata.httpType
        
        guard let request = self
            .metadata
            .setup
            .urlRequest(cmd: self.command, type: type, params: params) else {
            return (nil, NSError(domain:"Request is not valid", code:-1, userInfo:[:]))
        }
        
        return (request, nil)
    }
    
    private func executeRequest(_ request:  URLRequest? ) async -> NetResponse {
        guard let request = request else { return NetResponse(data: nil,
                                                              request: request,
                                                              response: nil,
                                                              error: nil, meta:
                                                                self.metadata) }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            return NetResponse(data: data,
                               request: request,
                               response: response,
                               error: nil,
                               meta: self.metadata)
        } catch(let error) {
            return NetResponse(data: nil,
                               request: request,
                               response: nil,
                               error: error,
                               meta: self.metadata)
        }
    }
    
    private func commit() async {
        self.metadata.callback?(self)
        // await self.mistakeHandler.test()
    }
    
    // MARK: - HANDLERS
    private func handle(_ response: NetResponse) async {
        await self.handleResponse(response)
        await self.handleError(response)
        await self.handleCode(response)
        await self.handleHeaders(response)
        await self.handleReceive(response)
        await self.handleConsole(response)
    }
    private func handleResponse(_ response: NetResponse) async {
        self.resp = response
    }
    private func handleCode(_ response: NetResponse) async {
        guard let response = response.response as? HTTPURLResponse else { return }

        let statusCode = response.statusCode
        if (200...299).contains(statusCode)  { // ALL OK
            self.metadata.succeeded = true
            return
        } else if statusCode == 304 { // CACHED
            self.metadata.succeeded = true
        } else { //OTHER CODES
            await self.logger.console("HTTP STATUS CODE IS: \(statusCode)")
        }
    }
    private func handleHeaders(_ response: NetResponse) async {
        guard let response = response.response else { return }
        self.metadata.respondHeaders = (response as? HTTPURLResponse)?.allHeaderFields ?? [:]
    }
    private func handleError(_ response: NetResponse) async {
        if let error = response.error as? URLError, error.code == .timedOut {
            await self.logger.log("TIME OUT\n")
            self.metadata.params?.print()
        } else if let error = response.error as NSError?,
                    error.code == -1009 ||
                    error.code == -1020 ||
                    error.code == -1004  {
            await self.logger.log("NO INTERNET CONNECTION")
        }

        if let error = response.error {
            await self.logger.log(error)
        }
    }
    private func handleReceive(_ response: NetResponse) async {
        guard let data = response.data else { return }
        if self.metadata.isTest {
            await self.testData(data: data)
            return
        }
        await self.receiveData(data: data)
    }
    private func handleConsole(_ response: NetResponse) async {
        guard let path = response.request?.url?.relativePath else { return }

        let delta = -self.metadata.startedRequest.timeIntervalSinceNow
        await self.logger.console("Duration \(delta) of \(path)\n")
    }
    
    // MARK: - PARSE
    private func checkEmptyDataParse(_ data: Data) async -> Data? {
        // It handler needs for case when server send empty field 'data' {}.
        if data.count == 2 {
            self.metadata.succeeded = true
            await self.logger.console("GOT EMPTY DATA: \(self.commandLink)")
            return nil
        }
        
        return data
    }

    private func checkMistakeParse(_ data: Data) async -> Data? {
        let decoder = JSONDecoder()
        if let error = try? decoder.decode(Mistake.self, from: data) {
            self.metadata.succeeded = false
            await self.logger.log("MESSAGE: \(error.message)")
            await self.logger.mistake(self)
            return nil
        }
        return data
    }
    
    func finalParse<T:Decodable>(_ data: Data) async -> T? {
        let decoder = JSONDecoder()
        do {
            let payload = try decoder.decode(T.self, from: data)
            guard let result = await self.checkResult(payload) else { return nil }
            return result

        } catch (let error) {
            self.metadata.succeeded = false
            await self.logger.log("\(self.metadata.httpType) \(self.fullLink)")
            await self.logger.mistake(self)
            await self.parseException(error, data)
        }
        return nil
    }
    private func checkResult<T:Decodable>(_ payload:T?) async -> T? {
        guard let result = payload else {
            self.metadata.succeeded = false
            //payload.handleMistake()
            await self.logger.log("\(self.metadata.httpType) \(self.fullLink)")
            await self.logger.mistake(self)
            return nil
        }
        return result
    }
    private func parseException(_ error: Error, _ data:Data) async {
        await self.logger.log("\(self.metadata.httpType) \(self.fullLink)")
        await self.logger.mistake(self)

        if let error = error as? Swift.DecodingError {
            await self.logger.log("DECODE ERROR")
            data.print()
            await self.logger.log("\(error)")
            await self.logger.mistake(self)
        }
        await self.logger.log(error)
    }
    
    // MARK: - MULTIPART
    
    private func createMultipartRequest(_ boundary: String) async -> (URLRequest?, Error?) {
        guard let request = self
            .metadata
            .setup
            .uploadRequest(cmd: self.command, type: .POST, params: nil, boundary: boundary) else {
            return (nil, NSError(domain:"Request is not valid", code:-1, userInfo:[:]))
        }
        
        return (request, nil)
    }

    func uploadImage(user: User, fileName: String, imageData: Data, callback: NetworkCallback? = nil) {
        self.metadata.callback = callback

        //            Здесь НЕЛЬЗЯ проверять ссылку.
        //            [weak self] in
        //            guard let self = self else { return }
        Task(priority: .background) {
            let boundary = UUID().uuidString
            let (urlRequest, _) = await self.createMultipartRequest(boundary)
            guard let urlRequest = urlRequest else { return }
            "\(String(describing: urlRequest.url))".logConsole()
            
            let session  = URLSession.shared

                
            var body = Data()
                
            // Append name
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(user.name)\r\n".data(using: .utf8)!)
                
            // Append email
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"email\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(user.email)\r\n".data(using: .utf8)!)
                
            // Append phone
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"phone\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(user.phone)\r\n".data(using: .utf8)!)
                
            // Append position_id
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"position_id\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(user.position_id)\r\n".data(using: .utf8)!)
                
                // Append photo
                let mimeType = "image/jpeg"  // или определите по расширению
                
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)

            body.append("--\(boundary)--\r\n".data(using: .utf8)!)


            // Send a POST request to the URL, with the data we created earlier
            do {
                let (responseData, _) = try await session.upload(for: urlRequest, from:body)
                await self.receiveData(data: responseData)
                await self.commit()
            } catch (let error) {
                //self.handle(error)
                await self.logger.log(error)
            }
        }
    }

    
}
