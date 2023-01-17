part of sni_core;

extension RequestOptionsExtension on RequestOptions {
  void setHeader(String key, dynamic value) {
    if (!headers.containsKey(key)) {
      headers[key] = value;
    }
  }

  set useAuth(bool value) {
    extra['useAuth'] = value;
  }

  RequestOptions get withoutAuth => this..useAuth = false;
}
