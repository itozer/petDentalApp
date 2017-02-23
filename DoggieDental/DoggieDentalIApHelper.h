//
//  DoggieDentalIApHelper.h
//  DoggieDental
//
//  Created by Isaac Tozer on 9/28/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface DoggieDentalIApHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    
    SKProductsRequest * _productsRequest;
    
    RequestProductsCompletionHandler _completionHandler;
    NSSet * _productIdentifiers;
    //NSMutableSet * _purchasedProductIdentifiers;
    
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

- (void)buyProduct:(SKProduct *)product;
//- (BOOL)productPurchased:(NSString *)productIdentifier;
- (NSArray*)getProductIdentifiers;

@end