//
//  RKTUser.h
//  RKTwitter
//
//  Created by Blake Watters on 9/5/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

@interface TWZUser : NSObject {
	NSNumber* _userID;
	NSString* _name;
	NSString* _screenName;
}

@property (nonatomic, retain) NSNumber* userID;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* screenName;

@end
