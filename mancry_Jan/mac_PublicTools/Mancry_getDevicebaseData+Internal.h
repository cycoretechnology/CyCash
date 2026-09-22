#import "Mancry_getDevicebaseData.h"
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#include <ifaddrs.h>
#import <sys/utsname.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <NetworkExtension/NetworkExtension.h>
#import <CoreTelephony/CTCarrier.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <mach/mach.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#include <sys/sysctl.h>
#import "SystemServices.h"

#define kLocationSuccess @"kLocationSuccess"
#define KEY_USERNAME_PASSWORD @"com.figures.name_password"
#define TL_Str_Protect(str) ((str) ? (str) : (@""))

NS_ASSUME_NONNULL_BEGIN

@interface Mancry_getDevicebaseData () <CLLocationManagerDelegate>
@property (nonatomic, strong, nullable) CLLocationManager *locationManager;
@property (nonatomic, strong, nullable) CLGeocoder *geocoder;
@end

@interface Mancry_getDevicebaseData (Internal)

+ (NSString *)trueOrFalse:(BOOL)b;
+ (CGFloat)getStatusBarHight;
+ (NSString *)getApplicationVersion;

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;
+ (void)IDFAAuthorization;
+ (NSString *)getIDFA;
+ (NSString *)getIDFV;

+ (NSString *)getSystemVersion;
+ (NSString *)getSystem;
+ (NSString *)getLanguage;
+ (NSString *)getTimeZone;
+ (NSNumber *)cpuCount;
+ (NSNumber *)mancry_ramWithAvailablewhySize;
+ (NSNumber *)ramTotalMemory;
+ (NSNumber *)cashTotalSize;
+ (NSNumber *)cashAvailableSize;
+ (NSNumber *)batteryLevel;
+ (BOOL)charging;
+ (NSNumber *)getBootTime;
+ (long long int)getUptimeWithoutResting;
+ (long long int)getUptimeWithResting;
+ (float)getScreenBrightness;
+ (NSString *)getScreenResolution;
+ (NSString *)getDeviceName;

+ (BOOL)isVPNOn;
+ (NSString *)getNetworkType;
+ (NSString *)getNetworkTypeDetail;
+ (NSString *)cellularType;
+ (NSDictionary *)SIMInfo;
+ (NSDictionary *)WifiInfo;
+ (BOOL)getProxyStatus;

+ (BOOL)debuggerAttached;
+ (BOOL)Jailbroken;
+ (BOOL)simulator;

+ (NSNumber *)getDeviceType;
+ (NSString *)getDeviceType2;
+ (NSString *)mancry_getDeviceTypeFormatted;

+ (BOOL)checkPhilippinesPhoneIsRight:(NSString *)phoneNum;
+ (NSArray *)getContactBookInNewConditionWithMaxNum:(NSInteger)maxCount WithPerCount:(NSInteger)perCount WithRightPhoneNum:(NSString *(^)(NSString *phoneNum))rightPhoneNum;
+ (NSArray *)getContactBookByGroupWithContactData:(NSArray *)contactData WithMaxCount:(NSInteger)maxCount WithPerCount:(NSInteger)perCount;
+ (NSArray *)getContactBookInNewConditionWithMaxNum:(NSInteger)maxCount WithRightPhoneNum:(NSString *(^)(NSString *phoneNum))rightPhoneNum;
+ (NSArray *)getAddressBookInfoWithMaxCount:(NSInteger)maxCount;
+ (void)getContactsPermissionStatusWithCompletion:(void(^)(BOOL granted))completion;

+ (void)goToSettingPage;
+ (void)getLocationWithCompletion:(void(^)(double latitude, double longitude, BOOL authorized, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
