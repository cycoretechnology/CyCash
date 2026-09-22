
#import "Mancry_getDevicebaseData+Internal.h"

@implementation Mancry_getDevicebaseData

+ (NSMutableDictionary *)mancry_getResgiterData{
    {
        NSString *noData = @"";
        NSMutableDictionary *mancry_allData = [NSMutableDictionary new];
        
        mancry_allData[@"androidId"] = noData;
        mancry_allData[@"gaid"] = noData;
        mancry_allData[@"uuid"] = [Mancry_getDevicebaseData mancry_getdeviceIdUUID];
        mancry_allData[@"idfa"] = [Mancry_getDevicebaseData getIDFA];
        mancry_allData[@"idfv"] = [Mancry_getDevicebaseData mancry_getIDFV];
        mancry_allData[@"phoneBoard"] = noData;
        mancry_allData[@"phoneBrand"] = @"Apple";
        //
        mancry_allData[@"phoneMark"] = [Mancry_getDevicebaseData getDeviceName];
        mancry_allData[@"phoneType"] = [Mancry_getDevicebaseData mancry_getDeviceTypeFormatted];
        mancry_allData[@"systemVersions"] = [NSString stringWithFormat:@"%@",[Mancry_getDevicebaseData getSystemVersion]];
        mancry_allData[@"versionCode"] = [Mancry_getDevicebaseData getApplicationVersion];
        mancry_allData[@"versionName"] = [Mancry_getDevicebaseData getApplicationVersion];
        mancry_allData[@"sdkVersion"] = noData;
        mancry_allData[@"productionDate"] = noData;
        mancry_allData[@"serial"] = noData;
        mancry_allData[@"screenResolution"] = [Mancry_getDevicebaseData getScreenResolution];
        mancry_allData[@"screenWidth"] = [NSString stringWithFormat:@"%d",(int)[UIScreen mainScreen].bounds.size.width];
        mancry_allData[@"screenHeight"] = [NSString stringWithFormat:@"%d",(int)[UIScreen mainScreen].bounds.size.height];
        mancry_allData[@"cpuNum"] = [NSString stringWithFormat:@"%@",[Mancry_getDevicebaseData cpuCount]];
        NSNumber *nsNumber = [Mancry_getDevicebaseData mancry_ramWithAvailablewhySize];
        double doubleRamCanUse = nsNumber.doubleValue;
        mancry_allData[@"ramCanUse"] = [NSString stringWithFormat:@"%.6f",doubleRamCanUse];
        NSNumber *ramNumer = [Mancry_getDevicebaseData ramTotalMemory];
        double doubleRamTotal = ramNumer.doubleValue;
        NSLog(@"RamTotal---%f",doubleRamTotal);
        mancry_allData[@"ramTotal"] = [NSString stringWithFormat:@"%.6f",doubleRamTotal];
        NSNumber *cashNumber = [Mancry_getDevicebaseData cashAvailableSize];
        
        double doublecashCanUse = cashNumber.doubleValue;
        NSLog(@"cashCanUse---%f",doublecashCanUse);
        mancry_allData[@"cashCanUse"] = [NSString stringWithFormat:@"%.6f",doublecashCanUse];
        NSNumber *nsCash = [Mancry_getDevicebaseData cashTotalSize];
        double doubleCash = nsCash.doubleValue;
        mancry_allData[@"cashTotal"] = [NSString stringWithFormat:@"%.6f",doubleCash];
        mancry_allData[@"batteryLevel"] = [[Mancry_getDevicebaseData batteryLevel]stringValue];
        mancry_allData[@"batteryMax"] = @"100";
        mancry_allData[@"totalBootTime"] = [NSString stringWithFormat:@"%lld",[Mancry_getDevicebaseData getUptimeWithResting]];
        mancry_allData[@"totalBootTimeWake"] = [NSString stringWithFormat:@"%lld",[Mancry_getDevicebaseData getUptimeWithoutResting]];
        mancry_allData[@"defaultLanguage"] = [Mancry_getDevicebaseData getLanguage];
        mancry_allData[@"defaultTimeZone"] = [Mancry_getDevicebaseData getTimeZone];
        //
        NSDictionary *simInfo = [Mancry_getDevicebaseData SIMInfo];
        mancry_allData[@"telephony"] = TL_Str_Protect(simInfo[@"SIM1NetworkOperator"]);
        mancry_allData[@"network"] = [Mancry_getDevicebaseData getNetworkType];

        __block NSString *hotspotSSID = @"";
        __block NSString *hotspotBSSID = @"";

        if (@available(iOS 14.0, *)) {
            dispatch_semaphore_t wifiSemaphore = dispatch_semaphore_create(0);
            [NEHotspotNetwork fetchCurrentWithCompletionHandler:^(NEHotspotNetwork * _Nullable currentNetwork) {
                if (currentNetwork) {
                    hotspotSSID = currentNetwork.SSID ?: @"";
                    hotspotBSSID = currentNetwork.BSSID ?: @"";
                }
                dispatch_semaphore_signal(wifiSemaphore);
            }];
            // 最多等待 2 秒，超时则走 CaptiveNetwork 兜底
            dispatch_semaphore_wait(wifiSemaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)));
        }

        if (hotspotSSID.length == 0 || hotspotBSSID.length == 0) {
            // 兜底：使用 CaptiveNetwork（iOS 15 已标记废弃但仍可用）
            NSDictionary *wifiInfo = [Mancry_getDevicebaseData WifiInfo];
            if (wifiInfo) {
                if (hotspotSSID.length == 0) {
                    hotspotSSID = wifiInfo[@"ssid"] ?: @"";
                }
                if (hotspotBSSID.length == 0) {
                    hotspotBSSID = wifiInfo[@"bssid"] ?: @"";
                }
            }
        }

        
        mancry_allData[@"mac"] = hotspotBSSID;
        mancry_allData[@"wifiName"] = hotspotSSID;
        mancry_allData[@"phoneNum"] = noData;
        mancry_allData[@"phoneNum2"] = noData;
        mancry_allData[@"rooted"] = [self trueOrFalse:[Mancry_getDevicebaseData Jailbroken]];
        mancry_allData[@"debugged"] = [self trueOrFalse:[Mancry_getDevicebaseData debuggerAttached]];
        mancry_allData[@"simulated"] = [self trueOrFalse:[Mancry_getDevicebaseData simulator]];
        mancry_allData[@"proxied"] = [self trueOrFalse:[Mancry_getDevicebaseData getProxyStatus]];
        mancry_allData[@"charged"] = [self trueOrFalse:[Mancry_getDevicebaseData charging]];
        
        // over
        [mancry_allData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:@""]){
                mancry_allData[key] = @"null";
            }
        }];
        
        // new add
        mancry_allData[@"deviceType"] = [Mancry_getDevicebaseData getDeviceType];
        mancry_allData[@"operatingSystem"] = @"2";
        
        mancry_allData[@"lastBootTime"] = [[Mancry_getDevicebaseData getBootTime]stringValue];
        mancry_allData[@"screenBrightness"] = [NSString stringWithFormat:@"%d",(int)[Mancry_getDevicebaseData getScreenBrightness]];
        if (simInfo[@"numberOfSlots"]){
            mancry_allData[@"slotCount"] = [simInfo[@"numberOfSlots"] stringValue];
        }
        if (simInfo[@"numberOfSIMCards"]){
            mancry_allData[@"simCount"] = [simInfo[@"numberOfSIMCards"]stringValue];
        }
        if (simInfo[@"SIM2NetworkOperator"]&& ![simInfo[@"SIM2NetworkOperator"] isEqualToString:@""]){
            mancry_allData[@"telephony2"] = simInfo[@"SIM2NetworkOperator"];
        }
        mancry_allData[@"wifiBssid"] = mancry_allData[@"mac"];
        mancry_allData[@"wifiSsid"] = mancry_allData[@"wifiName"];
        mancry_allData[@"isvpn"] = [self trueOrFalse: [Mancry_getDevicebaseData isVPNOn]];
        
        // -99
        mancry_allData[@"videoInternal"] = @"-99";
        mancry_allData[@"imageInternal"] = @"-99";
        mancry_allData[@"albumFile"] = @"-99";
        
        return mancry_allData;
    }
}

+ (NSString *)trueOrFalse:(BOOL)b{
    return b ? @"true" : @"false";
}

+ (CGFloat)getStatusBarHight {
   float statusBarHeight = 0;
   if (@available(iOS 13.0, *)) {
       UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
       statusBarHeight = statusBarManager.statusBarFrame.size.height;
   }
   else {
       statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
   }
   return statusBarHeight;
}

+ (NSString *)getApplicationVersion{
   return [SystemServices sharedServices].applicationVersion;
}

@end
