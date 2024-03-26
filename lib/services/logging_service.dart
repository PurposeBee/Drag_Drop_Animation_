
// ignore: depend_on_referenced_packages
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    printEmojis: false,
    lineLength: 300
  )
);
