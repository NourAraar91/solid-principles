import Foundation

// MARK: Printer example

protocol Printer {
    func doPrint()
    func doScan()
}

struct Cannon370: CanPrint , CanScan{
    
    func doPrint() {
        print("printing ....")
    }
    
    func doScan() {
        print("scanning ....")
    }
}

struct Cannon375: CanPrint {
    func doPrint() {
        print("printing ....")
    }
}


protocol CanPrint {
    func doPrint()
}


protocol CanScan {
    func doScan()
}









// MARK: ATM example

protocol NotSOLIDATM {
    
    func requestDepositAmount()
    func requestWithdrawalAmount()
    func requestTransfer()
    func informInsufficientFunds()
    
}


struct NotSOLIDDepositTransaction: Transaction {
    
    let ui: NotSOLIDATM

    // MARK: - Protocol conformance
    
    // MARK: Transaction
    
    func execute() {
        ui.requestDepositAmount()
        ui.requestWithdrawalAmount() // OOPS! DepositTransaction should NOT be able to do this
    }
    
}



struct NotSOLIDConsoleATM: NotSOLIDATM {
    
    // MARK: - Protocol conformance
    
    // MARK: ATM
    
    func requestDepositAmount() {
        print("[Not SOLID] Requested deposit")
    }
    
    func requestWithdrawalAmount() {
        print("[Not SOLID] Requested withdrawal")
    }
    
    func requestTransfer() {
        print("[Not SOLID] Requested Transfer")
    }
    
    func informInsufficientFunds() {
        print("[Not SOLID] Insufficient funds!")
    }
}



// MARK: SOLID

protocol Transaction {
    func execute()
}



protocol SOLIDATM: DepositUI, TransferUI, WithdrawalUI {
    
}


struct SOLIDDepositUI: DepositUI {
    
    func requestDepositAmount() {
        print("[SOLID] Requested deposit")
    }
    
}


struct SOLIDDepositTransaction: Transaction {
    
    let ui: DepositUI
    
    func execute() {
        ui.requestDepositAmount()
    }
    
}


protocol DepositUI {
    
    func requestDepositAmount()
    
}


protocol TransferUI {
    
    func requestTransfer()
    
}

protocol WithdrawalUI {
    
    func requestWithdrawalAmount()
    func informInsufficientFunds()
    
}
