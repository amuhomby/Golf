//
//  AddressBookManager.h
//  PhoneBook
//
//  Created by admin on 5/31/15.
//  Copyright (c) 2015 kyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

@protocol ContactInfoDelegate

- (void)didFinishLoadContactInfo:(NSMutableArray *)arrContact;

- (void)didFinishLoadError:(CNAuthorizationStatus)status;

@end



@interface AddressBookManager : NSObject
{
    NSMutableArray *arrContactList;
    
    CNContactStore *contactsStrore;

}

@property (nonatomic, retain) id<ContactInfoDelegate> delegate;

+ (AddressBookManager*)sharedAddressBookManager;

- (void)getAddressBook;

@end
