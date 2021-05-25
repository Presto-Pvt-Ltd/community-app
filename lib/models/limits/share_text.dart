import 'package:json_annotation/json_annotation.dart';
part 'share_text.g.dart';

@JsonSerializable()
class ShareText {
  final String text;

  ShareText({
    required this.text,
  });
  factory ShareText.fromJson(Map<String, dynamic> json) =>
      _$ShareTextFromJson(json);
  Map<String, dynamic> toJson() => _$ShareTextToJson(this);
}
