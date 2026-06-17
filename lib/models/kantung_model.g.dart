// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kantung_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KantungModelAdapter extends TypeAdapter<KantungModel> {
  @override
  final int typeId = 0;

  @override
  KantungModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KantungModel(
      id: fields[0] as String,
      nama: fields[1] as String,
      saldo: fields[2] as double,
      alokasiAwal: fields[3] as double,
      jenisKategori: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, KantungModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nama)
      ..writeByte(2)
      ..write(obj.saldo)
      ..writeByte(3)
      ..write(obj.alokasiAwal)
      ..writeByte(4)
      ..write(obj.jenisKategori);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KantungModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
