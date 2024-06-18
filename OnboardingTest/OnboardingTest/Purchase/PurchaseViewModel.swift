//
//  PurchaseViewModel.swift
//

import Foundation
import StoreKit

final class PurchaseViewModel {
    private var updateListenerTask: Task<Void, Never>? = nil
    
    init() {
        startListeningForTransactionUpdates()
    }
    
    deinit {
        stopListeningForTransactionUpdates()
    }
    
    func purchase(product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verificationResult):
            switch verificationResult {
            case .verified(let transaction):
                await PurchaseManager.shared.updateCustomerProductStatus()
                await transaction.finish()
                return transaction
            case .unverified:
                print("Transaction verification failed")
                return nil
            }
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    func startListeningForTransactionUpdates() {
        updateListenerTask = Task {
            for await result in Transaction.updates {
                switch result {
                case .verified(let transaction):
                    print("Transaction verified")
                    await transaction.finish()
                    await PurchaseManager.shared.updateCustomerProductStatus()
                    
                case .unverified:
                    print("Transaction verification failed")
                }
            }
        }
    }
    
    func stopListeningForTransactionUpdates() {
        updateListenerTask?.cancel()
        updateListenerTask = nil
    }
}
