// 取消命名检查
// ignore_for_file: non_constant_identifier_names, constant_identifier_names
import 'package:dio/dio.dart';

//自定url地址配置类
class VentUrls {
  static String apiPath = "https://ventroar.xyz:2548";
  //POST  登录账号(返回该登录用户基本数据)	account,password
  static String signIn = "$apiPath/signin";
  //POST  注册账号(不提供激活但发送验证邮件)	name,email,password
  static String signUp = "$apiPath/signup";
  //POST  作用于接受邮箱激活账号	null
  static String emailActivation = "$apiPath/emailactivation";
  //POST  仅接受头部token登录账号(返回该登录用户基本数据)	null
  static String tokenLogin = "$apiPath/tokenlogin";
  //POST  仅发送激活账号的验证邮件	email
  static String sendActivationEmail = "$apiPath/sendactivationemail";
  //POST  仅发送修改密码的验证邮件	email
  static String rePassword = "$apiPath/repassword";
  //PUT   作用于接受邮箱修改密码	password
  static String rePasswordValidate = "$apiPath/repassword/validate";
  //POST  用于上传图片资源	imager
  static String uploadImg = "$apiPath/uploadImg";
  //POST  用于上传用户头像资源	avatar
  static String uploadAvatar = "$apiPath/uploadavatar";
}

class VentUrlsTest {
  static String apiPath = "http://localhost:2547";
  //POST  登录账号(返回该登录用户基本数据)	account,password
  static String signIn = "$apiPath/signin";
  //POST  注册账号(不提供激活但发送验证邮件)	name,email,password
  static String signUp = "$apiPath/signup";
  //POST  作用于接受邮箱激活账号	null
  static String emailActivation = "$apiPath/emailactivation";
  //POST  仅接受头部token登录账号(返回该登录用户基本数据)	null
  static String tokenLogin = "$apiPath/tokenlogin";
  //POST  仅发送激活账号的验证邮件	email
  static String sendActivationEmail = "$apiPath/sendactivationemail";
  //POST  仅发送修改密码的验证邮件	email
  static String rePassword = "$apiPath/repassword";
  //PUT   作用于接受邮箱修改密码	password
  static String rePasswordValidate = "$apiPath/repassword/validate";
  //POST  用于上传图片资源	imager
  static String uploadImg = "$apiPath/uploadImg";
  //POST  用于上传用户头像资源	avatar
  static String uploadAvatar = "$apiPath/uploadavatar";
}

//自定配置信息类
class DioOptions {
  static String BASIC_URL = VentUrls.apiPath; //基础url地址
  static const int CONNECT_TIMEOUT = 6 * 1000; //连接超时时间
  static const int RECEIVE_TIMEOUT = 6 * 1000; //响应超时时间
  static const bool CACHE_ENABLE = false; //是否开启网络缓存,默认false
  static int MAX_CACHE_AGE = 7 * 24 * 60 * 60; //最大缓存存在期限(按秒),默认缓存七天,可看情况自定
  static int MAX_CACHE_COUNT = 100; //最大缓存条数,默认100条
}

//简单的自定义拦截器
class CustomInterceptors extends Interceptor {
  @override
  //请求之前
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('请求之前');
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  //响应之后
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('响应之后');
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('datas: ${response.data}');
    return super.onResponse(response, handler);
  }

  @override
  //发生异常时
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('发生异常');
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('ERROR-MESSAGE => [${err.response?.data["msg"]}]');

    return super.onError(err, handler);
  }
}

//服务总类(基类、父类)
class Services {
  //全局Dio实例
  static final Services instance = Services._init();
  static Dio? _dio;
  Services._init();

  Future<Dio> get dio async {
    //设置基本配置信息
    var options = BaseOptions(
      //连接超时时间
      connectTimeout: DioOptions.CONNECT_TIMEOUT,
      //响应超时时间
      receiveTimeout: DioOptions.RECEIVE_TIMEOUT,
      //响应数据类型
      responseType: ResponseType.json,
      //默认url地址
      baseUrl: VentUrls.apiPath,
      //头部配置信息
      // headers: /// 自定义Header
    );

    //设置自定义网络拦截器配置
    Dio a = Dio(options);
    a.interceptors.add(CustomInterceptors());
    //检查静态变量dio是否存在
    //如果存在就返回已有的dio
    //如果不存在就创建新的dio实例返回
    return _dio ?? a;
  }

  /// 清空全局dio对象
  void close() {
    _dio != null ? _dio!.close() : _dio = null;
  }
}

class RoarHttpLib {}

class UserHttpLib {
  Future<Map> signIn({required Map<String, dynamic> data}) async {
    Response response;
    response = await Services.instance.dio
        .then((value) => value.post(VentUrlsTest.signIn, data: data));
    return {"headers": response.headers, "data": response.data};
  }

  Future<Map> tokenLogin(
      {required Map<String, dynamic> data, required String token}) async {
    Response response;
    response = await Services.instance.dio.then((value) => value.post(
          VentUrlsTest.signIn,
          data: data,
          options: Options(
            headers: {"x-auth-token": token},
          ),
        ));
    return response.data;
  }

  Future<Map> signUp({required Map<String, dynamic> data}) async {
    Response response;
    response = await Services.instance.dio
        .then((value) => value.post(VentUrlsTest.signUp, data: data));
    return response.data;
  }

  void signOut() {}
}
