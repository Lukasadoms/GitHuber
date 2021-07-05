//
//  UserDataManager.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 2021-07-05.
//

import Foundation
import CoreData

struct UserDataManager {
    
//    func saveTransactionsToDataBase(user: User) throws {
//        for transaction in transactions {
//            let newTransaction = Transaction(context: CoreDataManager.managedContext)
//            newTransaction.amount = NSDecimalNumber(decimal: transaction.amount)
//            newTransaction.createdOn = Int64(transaction.createdOn)
//            newTransaction.currency = transaction.currency
//            newTransaction.receiverId = transaction.receiverId
//            newTransaction.senderId = transaction.senderId
//            newTransaction.reference = transaction.reference
//            if transaction.senderId == transaction.receiverId {
//                var phoneNumberArray: [String] = []
//                phoneNumberArray.append(transaction.senderId)
//                try addAccountReferenceToTransaction(accountsPhoneNumbers: phoneNumberArray, transaction: newTransaction)
//            }
//            else {
//                let accountsPhoneNumbers = [transaction.senderId, transaction.receiverId]
//                try addAccountReferenceToTransaction(accountsPhoneNumbers: accountsPhoneNumbers, transaction: newTransaction)
//            }
//        }
//        try CoreDataManager.saveContext()
//    }
    
    func saveAccountToDatabase(user: User) throws {
        let newUser = UserData(context: CoreDataManager.managedContext)
        do {
            try CoreDataManager.saveContext()
        }
        catch {
            throw error
        }
    }
    
//    func getAccountFromDatabase (accountPhoneNumber: String) -> Account? {
//
//        do {
//            let fetchRequest : NSFetchRequest<Account> = Account.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "phoneNumber == %@", accountPhoneNumber)
//            let fetchedResults = try CoreDataManager.managedContext.fetch(fetchRequest)
//            if let account = fetchedResults.first {
//                return account
//            }
//        }
//        catch {
//            return nil
//        }
//        return nil
//    }
}
