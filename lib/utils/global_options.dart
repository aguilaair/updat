/// Used to define options that can be accessed globally by Updat.
/// Properties are static, so there is no need to instantiate this.
class UpdatGlobalOptions {
  /// A [Map] of HTTP headers injected into the downloadRelease
  /// `GET` request made by Updat.
  /// If you need to authenticate to your Git server with a
  /// personal access token, you are able to define that here.
  /// ```dart
  /// UpdatGlobalOptions.downloadReleaseHeaders = {
  ///   "Authorization": "Bearer <personal access token>",
  /// };
  /// ```
  static Map<String, String> downloadReleaseHeaders = {};
}