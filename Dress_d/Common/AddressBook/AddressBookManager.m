//
//  AddressBookManager.m
//  PhoneBook
//
//  Created by admin on 5/31/15.
//  Copyright (c) 2015 kyn. All rights reserved.
//
#import "AddressBookManager.h"

@implementation AddressBookManager

AddressBookManager* _sharedAddressBookManager = nil;

+(AddressBookManager*)sharedAddressBookManager
{
    if( _sharedAddressBookManager == nil )
        _sharedAddressBookManager = [[AddressBookManager alloc] init];
    return _sharedAddressBookManager;
}

- (void)getAddressBook
{
    if(arrContactList != nil)
        [arrContactList removeAllObjects];
    else
        arrContactList = [NSMutableArray arrayWithCapacity:0];
    
    if ( contactsStrore == nil )
        contactsStrore = [[CNContactStore alloc] init];
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted)
    {
        [self.delegate didFinishLoadError:status];
        return;
    }
    
    CNContactStore *store = [[CNContactStore alloc] init];
    if ( store == nil )
        [self.delegate didFinishLoadError:CNAuthorizationStatusDenied];
    
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        // make sure the user granted us access
        if (!granted)
        {
            [self.delegate didFinishLoadError:CNAuthorizationStatusDenied];
            return;
        }
        
        // build array of contacts
        NSMutableArray *contacts = [NSMutableArray array];
        
        NSError *fetchError;
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactPhoneticGivenNameKey, CNContactPhoneticMiddleNameKey, CNContactPhoneticFamilyNameKey, CNContactImageDataKey]];
        
        BOOL success = [store enumerateContactsWithFetchRequest:request error:&fetchError usingBlock:^(CNContact *contact, BOOL *stop) {
            [contacts addObject:contact];
        }];
        if ( !success )
        {
            [self.delegate didFinishLoadError:CNAuthorizationStatusDenied];
            return;
        }
        
        // you can now do something with the list of contacts, for example, to show the names
        
//        CNContactFormatter *formatter = [[CNContactFormatter alloc] init];
        
        for ( CNContact *contact in contacts )
        {
//            NSString *string = [formatter stringFromContact:contact];
//            NSLog(@"contact = %@", string);

            [arrContactList addObject:contact];
        }
        
        [self.delegate didFinishLoadContactInfo:arrContactList];
    }];
    
    return;
}


@end
