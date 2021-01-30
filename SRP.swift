import Foundation


// MARK: Not SRP
class CoffeeShopNotSRP {
    let name: String
    let city: String
    let zipCode: Int
    
    init(name: String, city: String, zipCode: Int){
        self.name = name
        self.city = city
        self.zipCode = zipCode
    }
    
    func getName() { }
    func changeAddress(city: String, zipCode: Int) { }
}


















// MARK: SRP

class CoffeeShopSRP {
    init(name: String, address: AddressSRP){ }
    func getName() { }
    func getAddress() { }
}

class AddressSRP {
    init(city: String, zipCode: Int){ }
}

public class AddressServiceSRP {
  public func changeAddress(city: String, zipCode: Int) { }
}











public struct NotSOLIDClient: Client {
    
    public func startScheduler() {
        let serviceScheduler = NotSOLIDServiceScheduler(userID: "123")
        
        serviceScheduler.start()
    }
    
    public init(){}
    
}

public struct NotSOLIDTimelineService {
    
    public static func fetchTimelineForUserID(userID: String) {
        print("[Not SOLID] fetched timeline for user \(userID)")
    }
    
}

public struct NotSOLIDProfileService {
    
    public static func fetchProfileForUserID(userID: String) {
        print("[Not SOLID] fetched profile for user \(userID)")
    }
}

public class NotSOLIDServiceScheduler: NSObject {
    
    let userID: String
    private var serviceTimer: Timer?
    private var timerTick: Int
    
    // MARK: - Public methods
    
    public init(userID: String) {
        self.userID = userID
        self.serviceTimer = nil
        self.timerTick = 0
    }
    
    // Responsibility: starts timer
    public func start() {
        serviceTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerDidFire), userInfo: nil, repeats: true)
    }
    
    public func stop() {
        serviceTimer?.invalidate()
        serviceTimer = nil
    }
    
    // MARK: - Private methods
    
    @objc private func timerDidFire(timer: Timer) {
        timerTick += 1
        runServicesWithTick(tick: timerTick)
    }
    
    // Responsibility: decides frequencies
    private func runServicesWithTick(tick: Int) {
        if ((tick % 2) == 1) {
            runTimelineUpdateService()
        }
        
        if ((tick % 2) == 0) {
            runProfileUpdateService()
        }
        
    }
    
    // Responsibility: Executes specific services
    private func runTimelineUpdateService() {
        NotSOLIDTimelineService.fetchTimelineForUserID(userID: userID)
    }
    
    private func runProfileUpdateService() {
        NotSOLIDProfileService.fetchProfileForUserID(userID: userID)
    }
    
}




// SOLID


public protocol Client {
    func startScheduler()
}


public protocol ServiceScheduler {
    func start()
    func stop()
}

public protocol Service {
    func frequency() -> Int
    func execute()
}

public protocol TimerProtocol {
    func onTick(action: @escaping (Int) -> ())
    func start()
    func stop()
}

public struct SOLIDClient: Client {
    public func startScheduler() {
        let serviceScheduler = SOLIDSchedulerFactory.twitterServiceSchedulerWithUserID(userID: "123")
        
        serviceScheduler.start()
    }
}



public struct SOLIDServiceScheduler: ServiceScheduler {
    // MARK: - Public methods
    
    let timer: TimerProtocol
    private var services: [Service]
    
    public init(timer: TimerProtocol) {
        self.timer = timer
        self.services = []
    }
        
    public func start() {
        timer.onTick() {
            tick in
            
            self.timerDidTick(tick: tick)
        }
        
        timer.start()
    }
    
    public func stop() {
        timer.stop()
    }
    
    
    public mutating func registerService(service: Service) {
        services.append(service)
    }
    
    // MARK: - Private methods
    
    private func timerDidTick(tick: Int) {
        runServicesWithTick(tick: tick)
    }
    
    private func runServicesWithTick(tick: Int) {
        for service in services {
            if (shouldExecuteFrequency(frequency: service.frequency(), onTick:tick)) {
                service.execute()
            }
        }
    }
    
    private func shouldExecuteFrequency(frequency: Int, onTick tick: Int) -> Bool {
        return (tick % frequency) == 0
    }
    
}




public struct SOLIDProfileService: Service {
    
    private let freq: Int
    let userID: String
    
    public init(frequency: Int, userID: String) {
        self.freq = frequency
        self.userID = userID
    }
    // MARK: - Protocol conformance
    
    // MARK: Service
    
    public func frequency() -> Int {
        return freq
    }
    
    public func execute() {
        self.fetchProfileForUserID(userID: userID)
    }
    
    // MARK: - Private methods
    
    private func fetchProfileForUserID(userID: String) {
        print("[SOLID] fetched profile for user \(userID)")
    }
    
}



public class SOLIDTimer: TimerProtocol {

    
    private var internalTimer: Timer?
    private var tick: Int
    private var tickAction: ((Int) -> ())?
    
    public init() {
        self.internalTimer = nil
        self.tick = 0
        self.tickAction = nil
    }
    
    // MARK: - Protocol conformance
    
    // MARK: Timer
    
    public func onTick(action: @escaping (Int) -> ()) {
        tickAction = action
    }
    
    public func start() {
        internalTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerDidFire), userInfo: nil, repeats: true)
    }
    
    public func stop() {
        internalTimer?.invalidate()
        internalTimer = nil
    }
    
    // MARK: - Private methods
    
    @objc private func timerDidFire(timer: Timer) {
        tick += 1
        
        tickAction?(tick)
    }
    
}


public struct SOLIDSchedulerFactory {
    
    public static func twitterServiceSchedulerWithUserID(userID: String) -> ServiceScheduler {
        let timer = clockTimer()
        var twitterScheduler = SOLIDServiceScheduler(timer: timer)
        
        twitterScheduler.registerService(service: SOLIDServiceFactory.twitterTimelineServiceWithUserID(userID: userID))
        twitterScheduler.registerService(service: SOLIDServiceFactory.twitterProfileServiceWithUserID(userID: userID))
        
        return twitterScheduler
    }
    
    public static func clockTimer() -> TimerProtocol {
        return SOLIDTimer()
    }
    
}


public struct SOLIDTimelineService: Service {
    
    private let freq: Int
    public let userID: String
    
    public init(frequency: Int, userID: String) {
        self.freq = frequency
        self.userID = userID
    }
    
    // MARK: - Protocol conformance
    
    // MARK: Service
    
    public func frequency() -> Int {
        return freq
    }
    
    public func execute() {
        fetchTimelineForUserID(userID: userID)
    }
    
    // MARK: - Private methods
    
    private func fetchTimelineForUserID(userID: String) {
        print("[SOLID] fetched timeline for user \(userID)")
    }
    
}


public struct SOLIDServiceFactory {
    
    public static func twitterTimelineServiceWithUserID(userID: String) -> Service {
        return SOLIDTimelineService(frequency: 1, userID: userID)
    }
    
    public static func twitterProfileServiceWithUserID(userID: String) -> Service {
        return SOLIDProfileService(frequency: 2, userID: userID)
    }
    
}



