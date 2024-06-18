//
//  PurchaseManager.swift
//

import Foundation
import StoreKit

final class PurchaseManager {
    static let shared = PurchaseManager()
    
    var subscriptions: [Product] = []
    
    var purchasedSubscriptions: Set<Product> = []
    
    private init() {
        Task {
            await fetchProducts()
            await updateCustomerProductStatus()
        }
    }
    
    func fetchProducts() async {
        do {
            subscriptions = try await Product.products(for: [Configuration.subscriptionID])
        } catch {
            print(error)
        }
    }
    
    func checkVerified(result: VerificationResult<Transaction>) async -> Bool {
            switch result {
            case .unverified:
                return false
            case .verified(let transaction):
                await transaction.finish()
                return true
            }
        }
    
    func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            let verified = await checkVerified(result: result)
            if verified, let transaction = extractTransaction(from: result),
               let subscription = subscriptions.first(where: {$0.id == transaction.productID}),
               transaction.productType == .autoRenewable {
                purchasedSubscriptions.insert(subscription)
            } else if !verified {
                print("Transaction verification failed")
            }
        }
    }
    
    private func extractTransaction(from result: VerificationResult<Transaction>) -> Transaction? {
        switch result {
        case .verified(let transaction):
            return transaction
        default:
            return nil
        }
    }
}
