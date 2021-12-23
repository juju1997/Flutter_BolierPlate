class RequestModel {
  final String id;
  String reqDate = (DateTime.now()).toString();
  final String header;
  final String body;

  RequestModel ({
    required this.id,
    required this.header,
    required this.body
  });

  factory RequestModel.fromMap(String documentId, Map<String, dynamic> data){
    String header = data['header'];
    String body = data['body'];

    return RequestModel(id: documentId, header: header, body: body);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reqDate': reqDate,
      'header': header,
      'body': body
    };
  }
}

