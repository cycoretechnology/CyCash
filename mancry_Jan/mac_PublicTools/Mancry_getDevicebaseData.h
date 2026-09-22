
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Mancry_getDevicebaseData : NSObject
+ (NSMutableDictionary *)mancry_getResgiterData;
@end

@interface Mancry_getDevicebaseData (ContactsPublic)
+ (NSArray *)getEquipmentContactWithMaxNum:(NSInteger)maxCount WithPerCount:(NSInteger)perCount;
@end

@interface Mancry_getDevicebaseData (ModelPublic)
+ (NSString *)mancry_getDeviceTypeFormatted;
@end

@interface Mancry_getDevicebaseData (IdentityPublic)
+ (NSString *)mancry_getdeviceIdUUID;
+ (NSString *)mancry_getIDFV;
@end

NS_ASSUME_NONNULL_END
