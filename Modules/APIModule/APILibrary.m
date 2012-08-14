//
//  APILibrary.m
//  Sanguosha
//
//  Created by Liu Mingxing on 5/14/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "APILibrary.h"
#import "ASIHTTPRequest.h"
#import "SBJsonParser.h"
#import "Foundation+KGOAdditions.h"
@implementation APILibrary
@synthesize uniqueIdentifier = _uniqueIdentifier;
@synthesize userData = _userData;

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    self.uniqueIdentifier = nil;
    self.userData = nil;
    [super dealloc];
}

+ (APILibrary *)sharedInstance {
    static APILibrary *sharedInstace = nil;
    if (!sharedInstace) {
        sharedInstace = [[APILibrary alloc] init];
    }
    return sharedInstace;
}

- (NSString *)host {
    if (!_appConfig) {
        NSString *mainFile = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];    
        _appConfig = [[NSDictionary alloc] initWithContentsOfFile:mainFile];
    }
    NSDictionary *serverDictionary = [_appConfig dictionaryForKey:@"Server"];
    return [NSString stringWithFormat:@"http://%@",[serverDictionary stringForKey:@"host"]];
}

+ (void)alertWithException:(NSString *)exception {
    NSString *title = NSLocalizedString(@"Exception", nil);    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
                                                    message:exception 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil, nil];
    [alert show];
}

//http://sgol.sinaapp.com/requestToken/api?app_id=ios
+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
 helloWithParam:(id)param {
    NSString *host = [[APILibrary sharedInstance] host];
    NSString *urlString = [NSString stringWithFormat:@"%@/requestToken/api?app_id=ios",host];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request startSynchronous];
    
    NSError *errorRequest = [request error];
    if (!errorRequest) {
        NSString *response = [request responseString];
        SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
        NSDictionary *obj = [parser objectWithString:response];
        if (obj) {
            NSString *uniqueIdentifier = [obj forcedStringForKey:@"response"];
            if (uniqueIdentifier) {
                [APILibrary sharedInstance].uniqueIdentifier = uniqueIdentifier;
                *status = YES;
            } else {
                *error = @"hello request error";
            }
        } else {
            *error = @"hello request error";
        }
    } else {
        *error = [errorRequest description];
    }
    return *status;
}


//http://sgol.sinaapp.com/auth?username=newstar&password=demo
+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
loginWithUserData:(AccountData *)account {
    NSString *host = [[APILibrary sharedInstance] host];
    NSString *urlString = [NSString stringWithFormat:@"%@/auth/api?username=%@&password=%@&token=%@",host,account.usrName,account.password,[APILibrary sharedInstance].uniqueIdentifier];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request startSynchronous];
    
    NSError *errorRequest = [request error];
    if (!errorRequest) {
        NSString *response = [request responseString];
        SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
        NSDictionary *obj = [parser objectWithString:response];
        if (obj) {
            NSDictionary *errDictionary = [obj dictionaryForKey:@"error"];
            if (errDictionary) {
                *error = [errDictionary forcedStringForKey:@"message"];
            } else {
                NSDictionary *response = [obj dictionaryForKey:@"response"];
                account.email = [response forcedStringForKey:@"email"];
                account.firstName = [response forcedStringForKey:@"first_name"];
                account.lastName = [response forcedStringForKey:@"last_name"];
                account.playerID = [response forcedStringForKey:@"id"];
                *status = YES;
            }
        }
    } else {
        *error = [errorRequest description];
    }
    return *status;
}

+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
getAvalibelGamesWithParam:(id)param
      withDelegate:(id<APILibraryDelegate>)delegate {
    NSString *host = [[APILibrary sharedInstance] host];
    NSString *urlString = [NSString stringWithFormat:@"%@/games/getAvailableGames/api?token=%@&game_type_id=1",host,[APILibrary sharedInstance].uniqueIdentifier];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request startSynchronous];
    
    NSError *errorRequest = [request error];
    if (!errorRequest) {
        NSString *response = [request responseString];
        SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
        NSDictionary *obj = [parser objectWithString:response];
        if (obj) {
            *status = YES;
            NSArray *games = [obj arrayForKey:@"response"];
            if ([delegate respondsToSelector:@selector(apiLibraryDidReceivedResult:)]) {
                [delegate apiLibraryDidReceivedResult:games];
            }
        } else {
            *error = @"hello request error";
        }
    } else {
        *error = [errorRequest description];
    }
    if (!*status) {
        if ([delegate respondsToSelector:@selector(apiLibraryDidReceivedError:)]) {
            [delegate apiLibraryDidReceivedError:*error];
        }
    }
    return *status;
}

+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
joinGameWithGameID:(NSString *)gameID
      withDelegate:(id<APILibraryDelegate>)delegate {
    NSString *host = [[APILibrary sharedInstance] host];
    NSString *urlString = [NSString stringWithFormat:@"%@/games/join/api?token=%@&id=%@",host,[APILibrary sharedInstance].uniqueIdentifier,gameID];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request startSynchronous];
    
    NSError *errorRequest = [request error];
    if (!errorRequest) {
        NSString *response = [request responseString];
        SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
        NSDictionary *obj = [parser objectWithString:response];
        if (obj) {
            *status = YES;
            NSString *gameID = [obj objectForKey:@"response"];
            if ([delegate respondsToSelector:@selector(apiLibraryDidReceivedResult:)]) {
                [delegate apiLibraryDidReceivedResult:gameID];
            }
        } else {
            *error = @"join game request error";
        }
    } else {
        *error = [errorRequest description];
    }
    if (!*status) {
        if ([delegate respondsToSelector:@selector(apiLibraryDidReceivedError:)]) {
            [delegate apiLibraryDidReceivedError:*error];
        }
    }
    return *status;
}

+ (BOOL)apiLibrary:(BOOL *)status
          metError:(NSString **)error
getMyRoleWithGameID:(NSString *)gameID
withDelegate:(id<APILibraryDelegate>)delegate {
    NSString *host = [[APILibrary sharedInstance] host];
    NSString *urlString = [NSString stringWithFormat:@"%@/games/myrole/api?token=%@&id=%@",host,[APILibrary sharedInstance].uniqueIdentifier,gameID];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request startSynchronous];
    
    NSError *errorRequest = [request error];
    if (!errorRequest) {
        NSString *response = [request responseString];
        SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
        NSDictionary *obj = [parser objectWithString:response];
        if (obj) {
            *status = YES;
            NSString *gameID = [obj objectForKey:@"response"];
            if ([delegate respondsToSelector:@selector(apiLibraryDidReceivedResult:)]) {
                [delegate apiLibraryDidReceivedResult:gameID];
            }
        } else {
            *error = @"join game request error";
        }
    } else {
        *error = [errorRequest description];
    }
    if (!*status) {
        if ([delegate respondsToSelector:@selector(apiLibraryDidReceivedError:)]) {
            [delegate apiLibraryDidReceivedError:*error];
        }
    }
    return *status;
}

@end
