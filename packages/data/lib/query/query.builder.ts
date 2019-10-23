import { Association, ModelAttributeColumnOptions, ModelCtor } from 'sequelize';
import { ProjectionConfiguration, PropertyConfiguration, PropertyOptions } from '../projection';
import { Query } from './query';
import { getDeletedAtColumn, getTableName } from './query.utils';
import _ from 'lodash';

class ModelAssociation {
  alias: string;
  association: Association;
  model: ModelCtor<any>;
  modelProperty: string;
}

export class QueryBuilder<T> {
  private query: Query;
  private aliasCount:number = 0;
  private readonly mainAlias:string;
  private readonly associations: { [key: string]: ModelAssociation; } = {};

  constructor(private model:ModelCtor<any>, private projection:{ new(): T; }) {
    this.query = new Query(model.sequelize);
    this.mainAlias = this.createAlias(model.name);

    if (!QueryBuilder.isProjection(this.projection)) {
      throw new Error('This class is not a @Projection');
    }
    const projectionConfig:ProjectionConfiguration = Reflect.getMetadata('projection', this.projection);

    this.query.from(getTableName(model), this.mainAlias);
    if (this.model.options.paranoid) {
      this.query.where(this.mainAlias + '.' + getDeletedAtColumn(model) + ' IS NULL');
    }

    this.build(this.mainAlias, this.model, projectionConfig);
  }

  private createAlias(name: string) {
    this.aliasCount += 1;
    return `${name.toLowerCase()}_${this.aliasCount}`;
  }

  private static isProjection(object: any):boolean {
    const projection:ProjectionConfiguration = Reflect.getMetadata('projection', object);
    return projection !== undefined;
  }

  private getAssociationInternal(alias:string, property:string, model:ModelCtor<any>, options?:PropertyOptions):ModelAssociation {
    if (model.rawAttributes.hasOwnProperty(property)) {
      throw new Error(`Property ${property} field is not an association on model ${model.name}`);
    } else if (model.associations.hasOwnProperty(property)) {
      const association:Association = model.associations[property];
      if (!this.associations[property]) {
        const associationAlias = this.createAlias(property);
        this.associations[property] = {
          alias: associationAlias,
          modelProperty: property,
          model: association.target,
          association
        };
        const condition = `${alias}.${association.source.primaryKeyAttribute} = ${associationAlias}.${association.target.primaryKeyAttribute}`;
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

  private getAssociation(alias:string, modelProperty:string, model:ModelCtor<any>, options?:PropertyOptions) {
    if (modelProperty.indexOf('.') > 0) {
      const associations = modelProperty.split('.');
      let lastAssociation:ModelAssociation = null;
      for (let i = 0; i < associations.length - 1; i++) {
        const currentProperty = associations[i];
        const currentModel:ModelCtor<any> = lastAssociation && lastAssociation.model || model;
        lastAssociation = this.getAssociation(alias, currentProperty, currentModel, options);
      }

      return lastAssociation;
    }
    return this.getAssociationInternal(alias, modelProperty, model, options);
  }

  private build(alias:string, model:ModelCtor<any>, projection:ProjectionConfiguration, prefix?:string) {
    projection.properties.forEach((property:PropertyConfiguration) => {
      const { modelProperty, projectionProperty, options, propertyType } = property;

      if (modelProperty.indexOf('.') > 0) {
        const modelAssociation = this.getAssociation(alias, modelProperty, model, options);
        const split = modelProperty.split('.');
        const lastProperty = split[split.length - 1];

        if (!modelAssociation.model.rawAttributes.hasOwnProperty(lastProperty)) {
          throw new Error(`Property ${lastProperty} not found on Model ${modelAssociation.model.name}`);
        }

        const field = prefix ? `${prefix}.${projectionProperty}` : projectionProperty;
        this.query.field(`${modelAssociation.alias}.${lastProperty}`, field);
      } else if (model.rawAttributes.hasOwnProperty(modelProperty)) {
        const field = prefix ? `${prefix}.${projectionProperty}` : projectionProperty;
        this.query.field(`${alias}.${modelProperty}`, field);
      } else if (model.associations.hasOwnProperty(modelProperty)) {
        const modelAssociation = this.getAssociation(alias, modelProperty, model, options);
        if (QueryBuilder.isProjection(propertyType)) {
          const associationProjection:ProjectionConfiguration = Reflect.getMetadata('projection', propertyType);
          const newPrefix = prefix ? `${prefix}.${projectionProperty}` : projectionProperty;
          this.build(modelAssociation.alias, modelAssociation.model, associationProjection, newPrefix);
        }
      } else {
        throw new Error(`Property ${modelProperty} not found on Model ${model.name}`);
      }
    });
  }

  async list():Promise<Array<T>> {
    const list:Array<any> = await this.query.list();
    return list.map(this.mapItem);
  }

  async single():Promise<T> {
    return this.mapItem(await this.query.single());
  }

  private mapItem(item:any):any {
    const result = {};
    _.forEach(item, (value: any, key: string):object => _.set(result, key, value));
    return result;
  }

}