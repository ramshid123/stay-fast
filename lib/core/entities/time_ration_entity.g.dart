// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_ration_entity.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const FastingTimeRatioEntitySchema = Schema(
  name: r'FastingTimeRatioEntity',
  id: 2282902440284701239,
  properties: {
    r'eat': PropertySchema(
      id: 0,
      name: r'eat',
      type: IsarType.long,
    ),
    r'fast': PropertySchema(
      id: 1,
      name: r'fast',
      type: IsarType.long,
    )
  },
  estimateSize: _fastingTimeRatioEntityEstimateSize,
  serialize: _fastingTimeRatioEntitySerialize,
  deserialize: _fastingTimeRatioEntityDeserialize,
  deserializeProp: _fastingTimeRatioEntityDeserializeProp,
);

int _fastingTimeRatioEntityEstimateSize(
  FastingTimeRatioEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _fastingTimeRatioEntitySerialize(
  FastingTimeRatioEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.eat);
  writer.writeLong(offsets[1], object.fast);
}

FastingTimeRatioEntity _fastingTimeRatioEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FastingTimeRatioEntity(
    eat: reader.readLongOrNull(offsets[0]),
    fast: reader.readLongOrNull(offsets[1]),
  );
  return object;
}

P _fastingTimeRatioEntityDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension FastingTimeRatioEntityQueryFilter on QueryBuilder<
    FastingTimeRatioEntity, FastingTimeRatioEntity, QFilterCondition> {
  QueryBuilder<FastingTimeRatioEntity, FastingTimeRatioEntity,
      QAfterFilterCondition> eatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'eat',
      ));
    });
  }

  QueryBuilder<FastingTimeRatioEntity, FastingTimeRatioEntity,
      QAfterFilterCondition> eatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'eat',
      ));
    });
  }

  QueryBuilder<FastingTimeRatioEntity, FastingTimeRatioEntity,
      QAfterFilterCondition> eatEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eat',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingTimeRatioEntity, FastingTimeRatioEntity,
      QAfterFilterCondition> eatGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eat',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingTimeRatioEntity, FastingTimeRatioEntity,
      QAfterFilterCondition> eatLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eat',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingTimeRatioEntity, FastingTimeRatioEntity,
      QAfterFilterCondition> eatBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FastingTimeRatioEntity, FastingTimeRatioEntity,
      QAfterFilterCondition> fastIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fast',
      ));
    });
  }

  QueryBuilder<FastingTimeRatioEntity, FastingTimeRatioEntity,
      QAfterFilterCondition> fastIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fast',
      ));
    });
  }

  QueryBuilder<FastingTimeRatioEntity, FastingTimeRatioEntity,
      QAfterFilterCondition> fastEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fast',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingTimeRatioEntity, FastingTimeRatioEntity,
      QAfterFilterCondition> fastGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fast',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingTimeRatioEntity, FastingTimeRatioEntity,
      QAfterFilterCondition> fastLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fast',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingTimeRatioEntity, FastingTimeRatioEntity,
      QAfterFilterCondition> fastBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fast',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FastingTimeRatioEntityQueryObject on QueryBuilder<
    FastingTimeRatioEntity, FastingTimeRatioEntity, QFilterCondition> {}
