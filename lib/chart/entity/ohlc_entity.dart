// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import,camel_case_types
mixin OHLCEntity {
  double open;
  double high;
  double low;
  double close;

  List<double> maValueList;

//  Upper rail
  double up;
//  Middle rail
  double mb;
//  Down rail
  double dn;

  double BOLLMA;
}
