const String urlFull= 'http://example.com';

const String tokenId = 'token';
const String secret = 'secret';
String token = 'Token $tokenId:$secret';

final headers = {
  'Authorization': token,
};