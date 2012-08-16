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
@optional
- (void)apiLibraryDidReceivedResult:(id)result;
- (void)apiLibraryDidReceivedError:(NSString *)error;
- (void)apiLibraryDidReceivedGameDetail:(id)detail;
- (void)apiLibraryDidReceivedCreateGameResult:(id)result;
- (void)apiLibraryDidReceivedJoinGameResult:(id)result;
- (void)apiLibraryDidReceivedObserveResult:(id)result;
- (void)apiLibraryWithGameInstance:(GameInstance *)agameInstance roleInstance:(GameRoleInstance *)roleInstance didReceivedKilledByResult:(NSString *)gameID;
- (void)apiLibraryDidReceivedUnKilledByResult:(id)result;
- (void)apiLibraryDidReceivedFinishResult:(id)result;
- (void)apiLibraryDidReceivedReopenResult:(id)result;
- (void)apiLibraryDidReceivedCloseResult:(id)result;
- (void)apiLibraryDidReceivedOneononeResult:(id)result;
- (void)apiLibraryDidReceivedRankingResult:(id)result;
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
+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
getTypesWithDelegate:(id<APILibraryDelegate>)delegate;
+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
createWithGameTypeID:(NSString *)gameTypeID
      withDelegate:(id<APILibraryDelegate>)delegate;
+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
observeGameWithGameID:(NSString *)gameID
      withDelegate:(id<APILibraryDelegate>)delegate;
+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
              game:(GameInstance *)gameInstance
               who:(GameRoleInstance *)RoleInstance
          killedBy:(GameRoleInstance *)byRoleInstance
      withDelegate:(id<APILibraryDelegate>)delegate;
+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
            gameID:(NSString *)gameID
             whoID:(NSString *)whoID
unkilledWithDelegate:(id<APILibraryDelegate>)delegate;
+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
  reopenWithGameID:(NSString *)gameID
      withDelegate:(id<APILibraryDelegate>)delegate;
+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
  finishWithGameID:(NSString *)gameID
      withDelegate:(id<APILibraryDelegate>)delegate;
+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
   closeWithGameID:(NSString *)gameID
      withDelegate:(id<APILibraryDelegate>)delegate;
+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
 onOnoneWithGameID:(NSString *)gameID
      withDelegate:(id<APILibraryDelegate>)delegate;
+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
rankingWithDelegate:(id<APILibraryDelegate>)delegate;
@end
