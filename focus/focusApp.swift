import SwiftUI
import StreamChat
import StreamChatSwiftUI
@main
struct focusApp: App {
    var chatClient: ChatClient = {
        //For the tutorial we use a hard coded api key and application group identifier
        var config = ChatClientConfig(apiKey: .init("g5peb9r9v99p"))
        config.isLocalStorageEnabled = true
        config.applicationGroupIdentifier = "group.io.getstream.iOS.ChatDemoAppSwiftUI"
//        config.applicationGroupIdentifier = "group.io.getstream.StreamChat"

        
        // The resulting config is passed into a new `ChatClient` instance.
        let client = ChatClient(config: config)
        return client
    }()
    
    @State var streamChat: StreamChat?
    
    init() {
        streamChat = StreamChat(chatClient: chatClient)
        connectUser()
    }
    
    var body: some Scene {
        WindowGroup {
            CustomChannelList()
        }
    }
    
    private func connectUser() {
        // user 1
        let userID = "Ward"
        
//        guard let url = URL(string: "http://localhost:3002/token"),
        guard let url = URL(string: "http://10.82.171.93:3002/token"),

              let imageURL = URL(string: "https://media.istockphoto.com/id/182823312/photo/happy-golden-retriever-puppy-smiling-at-camera.jpg?s=2048x2048&w=is&k=20&c=u4enQlCpE24C3N9-63wBkCQj5Oi1jq6Sw9iXiySZBpY=") else {
            print("Invalid URL")
            return
        }
        // user 2
//        let userID = "Echo"
//
////        guard let url = URL(string: "http://localhost:3002/token"),
//        guard let url = URL(string: "http://10.82.223.63:3002/token"),
//              let imageURL = URL(string: "https://images.unsplash.com/photo-1711924847907-498771a92bde?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxNTV8fHxlbnwwfHx8fHw%3D") else {
//            print("Invalid URL")
//            return
//        }
        
        // 创建一个URL
//        let url = URL(string: "http://localhost:3002/token")!

        // 创建一个请求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // 设置请求体
        let body: [String: Any] = ["input": userID]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData

        // 创建一个任务
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let userToken = json["token"] as? String {
                        do {
                            // 连接用户
                            let token = try Token(rawValue: userToken)
                            self.chatClient.connectUser(
                                userInfo: .init(
                                    id: userID,
                                    name: userID,
                                    imageURL:imageURL
                                ),
                                token: token
                            ){ error in
                                if let error = error {
                                    print("connecting the user failed \(error)")
                                    return
                                }
                            }
                            print("Token: \(token)")
                        } catch {
                            print("Failed to create a `Token` instance: \(error)")
                        }
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
        }

        // 开始任务
        task.resume()
    }
}
