//
//  ComputeToken.h
//  HelloWold_OBC
//
//  Created by WL on 13-10-2.
//  Copyright (c) 2013年 WL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComputeToken : NSObject
{
    NSString *_ConditionDateTime;
    NSString *imei;
    NSString *licensestring;
//    NSData *RequestAuthenticatorData;
//    NSString *FinalPassword;
    
}
@property(nonatomic,retain) NSString *ConditionDateTime;
@property(nonatomic,retain) NSString *IMEI;
@property(nonatomic,retain) NSString *LicenseString;

- (id) initConditionDateTime:(NSString *)ConditionDateTime;
- (id) initIMEI:(NSString *)IMEI;
- (id) initLicenseString:(NSString *)LicenseString;

- (NSString*) GetToken;
- (NSData*) ComputeHashString:(NSData *)RequestAuthenticatorData FinalPassword:(NSString*)FinalPasswordString DESKEY:(NSString*)DESKEYString;
-(NSString *) md5:( NSString * )str;
-(NSData*) hexToBytes :(NSString*)HexString;
-(NSString *)ToHex:(long long int)tmpid;
-(NSInteger)HexStringToInteger:(NSString *)HexString;
-(NSString *)GetThreeNumberString:(NSInteger)intNumber;
//private byte[] ComputeHashString(byte[] RequestAuthenticator, string FinalPassword, string DESKEY)

@end
