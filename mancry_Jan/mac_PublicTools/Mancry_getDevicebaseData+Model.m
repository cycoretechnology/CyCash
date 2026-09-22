#import "Mancry_getDevicebaseData+Internal.h"

@implementation Mancry_getDevicebaseData (Model)

+ (NSNumber *)getDeviceType{

   NSNumber *mancry_deviceType = @0;
  
   NSString *detailDeviceType = [self mancry_getDeviceTypeFormatted];
   if ([detailDeviceType hasPrefix:@"iPhone"])
       mancry_deviceType = @3;
   else if ([detailDeviceType hasPrefix:@"iPad"])
       mancry_deviceType = @2;
   else if ([detailDeviceType hasPrefix:@"iMac"] || [detailDeviceType hasPrefix:@"Mac"])
       mancry_deviceType = @1;

   return mancry_deviceType;
}

+ (NSString *)getDeviceType2{
   NSString *mancry_deviceType = @"unknown";
   NSString *detailDeviceType = [self mancry_getDeviceTypeFormatted];
   if ([detailDeviceType hasPrefix:@"iPhone"])
       mancry_deviceType = @"Mobile";
   else if ([detailDeviceType hasPrefix:@"iPad"])
       mancry_deviceType = @"Tablet";
   else if ([detailDeviceType hasPrefix:@"iMac"] || [detailDeviceType hasPrefix:@"Mac"])
       mancry_deviceType = @"pc";
   return mancry_deviceType;
}

+ (NSString *)mancry_getDeviceTypeFormatted{
   NSString *mancry_deviceType;
   NSString *mancry_newDeviceType;
   struct utsname dt;
   
   uname(&dt);
   
    mancry_deviceType = [NSString stringWithFormat:@"%s", dt.machine];
   mancry_newDeviceType = mancry_deviceType;
   // Simulators
   if ([mancry_deviceType isEqualToString:@"i386"])
       mancry_newDeviceType = @"iPhone Simulator";
   else if ([mancry_deviceType isEqualToString:@"x86_64"])
       mancry_newDeviceType = @"iPhone Simulator";
   else if ([mancry_deviceType isEqualToString:@"arm64"])
       mancry_newDeviceType = @"iPhone Simulator";
   // iPhones
   else if ([mancry_deviceType isEqualToString:@"iPhone1,1"])
       mancry_newDeviceType = @"iPhone";
   else if ([mancry_deviceType isEqualToString:@"iPhone1,2"])
       mancry_newDeviceType = @"iPhone 3G";
   else if ([mancry_deviceType isEqualToString:@"iPhone2,1"])
       mancry_newDeviceType = @"iPhone 3GS";
   else if ([mancry_deviceType isEqualToString:@"iPhone3,1"])
       mancry_newDeviceType = @"iPhone 4";
   else if ([mancry_deviceType isEqualToString:@"iPhone4,1"])
       mancry_newDeviceType = @"iPhone 4S";
   else if ([mancry_deviceType isEqualToString:@"iPhone5,1"])
       mancry_newDeviceType = @"iPhone 5";
   else if ([mancry_deviceType isEqualToString:@"iPhone5,2"])
       mancry_newDeviceType = @"iPhone 5";
   else if ([mancry_deviceType isEqualToString:@"iPhone5,3"])
       mancry_newDeviceType = @"iPhone 5c";
   else if ([mancry_deviceType isEqualToString:@"iPhone5,4"])
       mancry_newDeviceType = @"iPhone 5c";
   else if ([mancry_deviceType isEqualToString:@"iPhone6,1"])
       mancry_newDeviceType = @"iPhone 5s";
   else if ([mancry_deviceType isEqualToString:@"iPhone6,2"])
       mancry_newDeviceType = @"iPhone 5s";
   else if ([mancry_deviceType isEqualToString:@"iPhone7,1"])
       mancry_newDeviceType = @"iPhone 6 Plus";
   else if ([mancry_deviceType isEqualToString:@"iPhone7,2"])
       mancry_newDeviceType = @"iPhone 6";
   else if ([mancry_deviceType isEqualToString:@"iPhone8,1"])
       mancry_newDeviceType = @"iPhone 6s";
   else if ([mancry_deviceType isEqualToString:@"iPhone8,2"])
       mancry_newDeviceType = @"iPhone 6s Plus";
   else if ([mancry_deviceType isEqualToString:@"iPhone8,4"])
       mancry_newDeviceType = @"iPhone SE";
   else if ([mancry_deviceType isEqualToString:@"iPhone9,1"])
       mancry_newDeviceType = @"iPhone 7";
   else if ([mancry_deviceType isEqualToString:@"iPhone9,3"])
       mancry_newDeviceType = @"iPhone 7";
   else if ([mancry_deviceType isEqualToString:@"iPhone9,2"])
       mancry_newDeviceType = @"iPhone 7 Plus";
   else if ([mancry_deviceType isEqualToString:@"iPhone9,4"])
       mancry_newDeviceType = @"iPhone 7 Plus";
   else if ([mancry_deviceType isEqualToString:@"iPhone10,1"])
       mancry_newDeviceType = @"iPhone 8";
   else if ([mancry_deviceType isEqualToString:@"iPhone10,4"])
       mancry_newDeviceType = @"iPhone 8";
   else if ([mancry_deviceType isEqualToString:@"iPhone10,2"])
       mancry_newDeviceType = @"iPhone 8 Plus";
   else if ([mancry_deviceType isEqualToString:@"iPhone10,5"])
       mancry_newDeviceType = @"iPhone 8 Plus";
   else if ([mancry_deviceType isEqualToString:@"iPhone10,3"])
       mancry_newDeviceType = @"iPhone X";
   else if ([mancry_deviceType isEqualToString:@"iPhone10,6"])
       mancry_newDeviceType = @"iPhone X";
   else if ([mancry_deviceType isEqualToString:@"iPhone11,8"])
       mancry_newDeviceType = @"iPhone XR";
   else if ([mancry_deviceType isEqualToString:@"iPhone11,2"])
       mancry_newDeviceType = @"iPhone XS";
   else if ([mancry_deviceType isEqualToString:@"iPhone11,6"])
       mancry_newDeviceType = @"iPhone XS Max";
   else if ([mancry_deviceType isEqualToString:@"iPhone12,1"])
       mancry_newDeviceType = @"iPhone 11";
   else if ([mancry_deviceType isEqualToString:@"iPhone12,3"])
       mancry_newDeviceType = @"iPhone 11 Pro";
   else if ([mancry_deviceType isEqualToString:@"iPhone12,5"])
       mancry_newDeviceType = @"iPhone 11 Pro Max";
   else if ([mancry_deviceType isEqualToString:@"iPhone12,8"])
       mancry_newDeviceType = @"iPhone SE 2";
   else if ([mancry_deviceType isEqualToString:@"iPhone13,1"])
       mancry_newDeviceType = @"iPhone 12 mini";
   else if ([mancry_deviceType isEqualToString:@"iPhone13,2"])
       mancry_newDeviceType = @"iPhone 12";
   else if ([mancry_deviceType isEqualToString:@"iPhone13,3"])
       mancry_newDeviceType = @"iPhone 12 Pro";
   else if ([mancry_deviceType isEqualToString:@"iPhone13,4"])
       mancry_newDeviceType = @"iPhone 12 Pro Max";
   else if ([mancry_deviceType isEqualToString:@"iPhone14,4"])
       mancry_newDeviceType = @"iPhone 13 mini";
   else if ([mancry_deviceType isEqualToString:@"iPhone14,5"])
       mancry_newDeviceType = @"iPhone 13";
   else if ([mancry_deviceType isEqualToString:@"iPhone14,2"])
       mancry_newDeviceType = @"iPhone 13 Pro";
   else if ([mancry_deviceType isEqualToString:@"iPhone14,3"])
       mancry_newDeviceType = @"iPhone 13 Pro Max";
   else if ([mancry_deviceType isEqualToString:@"iPhone14,6"])
       mancry_newDeviceType = @"iPhone SE 3";
   else if ([mancry_deviceType isEqualToString:@"iPhone14,7"])
       mancry_newDeviceType = @"iPhone 14";
   else if ([mancry_deviceType isEqualToString:@"iPhone14,8"])
       mancry_newDeviceType = @"iPhone 14 Plus";
   else if ([mancry_deviceType isEqualToString:@"iPhone15,2"])
       mancry_newDeviceType = @"iPhone 14 Pro";
   else if ([mancry_deviceType isEqualToString:@"iPhone15,3"])
       mancry_newDeviceType = @"iPhone 14 Pro Max";
   // iPods
   else if ([mancry_deviceType isEqualToString:@"iPod1,1"])
       mancry_newDeviceType = @"iPod Touch 1G";
   else if ([mancry_deviceType isEqualToString:@"iPod2,1"])
       mancry_newDeviceType = @"iPod Touch 2G";
   else if ([mancry_deviceType isEqualToString:@"iPod3,1"])
       mancry_newDeviceType = @"iPod Touch 3G";
   else if ([mancry_deviceType isEqualToString:@"iPod4,1"])
       mancry_newDeviceType = @"iPod Touch 4G";
   else if ([mancry_deviceType isEqualToString:@"iPod5,1"])
       mancry_newDeviceType = @"iPod Touch 5G";
   else if ([mancry_deviceType isEqualToString:@"iPod7,1"])
       mancry_newDeviceType = @"iPod Touch 6G";
   else if ([mancry_deviceType isEqualToString:@"iPod9,1"])
       mancry_newDeviceType = @"iPod Touch 7G";
   // iPads
   else if ([mancry_deviceType isEqualToString:@"iPad1,1"])
       mancry_newDeviceType = @"iPad";
   else if ([mancry_deviceType isEqualToString:@"iPad2,1"])
       mancry_newDeviceType = @"iPad 2";
   else if ([mancry_deviceType isEqualToString:@"iPad2,2"])
       mancry_newDeviceType = @"iPad 2";
   else if ([mancry_deviceType isEqualToString:@"iPad2,3"])
       mancry_newDeviceType = @"iPad 2";
   else if ([mancry_deviceType isEqualToString:@"iPad2,4"])
       mancry_newDeviceType = @"iPad 2";
   else if ([mancry_deviceType isEqualToString:@"iPad2,5"])
       mancry_newDeviceType = @"iPad mini";
   else if ([mancry_deviceType isEqualToString:@"iPad2,6"])
       mancry_newDeviceType = @"iPad mini";
   else if ([mancry_deviceType isEqualToString:@"iPad2,7"])
       mancry_newDeviceType = @"iPad mini";
   else if ([mancry_deviceType isEqualToString:@"iPad3,1"])
       mancry_newDeviceType = @"iPad 3";
   else if ([mancry_deviceType isEqualToString:@"iPad3,2"])
       mancry_newDeviceType = @"iPad 3";
   else if ([mancry_deviceType isEqualToString:@"iPad3,3"])
       mancry_newDeviceType = @"iPad 3";
   else if ([mancry_deviceType isEqualToString:@"iPad3,4"])
       mancry_newDeviceType = @"iPad 4";
   else if ([mancry_deviceType isEqualToString:@"iPad3,5"])
       mancry_newDeviceType = @"iPad 4";
   else if ([mancry_deviceType isEqualToString:@"iPad3,6"])
       mancry_newDeviceType = @"iPad 4";
   else if ([mancry_deviceType isEqualToString:@"iPad4,1"])
       mancry_newDeviceType = @"iPad Air";
   else if ([mancry_deviceType isEqualToString:@"iPad4,2"])
       mancry_newDeviceType = @"iPad Air";
   else if ([mancry_deviceType isEqualToString:@"iPad4,3"])
       mancry_newDeviceType = @"iPad Air";
   else if ([mancry_deviceType isEqualToString:@"iPad4,4"])
       mancry_newDeviceType = @"iPad mini 2";
   else if ([mancry_deviceType isEqualToString:@"iPad4,5"])
       mancry_newDeviceType = @"iPad mini 2";
   else if ([mancry_deviceType isEqualToString:@"iPad4,6"])
       mancry_newDeviceType = @"iPad mini 2";
   else if ([mancry_deviceType isEqualToString:@"iPad4,7"])
       mancry_newDeviceType = @"iPad mini 3";
   else if ([mancry_deviceType isEqualToString:@"iPad4,8"])
       mancry_newDeviceType = @"iPad mini 3";
   else if ([mancry_deviceType isEqualToString:@"iPad4,9"])
       mancry_newDeviceType = @"iPad mini 3";
   else if ([mancry_deviceType isEqualToString:@"iPad5,1"])
       mancry_newDeviceType = @"iPad mini 4";
   else if ([mancry_deviceType isEqualToString:@"iPad5,2"])
       mancry_newDeviceType = @"iPad mini 4";
   //
   else if ([mancry_deviceType isEqualToString:@"iPad11,1"])
       mancry_newDeviceType = @"iPad mini 5";
   else if ([mancry_deviceType isEqualToString:@"iPad11,2"])
       mancry_newDeviceType = @"iPad mini 5";
   //
   else if ([mancry_deviceType isEqualToString:@"iPad14,1"])
       mancry_newDeviceType = @"iPad mini 6";
   else if ([mancry_deviceType isEqualToString:@"iPad14,2"])
       mancry_newDeviceType = @"iPad mini 6";
   //
   else if ([mancry_deviceType isEqualToString:@"iPad5,3"])
       mancry_newDeviceType = @"iPad Air 2";
   else if ([mancry_deviceType isEqualToString:@"iPad5,4"])
       mancry_newDeviceType = @"iPad Air 2";
   else if ([mancry_deviceType isEqualToString:@"iPad6,3"])
       mancry_newDeviceType = @"iPad Pro (9.7-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad6,4"])
       mancry_newDeviceType = @"iPad Pro (9.7-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad6,7"])
       mancry_newDeviceType = @"iPad Pro (12.9-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad6,8"])
       mancry_newDeviceType = @"iPad Pro (12.9-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad6,11"])
       mancry_newDeviceType = @"iPad 5";
   else if ([mancry_deviceType isEqualToString:@"iPad6,12"])
       mancry_newDeviceType = @"iPad 5";
   else if ([mancry_deviceType isEqualToString:@"iPad7,1"])
       mancry_newDeviceType = @"iPad Pro 2 (12.9-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad7,2"])
       mancry_newDeviceType = @"iPad Pro 2 (12.9-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad7,3"])
       mancry_newDeviceType = @"iPad Pro (10.5-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad7,4"])
       mancry_newDeviceType = @"iPad Pro (10.5-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad7,5"])
       mancry_newDeviceType = @"iPad 6";
   else if ([mancry_deviceType isEqualToString:@"iPad7,6"])
       mancry_newDeviceType = @"iPad 6";
   else if ([mancry_deviceType isEqualToString:@"iPad7,11"])
       mancry_newDeviceType = @"iPad 7";
   else if ([mancry_deviceType isEqualToString:@"iPad7,12"])
       mancry_newDeviceType = @"iPad 7";
   else if ([mancry_deviceType isEqualToString:@"iPad11,6"])
       mancry_newDeviceType = @"iPad 8";
   else if ([mancry_deviceType isEqualToString:@"iPad11,7"])
       mancry_newDeviceType = @"iPad 8";
   else if ([mancry_deviceType isEqualToString:@"iPad12,1"])
       mancry_newDeviceType = @"iPad 9";
   else if ([mancry_deviceType isEqualToString:@"iPad12,2"])
       mancry_newDeviceType = @"iPad 9";
   else if ([mancry_deviceType isEqualToString:@"iPad11,3"])
       mancry_newDeviceType = @"iPad Air 3";
   else if ([mancry_deviceType isEqualToString:@"iPad11,4"])
       mancry_newDeviceType = @"iPad Air 3";
   else if ([mancry_deviceType isEqualToString:@"iPad13,1"])
       mancry_newDeviceType = @"iPad Air 4";
   else if ([mancry_deviceType isEqualToString:@"iPad13,2"])
       mancry_newDeviceType = @"iPad Air 4";
   else if ([mancry_deviceType isEqualToString:@"iPad13,16"])
       mancry_newDeviceType = @"iPad Air 5";
   else if ([mancry_deviceType isEqualToString:@"iPad13,17"])
       mancry_newDeviceType = @"iPad Air 5";
   else if ([mancry_deviceType isEqualToString:@"iPad8,1"])
       mancry_newDeviceType = @"iPad Pro (11-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad8,2"])
       mancry_newDeviceType = @"iPad Pro (11-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad8,3"])
       mancry_newDeviceType = @"iPad Pro (11-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad8,4"])
       mancry_newDeviceType = @"iPad Pro (11-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad8,5"])
       mancry_newDeviceType = @"iPad Pro 3 (12.9-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad8,6"])
       mancry_newDeviceType = @"iPad Pro 3 (12.9-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad8,7"])
       mancry_newDeviceType = @"iPad Pro 3 (12.9-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad8,8"])
       mancry_newDeviceType = @"iPad Pro 3 (12.9-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad8,9"])
       mancry_newDeviceType = @"iPad Pro 2 (11-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad8,10"])
       mancry_newDeviceType = @"iPad Pro 2 (11-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad8,11"])
       mancry_newDeviceType = @"iPad Pro 4 (12.9-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad8,12"])
       mancry_newDeviceType = @"iPad Pro 4 (12.9-inch)";
   //
   else if ([mancry_deviceType isEqualToString:@"iPad13,4"])
       mancry_newDeviceType = @"iPad Pro 3 (11-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad13,5"])
       mancry_newDeviceType = @"iPad Pro 3 (11-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad13,6"])
       mancry_newDeviceType = @"iPad Pro 3 (11-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad13,7"])
       mancry_newDeviceType = @"iPad Pro 3 (11-inch)";
   //
   else if ([mancry_deviceType isEqualToString:@"iPad13,8"])
       mancry_newDeviceType = @"iPad Pro 5 (12.9-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad13,8"])
       mancry_newDeviceType = @"iPad Pro 5 (12.9-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad13,10"])
       mancry_newDeviceType = @"iPad Pro 5 (12.9-inch)";
   else if ([mancry_deviceType isEqualToString:@"iPad13,11"])
       mancry_newDeviceType = @"iPad Pro 5 (12.9-inch)";
   else if ([mancry_deviceType hasPrefix:@"iPad"])
       mancry_newDeviceType = @"iPad";
   
   else if ([mancry_deviceType isEqualToString:@"AppleTV2,1"])
       mancry_newDeviceType = @"Apple TV 2";
   else if ([mancry_deviceType isEqualToString:@"AppleTV3,1"])
       mancry_newDeviceType = @"Apple TV 3";
   else if ([mancry_deviceType isEqualToString:@"AppleTV3,2"])
       mancry_newDeviceType = @"Apple TV 3 (2013)";
   return mancry_newDeviceType;
}

@end
