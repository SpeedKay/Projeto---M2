class LoginResponseDto {
  const LoginResponseDto({
    required this.accessToken,
    required this.tokenType,
    required this.expiresInMinutes,
  });

  final String accessToken;
  final String tokenType;
  final int expiresInMinutes;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) => LoginResponseDto(
    accessToken: json['accessToken'] as String,
    tokenType: json['tokenType'] as String,
    expiresInMinutes: (json['expiresInMinutes'] as num).toInt(),
  );
}