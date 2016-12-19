//
//  EMHTTPClient.h
//  EMCommunication
//
//  Created by gjz on 15/10/23.
//  Copyright © 2015年 gjz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"//AFNet

#define kDefaultTimeout 10
#define kMinTimeout 2
#define kMaxTimeout 120

#define kTimeoutErrorCode -111111


#pragma mark - ----


typedef void (^AFSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^AFFaildBlock)(AFHTTPRequestOperation *operation, NSError *error);

#pragma mark - ----

@interface EMMediaObject : NSObject

@property (nonatomic, strong) NSData *bytes;//二进制内容
@property (nonatomic, copy) NSString *fieldName; //上传到服务器的key
@property (nonatomic, copy) NSString *fileName; //上传到服务器，存储的文件名，可选，默认image.jpg
@property (nonatomic, copy) NSString *mimeType; //上传到服务器的mimeType,可选，默认image/jpeg


+ (EMMediaObject *)mediaObjectWithBytes:(NSData *)bytes name:(NSString *)name;

@end

#pragma mark - ----

@interface EMHTTPClient : NSObject

#pragma mark - ---- 初始化

/**
 *  初始化
 *
 *  @param host 初始化EMHTTPClient对象，不是单例，每次内部new一个EMHTTPClient对象
 *
 *  @return 对象
 */
+ (EMHTTPClient *)client;


@property (readonly) AFHTTPRequestOperationManager *httpRequestManager;

@property (nonatomic,assign) NSStringEncoding stringEncoding;


#pragma mark - ---- HTTP 头

/**
 *  重置HTTP 头
 *
 */
- (void)resetSerializer;

#pragma mark - ---- HTTP 头

/**
 *  设置自定义HTTP 头
 *
 *  @param value value
 *  @param key   key
 */
- (void)setValue:(id)value forHTTPHeaderKey:(NSString *)key;

#pragma mark - ---- RawData网络请求

/**
 *  发送GET请求，服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation* )asyncRawDataGet:(NSString *)url
                                  paramters:(NSDictionary *)kvParams
                                    timeout:(NSUInteger)timeout
                                    success:(AFSuccessBlock)successBlock
                                      faild:(AFFaildBlock)faildBlock;

/**
 *  发送GET请求，服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param destinationPath     下载到得文件的目标路径
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation* )asyncDownloadGet:(NSString *)url
                                   paramters:(NSDictionary *)kvParams
                             destinationPath:(NSString *)destinationPath
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock;

/**
 *  发送GET请求，直接返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 */
- (AFHTTPRequestOperation* )syncRawDataGet:(NSString *)url
                                 paramters:(NSDictionary *)kvParams
                                   timeout:(NSUInteger)timeout;


/**
 *  发送Post请求, 服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          请求的URL，不能为空
 *  @param paramDict    post的参数key，value形式
 *  @param timeout     timeout时间，单位是秒,如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation *)asyncRawDataPost:(NSString *)url
                                   paramters:(NSDictionary *)paramDict
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock;


/**
 *  发送POST请求，服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param destinationPath     下载到得文件的目标路径
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation* )asyncDownloadPost:(NSString *)url
                                   paramters:(NSDictionary *)kvParams
                             destinationPath:(NSString *)destinationPath
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock;


/**
 *  发送Post请求, 服务端直接返回
 *
 *  @param url          请求的URL，不能为空
 *  @param paramDict    post的参数key，value形式
 *  @param timeout     timeout时间，单位是秒,如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 */
- (AFHTTPRequestOperation *)syncRawDataPost:(NSString *)url
                                   paramters:(NSDictionary *)paramDict
                                     timeout:(NSUInteger)timeout;

/**
 *  发送自定义Request, 服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param request    发送的Request对象，不能为空
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation *)asyncRawDataRequest:(NSURLRequest *)request
                                        timeout:(NSUInteger)timeout
                                        success:(AFSuccessBlock)successBlock
                                          faild:(AFFaildBlock)faildBlock;

/**
 *  发送自定义Request, 服务端直接返回
 *
 *  @param request    发送的Request对象，不能为空
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation *)syncRawDataRequest:(NSURLRequest *)request
                                        timeout:(NSUInteger)timeout;


/**
 *  上传多媒体文件，比如图片, multipart-form形式post上传，服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          上传URL，不能为空
 *  @param paramDict    参数key，value形式
 *  @param mediaObj     media数据
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=120||timeout<=0时候，会使用默认值15s
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation*)asyncRawDataMultipartFormPost:(NSString *)url
                                               paramters:(NSDictionary *)paramDict
                                             mediaObject:(EMMediaObject *)mediaObj
                                                 timeout:(NSUInteger)timeout
                                                 success:(AFSuccessBlock)successBlock
                                                   faild:(AFFaildBlock)faildBlock;

/**
 *  获取文件信息
 *
 *  @param URLString    url
 *  @param parameters   参数key，value形式
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 *
 *  @return
 */

- (AFHTTPRequestOperation *)HEAD:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         timeout:(NSUInteger)timeout
                         success:(AFSuccessBlock)successBlock
                           faild:(AFFaildBlock)faildBlock;


#pragma mark - ---- 取消正在发送的网络请求

/**
 *  取消请求
 *
 *  @param url          请求的URL，不能为空
 */
- (void)cancelRequest:(NSString*)url;

/**
 *  取消请求
 *
 *  @param operation    请求的operation，不能为空
 */
- (void)cancelOperation:(AFHTTPRequestOperation*)operation;


/**
 *  取消所有请求
 *
 */
- (void)cancelAllRequest;

#pragma mark - ---------- 类方法


#pragma mark - ---- HTTP 头

/**
 *  重置HTTP 头
 *
 */
+ (void)resetSerializer;

#pragma mark - ---- HTTP 头

/**
 *  设置自定义HTTP 头
 *
 *  @param value value
 *  @param key   key
 */
+ (void)setValue:(id)value forHTTPHeaderKey:(NSString *)key;

/**
 *  设置编码格式 头
 *
 *  @param encodeing 格式
 */
+ (void)setStringEncoding:(NSStringEncoding)encodeing;


#pragma mark - ---- RawData网络请求

/**
 *  发送GET请求，服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation* )asyncRawDataGet:(NSString *)url
                                  paramters:(NSDictionary *)kvParams
                                    timeout:(NSUInteger)timeout
                                    success:(AFSuccessBlock)successBlock
                                      faild:(AFFaildBlock)faildBlock;

/**
 *  发送GET请求，服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param destinationPath     下载到得文件的目标路径
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation* )asyncDownloadGet:(NSString *)url
                                   paramters:(NSDictionary *)kvParams
                             destinationPath:(NSString *)destinationPath
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock;

/**
 *  发送GET请求，直接返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 */
+ (AFHTTPRequestOperation* )syncRawDataGet:(NSString *)url
                                 paramters:(NSDictionary *)kvParams
                                   timeout:(NSUInteger)timeout;


/**
 *  发送Post请求, 服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          请求的URL，不能为空
 *  @param paramDict    post的参数key，value形式
 *  @param timeout     timeout时间，单位是秒,如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation *)asyncRawDataPost:(NSString *)url
                                   paramters:(NSDictionary *)paramDict
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock;

/**
 *  发送POST请求，服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param destinationPath     下载到得文件的目标路径
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation* )asyncDownloadPost:(NSString *)url
                                    paramters:(NSDictionary *)kvParams
                              destinationPath:(NSString *)destinationPath
                                      timeout:(NSUInteger)timeout
                                      success:(AFSuccessBlock)successBlock
                                        faild:(AFFaildBlock)faildBlock;

/**
 *  发送Post请求, 服务端直接返回
 *
 *  @param url          请求的URL，不能为空
 *  @param paramDict    post的参数key，value形式
 *  @param timeout     timeout时间，单位是秒,如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 */
+ (AFHTTPRequestOperation *)syncRawDataPost:(NSString *)url
                                  paramters:(NSDictionary *)paramDict
                                    timeout:(NSUInteger)timeout;

/**
 *  发送自定义Request, 服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param request    发送的Request对象，不能为空
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation *)asyncRawDataRequest:(NSURLRequest *)request
                                        timeout:(NSUInteger)timeout
                                        success:(AFSuccessBlock)successBlock
                                          faild:(AFFaildBlock)faildBlock;

/**
 *  发送自定义Request, 服务端直接返回
 *
 *  @param request    发送的Request对象，不能为空
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation *)syncRawDataRequest:(NSURLRequest *)request
                                       timeout:(NSUInteger)timeout;


/**
 *  上传多媒体文件，比如图片, multipart-form形式post上传，服务端返回的原始数据(NSData)会通过callback返回
 *
 *  @param url          上传URL，不能为空
 *  @param paramDict    参数key，value形式
 *  @param mediaObj     media数据
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=120||timeout<=0时候，会使用默认值15s
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation*)asyncRawDataMultipartFormPost:(NSString *)url
                                               paramters:(NSDictionary *)paramDict
                                             mediaObject:(EMMediaObject *)mediaObj
                                                 timeout:(NSUInteger)timeout
                                                 success:(AFSuccessBlock)successBlock
                                                   faild:(AFFaildBlock)faildBlock;


/**
 *  获取文件信息
 *
 *  @param URLString    url
 *  @param parameters   参数key，value形式
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 *
 *  @return
 */

+ (AFHTTPRequestOperation *)HEAD:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         timeout:(NSUInteger)timeout
                         success:(AFSuccessBlock)successBlock
                           faild:(AFFaildBlock)faildBlock;


#pragma mark - ---- 取消正在发送的网络请求

/**
 *  取消请求
 *
 *  @param url          请求的URL，不能为空
 */
+ (void)cancelRequest:(NSString*)url;

/**
 *  取消请求
 *
 *  @param operation    请求的operation，不能为空
 */
+ (void)cancelOperation:(AFHTTPRequestOperation*)operation;


/**
 *  取消所有请求
 *
 */
+ (void)cancelAllRequest;

@end

#pragma mark - ----- Request

@interface EMHTTPClient(Request)

/**
 *  返回Request
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param paramDict    请求带的key/value参数
 *  @param method       请求的类型Get/Post
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 */
+ (NSMutableURLRequest *)httpRequest:(NSString *)url
                           paramters:(NSDictionary *)paramDict
                              method:(NSString *)method
                             timeout:(NSUInteger)timeout;

/**
 *  返回Request
 *
 *  @param method       请求的类型Get/Post
 *  @param URLString    请求的URL，参数带在URL里面，不能为空
 *  @param parameters   请求带的key/value参数
 *  @param block        赋值multipart
 */
+ (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;


@end

#pragma mark - ----- JSON 网络请求

@interface EMHTTPClient(JSON)


/**
 *  发送GET请求，服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation *)asyncJSONGet:(NSString *)url
                               paramters:(NSDictionary *)kvParams
                                 timeout:(NSUInteger)timeout
                                 success:(AFSuccessBlock)successBlock
                                   faild:(AFFaildBlock)faildBlock;


/**
 *  发送Post请求, 服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          请求的URL，不能为空
 *  @param paramDict    post的参数key，value形式
 *  @param timeout     timeout时间，单位是秒,如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation *)asyncJSONPost:(NSString *)url
                                paramters:(NSDictionary *)paramDict
                                  timeout:(NSUInteger)timeout
                                  success:(AFSuccessBlock)successBlock
                                    faild:(AFFaildBlock)faildBlock;


/**
 *  发送自定义Request, 服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param request    发送的Request对象，不能为空
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation *)asyncJSONRequest:(NSURLRequest *)request
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock;



/**
 *  上传多媒体文件，比如图片, multipart-form形式post上传，服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          上传URL，不能为空
 *  @param paramDict    参数key，value形式
 *  @param mediaObj     media数据
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=120||timeout<=0时候，会使用默认值15s
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation *)asyncJSONMultipartFormPost:(NSString *)url
                                             paramters:(NSDictionary *)paramDict
                                           mediaObject:(EMMediaObject *)mediaObj
                                               timeout:(NSUInteger)timeout
                                               success:(AFSuccessBlock)successBlock
                                                 faild:(AFFaildBlock)faildBlock;

/**
 *  发送GET请求，服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param kvParams     请求带的key/value参数
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation *)asyncJSONGet:(NSString *)url
                               paramters:(NSDictionary *)kvParams
                                 timeout:(NSUInteger)timeout
                                 success:(AFSuccessBlock)successBlock
                                   faild:(AFFaildBlock)faildBlock;


/**
 *  发送Post请求, 服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          请求的URL，不能为空
 *  @param paramDict    post的参数key，value形式
 *  @param timeout     timeout时间，单位是秒,如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation *)asyncJSONPost:(NSString *)url
                                paramters:(NSDictionary *)paramDict
                                  timeout:(NSUInteger)timeout
                                  success:(AFSuccessBlock)successBlock
                                    faild:(AFFaildBlock)faildBlock;


/**
 *  发送自定义Request, 服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param request    发送的Request对象，不能为空
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation *)asyncJSONRequest:(NSURLRequest *)request
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock;



/**
 *  上传多媒体文件，比如图片, multipart-form形式post上传，服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          上传URL，不能为空
 *  @param paramDict    参数key，value形式
 *  @param mediaObj     media数据
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=120||timeout<=0时候，会使用默认值15s
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation *)asyncJSONMultipartFormPost:(NSString *)url
                                             paramters:(NSDictionary *)paramDict
                                           mediaObject:(EMMediaObject *)mediaObj
                                               timeout:(NSUInteger)timeout
                                               success:(AFSuccessBlock)successBlock
                                                 faild:(AFFaildBlock)faildBlock;

@end




