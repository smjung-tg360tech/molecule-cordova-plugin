import Foundation
import MoleculeTracker

@objc(CDVMoleculeAgent) class CDVMoleculeAgent:CDVPlugin {

    @objc func startApplication(_ command:CDVInvokedUrlCommand) {
        MoleculeTracker.shared.track()
    }
    
    @objc func startActivity(_ command:CDVInvokedUrlCommand)  {
        let arg:String = command.arguments.first as! String
        MoleculeTracker.shared.startActivity(str: arg)
    }
        
    @objc func setItemList(_ command:CDVInvokedUrlCommand)  {
        let arg:String = command.arguments.first as! String
        MoleculeTracker.shared.setItemList(str:arg)
    }
    
    @objc func setCartList(_ command:CDVInvokedUrlCommand)  {
        let arg:String = command.arguments.first as! String
        MoleculeTracker.shared.setCartList(str:arg)
    }
    
    @objc func setOrderList(_ command:CDVInvokedUrlCommand)  {
        let arg:String = command.arguments.first as! String
        MoleculeTracker.shared.setOrderList(str:arg)
    }
    
    @objc func setSearchKeyword(_ command:CDVInvokedUrlCommand)  {
        let arg:String = command.arguments.first as! String
        MoleculeTracker.shared.setSearchKeyword(str:arg)
    }
    
    @objc func setMudList(_ command:CDVInvokedUrlCommand)  {
        let arg:String = command.arguments.first as! String
        MoleculeTracker.shared.setMudList(str:arg)
    }
    
    @objc func login(_ command:CDVInvokedUrlCommand)  {
        MoleculeTracker.shared.login()
    }
    
    @objc func join(_ command:CDVInvokedUrlCommand)  {
        MoleculeTracker.shared.join()
    }
}

public final class UserDefaultsQueue: NSObject, Queue {
    private var items: [Event] {
        didSet {
            if autoSave {
                try? UserDefaultsQueue.write(items, to: userDefaults)
            }
        }
    }
    private let userDefaults: UserDefaults
    private let autoSave: Bool
    
    init(_ userDefaults: UserDefaults, autoSave: Bool = false) {
        self.userDefaults = userDefaults
        self.autoSave = autoSave
        self.items = (try? UserDefaultsQueue.readEvents(from: userDefaults)) ?? []
        super.init()
    }
    
    public var eventCount: Int {
        return items.count
    }
    
    public func enqueue(events: [Event], completion: (()->())?) {
        items.append(contentsOf: events)
        completion?()
    }
    
    public func first(limit: Int, completion: (_ items: [Event])->()) {
        let amount = [limit,eventCount].min()!
        let dequeuedItems = Array(items[0..<amount])
        completion(dequeuedItems)
    }
    
    public func remove(events: [Event], completion: ()->()) {
        items = items.filter({ event in !events.contains(where: { eventToRemove in eventToRemove.uuid == event.uuid })})
        completion()
    }
    
    public func save() throws {
        try UserDefaultsQueue.write(items, to: userDefaults)
    }
}

extension UserDefaultsQueue {
    
    private static let userDefaultsKey = "UserDefaultsQueue.items"
    
    private static func readEvents(from userDefaults: UserDefaults) throws -> [Event] {
        guard let data = userDefaults.data(forKey: userDefaultsKey) else { return [] }
        let decoder = JSONDecoder()
        return try decoder.decode([Event].self, from: data)
    }
    
    private static func write(_ events: [Event], to userDefaults: UserDefaults) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(events)
        userDefaults.set(data, forKey: userDefaultsKey)
    }
    
}


extension MoleculeTracker {
    static let shared: MoleculeTracker = {
        let queue = UserDefaultsQueue(UserDefaults.standard, autoSave: true)
        let dispatcher = URLSessionDispatcher(baseURL:URL(string:"http://analytics-app.tg360tech.com/api/track")!) //호출할 서버 주소
        let moleculeTracker = MoleculeTracker(mid: "AA-99999",mky:"!@#%^*()%$$" , queue: queue, dispatcher: dispatcher) //mid :앱아이디 ,  mky : 앱키
        moleculeTracker.logger = DefaultLogger(minLevel: .verbose)
        moleculeTracker.migrateFromFourPointFourSharedInstance()
        return moleculeTracker
    }()
    
    private func migrateFromFourPointFourSharedInstance() {
        guard !UserDefaults.standard.bool(forKey: "migratedFromFourPointFourSharedInstance") else { return }
        copyFromOldSharedInstance()
        UserDefaults.standard.set(true, forKey: "migratedFromFourPointFourSharedInstance")
    }
}
