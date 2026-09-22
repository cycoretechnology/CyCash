#import "Mancry_getDevicebaseData+Internal.h"

@implementation Mancry_getDevicebaseData (Security)

+ (BOOL)debuggerAttached{
   return [SystemServices sharedServices].debuggerAttached;
}

+ (BOOL)Jailbroken{
   return [SystemServices sharedServices].jailbroken == NOTJAIL ? NO : YES;
}

+ (BOOL)simulator{
   NSString *deviceType = [SystemServices sharedServices].systemDeviceTypeNotFormatted;
   if ([deviceType isEqualToString:@"i386"])
       return YES;
   else if ([deviceType isEqualToString:@"x86_64"])
       return YES;
   else if ([deviceType isEqualToString:@"arm64"])
       return YES;
   
   return NO;
}

@end
