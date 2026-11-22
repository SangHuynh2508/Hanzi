// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionary_database.dart';

// ignore_for_file: type=lint
class DictEntries extends Table with TableInfo<DictEntries, DictEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DictEntries(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _simplifiedMeta = const VerificationMeta(
    'simplified',
  );
  late final GeneratedColumn<String> simplified = GeneratedColumn<String>(
    'simplified',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _traditionalMeta = const VerificationMeta(
    'traditional',
  );
  late final GeneratedColumn<String> traditional = GeneratedColumn<String>(
    'traditional',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _pinyinMeta = const VerificationMeta('pinyin');
  late final GeneratedColumn<String> pinyin = GeneratedColumn<String>(
    'pinyin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _pinyinPlainMeta = const VerificationMeta(
    'pinyinPlain',
  );
  late final GeneratedColumn<String> pinyinPlain = GeneratedColumn<String>(
    'pinyin_plain',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _hanVietMeta = const VerificationMeta(
    'hanViet',
  );
  late final GeneratedColumn<String> hanViet = GeneratedColumn<String>(
    'han_viet',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _hanVietPlainMeta = const VerificationMeta(
    'hanVietPlain',
  );
  late final GeneratedColumn<String> hanVietPlain = GeneratedColumn<String>(
    'han_viet_plain',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _meaningViMeta = const VerificationMeta(
    'meaningVi',
  );
  late final GeneratedColumn<String> meaningVi = GeneratedColumn<String>(
    'meaning_vi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _meaningViPlainMeta = const VerificationMeta(
    'meaningViPlain',
  );
  late final GeneratedColumn<String> meaningViPlain = GeneratedColumn<String>(
    'meaning_vi_plain',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _meaningEnMeta = const VerificationMeta(
    'meaningEn',
  );
  late final GeneratedColumn<String> meaningEn = GeneratedColumn<String>(
    'meaning_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _hskLevelMeta = const VerificationMeta(
    'hskLevel',
  );
  late final GeneratedColumn<int> hskLevel = GeneratedColumn<int>(
    'hsk_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _freqRankMeta = const VerificationMeta(
    'freqRank',
  );
  late final GeneratedColumn<int> freqRank = GeneratedColumn<int>(
    'freq_rank',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    simplified,
    traditional,
    pinyin,
    pinyinPlain,
    hanViet,
    hanVietPlain,
    meaningVi,
    meaningViPlain,
    meaningEn,
    hskLevel,
    freqRank,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dict_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DictEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('simplified')) {
      context.handle(
        _simplifiedMeta,
        simplified.isAcceptableOrUnknown(data['simplified']!, _simplifiedMeta),
      );
    } else if (isInserting) {
      context.missing(_simplifiedMeta);
    }
    if (data.containsKey('traditional')) {
      context.handle(
        _traditionalMeta,
        traditional.isAcceptableOrUnknown(
          data['traditional']!,
          _traditionalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_traditionalMeta);
    }
    if (data.containsKey('pinyin')) {
      context.handle(
        _pinyinMeta,
        pinyin.isAcceptableOrUnknown(data['pinyin']!, _pinyinMeta),
      );
    } else if (isInserting) {
      context.missing(_pinyinMeta);
    }
    if (data.containsKey('pinyin_plain')) {
      context.handle(
        _pinyinPlainMeta,
        pinyinPlain.isAcceptableOrUnknown(
          data['pinyin_plain']!,
          _pinyinPlainMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pinyinPlainMeta);
    }
    if (data.containsKey('han_viet')) {
      context.handle(
        _hanVietMeta,
        hanViet.isAcceptableOrUnknown(data['han_viet']!, _hanVietMeta),
      );
    } else if (isInserting) {
      context.missing(_hanVietMeta);
    }
    if (data.containsKey('han_viet_plain')) {
      context.handle(
        _hanVietPlainMeta,
        hanVietPlain.isAcceptableOrUnknown(
          data['han_viet_plain']!,
          _hanVietPlainMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hanVietPlainMeta);
    }
    if (data.containsKey('meaning_vi')) {
      context.handle(
        _meaningViMeta,
        meaningVi.isAcceptableOrUnknown(data['meaning_vi']!, _meaningViMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningViMeta);
    }
    if (data.containsKey('meaning_vi_plain')) {
      context.handle(
        _meaningViPlainMeta,
        meaningViPlain.isAcceptableOrUnknown(
          data['meaning_vi_plain']!,
          _meaningViPlainMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_meaningViPlainMeta);
    }
    if (data.containsKey('meaning_en')) {
      context.handle(
        _meaningEnMeta,
        meaningEn.isAcceptableOrUnknown(data['meaning_en']!, _meaningEnMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningEnMeta);
    }
    if (data.containsKey('hsk_level')) {
      context.handle(
        _hskLevelMeta,
        hskLevel.isAcceptableOrUnknown(data['hsk_level']!, _hskLevelMeta),
      );
    }
    if (data.containsKey('freq_rank')) {
      context.handle(
        _freqRankMeta,
        freqRank.isAcceptableOrUnknown(data['freq_rank']!, _freqRankMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DictEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DictEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      simplified: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}simplified'],
      )!,
      traditional: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}traditional'],
      )!,
      pinyin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pinyin'],
      )!,
      pinyinPlain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pinyin_plain'],
      )!,
      hanViet: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}han_viet'],
      )!,
      hanVietPlain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}han_viet_plain'],
      )!,
      meaningVi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning_vi'],
      )!,
      meaningViPlain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning_vi_plain'],
      )!,
      meaningEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning_en'],
      )!,
      hskLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hsk_level'],
      ),
      freqRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}freq_rank'],
      ),
    );
  }

  @override
  DictEntries createAlias(String alias) {
    return DictEntries(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class DictEntry extends DataClass implements Insertable<DictEntry> {
  final int id;
  final String simplified;
  final String traditional;
  final String pinyin;
  final String pinyinPlain;
  final String hanViet;
  final String hanVietPlain;
  final String meaningVi;
  final String meaningViPlain;
  final String meaningEn;
  final int? hskLevel;
  final int? freqRank;
  const DictEntry({
    required this.id,
    required this.simplified,
    required this.traditional,
    required this.pinyin,
    required this.pinyinPlain,
    required this.hanViet,
    required this.hanVietPlain,
    required this.meaningVi,
    required this.meaningViPlain,
    required this.meaningEn,
    this.hskLevel,
    this.freqRank,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['simplified'] = Variable<String>(simplified);
    map['traditional'] = Variable<String>(traditional);
    map['pinyin'] = Variable<String>(pinyin);
    map['pinyin_plain'] = Variable<String>(pinyinPlain);
    map['han_viet'] = Variable<String>(hanViet);
    map['han_viet_plain'] = Variable<String>(hanVietPlain);
    map['meaning_vi'] = Variable<String>(meaningVi);
    map['meaning_vi_plain'] = Variable<String>(meaningViPlain);
    map['meaning_en'] = Variable<String>(meaningEn);
    if (!nullToAbsent || hskLevel != null) {
      map['hsk_level'] = Variable<int>(hskLevel);
    }
    if (!nullToAbsent || freqRank != null) {
      map['freq_rank'] = Variable<int>(freqRank);
    }
    return map;
  }

  DictEntriesCompanion toCompanion(bool nullToAbsent) {
    return DictEntriesCompanion(
      id: Value(id),
      simplified: Value(simplified),
      traditional: Value(traditional),
      pinyin: Value(pinyin),
      pinyinPlain: Value(pinyinPlain),
      hanViet: Value(hanViet),
      hanVietPlain: Value(hanVietPlain),
      meaningVi: Value(meaningVi),
      meaningViPlain: Value(meaningViPlain),
      meaningEn: Value(meaningEn),
      hskLevel: hskLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(hskLevel),
      freqRank: freqRank == null && nullToAbsent
          ? const Value.absent()
          : Value(freqRank),
    );
  }

  factory DictEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DictEntry(
      id: serializer.fromJson<int>(json['id']),
      simplified: serializer.fromJson<String>(json['simplified']),
      traditional: serializer.fromJson<String>(json['traditional']),
      pinyin: serializer.fromJson<String>(json['pinyin']),
      pinyinPlain: serializer.fromJson<String>(json['pinyin_plain']),
      hanViet: serializer.fromJson<String>(json['han_viet']),
      hanVietPlain: serializer.fromJson<String>(json['han_viet_plain']),
      meaningVi: serializer.fromJson<String>(json['meaning_vi']),
      meaningViPlain: serializer.fromJson<String>(json['meaning_vi_plain']),
      meaningEn: serializer.fromJson<String>(json['meaning_en']),
      hskLevel: serializer.fromJson<int?>(json['hsk_level']),
      freqRank: serializer.fromJson<int?>(json['freq_rank']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'simplified': serializer.toJson<String>(simplified),
      'traditional': serializer.toJson<String>(traditional),
      'pinyin': serializer.toJson<String>(pinyin),
      'pinyin_plain': serializer.toJson<String>(pinyinPlain),
      'han_viet': serializer.toJson<String>(hanViet),
      'han_viet_plain': serializer.toJson<String>(hanVietPlain),
      'meaning_vi': serializer.toJson<String>(meaningVi),
      'meaning_vi_plain': serializer.toJson<String>(meaningViPlain),
      'meaning_en': serializer.toJson<String>(meaningEn),
      'hsk_level': serializer.toJson<int?>(hskLevel),
      'freq_rank': serializer.toJson<int?>(freqRank),
    };
  }

  DictEntry copyWith({
    int? id,
    String? simplified,
    String? traditional,
    String? pinyin,
    String? pinyinPlain,
    String? hanViet,
    String? hanVietPlain,
    String? meaningVi,
    String? meaningViPlain,
    String? meaningEn,
    Value<int?> hskLevel = const Value.absent(),
    Value<int?> freqRank = const Value.absent(),
  }) => DictEntry(
    id: id ?? this.id,
    simplified: simplified ?? this.simplified,
    traditional: traditional ?? this.traditional,
    pinyin: pinyin ?? this.pinyin,
    pinyinPlain: pinyinPlain ?? this.pinyinPlain,
    hanViet: hanViet ?? this.hanViet,
    hanVietPlain: hanVietPlain ?? this.hanVietPlain,
    meaningVi: meaningVi ?? this.meaningVi,
    meaningViPlain: meaningViPlain ?? this.meaningViPlain,
    meaningEn: meaningEn ?? this.meaningEn,
    hskLevel: hskLevel.present ? hskLevel.value : this.hskLevel,
    freqRank: freqRank.present ? freqRank.value : this.freqRank,
  );
  DictEntry copyWithCompanion(DictEntriesCompanion data) {
    return DictEntry(
      id: data.id.present ? data.id.value : this.id,
      simplified: data.simplified.present
          ? data.simplified.value
          : this.simplified,
      traditional: data.traditional.present
          ? data.traditional.value
          : this.traditional,
      pinyin: data.pinyin.present ? data.pinyin.value : this.pinyin,
      pinyinPlain: data.pinyinPlain.present
          ? data.pinyinPlain.value
          : this.pinyinPlain,
      hanViet: data.hanViet.present ? data.hanViet.value : this.hanViet,
      hanVietPlain: data.hanVietPlain.present
          ? data.hanVietPlain.value
          : this.hanVietPlain,
      meaningVi: data.meaningVi.present ? data.meaningVi.value : this.meaningVi,
      meaningViPlain: data.meaningViPlain.present
          ? data.meaningViPlain.value
          : this.meaningViPlain,
      meaningEn: data.meaningEn.present ? data.meaningEn.value : this.meaningEn,
      hskLevel: data.hskLevel.present ? data.hskLevel.value : this.hskLevel,
      freqRank: data.freqRank.present ? data.freqRank.value : this.freqRank,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DictEntry(')
          ..write('id: $id, ')
          ..write('simplified: $simplified, ')
          ..write('traditional: $traditional, ')
          ..write('pinyin: $pinyin, ')
          ..write('pinyinPlain: $pinyinPlain, ')
          ..write('hanViet: $hanViet, ')
          ..write('hanVietPlain: $hanVietPlain, ')
          ..write('meaningVi: $meaningVi, ')
          ..write('meaningViPlain: $meaningViPlain, ')
          ..write('meaningEn: $meaningEn, ')
          ..write('hskLevel: $hskLevel, ')
          ..write('freqRank: $freqRank')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    simplified,
    traditional,
    pinyin,
    pinyinPlain,
    hanViet,
    hanVietPlain,
    meaningVi,
    meaningViPlain,
    meaningEn,
    hskLevel,
    freqRank,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DictEntry &&
          other.id == this.id &&
          other.simplified == this.simplified &&
          other.traditional == this.traditional &&
          other.pinyin == this.pinyin &&
          other.pinyinPlain == this.pinyinPlain &&
          other.hanViet == this.hanViet &&
          other.hanVietPlain == this.hanVietPlain &&
          other.meaningVi == this.meaningVi &&
          other.meaningViPlain == this.meaningViPlain &&
          other.meaningEn == this.meaningEn &&
          other.hskLevel == this.hskLevel &&
          other.freqRank == this.freqRank);
}

class DictEntriesCompanion extends UpdateCompanion<DictEntry> {
  final Value<int> id;
  final Value<String> simplified;
  final Value<String> traditional;
  final Value<String> pinyin;
  final Value<String> pinyinPlain;
  final Value<String> hanViet;
  final Value<String> hanVietPlain;
  final Value<String> meaningVi;
  final Value<String> meaningViPlain;
  final Value<String> meaningEn;
  final Value<int?> hskLevel;
  final Value<int?> freqRank;
  const DictEntriesCompanion({
    this.id = const Value.absent(),
    this.simplified = const Value.absent(),
    this.traditional = const Value.absent(),
    this.pinyin = const Value.absent(),
    this.pinyinPlain = const Value.absent(),
    this.hanViet = const Value.absent(),
    this.hanVietPlain = const Value.absent(),
    this.meaningVi = const Value.absent(),
    this.meaningViPlain = const Value.absent(),
    this.meaningEn = const Value.absent(),
    this.hskLevel = const Value.absent(),
    this.freqRank = const Value.absent(),
  });
  DictEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String simplified,
    required String traditional,
    required String pinyin,
    required String pinyinPlain,
    required String hanViet,
    required String hanVietPlain,
    required String meaningVi,
    required String meaningViPlain,
    required String meaningEn,
    this.hskLevel = const Value.absent(),
    this.freqRank = const Value.absent(),
  }) : simplified = Value(simplified),
       traditional = Value(traditional),
       pinyin = Value(pinyin),
       pinyinPlain = Value(pinyinPlain),
       hanViet = Value(hanViet),
       hanVietPlain = Value(hanVietPlain),
       meaningVi = Value(meaningVi),
       meaningViPlain = Value(meaningViPlain),
       meaningEn = Value(meaningEn);
  static Insertable<DictEntry> custom({
    Expression<int>? id,
    Expression<String>? simplified,
    Expression<String>? traditional,
    Expression<String>? pinyin,
    Expression<String>? pinyinPlain,
    Expression<String>? hanViet,
    Expression<String>? hanVietPlain,
    Expression<String>? meaningVi,
    Expression<String>? meaningViPlain,
    Expression<String>? meaningEn,
    Expression<int>? hskLevel,
    Expression<int>? freqRank,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (simplified != null) 'simplified': simplified,
      if (traditional != null) 'traditional': traditional,
      if (pinyin != null) 'pinyin': pinyin,
      if (pinyinPlain != null) 'pinyin_plain': pinyinPlain,
      if (hanViet != null) 'han_viet': hanViet,
      if (hanVietPlain != null) 'han_viet_plain': hanVietPlain,
      if (meaningVi != null) 'meaning_vi': meaningVi,
      if (meaningViPlain != null) 'meaning_vi_plain': meaningViPlain,
      if (meaningEn != null) 'meaning_en': meaningEn,
      if (hskLevel != null) 'hsk_level': hskLevel,
      if (freqRank != null) 'freq_rank': freqRank,
    });
  }

  DictEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? simplified,
    Value<String>? traditional,
    Value<String>? pinyin,
    Value<String>? pinyinPlain,
    Value<String>? hanViet,
    Value<String>? hanVietPlain,
    Value<String>? meaningVi,
    Value<String>? meaningViPlain,
    Value<String>? meaningEn,
    Value<int?>? hskLevel,
    Value<int?>? freqRank,
  }) {
    return DictEntriesCompanion(
      id: id ?? this.id,
      simplified: simplified ?? this.simplified,
      traditional: traditional ?? this.traditional,
      pinyin: pinyin ?? this.pinyin,
      pinyinPlain: pinyinPlain ?? this.pinyinPlain,
      hanViet: hanViet ?? this.hanViet,
      hanVietPlain: hanVietPlain ?? this.hanVietPlain,
      meaningVi: meaningVi ?? this.meaningVi,
      meaningViPlain: meaningViPlain ?? this.meaningViPlain,
      meaningEn: meaningEn ?? this.meaningEn,
      hskLevel: hskLevel ?? this.hskLevel,
      freqRank: freqRank ?? this.freqRank,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (simplified.present) {
      map['simplified'] = Variable<String>(simplified.value);
    }
    if (traditional.present) {
      map['traditional'] = Variable<String>(traditional.value);
    }
    if (pinyin.present) {
      map['pinyin'] = Variable<String>(pinyin.value);
    }
    if (pinyinPlain.present) {
      map['pinyin_plain'] = Variable<String>(pinyinPlain.value);
    }
    if (hanViet.present) {
      map['han_viet'] = Variable<String>(hanViet.value);
    }
    if (hanVietPlain.present) {
      map['han_viet_plain'] = Variable<String>(hanVietPlain.value);
    }
    if (meaningVi.present) {
      map['meaning_vi'] = Variable<String>(meaningVi.value);
    }
    if (meaningViPlain.present) {
      map['meaning_vi_plain'] = Variable<String>(meaningViPlain.value);
    }
    if (meaningEn.present) {
      map['meaning_en'] = Variable<String>(meaningEn.value);
    }
    if (hskLevel.present) {
      map['hsk_level'] = Variable<int>(hskLevel.value);
    }
    if (freqRank.present) {
      map['freq_rank'] = Variable<int>(freqRank.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DictEntriesCompanion(')
          ..write('id: $id, ')
          ..write('simplified: $simplified, ')
          ..write('traditional: $traditional, ')
          ..write('pinyin: $pinyin, ')
          ..write('pinyinPlain: $pinyinPlain, ')
          ..write('hanViet: $hanViet, ')
          ..write('hanVietPlain: $hanVietPlain, ')
          ..write('meaningVi: $meaningVi, ')
          ..write('meaningViPlain: $meaningViPlain, ')
          ..write('meaningEn: $meaningEn, ')
          ..write('hskLevel: $hskLevel, ')
          ..write('freqRank: $freqRank')
          ..write(')'))
        .toString();
  }
}

class Hanzi extends Table with TableInfo<Hanzi, HanziData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Hanzi(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _charMeta = const VerificationMeta('char');
  late final GeneratedColumn<String> char = GeneratedColumn<String>(
    'char',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _hanVietReadingsMeta = const VerificationMeta(
    'hanVietReadings',
  );
  late final GeneratedColumn<String> hanVietReadings = GeneratedColumn<String>(
    'han_viet_readings',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _radicalMeta = const VerificationMeta(
    'radical',
  );
  late final GeneratedColumn<String> radical = GeneratedColumn<String>(
    'radical',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _decompositionMeta = const VerificationMeta(
    'decomposition',
  );
  late final GeneratedColumn<String> decomposition = GeneratedColumn<String>(
    'decomposition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _meaningMeta = const VerificationMeta(
    'meaning',
  );
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
    'meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    char,
    hanVietReadings,
    radical,
    decomposition,
    meaning,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hanzi';
  @override
  VerificationContext validateIntegrity(
    Insertable<HanziData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('char')) {
      context.handle(
        _charMeta,
        char.isAcceptableOrUnknown(data['char']!, _charMeta),
      );
    } else if (isInserting) {
      context.missing(_charMeta);
    }
    if (data.containsKey('han_viet_readings')) {
      context.handle(
        _hanVietReadingsMeta,
        hanVietReadings.isAcceptableOrUnknown(
          data['han_viet_readings']!,
          _hanVietReadingsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hanVietReadingsMeta);
    }
    if (data.containsKey('radical')) {
      context.handle(
        _radicalMeta,
        radical.isAcceptableOrUnknown(data['radical']!, _radicalMeta),
      );
    } else if (isInserting) {
      context.missing(_radicalMeta);
    }
    if (data.containsKey('decomposition')) {
      context.handle(
        _decompositionMeta,
        decomposition.isAcceptableOrUnknown(
          data['decomposition']!,
          _decompositionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_decompositionMeta);
    }
    if (data.containsKey('meaning')) {
      context.handle(
        _meaningMeta,
        meaning.isAcceptableOrUnknown(data['meaning']!, _meaningMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {char};
  @override
  HanziData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HanziData(
      char: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}char'],
      )!,
      hanVietReadings: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}han_viet_readings'],
      )!,
      radical: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}radical'],
      )!,
      decomposition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}decomposition'],
      )!,
      meaning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning'],
      )!,
    );
  }

  @override
  Hanzi createAlias(String alias) {
    return Hanzi(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class HanziData extends DataClass implements Insertable<HanziData> {
  final String char;
  final String hanVietReadings;
  final String radical;
  final String decomposition;
  final String meaning;
  const HanziData({
    required this.char,
    required this.hanVietReadings,
    required this.radical,
    required this.decomposition,
    required this.meaning,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['char'] = Variable<String>(char);
    map['han_viet_readings'] = Variable<String>(hanVietReadings);
    map['radical'] = Variable<String>(radical);
    map['decomposition'] = Variable<String>(decomposition);
    map['meaning'] = Variable<String>(meaning);
    return map;
  }

  HanziCompanion toCompanion(bool nullToAbsent) {
    return HanziCompanion(
      char: Value(char),
      hanVietReadings: Value(hanVietReadings),
      radical: Value(radical),
      decomposition: Value(decomposition),
      meaning: Value(meaning),
    );
  }

  factory HanziData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HanziData(
      char: serializer.fromJson<String>(json['char']),
      hanVietReadings: serializer.fromJson<String>(json['han_viet_readings']),
      radical: serializer.fromJson<String>(json['radical']),
      decomposition: serializer.fromJson<String>(json['decomposition']),
      meaning: serializer.fromJson<String>(json['meaning']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'char': serializer.toJson<String>(char),
      'han_viet_readings': serializer.toJson<String>(hanVietReadings),
      'radical': serializer.toJson<String>(radical),
      'decomposition': serializer.toJson<String>(decomposition),
      'meaning': serializer.toJson<String>(meaning),
    };
  }

  HanziData copyWith({
    String? char,
    String? hanVietReadings,
    String? radical,
    String? decomposition,
    String? meaning,
  }) => HanziData(
    char: char ?? this.char,
    hanVietReadings: hanVietReadings ?? this.hanVietReadings,
    radical: radical ?? this.radical,
    decomposition: decomposition ?? this.decomposition,
    meaning: meaning ?? this.meaning,
  );
  HanziData copyWithCompanion(HanziCompanion data) {
    return HanziData(
      char: data.char.present ? data.char.value : this.char,
      hanVietReadings: data.hanVietReadings.present
          ? data.hanVietReadings.value
          : this.hanVietReadings,
      radical: data.radical.present ? data.radical.value : this.radical,
      decomposition: data.decomposition.present
          ? data.decomposition.value
          : this.decomposition,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HanziData(')
          ..write('char: $char, ')
          ..write('hanVietReadings: $hanVietReadings, ')
          ..write('radical: $radical, ')
          ..write('decomposition: $decomposition, ')
          ..write('meaning: $meaning')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(char, hanVietReadings, radical, decomposition, meaning);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HanziData &&
          other.char == this.char &&
          other.hanVietReadings == this.hanVietReadings &&
          other.radical == this.radical &&
          other.decomposition == this.decomposition &&
          other.meaning == this.meaning);
}

class HanziCompanion extends UpdateCompanion<HanziData> {
  final Value<String> char;
  final Value<String> hanVietReadings;
  final Value<String> radical;
  final Value<String> decomposition;
  final Value<String> meaning;
  final Value<int> rowid;
  const HanziCompanion({
    this.char = const Value.absent(),
    this.hanVietReadings = const Value.absent(),
    this.radical = const Value.absent(),
    this.decomposition = const Value.absent(),
    this.meaning = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HanziCompanion.insert({
    required String char,
    required String hanVietReadings,
    required String radical,
    required String decomposition,
    required String meaning,
    this.rowid = const Value.absent(),
  }) : char = Value(char),
       hanVietReadings = Value(hanVietReadings),
       radical = Value(radical),
       decomposition = Value(decomposition),
       meaning = Value(meaning);
  static Insertable<HanziData> custom({
    Expression<String>? char,
    Expression<String>? hanVietReadings,
    Expression<String>? radical,
    Expression<String>? decomposition,
    Expression<String>? meaning,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (char != null) 'char': char,
      if (hanVietReadings != null) 'han_viet_readings': hanVietReadings,
      if (radical != null) 'radical': radical,
      if (decomposition != null) 'decomposition': decomposition,
      if (meaning != null) 'meaning': meaning,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HanziCompanion copyWith({
    Value<String>? char,
    Value<String>? hanVietReadings,
    Value<String>? radical,
    Value<String>? decomposition,
    Value<String>? meaning,
    Value<int>? rowid,
  }) {
    return HanziCompanion(
      char: char ?? this.char,
      hanVietReadings: hanVietReadings ?? this.hanVietReadings,
      radical: radical ?? this.radical,
      decomposition: decomposition ?? this.decomposition,
      meaning: meaning ?? this.meaning,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (char.present) {
      map['char'] = Variable<String>(char.value);
    }
    if (hanVietReadings.present) {
      map['han_viet_readings'] = Variable<String>(hanVietReadings.value);
    }
    if (radical.present) {
      map['radical'] = Variable<String>(radical.value);
    }
    if (decomposition.present) {
      map['decomposition'] = Variable<String>(decomposition.value);
    }
    if (meaning.present) {
      map['meaning'] = Variable<String>(meaning.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HanziCompanion(')
          ..write('char: $char, ')
          ..write('hanVietReadings: $hanVietReadings, ')
          ..write('radical: $radical, ')
          ..write('decomposition: $decomposition, ')
          ..write('meaning: $meaning, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DictFts extends Table
    with TableInfo<DictFts, DictFt>, VirtualTableInfo<DictFts, DictFt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DictFts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pinyinPlainMeta = const VerificationMeta(
    'pinyinPlain',
  );
  late final GeneratedColumn<String> pinyinPlain = GeneratedColumn<String>(
    'pinyin_plain',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _hanVietPlainMeta = const VerificationMeta(
    'hanVietPlain',
  );
  late final GeneratedColumn<String> hanVietPlain = GeneratedColumn<String>(
    'han_viet_plain',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _meaningViPlainMeta = const VerificationMeta(
    'meaningViPlain',
  );
  late final GeneratedColumn<String> meaningViPlain = GeneratedColumn<String>(
    'meaning_vi_plain',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    pinyinPlain,
    hanVietPlain,
    meaningViPlain,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dict_fts';
  @override
  VerificationContext validateIntegrity(
    Insertable<DictFt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pinyin_plain')) {
      context.handle(
        _pinyinPlainMeta,
        pinyinPlain.isAcceptableOrUnknown(
          data['pinyin_plain']!,
          _pinyinPlainMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pinyinPlainMeta);
    }
    if (data.containsKey('han_viet_plain')) {
      context.handle(
        _hanVietPlainMeta,
        hanVietPlain.isAcceptableOrUnknown(
          data['han_viet_plain']!,
          _hanVietPlainMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hanVietPlainMeta);
    }
    if (data.containsKey('meaning_vi_plain')) {
      context.handle(
        _meaningViPlainMeta,
        meaningViPlain.isAcceptableOrUnknown(
          data['meaning_vi_plain']!,
          _meaningViPlainMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_meaningViPlainMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  DictFt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DictFt(
      pinyinPlain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pinyin_plain'],
      )!,
      hanVietPlain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}han_viet_plain'],
      )!,
      meaningViPlain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning_vi_plain'],
      )!,
    );
  }

  @override
  DictFts createAlias(String alias) {
    return DictFts(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
  @override
  String get moduleAndArgs =>
      'fts5(pinyin_plain, han_viet_plain, meaning_vi_plain, content=\'dict_entries\', content_rowid=\'id\')';
}

class DictFt extends DataClass implements Insertable<DictFt> {
  final String pinyinPlain;
  final String hanVietPlain;
  final String meaningViPlain;
  const DictFt({
    required this.pinyinPlain,
    required this.hanVietPlain,
    required this.meaningViPlain,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pinyin_plain'] = Variable<String>(pinyinPlain);
    map['han_viet_plain'] = Variable<String>(hanVietPlain);
    map['meaning_vi_plain'] = Variable<String>(meaningViPlain);
    return map;
  }

  DictFtsCompanion toCompanion(bool nullToAbsent) {
    return DictFtsCompanion(
      pinyinPlain: Value(pinyinPlain),
      hanVietPlain: Value(hanVietPlain),
      meaningViPlain: Value(meaningViPlain),
    );
  }

  factory DictFt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DictFt(
      pinyinPlain: serializer.fromJson<String>(json['pinyin_plain']),
      hanVietPlain: serializer.fromJson<String>(json['han_viet_plain']),
      meaningViPlain: serializer.fromJson<String>(json['meaning_vi_plain']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pinyin_plain': serializer.toJson<String>(pinyinPlain),
      'han_viet_plain': serializer.toJson<String>(hanVietPlain),
      'meaning_vi_plain': serializer.toJson<String>(meaningViPlain),
    };
  }

  DictFt copyWith({
    String? pinyinPlain,
    String? hanVietPlain,
    String? meaningViPlain,
  }) => DictFt(
    pinyinPlain: pinyinPlain ?? this.pinyinPlain,
    hanVietPlain: hanVietPlain ?? this.hanVietPlain,
    meaningViPlain: meaningViPlain ?? this.meaningViPlain,
  );
  DictFt copyWithCompanion(DictFtsCompanion data) {
    return DictFt(
      pinyinPlain: data.pinyinPlain.present
          ? data.pinyinPlain.value
          : this.pinyinPlain,
      hanVietPlain: data.hanVietPlain.present
          ? data.hanVietPlain.value
          : this.hanVietPlain,
      meaningViPlain: data.meaningViPlain.present
          ? data.meaningViPlain.value
          : this.meaningViPlain,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DictFt(')
          ..write('pinyinPlain: $pinyinPlain, ')
          ..write('hanVietPlain: $hanVietPlain, ')
          ..write('meaningViPlain: $meaningViPlain')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(pinyinPlain, hanVietPlain, meaningViPlain);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DictFt &&
          other.pinyinPlain == this.pinyinPlain &&
          other.hanVietPlain == this.hanVietPlain &&
          other.meaningViPlain == this.meaningViPlain);
}

class DictFtsCompanion extends UpdateCompanion<DictFt> {
  final Value<String> pinyinPlain;
  final Value<String> hanVietPlain;
  final Value<String> meaningViPlain;
  final Value<int> rowid;
  const DictFtsCompanion({
    this.pinyinPlain = const Value.absent(),
    this.hanVietPlain = const Value.absent(),
    this.meaningViPlain = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DictFtsCompanion.insert({
    required String pinyinPlain,
    required String hanVietPlain,
    required String meaningViPlain,
    this.rowid = const Value.absent(),
  }) : pinyinPlain = Value(pinyinPlain),
       hanVietPlain = Value(hanVietPlain),
       meaningViPlain = Value(meaningViPlain);
  static Insertable<DictFt> custom({
    Expression<String>? pinyinPlain,
    Expression<String>? hanVietPlain,
    Expression<String>? meaningViPlain,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (pinyinPlain != null) 'pinyin_plain': pinyinPlain,
      if (hanVietPlain != null) 'han_viet_plain': hanVietPlain,
      if (meaningViPlain != null) 'meaning_vi_plain': meaningViPlain,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DictFtsCompanion copyWith({
    Value<String>? pinyinPlain,
    Value<String>? hanVietPlain,
    Value<String>? meaningViPlain,
    Value<int>? rowid,
  }) {
    return DictFtsCompanion(
      pinyinPlain: pinyinPlain ?? this.pinyinPlain,
      hanVietPlain: hanVietPlain ?? this.hanVietPlain,
      meaningViPlain: meaningViPlain ?? this.meaningViPlain,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pinyinPlain.present) {
      map['pinyin_plain'] = Variable<String>(pinyinPlain.value);
    }
    if (hanVietPlain.present) {
      map['han_viet_plain'] = Variable<String>(hanVietPlain.value);
    }
    if (meaningViPlain.present) {
      map['meaning_vi_plain'] = Variable<String>(meaningViPlain.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DictFtsCompanion(')
          ..write('pinyinPlain: $pinyinPlain, ')
          ..write('hanVietPlain: $hanVietPlain, ')
          ..write('meaningViPlain: $meaningViPlain, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$DictionaryDatabase extends GeneratedDatabase {
  _$DictionaryDatabase(QueryExecutor e) : super(e);
  $DictionaryDatabaseManager get managers => $DictionaryDatabaseManager(this);
  late final DictEntries dictEntries = DictEntries(this);
  late final Index dictEntriesSimplified = Index(
    'dict_entries_simplified',
    'CREATE INDEX dict_entries_simplified ON dict_entries (simplified)',
  );
  late final Index dictEntriesHsk = Index(
    'dict_entries_hsk',
    'CREATE INDEX dict_entries_hsk ON dict_entries (hsk_level)',
  );
  late final Hanzi hanzi = Hanzi(this);
  late final DictFts dictFts = DictFts(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dictEntries,
    dictEntriesSimplified,
    dictEntriesHsk,
    hanzi,
    dictFts,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $DictEntriesCreateCompanionBuilder = DictEntriesCompanion Function({
  Value<int> id,
  required String simplified,
  required String traditional,
  required String pinyin,
  required String pinyinPlain,
  required String hanViet,
  required String hanVietPlain,
  required String meaningVi,
  required String meaningViPlain,
  required String meaningEn,
  Value<int?> hskLevel,
  Value<int?> freqRank,
});
typedef $DictEntriesUpdateCompanionBuilder = DictEntriesCompanion Function({
  Value<int> id,
  Value<String> simplified,
  Value<String> traditional,
  Value<String> pinyin,
  Value<String> pinyinPlain,
  Value<String> hanViet,
  Value<String> hanVietPlain,
  Value<String> meaningVi,
  Value<String> meaningViPlain,
  Value<String> meaningEn,
  Value<int?> hskLevel,
  Value<int?> freqRank,
});

class $DictEntriesFilterComposer
    extends Composer<_$DictionaryDatabase, DictEntries> {
  $DictEntriesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get simplified => $composableBuilder(
    column: $table.simplified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get traditional => $composableBuilder(
    column: $table.traditional,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinyin => $composableBuilder(
    column: $table.pinyin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinyinPlain => $composableBuilder(
    column: $table.pinyinPlain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hanViet => $composableBuilder(
    column: $table.hanViet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hanVietPlain => $composableBuilder(
    column: $table.hanVietPlain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaningVi => $composableBuilder(
    column: $table.meaningVi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaningViPlain => $composableBuilder(
    column: $table.meaningViPlain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaningEn => $composableBuilder(
    column: $table.meaningEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hskLevel => $composableBuilder(
    column: $table.hskLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get freqRank => $composableBuilder(
    column: $table.freqRank,
    builder: (column) => ColumnFilters(column),
  );
}

class $DictEntriesOrderingComposer
    extends Composer<_$DictionaryDatabase, DictEntries> {
  $DictEntriesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get simplified => $composableBuilder(
    column: $table.simplified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get traditional => $composableBuilder(
    column: $table.traditional,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinyin => $composableBuilder(
    column: $table.pinyin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinyinPlain => $composableBuilder(
    column: $table.pinyinPlain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hanViet => $composableBuilder(
    column: $table.hanViet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hanVietPlain => $composableBuilder(
    column: $table.hanVietPlain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningVi => $composableBuilder(
    column: $table.meaningVi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningViPlain => $composableBuilder(
    column: $table.meaningViPlain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningEn => $composableBuilder(
    column: $table.meaningEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hskLevel => $composableBuilder(
    column: $table.hskLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get freqRank => $composableBuilder(
    column: $table.freqRank,
    builder: (column) => ColumnOrderings(column),
  );
}

class $DictEntriesAnnotationComposer
    extends Composer<_$DictionaryDatabase, DictEntries> {
  $DictEntriesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get simplified => $composableBuilder(
    column: $table.simplified,
    builder: (column) => column,
  );

  GeneratedColumn<String> get traditional => $composableBuilder(
    column: $table.traditional,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pinyin =>
      $composableBuilder(column: $table.pinyin, builder: (column) => column);

  GeneratedColumn<String> get pinyinPlain => $composableBuilder(
    column: $table.pinyinPlain,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hanViet =>
      $composableBuilder(column: $table.hanViet, builder: (column) => column);

  GeneratedColumn<String> get hanVietPlain => $composableBuilder(
    column: $table.hanVietPlain,
    builder: (column) => column,
  );

  GeneratedColumn<String> get meaningVi =>
      $composableBuilder(column: $table.meaningVi, builder: (column) => column);

  GeneratedColumn<String> get meaningViPlain => $composableBuilder(
    column: $table.meaningViPlain,
    builder: (column) => column,
  );

  GeneratedColumn<String> get meaningEn =>
      $composableBuilder(column: $table.meaningEn, builder: (column) => column);

  GeneratedColumn<int> get hskLevel =>
      $composableBuilder(column: $table.hskLevel, builder: (column) => column);

  GeneratedColumn<int> get freqRank =>
      $composableBuilder(column: $table.freqRank, builder: (column) => column);
}

class $DictEntriesTableManager
    extends
        RootTableManager<
          _$DictionaryDatabase,
          DictEntries,
          DictEntry,
          $DictEntriesFilterComposer,
          $DictEntriesOrderingComposer,
          $DictEntriesAnnotationComposer,
          $DictEntriesCreateCompanionBuilder,
          $DictEntriesUpdateCompanionBuilder,
          (
            DictEntry,
            BaseReferences<_$DictionaryDatabase, DictEntries, DictEntry>,
          ),
          DictEntry,
          PrefetchHooks Function()
        > {
  $DictEntriesTableManager(_$DictionaryDatabase db, DictEntries table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $DictEntriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $DictEntriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $DictEntriesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> simplified = const Value.absent(),
                Value<String> traditional = const Value.absent(),
                Value<String> pinyin = const Value.absent(),
                Value<String> pinyinPlain = const Value.absent(),
                Value<String> hanViet = const Value.absent(),
                Value<String> hanVietPlain = const Value.absent(),
                Value<String> meaningVi = const Value.absent(),
                Value<String> meaningViPlain = const Value.absent(),
                Value<String> meaningEn = const Value.absent(),
                Value<int?> hskLevel = const Value.absent(),
                Value<int?> freqRank = const Value.absent(),
              }) => DictEntriesCompanion(
                id: id,
                simplified: simplified,
                traditional: traditional,
                pinyin: pinyin,
                pinyinPlain: pinyinPlain,
                hanViet: hanViet,
                hanVietPlain: hanVietPlain,
                meaningVi: meaningVi,
                meaningViPlain: meaningViPlain,
                meaningEn: meaningEn,
                hskLevel: hskLevel,
                freqRank: freqRank,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String simplified,
                required String traditional,
                required String pinyin,
                required String pinyinPlain,
                required String hanViet,
                required String hanVietPlain,
                required String meaningVi,
                required String meaningViPlain,
                required String meaningEn,
                Value<int?> hskLevel = const Value.absent(),
                Value<int?> freqRank = const Value.absent(),
              }) => DictEntriesCompanion.insert(
                id: id,
                simplified: simplified,
                traditional: traditional,
                pinyin: pinyin,
                pinyinPlain: pinyinPlain,
                hanViet: hanViet,
                hanVietPlain: hanVietPlain,
                meaningVi: meaningVi,
                meaningViPlain: meaningViPlain,
                meaningEn: meaningEn,
                hskLevel: hskLevel,
                freqRank: freqRank,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<DictEntries, DictEntry>(table),
                  BaseReferences<_$DictionaryDatabase, DictEntries, DictEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $DictEntriesProcessedTableManager =
    ProcessedTableManager<
      _$DictionaryDatabase,
      DictEntries,
      DictEntry,
      $DictEntriesFilterComposer,
      $DictEntriesOrderingComposer,
      $DictEntriesAnnotationComposer,
      $DictEntriesCreateCompanionBuilder,
      $DictEntriesUpdateCompanionBuilder,
      (DictEntry, BaseReferences<_$DictionaryDatabase, DictEntries, DictEntry>),
      DictEntry,
      PrefetchHooks Function()
    >;
typedef $HanziCreateCompanionBuilder = HanziCompanion Function({
  required String char,
  required String hanVietReadings,
  required String radical,
  required String decomposition,
  required String meaning,
  Value<int> rowid,
});
typedef $HanziUpdateCompanionBuilder = HanziCompanion Function({
  Value<String> char,
  Value<String> hanVietReadings,
  Value<String> radical,
  Value<String> decomposition,
  Value<String> meaning,
  Value<int> rowid,
});

class $HanziFilterComposer extends Composer<_$DictionaryDatabase, Hanzi> {
  $HanziFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get char => $composableBuilder(
    column: $table.char,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hanVietReadings => $composableBuilder(
    column: $table.hanVietReadings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get radical => $composableBuilder(
    column: $table.radical,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get decomposition => $composableBuilder(
    column: $table.decomposition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnFilters(column),
  );
}

class $HanziOrderingComposer extends Composer<_$DictionaryDatabase, Hanzi> {
  $HanziOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get char => $composableBuilder(
    column: $table.char,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hanVietReadings => $composableBuilder(
    column: $table.hanVietReadings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get radical => $composableBuilder(
    column: $table.radical,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get decomposition => $composableBuilder(
    column: $table.decomposition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnOrderings(column),
  );
}

class $HanziAnnotationComposer extends Composer<_$DictionaryDatabase, Hanzi> {
  $HanziAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get char =>
      $composableBuilder(column: $table.char, builder: (column) => column);

  GeneratedColumn<String> get hanVietReadings => $composableBuilder(
    column: $table.hanVietReadings,
    builder: (column) => column,
  );

  GeneratedColumn<String> get radical =>
      $composableBuilder(column: $table.radical, builder: (column) => column);

  GeneratedColumn<String> get decomposition => $composableBuilder(
    column: $table.decomposition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get meaning =>
      $composableBuilder(column: $table.meaning, builder: (column) => column);
}

class $HanziTableManager
    extends
        RootTableManager<
          _$DictionaryDatabase,
          Hanzi,
          HanziData,
          $HanziFilterComposer,
          $HanziOrderingComposer,
          $HanziAnnotationComposer,
          $HanziCreateCompanionBuilder,
          $HanziUpdateCompanionBuilder,
          (HanziData, BaseReferences<_$DictionaryDatabase, Hanzi, HanziData>),
          HanziData,
          PrefetchHooks Function()
        > {
  $HanziTableManager(_$DictionaryDatabase db, Hanzi table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $HanziFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $HanziOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $HanziAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> char = const Value.absent(),
                Value<String> hanVietReadings = const Value.absent(),
                Value<String> radical = const Value.absent(),
                Value<String> decomposition = const Value.absent(),
                Value<String> meaning = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HanziCompanion(
                char: char,
                hanVietReadings: hanVietReadings,
                radical: radical,
                decomposition: decomposition,
                meaning: meaning,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String char,
                required String hanVietReadings,
                required String radical,
                required String decomposition,
                required String meaning,
                Value<int> rowid = const Value.absent(),
              }) => HanziCompanion.insert(
                char: char,
                hanVietReadings: hanVietReadings,
                radical: radical,
                decomposition: decomposition,
                meaning: meaning,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Hanzi, HanziData>(table),
                  BaseReferences<_$DictionaryDatabase, Hanzi, HanziData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $HanziProcessedTableManager =
    ProcessedTableManager<
      _$DictionaryDatabase,
      Hanzi,
      HanziData,
      $HanziFilterComposer,
      $HanziOrderingComposer,
      $HanziAnnotationComposer,
      $HanziCreateCompanionBuilder,
      $HanziUpdateCompanionBuilder,
      (HanziData, BaseReferences<_$DictionaryDatabase, Hanzi, HanziData>),
      HanziData,
      PrefetchHooks Function()
    >;
typedef $DictFtsCreateCompanionBuilder = DictFtsCompanion Function({
  required String pinyinPlain,
  required String hanVietPlain,
  required String meaningViPlain,
  Value<int> rowid,
});
typedef $DictFtsUpdateCompanionBuilder = DictFtsCompanion Function({
  Value<String> pinyinPlain,
  Value<String> hanVietPlain,
  Value<String> meaningViPlain,
  Value<int> rowid,
});

class $DictFtsFilterComposer extends Composer<_$DictionaryDatabase, DictFts> {
  $DictFtsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get pinyinPlain => $composableBuilder(
    column: $table.pinyinPlain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hanVietPlain => $composableBuilder(
    column: $table.hanVietPlain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaningViPlain => $composableBuilder(
    column: $table.meaningViPlain,
    builder: (column) => ColumnFilters(column),
  );
}

class $DictFtsOrderingComposer extends Composer<_$DictionaryDatabase, DictFts> {
  $DictFtsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get pinyinPlain => $composableBuilder(
    column: $table.pinyinPlain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hanVietPlain => $composableBuilder(
    column: $table.hanVietPlain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningViPlain => $composableBuilder(
    column: $table.meaningViPlain,
    builder: (column) => ColumnOrderings(column),
  );
}

class $DictFtsAnnotationComposer
    extends Composer<_$DictionaryDatabase, DictFts> {
  $DictFtsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get pinyinPlain => $composableBuilder(
    column: $table.pinyinPlain,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hanVietPlain => $composableBuilder(
    column: $table.hanVietPlain,
    builder: (column) => column,
  );

  GeneratedColumn<String> get meaningViPlain => $composableBuilder(
    column: $table.meaningViPlain,
    builder: (column) => column,
  );
}

class $DictFtsTableManager
    extends
        RootTableManager<
          _$DictionaryDatabase,
          DictFts,
          DictFt,
          $DictFtsFilterComposer,
          $DictFtsOrderingComposer,
          $DictFtsAnnotationComposer,
          $DictFtsCreateCompanionBuilder,
          $DictFtsUpdateCompanionBuilder,
          (DictFt, BaseReferences<_$DictionaryDatabase, DictFts, DictFt>),
          DictFt,
          PrefetchHooks Function()
        > {
  $DictFtsTableManager(_$DictionaryDatabase db, DictFts table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $DictFtsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $DictFtsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $DictFtsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> pinyinPlain = const Value.absent(),
                Value<String> hanVietPlain = const Value.absent(),
                Value<String> meaningViPlain = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DictFtsCompanion(
                pinyinPlain: pinyinPlain,
                hanVietPlain: hanVietPlain,
                meaningViPlain: meaningViPlain,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String pinyinPlain,
                required String hanVietPlain,
                required String meaningViPlain,
                Value<int> rowid = const Value.absent(),
              }) => DictFtsCompanion.insert(
                pinyinPlain: pinyinPlain,
                hanVietPlain: hanVietPlain,
                meaningViPlain: meaningViPlain,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<DictFts, DictFt>(table),
                  BaseReferences<_$DictionaryDatabase, DictFts, DictFt>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $DictFtsProcessedTableManager =
    ProcessedTableManager<
      _$DictionaryDatabase,
      DictFts,
      DictFt,
      $DictFtsFilterComposer,
      $DictFtsOrderingComposer,
      $DictFtsAnnotationComposer,
      $DictFtsCreateCompanionBuilder,
      $DictFtsUpdateCompanionBuilder,
      (DictFt, BaseReferences<_$DictionaryDatabase, DictFts, DictFt>),
      DictFt,
      PrefetchHooks Function()
    >;

class $DictionaryDatabaseManager {
  final _$DictionaryDatabase _db;
  $DictionaryDatabaseManager(this._db);
  $DictEntriesTableManager get dictEntries =>
      $DictEntriesTableManager(_db, _db.dictEntries);
  $HanziTableManager get hanzi => $HanziTableManager(_db, _db.hanzi);
  $DictFtsTableManager get dictFts => $DictFtsTableManager(_db, _db.dictFts);
}
