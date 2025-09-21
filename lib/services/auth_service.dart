export 'auth_service_stub.dart' // Fallback for other platforms
if (dart.library.html) 'auth_service_web.dart' // USE THIS FOR WEB (CHROME)
if (dart.library.io) 'auth_service_mobile.dart'; // USE THIS FOR MOBILE