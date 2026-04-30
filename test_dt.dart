void main() {
  var str = '2024-05-01T03:19:05+02:00';
  var dt1 = DateTime.parse(str);
  print('dt1: $dt1, isUtc: ${dt1.isUtc}');
  var dt2 = dt1.toLocal();
  print('dt2: $dt2, isUtc: ${dt2.isUtc}');
  var dt3 = DateTime.parse('${str}Z');
  print('dt3: $dt3, isUtc: ${dt3.isUtc}');
}
