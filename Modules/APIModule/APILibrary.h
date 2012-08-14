//
//  APILibrary.h
//  Sanguosha
//
//  Created by Liu Mingxing on 5/14/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@protocol APILibraryDelegate <NSObject>

- (void)apiLibraryDidReceivedResult:(id)result;
- (void)apiLibraryDidReceivedError:(NSString *)error;

@end

@interface APILibrary : NSObject {
    NSDictionary *_appConfig;
    NSString *_uniqueIdentifier;
    AccountData *_userData;
}

@property (nonatomic, retain)  NSString *uniqueIdentifier;
@property (nonatomic, retain)  AccountData *userData;

+ (APILibrary *)sharedInstance;
- (NSString *)host;
+ (void)alertWithException:(NSString *)exception;
+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
    helloWithParam:(id)param;
+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
 loginWithUserData:(AccountData *)account;
+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
getAvalibelGamesWithParam:(id)param
      withDelegate:(id<APILibraryDelegate>)delegate;
+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
 joinGameWithGameID:(NSString *)gameID
      withDelegate:(id<APILibraryDelegate>)delegate;
+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
getMyRoleWithGameID:(NSString *)gameID
      withDelegate:(id<APILibraryDelegate>)delegate;
@end
