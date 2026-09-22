#import "Mancry_getDevicebaseData+Internal.h"
#import <Security/Security.h>

@implementation Mancry_getDevicebaseData (Identity)

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
   return [NSMutableDictionary dictionaryWithObjectsAndKeys:
           (id)kSecClassGenericPassword,(id)kSecClass,
           service, (id)kSecAttrService,
           service, (id)kSecAttrAccount,
           (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
           nil];
}

+ (void)save:(NSString *)service data:(id)data {
   NSMutableDictionary *joyces_keychain= [self getKeychainQuery:service];
   SecItemDelete((CFDictionaryRef)joyces_keychain);
   [joyces_keychain setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
   SecItemAdd((CFDictionaryRef)joyces_keychain, NULL);
}

+ (id)load:(NSString *)service {
   id ret = nil;
   NSMutableDictionary *joyces_keychain = [self getKeychainQuery:service];
   [joyces_keychain setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
   [joyces_keychain setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
   CFDataRef keyData = NULL;
   if (SecItemCopyMatching((CFDictionaryRef)joyces_keychain, (CFTypeRef *)&keyData) == noErr) {
       @try {
           ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
       } @catch (NSException *e) {
//            NSLog(@"Unarchive of %@ failed: %@", service, e);
       } @finally {
       }
   }
   if (keyData)
       CFRelease(keyData);
   return ret;
}

+ (void)deleteKeyData:(NSString *)service {
   NSMutableDictionary *joyces_keychain = [self getKeychainQuery:service];
   SecItemDelete((CFDictionaryRef)joyces_keychain);
}

+ (void)IDFAAuthorization{
   if (@available(iOS 14, *)) {
       [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
       }];
   }
}

+ (NSString*)getIDFA{
   __block NSString * idfa = @"";

   if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {

            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
               idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
           } else {
           }}];
   }else {
       idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
   }
   return idfa;
}

+ (NSString*)getIDFV{
   NSString * IDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
   return IDFV;
}

+ (NSString *)mancry_getdeviceIdUUID
{
    
    NSString * joycesUUID = (NSString *)[self load:KEY_USERNAME_PASSWORD];
    if ([joycesUUID isEqualToString:@""] || !joycesUUID)
    {
        joycesUUID = [self getIDFV];

        [self save:KEY_USERNAME_PASSWORD data:joycesUUID];

    }
    return joycesUUID;
}

+ (NSString *)mancry_getIDFV{
    NSString * IDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return IDFV;
}

@end
