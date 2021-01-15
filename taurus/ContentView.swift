//
//  ContentView.swift
//  taurus
//
//  Created by Tom MacWright on 11/1/20.
//

import SwiftUI
import Network

struct ContentView: View {
    @State var content = ""
    
    // https://github.com/agnosticdev/NetworkConnectivity/blob/c51f7a0b8f9b0733b52bd2ddbd0425b6e5d6fbbb/Sources/NetworkConnectivity/NetworkConnectivity.swift#L95
    
    @State private var tcpStreamAlive: Bool = false
    @State private var online: Bool = false
    @State private var url: String = "gemini://drewdevault.com"
    
    // https://stackoverflow.com/questions/54452129/how-to-create-ios-nwconnection-for-tls-with-self-signed-cert
    func createTLSParameters(allowInsecure: Bool, queue: DispatchQueue) -> NWParameters {
        let options = NWProtocolTLS.Options()
        sec_protocol_options_set_verify_block(options.securityProtocolOptions, { (sec_protocol_metadata, sec_trust, sec_protocol_verify_complete) in
            let trust = sec_trust_copy_ref(sec_trust).takeRetainedValue()
            var error: CFError?
            sec_protocol_verify_complete(true)
            /*
             if SecTrustEvaluateWithError(trust, &error) {
             sec_protocol_verify_complete(true)
             } else {
             if allowInsecure == true {
             sec_protocol_verify_complete(true)
             } else {
             sec_protocol_verify_complete(false)
             }
             }
             */
        }, queue)
        return NWParameters(tls: options)
    }
    
    
    private func loadUrl() {
        self.content = ""
        let u = URL(string: url)!;
        
        if (u.scheme != "gemini") {
            // Exit
        }
        let host = u.host;
        
        let queue = DispatchQueue(label: "taurus")
        let hostEndpoint = NWEndpoint.Host.init(host!)
        let nwConnection = NWConnection(host: hostEndpoint, port: 1965, using: createTLSParameters(allowInsecure: true, queue: queue))
        nwConnection.stateUpdateHandler = self.stateDidChange(to:)
        self.setupReceive(on: nwConnection)
        
        nwConnection.start(queue: queue)
        nwConnection.send(content: "\(url)\r\n".data(using: .utf8)!, completion: .contentProcessed( { error in
            print("data sent")
            if let error = error {
                print("got error")
                // self.connectionDidFail(error: error)
                return
            }
            // print("connection did send, data: \(data as NSData)")
        }))
    }
    
    private func setupReceive(on connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { (data, contentContext, isComplete, error) in
            print("got receive")
            // Read data off the stream
            if let data = data, !data.isEmpty {
                
                self.content += String(decoding: data, as: UTF8.self)
            }
            
            if isComplete {
                print("setupReceive: isComplete handle end of stream")
                connection.cancel()
                self.tcpStreamAlive = false
            } else if let error = error {
                print("setupReceive: error \(error.localizedDescription)")
            } else {
                self.setupReceive(on: connection)
            }
        }
    }
    
    private func stateDidChange(to state: NWConnection.State) {
        
        print("got state change")
        switch state {
        case .setup:
            self.notifyDelegateOnChange(newStatusFlag: false, connectivityStatus: "setup")
            self.tcpStreamAlive = true
            break
        case .waiting:
            self.notifyDelegateOnChange(newStatusFlag: false, connectivityStatus: "waiting")
            self.tcpStreamAlive = true
            break
        case .ready:
            self.notifyDelegateOnChange(newStatusFlag: true, connectivityStatus: "ready")
            self.tcpStreamAlive = true
            break
        case .failed(let error):
            let errorMessage = "Error: \(error.localizedDescription)"
            self.notifyDelegateOnChange(newStatusFlag: false, connectivityStatus: errorMessage)
            self.tcpStreamAlive = false
        case .cancelled:
            self.notifyDelegateOnChange(newStatusFlag: false, connectivityStatus: "cancelled")
            self.tcpStreamAlive = false
            //self.setupNWConnection()
            break
        case .preparing:
            self.notifyDelegateOnChange(newStatusFlag: false, connectivityStatus: "preparing")
            self.tcpStreamAlive = true
        }
    }
    
    private func notifyDelegateOnChange(newStatusFlag: Bool, connectivityStatus: String) {
        if newStatusFlag != self.online {
            print("newStatusFlag: \(newStatusFlag) - connectivityStatus: // \(connectivityStatus)")
            // self.networkStatusDelegate?.networkStatusChanged(online: newStatusFlag, // connectivityStatus: connectivityStatus)
            self.online = newStatusFlag
        } else {
            print("connectivityStatus: \(connectivityStatus)")
        }
    }
    
    struct Chunk: Hashable {
        var type = ""
        var url = ""
        var description = ""
        var level = 0
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(type + url + description)
        }
    }
    
    private func parsedContent() -> [Chunk] {
        var chunks: [Chunk] = [];
        return chunks;
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("URL", text: $url, onCommit: loadUrl)
                    .padding(.all)
                    .font(Font.system(size: 15, weight: .medium))
                    .background(Color.black)
                    .foregroundColor(Color.white)
                    .textFieldStyle(PlainTextFieldStyle())
            }.background(Color.white)
            
            ScrollView(.vertical) {
                /* VStack {
                    ForEach(self.parsedContent(), id: \.self) { chunk in
                        Group {
                            if (chunk.type == "text") {
                                Text(chunk.description)
                                    .font(.body)
                                    .lineSpacing(5.0)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 20.0)
                                    .padding(.vertical, 5.0)
                                    .lineLimit(nil)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            } else if (chunk.type == "heading") {
                                Text(chunk.description)
                                    .font(.title)
                                    .lineSpacing(5.0)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 20.0)
                                    .padding(.vertical, 5.0)
                                    .lineLimit(nil)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            } else if (chunk.type == "pre") {
                                Text(chunk.description)
                                    .font(.mono)
                                    .lineSpacing(5.0)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 20.0)
                                    .padding(.vertical, 5.0)
                                    .lineLimit(nil)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            } else {
                                Button(action: {
                                    self.url = chunk.url
                                    loadUrl()
                                }) {
                                    Text(chunk.description)
                                        .font(.body)
                                        .lineSpacing(5.0)
                                        .foregroundColor(Color.blue)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20.0)
                                        .padding(.vertical, 5.0)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity,
                                               alignment: .topLeading)
                                }.frame(maxWidth: .infinity, maxHeight: .infinity,
                                        alignment: .topLeading)
                            }
                        }.buttonStyle(PlainButtonStyle())
                        
                    }
                }.frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .topLeading
                ) */
            }.frame(minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
            )
            
        }.background(Color.black)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
