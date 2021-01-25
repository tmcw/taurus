//
//  ContentView.swift
//  taurus
//
//  Created by Tom MacWright on 11/1/20.
//

import SwiftUI
import Network

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

struct ContentView: View {
    @State var content: String = ""
    
    // https://github.com/agnosticdev/NetworkConnectivity/blob/c51f7a0b8f9b0733b52bd2ddbd0425b6e5d6fbbb/Sources/NetworkConnectivity/NetworkConnectivity.swift#L95
    
    @State private var tcpStreamAlive: Bool = false
    @State private var online: Bool = false
    @State private var currentUrl: String = "gemini://drewdevault.com"
    @State private var inputUrl: String = "gemini://drewdevault.com"
    
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
        let u = URL(string: inputUrl)!;
        
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
        nwConnection.send(content: "\(inputUrl)\r\n".data(using: .utf8)!, completion: .contentProcessed( { error in
            print("data sent")
            if let error = error {
                print("got error")
                // self.connectionDidFail(error: error)
                return
            }
            // print("connection did send, data: \(data as NSData)")
        }))
        currentUrl = inputUrl;
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
    
    func parsedContent() -> [Node]? {
        return parseResponse(content: self.content)?.tree.children;
    }
    
    func navigate(url: String) {
        inputUrl = url;
        loadUrl();
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            // TODO: state management
            // NavigationView(inputUrl: $inputUrl)
            
            ScrollView(.vertical) {
                Group {
                    VStack(alignment: .leading) {
                    if let nodes = self.parsedContent() {
                      ForEach(nodes, id: \.self) { node in
                          switch (node.data) {
                          case Data.root:
                              NilView();
                          case Data.brk:
                              NilView();
                          case .listItem(let value):
                              ListItemView(value: value);
                          case .text(let value):
                              TextView(value: value);
                          case .heading(let value, let rank):
                              HeadingView(value: value, rank: rank);
                          case .quote(let value):
                              QuoteView(value: value);
                          case .pre(let value, let _):
                              PreView(value: value);
                          case .webLink(let value, let url):
                              WebLinkView(value: value, url: url);
                          case .link(let value, let url):
                            LinkView(value: value) {
                                print("Clicked!");
                                navigate(url: url);
                            };
                          }
                      }
                    }
                    }.frame(minWidth: 200.0, idealWidth: 640.0, maxWidth: 800.0).padding(.bottom, 100.0).padding(.top, 50.0)
            }.frame(maxWidth: .infinity)
            }
        }.background(Color("Background"))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
