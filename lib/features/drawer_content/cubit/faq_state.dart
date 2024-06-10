import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/drawer_content/data/model/faq_model.dart';

@immutable
abstract class FAQState {}

class FAQInitial extends FAQState {}

class FAQLoading extends FAQState {}

class FAQLoaded extends FAQState {
  FAQModel fAQModel;
  FAQLoaded(this.fAQModel);
}

class FAQError extends FAQState {
  final String message;
  FAQError(this.message);
}
