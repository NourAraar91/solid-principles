import Foundation

// NOT SOLID

public class NOTSOLIDGeneralInvestment {
    
    let initialAmount: Double
    let time: Int
    let tax: Double

    init(initialAmount: Double, time: Int, tax: Double) {
        self.initialAmount = initialAmount
        self.time = time
        self.tax = tax
    }
}


public final class NOTSOLIDInvestmentManager {

    func calculateReturn(investment: NOTSOLIDGeneralInvestment) -> Double {
        return investment.initialAmount + Double(investment.time) * (investment.initialAmount * investment.tax)
    }
    
//    func calculateReturn(investment: NOTSOLIDGeneralInvestment) -> Double {
//        if let advanced = investment as? NOTSOLIDAdvancedInvestment {
//            return advanced.initialAmount + Double(advanced.time) * (advanced.initialAmount * advanced.tax) + (Double(advanced.period) * (advanced.incremental * advanced.tax))
//        } else {
//            return investment.initialAmount + Double(investment.time) * (investment.initialAmount * investment.tax)
//        }
//    }
    
}






public class NOTSOLIDAdvancedInvestment: NOTSOLIDGeneralInvestment {
    let incremental: Double
    let period: Int
    
    init(initialAmount: Double, time: Int, tax: Double, incremental: Double, period: Int) {
        self.incremental = incremental
        self.period = period
        super.init(initialAmount: initialAmount, time: time, tax: tax)
    }
}










// SOLID




protocol Investment {
    func calculateReturn() -> Double
}

public class GeneralInvestment: Investment {
    
    let initialAmount: Double
    let time: Int
    let tax: Double

    init(initialAmount: Double, time: Int, tax: Double) {
        self.initialAmount = initialAmount
        self.time = time
        self.tax = tax
    }
    
    func calculateReturn() -> Double {
        return initialAmount + Double(time) * (initialAmount * tax)
    }
}

public class AdvancedInvestment: Investment {
    
    let incremental: Double
    let period: Int
    let investment: GeneralInvestment
    
    init(initialAmount: Double, time: Int, tax: Double, incremental: Double, period: Int) {
        self.incremental = incremental
        self.period = period
        self.investment = GeneralInvestment(initialAmount: initialAmount, time: time, tax: tax)
    }
    
    func calculateReturn() -> Double {
        return investment.initialAmount + Double(investment.time) * (investment.initialAmount * investment.tax) + (Double(period) * (incremental * investment.tax))
    }
    
}

public final class InvestmentManager {
    
    func calculateReturn(_ investment: Investment) -> Double {
        return investment.calculateReturn()
    }
    
}



// MARK: EX2 Coffee shop

class CoffeeShop {
    func constructor(name: String, address: String){ }
    func getName() { }
    func getAddress() { }
}
class InvoiceService {
    
    
    func generateInvoice(shop: CoffeeShop) -> String{
        var invoice = "";
        if(shop is A) {
            invoice = "some format of invoice";
        }
        if(shop is B) {
            invoice = "some other format of invoice";
        }
        if(shop is C) {
            invoice = "some another format of invoice";
        }
        return invoice;
    }
}



protocol SOLIDCoffeeShop {
    func getInvoice() -> String;
    //...
}
class A : SOLIDCoffeeShop {
    func getInvoice() -> String {
        return "some format of invoice";
    }
}
class B : SOLIDCoffeeShop {
    func getInvoice() -> String {
        return "some other format of invoice";
    }
}
class C : SOLIDCoffeeShop {
    func getInvoice() -> String {
        return "some another format of invoice";
    }
}
class SOLIDInvoiceService {
    func generateInvoice(coffeeShop: SOLIDCoffeeShop) -> String{
        return coffeeShop.getInvoice();
    }
}
