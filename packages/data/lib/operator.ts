import { Operator, Expression } from './criteria';
import { QueryBuilder } from './query/query.builder';

export const NOT_EQUAL:Operator = (expression:Expression, property:string, value: any): void => {
  expression(`${property} <> ?`, value);
};

export const EQUAL:Operator = (expression:Expression, property:string, value: any): void => {
  expression(`${property} = ?`, value);
};

export const LESS_EQUAL:Operator = (expression:Expression, property:string, value: any): void => {
  expression(`${property} <= ?`, value);
};

export const GREATER_EQUAL:Operator = (expression:Expression, property:string, value: any): void => {
  expression(`${property} >= ?`, value);
};

export const LESS_THAN:Operator = (expression:Expression, property:string, value: any): void => {
  expression(`${property} < ?`, value);
};

export const GREATER_THAN:Operator = (expression:Expression, property:string, value: any): void => {
  expression(`${property} > ?`, value);
};

export const LIKE:Operator = (expression:Expression, property:string, value: any): void => {
  value = '%' + value.replace(/(%)|(_)|(\*)/g, '*$1$2$3').replace(/\*{2}/g, '%') + '%';
  expression(property + ' LIKE ? ESCAPE \'*\'', value);
};

export const ILIKE:Operator = (expression:Expression, property:string, value: any): void => {
  value = '%' + value.toUpperCase().replace(/(%)|(_)|(\*)/g, '*$1$2$3').replace(/\*{2}/g, '%') + '%';
  expression('UPPER(' + property + ') LIKE ? ESCAPE \'*\'', value);
};

export const ILIKE_START:Operator = (expression:Expression, property:string, value: any): void => {
  value = value.toUpperCase().replace(/(%)|(_)|(\*)/g, '*$1$2$3').replace(/\*{2}/g, '%') + '%';
  expression('UPPER(' + property + ') LIKE ? ESCAPE \'*\'', value);
};

export const BETWEEN:Operator = (expression:Expression, property:string, values: any, queryBuilder:QueryBuilder<any>): void => {
  // TODO there's a bug in squel that it's not possible to use more than one param on expr function
  // https://github.com/hiddentao/squel/issues/147
  // expression(property + ' BETWEEN ? AND ?', values[0], values[1]);
  queryBuilder.query.where(property + ' BETWEEN ? AND ?', values[0], values[1]);
};

export const IN:Operator = (expression:Expression, property:string, values: any[]): void => {
  if (values && values.length) {
    expression(property + ' IN ?', values);
  } else {
    expression('0');
  }
};

export const NOT_IN:Operator = (expression:Expression, property:string, values: any[]): void => {
  if (values && values.length > 0) {
    expression(property + ' NOT IN ?', values);
  } else {
    expression('1');
  }
};

export const IS_NULL:Operator = (expression:Expression, property:string): void => {
  expression(`${property} IS NULL`);
};

export const IS_NOT_NULL:Operator = (expression:Expression, property:string): void => {
  expression(`${property} IS NOT NULL`);
};
