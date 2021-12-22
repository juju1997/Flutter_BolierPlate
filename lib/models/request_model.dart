class RequestModel {
  final String id;
  final DateTime reqDate;
  final String header;
  final String body;

  RequestModel ({
    required this.id,
    required this.reqDate,
    required this.header,
    required this.body
  });

  factory RequestModel.fromMap(Map<String, dynamic> data, String documentId){
    DateTime reqDate = DateTime.parse(data['reqDate']);
    String header = data['header'];
    String body = data['body'];

    return RequestModel(id: documentId, reqDate: reqDate, header: header, body: body);
  }

  Map<String, dynamic> toMap() {
    return {
      'header': header,
      'body': body
    };
  }
}

