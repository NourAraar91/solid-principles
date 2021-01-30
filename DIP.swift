import Foundation


// MARK: Not DIP
class Shop {
    func getPayment() {
    }
    
    func deliverCoffee() {
    }
}

class Customer {
    func makePayment() {
    }
    
    func receiveCoffee() {
    }
}

class Delivery {
    
    let customer: Customer
    let coffeeShop: Shop
    
    init(customer: Customer, coffeeShop: Shop) {
        self.customer = customer
        self.coffeeShop = coffeeShop
    }
    
    func deliver() {
        customer.makePayment()
        coffeeShop.getPayment()
        coffeeShop.deliverCoffee()
        customer.receiveCoffee()
    }
}


// MARK: DIP
public protocol OrderCustomerProtocol {
    func createOrder();
    func receiveOrder();
}

public protocol OrderCoffeeShopProtocol {
    func deliverOrder();
}

class SOLIDShop : OrderCoffeeShopProtocol {
    func deliverOrder() {
        getPayment();
        deliverCoffee();
    }
    func getPayment() {
    }
    func deliverCoffee() {
    }
}

class SOLIDCustomer : OrderCustomerProtocol{
    func createOrder() {
        makePayment();
    }
    func receiveOrder() {
        receiveCoffee();
    }
    func makePayment() {
    }
    func receiveCoffee() {
    }
}
class SOLIDDelivery {
    let orderCoffeeShop: OrderCoffeeShopProtocol
    let orderCustomer: OrderCustomerProtocol
    
    init(orderCoffeeShop: OrderCoffeeShopProtocol, orderCustomer: OrderCustomerProtocol) {
        self.orderCoffeeShop = orderCoffeeShop
        self.orderCustomer = orderCustomer
    }
    
    func deliver() {
        orderCustomer.createOrder();
        orderCoffeeShop.deliverOrder();
        orderCustomer.receiveOrder();
    }
}
