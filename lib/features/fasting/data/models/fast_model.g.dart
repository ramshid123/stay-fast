// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fast_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFastModelCollection on Isar {
  IsarCollection<FastModel> get fastModels => this.collection();
}

const FastModelSchema = CollectionSchema(
  name: r'FastModel',
  id: 7417374628695995020,
  properties: {
    r'completedDurationInMilliseconds': PropertySchema(
      id: 0,
      name: r'completedDurationInMilliseconds',
      type: IsarType.long,
    ),
    r'durationInMilliseconds': PropertySchema(
      id: 1,
      name: r'durationInMilliseconds',
      type: IsarType.long,
    ),
    r'endTime': PropertySchema(
      id: 2,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'fastingTimeRatio': PropertySchema(
      id: 3,
      name: r'fastingTimeRatio',
      type: IsarType.object,
      target: r'FastingTimeRatioEntity',
    ),
    r'note': PropertySchema(
      id: 4,
      name: r'note',
      type: IsarType.string,
    ),
    r'rating': PropertySchema(
      id: 5,
      name: r'rating',
      type: IsarType.long,
    ),
    r'savedOn': PropertySchema(
      id: 6,
      name: r'savedOn',
      type: IsarType.dateTime,
    ),
    r'startTime': PropertySchema(
      id: 7,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 8,
      name: r'status',
      type: IsarType.byte,
      enumMap: _FastModelstatusEnumValueMap,
    )
  },
  estimateSize: _fastModelEstimateSize,
  serialize: _fastModelSerialize,
  deserialize: _fastModelDeserialize,
  deserializeProp: _fastModelDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {r'FastingTimeRatioEntity': FastingTimeRatioEntitySchema},
  getId: _fastModelGetId,
  getLinks: _fastModelGetLinks,
  attach: _fastModelAttach,
  version: '3.1.0+1',
);

int _fastModelEstimateSize(
  FastModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.fastingTimeRatio;
    if (value != null) {
      bytesCount += 3 +
          FastingTimeRatioEntitySchema.estimateSize(
              value, allOffsets[FastingTimeRatioEntity]!, allOffsets);
    }
  }
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _fastModelSerialize(
  FastModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.completedDurationInMilliseconds);
  writer.writeLong(offsets[1], object.durationInMilliseconds);
  writer.writeDateTime(offsets[2], object.endTime);
  writer.writeObject<FastingTimeRatioEntity>(
    offsets[3],
    allOffsets,
    FastingTimeRatioEntitySchema.serialize,
    object.fastingTimeRatio,
  );
  writer.writeString(offsets[4], object.note);
  writer.writeLong(offsets[5], object.rating);
  writer.writeDateTime(offsets[6], object.savedOn);
  writer.writeDateTime(offsets[7], object.startTime);
  writer.writeByte(offsets[8], object.status.index);
}

FastModel _fastModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FastModel(
    completedDurationInMilliseconds: reader.readLongOrNull(offsets[0]),
    durationInMilliseconds: reader.readLongOrNull(offsets[1]),
    endTime: reader.readDateTimeOrNull(offsets[2]),
    fastingTimeRatio: reader.readObjectOrNull<FastingTimeRatioEntity>(
      offsets[3],
      FastingTimeRatioEntitySchema.deserialize,
      allOffsets,
    ),
    isarId: id,
    note: reader.readStringOrNull(offsets[4]),
    rating: reader.readLongOrNull(offsets[5]),
    savedOn: reader.readDateTimeOrNull(offsets[6]),
    startTime: reader.readDateTimeOrNull(offsets[7]),
    status: _FastModelstatusValueEnumMap[reader.readByteOrNull(offsets[8])] ??
        FastStatus.finished,
  );
  return object;
}

P _fastModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readObjectOrNull<FastingTimeRatioEntity>(
        offset,
        FastingTimeRatioEntitySchema.deserialize,
        allOffsets,
      )) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (_FastModelstatusValueEnumMap[reader.readByteOrNull(offset)] ??
          FastStatus.finished) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _FastModelstatusEnumValueMap = {
  'finished': 0,
  'ongoing': 1,
};
const _FastModelstatusValueEnumMap = {
  0: FastStatus.finished,
  1: FastStatus.ongoing,
};

Id _fastModelGetId(FastModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _fastModelGetLinks(FastModel object) {
  return [];
}

void _fastModelAttach(IsarCollection<dynamic> col, Id id, FastModel object) {
  object.isarId = id;
}

extension FastModelQueryWhereSort
    on QueryBuilder<FastModel, FastModel, QWhere> {
  QueryBuilder<FastModel, FastModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FastModelQueryWhere
    on QueryBuilder<FastModel, FastModel, QWhereClause> {
  QueryBuilder<FastModel, FastModel, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FastModelQueryFilter
    on QueryBuilder<FastModel, FastModel, QFilterCondition> {
  QueryBuilder<FastModel, FastModel, QAfterFilterCondition>
      completedDurationInMillisecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedDurationInMilliseconds',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition>
      completedDurationInMillisecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedDurationInMilliseconds',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition>
      completedDurationInMillisecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedDurationInMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition>
      completedDurationInMillisecondsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedDurationInMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition>
      completedDurationInMillisecondsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedDurationInMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition>
      completedDurationInMillisecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedDurationInMilliseconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition>
      durationInMillisecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'durationInMilliseconds',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition>
      durationInMillisecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'durationInMilliseconds',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition>
      durationInMillisecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationInMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition>
      durationInMillisecondsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationInMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition>
      durationInMillisecondsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationInMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition>
      durationInMillisecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationInMilliseconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> endTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> endTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> endTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> endTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition>
      fastingTimeRatioIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fastingTimeRatio',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition>
      fastingTimeRatioIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fastingTimeRatio',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> isarIdEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> isarIdGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> isarIdLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> isarIdBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> noteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> noteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> ratingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rating',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> ratingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rating',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> ratingEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rating',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> ratingGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rating',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> ratingLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rating',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> ratingBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> savedOnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'savedOn',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> savedOnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'savedOn',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> savedOnEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'savedOn',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> savedOnGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'savedOn',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> savedOnLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'savedOn',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> savedOnBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'savedOn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> startTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startTime',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition>
      startTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startTime',
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> startTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition>
      startTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> startTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> startTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> statusEqualTo(
      FastStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> statusGreaterThan(
    FastStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> statusLessThan(
    FastStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> statusBetween(
    FastStatus lower,
    FastStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FastModelQueryObject
    on QueryBuilder<FastModel, FastModel, QFilterCondition> {
  QueryBuilder<FastModel, FastModel, QAfterFilterCondition> fastingTimeRatio(
      FilterQuery<FastingTimeRatioEntity> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'fastingTimeRatio');
    });
  }
}

extension FastModelQueryLinks
    on QueryBuilder<FastModel, FastModel, QFilterCondition> {}

extension FastModelQuerySortBy on QueryBuilder<FastModel, FastModel, QSortBy> {
  QueryBuilder<FastModel, FastModel, QAfterSortBy>
      sortByCompletedDurationInMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedDurationInMilliseconds', Sort.asc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy>
      sortByCompletedDurationInMillisecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedDurationInMilliseconds', Sort.desc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy>
      sortByDurationInMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMilliseconds', Sort.asc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy>
      sortByDurationInMillisecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMilliseconds', Sort.desc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> sortByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> sortByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> sortBySavedOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedOn', Sort.asc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> sortBySavedOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedOn', Sort.desc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension FastModelQuerySortThenBy
    on QueryBuilder<FastModel, FastModel, QSortThenBy> {
  QueryBuilder<FastModel, FastModel, QAfterSortBy>
      thenByCompletedDurationInMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedDurationInMilliseconds', Sort.asc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy>
      thenByCompletedDurationInMillisecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedDurationInMilliseconds', Sort.desc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy>
      thenByDurationInMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMilliseconds', Sort.asc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy>
      thenByDurationInMillisecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMilliseconds', Sort.desc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> thenByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> thenByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> thenBySavedOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedOn', Sort.asc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> thenBySavedOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedOn', Sort.desc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<FastModel, FastModel, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension FastModelQueryWhereDistinct
    on QueryBuilder<FastModel, FastModel, QDistinct> {
  QueryBuilder<FastModel, FastModel, QDistinct>
      distinctByCompletedDurationInMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedDurationInMilliseconds');
    });
  }

  QueryBuilder<FastModel, FastModel, QDistinct>
      distinctByDurationInMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationInMilliseconds');
    });
  }

  QueryBuilder<FastModel, FastModel, QDistinct> distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<FastModel, FastModel, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FastModel, FastModel, QDistinct> distinctByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rating');
    });
  }

  QueryBuilder<FastModel, FastModel, QDistinct> distinctBySavedOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'savedOn');
    });
  }

  QueryBuilder<FastModel, FastModel, QDistinct> distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<FastModel, FastModel, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }
}

extension FastModelQueryProperty
    on QueryBuilder<FastModel, FastModel, QQueryProperty> {
  QueryBuilder<FastModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<FastModel, int?, QQueryOperations>
      completedDurationInMillisecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedDurationInMilliseconds');
    });
  }

  QueryBuilder<FastModel, int?, QQueryOperations>
      durationInMillisecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationInMilliseconds');
    });
  }

  QueryBuilder<FastModel, DateTime?, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<FastModel, FastingTimeRatioEntity?, QQueryOperations>
      fastingTimeRatioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fastingTimeRatio');
    });
  }

  QueryBuilder<FastModel, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<FastModel, int?, QQueryOperations> ratingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rating');
    });
  }

  QueryBuilder<FastModel, DateTime?, QQueryOperations> savedOnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'savedOn');
    });
  }

  QueryBuilder<FastModel, DateTime?, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<FastModel, FastStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}
