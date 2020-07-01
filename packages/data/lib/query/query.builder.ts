import { Association, DataType, ModelCtor } from 'sequelize';
import { ProjectionConfiguration, PropertyConfiguration, PropertyOptions, Transformer } from '../projection';
import { Query } from './query';
import { getDeletedAtColumn, getTableName, getValue } from './query.utils';
import _ from 'lodash';
import { CriteriaRequest, Page } from '../model';
import { CriteriaConfiguration, CriteriaFieldConfiguration } from '../criteria';
import squel, { Expression } from 'squel';

class ModelAssociation {
  alias: string;
  association: Association;
  model: ModelCtor<any>;
  modelProperty: string;
}

type FieldDefinition = {
  type: DataType;
  transform?: Transformer;
  alias: string;
  column: string;
}

export interface QueryOptions {
  includeRemoved?: boolean
}

export class QueryBuilder<T> {
  readonly query: Query;

  private aliasCount: number = 0;
  private readonly mainAlias: string;
  private readonly associations: { [key: string]: ModelAssociation; } = {};
  private readonly fields: { [key: string]: FieldDefinition } = {};
  private readonly projectionConfig: ProjectionConfiguration;

  constructor(private model: ModelCtor<any>, private projection: { new(): T; }, private options?: QueryOptions) {
    this.query = new Query(model.sequelize);
    this.mainAlias = this.createAlias(model.name);

    if (!QueryBuilder.isProjection(this.projection)) {
      throw new Error(`The class ${this.projection.name} is not a @Projection`);
    }

    this.projectionConfig = Reflect.getMetadata('projection', this.projection);

    this.query.from(getTableName(model), this.mainAlias);
    if (!options?.includeRemoved && this.model.options.paranoid) {
      this.query.where(this.mainAlias + '.' + getDeletedAtColumn(model) + ' IS NULL');
    }

    this.build(this.mainAlias, this.model, this.projectionConfig);
  }

  sort(sort: string | string []) {
    if (!sort) return;

    const sortList: string [] = typeof sort === 'string' ? [sort] : sort

    for (let sortItem of sortList) {
      const sortField: string = sortItem.charAt(0) === '-' ? sortItem.substr(1) : sortItem;
      const sortAscending: boolean = sortItem.charAt(0) !== '-';

      if (!this.fields.hasOwnProperty(sortField)) {
        throw new Error(`Sort field "${sortField}" not found`);
      }

      const field: FieldDefinition = this.fields[sortField];
      this.query.order(`${field.alias}.${field.column}`, sortAscending);
    }
  }

  criteria(criteriaRequest: CriteriaRequest<any>) {
    if (!criteriaRequest || !criteriaRequest.query) return;

    const { reference, query } = criteriaRequest;

    const criteria: CriteriaConfiguration = Reflect.getMetadata('criteria', reference.prototype);
    if (!criteria) {
      throw new Error(`The class ${reference.name} is not a Criteria`);
    }

    const expression: Expression = squel.expr();

    criteria.fields.forEach((fieldConfig: CriteriaFieldConfiguration) => {
      const { modelProperty } = fieldConfig;

      const queryValue: any = query[fieldConfig.field];
      if (queryValue !== undefined && queryValue !== null) {
        let value = queryValue;
        if (fieldConfig.propertyType === Boolean && fieldConfig.options.value !== undefined) {
          // é boolean
          if (queryValue === true || queryValue === 'true') {
            value = fieldConfig.options.value;
          } else {
            return;
          }
        }

        const field: FieldDefinition = this.getField(modelProperty);
        const property: string = `${field.alias}.${field.column}`;
        fieldConfig.options.operator(expression.and.bind(expression), property, value, this);
      }
    });

    this.query.where(expression);
  }

  private createAlias(name: string): string {
    this.aliasCount += 1;
    return `${name.toLowerCase()}_${this.aliasCount}`;
  }

  private static isProjection(object: any): boolean {
    const projection: ProjectionConfiguration = Reflect.getMetadata('projection', object);
    return projection !== undefined;
  }

  private getAssociationInternal(alias: string, property: string, model: ModelCtor<any>, options?: PropertyOptions): ModelAssociation {
    if (model.rawAttributes.hasOwnProperty(property)) {
      throw new Error(`Property ${property} field is not an association on model ${model.name}`);
    } else if (model.associations.hasOwnProperty(property)) {
      const association: Association = model.associations[property];
      if (!this.associations[property]) {
        const associationAlias: string = this.createAlias(property);
        this.associations[property] = {
          alias: associationAlias,
          modelProperty: property,
          model: association.target,
          association
        };
        // @ts-ignore unfortunately on the type there is no identifierField but we need to use it
        const condition = `${alias}.${association.identifierField} = ${associationAlias}.${association.target.primaryKeyAttribute}`;
        if (options && options.joinType === 'right') {
          this.query.join(association.target.tableName, associationAlias, condition);
        } else {
          this.query.left_join(association.target.tableName, associationAlias, condition);
        }
      }
      return this.associations[property];
    } else {
      throw new Error(`Property ${property} not found on Model ${model.name}`);
    }
  }

  private getAssociation(alias: string, modelProperty: string,
                         model: ModelCtor<any>, options?: PropertyOptions): ModelAssociation {
    if (modelProperty.indexOf('.') > 0) {
      const associations: string [] = modelProperty.split('.');
      let lastAssociation: ModelAssociation = null;
      for (let i = 0; i < associations.length - 1; i++) {
        const currentProperty: string = associations[i];
        const currentModel: ModelCtor<any> = lastAssociation && lastAssociation.model || model;
        lastAssociation = this.getAssociation(lastAssociation?.alias ?? alias,
          currentProperty, currentModel, options);
      }

      return lastAssociation;
    }
    return this.getAssociationInternal(alias, modelProperty, model, options);
  }

  private getField(modelProperty: string): FieldDefinition {
    if (modelProperty.indexOf('.') > 0) {
      const modelAssociation = this.getAssociation(this.mainAlias, modelProperty, this.model);
      const split = modelProperty.split('.');
      const lastProperty = split[split.length - 1];

      if (!modelAssociation.model.rawAttributes.hasOwnProperty(lastProperty)) {
        throw new Error(`Property ${lastProperty} not found on Model ${modelAssociation.model.name}`);
      }
      const field = `${modelAssociation.alias}.${lastProperty}`;
      const column: string = modelAssociation.model.rawAttributes[lastProperty].field ?? lastProperty;
      this.query.field(`${modelAssociation.alias}.${column}`, field);
      this.fields[field] = {
        column,
        alias: modelAssociation.alias,
        type: modelAssociation.model.rawAttributes[lastProperty].type,
      };
      return this.fields[field];
    } else if (this.model.rawAttributes.hasOwnProperty(modelProperty)) {
      const field = `${this.mainAlias}.${modelProperty}`;
      const column: string = this.model.rawAttributes[modelProperty].field ?? modelProperty;
      return this.fields[field] = {
        column,
        alias: this.mainAlias,
        type: this.model.rawAttributes[modelProperty].type,
      };
    } else if (this.model.associations.hasOwnProperty(modelProperty)) {
      throw new Error(`Entire association is not allowed to be on Criteria. ${this.projection.name}.${modelProperty}`);
    } else {
      throw new Error(`Property ${modelProperty} not found on Model ${this.model.name}`);
    }
  }

  private build(alias: string, model: ModelCtor<any>, projection: ProjectionConfiguration, prefix?: string) {
    projection.properties.forEach((property: PropertyConfiguration) => {
      const { modelProperty, projectionProperty, options, propertyType } = property;



      if (modelProperty.indexOf('.') > 0) {
        const modelAssociation: ModelAssociation = this.getAssociation(alias, modelProperty, model, options);
        const split: string [] = modelProperty.split('.');
        const lastProperty: string = split[split.length - 1];
        const column: string = modelAssociation.model.rawAttributes[lastProperty].field ?? lastProperty;

        if (!modelAssociation.model.rawAttributes.hasOwnProperty(lastProperty)) {
          throw new Error(`Property ${lastProperty} not found on Model ${modelAssociation.model.name}`);
        }

        const field: string = prefix ? `${prefix}.${modelProperty}` : projectionProperty;
        this.query.field(`${modelAssociation.alias}.${column}`, field);
        this.fields[field] = {
          column,
          alias: modelAssociation.alias,
          type: modelAssociation.model.rawAttributes[lastProperty].type,
          transform: options && options.transform
        };
      } else if (model.rawAttributes.hasOwnProperty(modelProperty)) {
        const column: string = model.rawAttributes[modelProperty].field ?? modelProperty;
        const field: string = prefix ? `${prefix}.${projectionProperty}` : projectionProperty;
        this.query.field(`${alias}.${column}`, field);
        this.fields[field] = {
          column,
          alias,
          type: model.rawAttributes[modelProperty].type,
          transform: options && options.transform
        };
      } else if (model.associations.hasOwnProperty(modelProperty)) {
        const modelAssociation = this.getAssociation(alias, modelProperty, model, options);

        if (QueryBuilder.isProjection(propertyType)) {
          const associationProjection: ProjectionConfiguration = Reflect.getMetadata('projection', propertyType);
          const newPrefix = prefix ? `${prefix}.${projectionProperty}` : projectionProperty;
          this.build(modelAssociation.alias, modelAssociation.model, associationProjection, newPrefix);
        } else {
          throw new Error(`Property ${modelProperty} is an association, but the type on the Projection is not another Projection`)
        }
      } else {
        throw new Error(`Property ${modelProperty} not found on Model ${model.name}`);
      }
    });
  }

  async list(): Promise<Array<T>> {
    const list: Array<any> = await this.query.list();
    return list.map(item => this.mapItem(item));
  }

  async getPage(): Promise<Page<T>> {
    const page: Page<any> = await this.query.getPage();
    page.list = page.list.map(item => this.mapItem(item));
    return page;
  }

  async single(): Promise<T> {
    return this.mapItem(await this.query.single());
  }

  private mapItem(item: any): any {
    if (item === null) return null;

    const result = {};
    _.forEach(item, (value: any, key: string) => {
      const field: FieldDefinition = this.fields[key];
      const resultValue: any = getValue(field.type, value);
      _.set(result, key, field.transform ? field.transform(resultValue) : resultValue);
    });
    return result;
  }

}