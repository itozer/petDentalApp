//
//  DoggieDentalIApHelper.m
//  DoggieDental
//
//  Created by Isaac Tozer on 9/28/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalIApHelper.h"
#import "DoggieDentalPetStore.h"
#import "DoggieDentalCheckupPost.h"

#import <StoreKit/StoreKit.h>

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";


@implementation DoggieDentalIApHelper


- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        /*
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        */
 
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    _completionHandler = [completionHandler copy];
    
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}

/*
- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}
*/

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    //[self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [self provideContentForProductIdentifier:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    [self provideContentForProductIdentifier:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    //called if user cancels itunes purchase
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[DoggieDentalPetStore sharedStore] cancelTransaction];    //sets transaction status from 1 to 0
    //save pets now in case of program crash. I need to know that this checkup has been paid for
    BOOL success = [[DoggieDentalPetStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"saved pets. iTunesPurchase fail");
    } else {
        NSLog(@"save pets fail. iTunesPurchase fail");
    }
    
    NSMutableDictionary* checkupDictionary = [[NSMutableDictionary alloc] init];
    [checkupDictionary setObject:transaction forKey:@"error"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"failedTransaction" object:nil userInfo:checkupDictionary];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)provideContentForProductIdentifier:(SKPaymentTransaction *)transaction {
    
    //[_purchasedProductIdentifiers addObject:transaction.payment.productIdentifier];
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    
    //NSLog(@"transaction identifier length: %lu", (unsigned long)transaction.transactionIdentifier.length);
    
    [[DoggieDentalPetStore sharedStore] checkupPaymentComplete:transaction.transactionIdentifier];    //marks checkup as paid (transactionStatus = 2)
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:transaction.payment.productIdentifier userInfo:nil];
    NSLog(@"Transaction complete: %@", transaction.payment.productIdentifier);
    
    //save pets now in case of program crash. I need to know that this checkup has been paid for
    BOOL success = [[DoggieDentalPetStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"saved pets. iTunesPurchase complete");
    } else {
        NSLog(@"save pets fail. iTunesPurchase complete");
    }
    
    //posts checkup to pet dental servers
    //instead of calling post here, post now listens for the notification from this object
    /*
    DoggieDentalCheckupPost *post = [[DoggieDentalCheckupPost alloc] init];
    [post postCheckup];
    */
    
}

- (NSArray *)getProductIdentifiers {
    
    NSMutableArray *productIdentifiers = [[NSMutableArray alloc] init];
    for (NSString * p in _productIdentifiers) {
        [productIdentifiers addObject:p];
    }
    
    return productIdentifiers;
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;

    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }

    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}

@end



