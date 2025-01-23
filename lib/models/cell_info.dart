class CellInfo{
  final String type;
  final String cgi;
  final int psc;
  final int cid;
  final int lac;
  final int rnc;
  final String networkIso;
  final int mcc;
  final int mnc;
  final String bandGSMName;
  final String downlinkUarfcn;
  final String cellNumber;
  final int bitErrorRate;
  final int rssi;
  final int ecNo;

  CellInfo({
    required this.type,
    required this.cgi,
    required this.psc,
    required this.cid,
    required this.lac,
    required this.rnc,
    required this.networkIso,
    required this.mcc,
    required this.mnc,
    required this.bandGSMName,
    required this.downlinkUarfcn,
    required this.cellNumber,
    required this.bitErrorRate,
    required this.rssi,
    required this.ecNo,
  });
}