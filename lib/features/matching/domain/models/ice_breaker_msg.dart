abstract class IceBreakerMessages {
  List<String> messages;
  IceBreakerMessages(this.messages);

  Map<String, dynamic> toJson();
  IceBreakerMessages fromJson(Map<String, dynamic> json);
}
