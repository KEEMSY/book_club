// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curation_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CurationCard _$CurationCardFromJson(Map<String, dynamic> json) =>
    _CurationCard(
      id: json['id'] as String,
      bookId: json['book_id'] as String,
      cardType: json['card_type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      orderIndex: (json['order_index'] as num).toInt(),
    );

Map<String, dynamic> _$CurationCardToJson(_CurationCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'book_id': instance.bookId,
      'card_type': instance.cardType,
      'title': instance.title,
      'body': instance.body,
      'order_index': instance.orderIndex,
    };
