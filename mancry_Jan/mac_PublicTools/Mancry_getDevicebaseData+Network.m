#import "Mancry_getDevicebaseData+Internal.h"
#import <CFNetwork/CFNetwork.h>

static NSString * const mancry_netNotReachableToken = @"notReachable";
#define notReachable mancry_netNotReachableToken

/// Network 差异化：FNV-1a + 路由扇区（异于 Contacts Jenkins），不参与网络结果
static uint32_t mancry_networkRouteStamp = 0;

static uint32_t mancry_networkFNV1a(NSString *text) {
    uint32_t hash = 2166136261u;
    const char *bytes = text.UTF8String ?: "";
    for (const char *p = bytes; *p; p++) {
        hash ^= (uint32_t)(unsigned char)(*p);
        hash *= 16777619u;
    }
    return hash;
}

static NSArray<NSNumber *> *mancry_networkRouteSectors(NSInteger spokes, NSInteger offset) {
    NSInteger count = spokes < 4 ? 4 : spokes;
    NSInteger base = offset < 0 ? 0 : offset;
    NSMutableArray<NSNumber *> *sectors = [NSMutableArray arrayWithCapacity:count];
    uint32_t lane = 0xC0FFEEu;
    for (NSInteger i = 0; i < count; i++) {
        lane = lane * 214013u + 2531011u;
        NSInteger sector = (NSInteger)((lane >> 8) % 17u) + base + i;
        [sectors addObject:@(sector)];
    }
    return sectors;
}

static void mancry_networkWarmRouteLane(void) {
    uint32_t hash = mancry_networkFNV1a(@"network-wifi-wwan-route");
    NSArray<NSNumber *> *sectors = mancry_networkRouteSectors(5, 2);
    uint32_t mix = hash;
    for (NSNumber *sector in sectors) {
        mix ^= (uint32_t)sector.unsignedIntegerValue;
        mix = (mix << 7) | (mix >> 25);
    }
    mancry_networkRouteStamp = mix ^ 0x5A5A5A5Au;
}

static NSString *mancry_networkMapTypeCode(NSString *detail) {
    if ([detail isEqualToString:@"Unknow"]) {
        return @"-99";
    }
    if ([detail isEqualToString:@"WiFi"]) {
        return @"1";
    }
    if ([detail isEqualToString:@"2G"]) {
        return @"2";
    }
    if ([detail isEqualToString:@"3G"]) {
        return @"3";
    }
    if ([detail isEqualToString:@"4G"]) {
        return @"4";
    }
    if ([detail isEqualToString:@"5G"]) {
        return @"5";
    }
    return @"-99";
}

@implementation Mancry_getDevicebaseData (Network)


+ (NSString *)getNetworkType{
   mancry_networkWarmRouteLane();
   NSString *mancry_networkType = [self mancry_getNetworkTypeDetail];
   return mancry_networkMapTypeCode(mancry_networkType);
}



+ (BOOL)isVPNOn
{
  mancry_networkWarmRouteLane();
  BOOL flag = NO;
  NSString *version = [UIDevice currentDevice].systemVersion;
  // need two ways to judge this.
  if (version.doubleValue >= 9.0)
  {
      NSDictionary *mancyr_dict = CFBridgingRelease(CFNetworkCopySystemProxySettings());
      NSArray *mancry_keys = [mancyr_dict[@"__SCOPED__"] allKeys];
      for (NSString *mancry_key in mancry_keys) {
          if ([mancry_key rangeOfString:@"tap"].location != NSNotFound ||
              [mancry_key rangeOfString:@"tun"].location != NSNotFound ||
              [mancry_key rangeOfString:@"ipsec"].location != NSNotFound ||
              [mancry_key rangeOfString:@"ppp"].location != NSNotFound){
              flag = YES;
              break;
          }
      }
  }
  else
  {
      struct ifaddrs *interfaces = NULL;
      struct ifaddrs *temp_addr = NULL;
      int success = 0;
    
      success = getifaddrs(&interfaces);
      if (success == 0)
      {
          
          temp_addr = interfaces;
          while (temp_addr != NULL)
          {
              NSString *mancry_string = [NSString stringWithFormat:@"%s" , temp_addr->ifa_name];
              if ([mancry_string rangeOfString:@"tap"].location != NSNotFound ||
                  [mancry_string rangeOfString:@"tun"].location != NSNotFound ||
                  [mancry_string rangeOfString:@"ipsec"].location != NSNotFound ||
                  [mancry_string rangeOfString:@"ppp"].location != NSNotFound)
              {
                  flag = YES;
                  break;
              }
              temp_addr = temp_addr->ifa_next;
          }
      }
      // Free memory
      freeifaddrs(interfaces);
  }


  return flag;
}

+ (NSString *)mancry_getNetworkTypeDetail {
   
   struct sockaddr_storage mancry_zeroAddress;
   
   bzero(&mancry_zeroAddress, sizeof(mancry_zeroAddress));
    mancry_zeroAddress.ss_len = sizeof(mancry_zeroAddress);
    mancry_zeroAddress.ss_family = AF_INET;
   
   // Recover reachability flags
   SCNetworkReachabilityRef mancry_defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&mancry_zeroAddress);
   SCNetworkReachabilityFlags flags;
   
   BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(mancry_defaultRouteReachability, &flags);
   CFRelease(mancry_defaultRouteReachability);
   
   if (!didRetrieveFlags) {
       return notReachable;
   }
   
   BOOL isReachablemancry = ((flags & kSCNetworkFlagsReachable) != 0);
   BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
   if (isReachablemancry && !needsConnection) { }else{
       return notReachable;
   }
   if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired ) {
       return notReachable;
       
   } else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
       return [self mancry_cellularType];
   } else {
       return @"WiFi";
   }
}

+ (NSString *)mancry_cellularType {
   
   CTTelephonyNetworkInfo * mancry_info = [[CTTelephonyNetworkInfo alloc] init];
   
   NSString *mancryhnology;
   if (@available(iOS 12.1, *)) {
       if (mancry_info && [mancry_info respondsToSelector:@selector(serviceCurrentRadioAccessTechnology)]) {
           NSDictionary *radioDic = [mancry_info serviceCurrentRadioAccessTechnology];
           if (radioDic.allKeys.count) {
               mancryhnology = [radioDic objectForKey:radioDic.allKeys[0]];
           } else {
               return notReachable;
           }
       } else {
           
           return notReachable;
       }
       
   } else {
       
       mancryhnology = mancry_info.currentRadioAccessTechnology;
   }
   
   if (mancryhnology) {
       
       if (@available(iOS 14.1, *)) {
           
           if ([mancryhnology isEqualToString:CTRadioAccessTechnologyNRNSA] || [mancryhnology isEqualToString:CTRadioAccessTechnologyNR]) {
               return @"5G";
           }
       }
       
       if ([mancryhnology isEqualToString:CTRadioAccessTechnologyLTE]) {
           return @"4G";
           
       } else if ([mancryhnology isEqualToString:CTRadioAccessTechnologyWCDMA] || [mancryhnology isEqualToString:CTRadioAccessTechnologyHSDPA] || [mancryhnology isEqualToString:CTRadioAccessTechnologyHSUPA] || [mancryhnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] || [mancryhnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] || [mancryhnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] || [mancryhnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
           return @"3G";
           
       } else if ([mancryhnology isEqualToString:CTRadioAccessTechnologyEdge] || [mancryhnology isEqualToString:CTRadioAccessTechnologyGPRS] || [mancryhnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
           return @"2G";
           
       } else {
           
           return @"Unknow";
       }
       
   } else {
       return notReachable;
   }
}


+ (NSDictionary *)WifiInfo{
   NSArray *mancry_interfaces = CFBridgingRelease(CNCopySupportedInterfaces());
    
   id info = nil;
   for (NSString *interfaceName in mancry_interfaces) {
       info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef)interfaceName);
       if (info) {
           break;
       }
   }
   if (info){
       NSDictionary *infoDic = (NSDictionary *)info;
       NSString *ssid = [infoDic objectForKey:@"SSID"];
       NSString *bssid = [infoDic objectForKey:@"BSSID"];
       
       return @{@"ssid":ssid,@"bssid":bssid};
   }
   return nil;
}


+ (NSDictionary *)SIMInfo{
   
   NSInteger numberOfSlots = 0;
    ///
   NSInteger numberOfSIMCards = 0;
    ///
   NSString *SIM1NetworkOperator = @"";
    ///
   NSString *SIM2NetworkOperator = @"";
   ///
   CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
   //CTCarrier
   NSDictionary *carriers = [info serviceSubscriberCellularProviders];
   for (NSString *name in carriers ){
       numberOfSlots ++;

       CTCarrier *carrier = carriers[name];

       NSString *name = carrier.carrierName;
       if (!name || name.length <= 0){

       }else{
           numberOfSIMCards ++;
           if (numberOfSlots == 1){
               SIM1NetworkOperator = name;
           }else{
               SIM2NetworkOperator = name;
           }
       }
   }
   
   return @{@"numberOfSlots":@(numberOfSlots),@"numberOfSIMCards":@(numberOfSIMCards),@"SIM1NetworkOperator":SIM1NetworkOperator,@"SIM2NetworkOperator":SIM2NetworkOperator};
}


+ (BOOL)getProxyStatus {
   NSDictionary* mancry_proxySettings =  (__bridge NSDictionary*)(CFNetworkCopySystemProxySettings());
   NSArray*proxies = (__bridge NSArray*)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(mancry_proxySettings)));
   NSDictionary*settings = [proxies objectAtIndex:0];
   if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
       
       return NO;
   }else{
       
       return YES;
   }
}

@end
