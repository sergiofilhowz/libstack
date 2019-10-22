import { Association, ModelAttributeColumnOptions, ModelCtor } from 'sequelize';
import { ProjectionConfiguration, PropertyConfiguration } from '../projection';
import { Query } from './query';
import { getDeletedAtColumn, getTableName } from './query.utils';
import _ from 'lodash';

class ModelAssociation {
  alias: string;
  association: Association;
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

  private build(alias:string, model:ModelCtor<any>, projection:ProjectionConfiguration, prefix?:string) {
    projection.properties.forEach((property:PropertyConfiguration) => {
      const { modelProperty, projectionProperty, options, propertyType } = property;
      if (model.rawAttributes.hasOwnProperty(modelProperty)) {
        // const rawAttribute:ModelAttributeColumnOptions = model.rawAttributes[modelProperty];
        const field = prefix ? `${prefix}.${projectionProperty}` : projectionProperty;
        this.query.field(`${alias}.${modelProperty}`, field);
      } else if (model.associations.hasOwnProperty(modelProperty)) {
        const association:Association = model.associations[modelProperty];
        if (!this.associations[modelProperty]) {
          const associationAlias = this.createAlias(modelProperty);
          this.associations[modelProperty] = {
            alias: associationAlias,
            modelProperty,
            association
          };
          const condition = `${alias}.${association.source.primaryKeyAttribute} = ${associationAlias}.${association.target.primaryKeyAttribute}`;
          if (options && options.joinType === 'right') {
            this.query.join(association.target.tableName, associationAlias, condition);
          } else {
            this.query.left_join(association.target.tableName, associationAlias, condition);
          }
        }
        const modelAssociation = this.associations[modelProperty];
        if (QueryBuilder.isProjection(propertyType)) {
          const associationProjection:ProjectionConfiguration = Reflect.getMetadata('projection', propertyType);
          this.build(modelAssociation.alias, association.target, associationProjection, projectionProperty);
        }
      } else {
        throw new Error(`Property ${modelProperty} not found on Model ${model.name}`);
      }
    });
  }

  async list():Promise<Array<any>> {
    const list:Array<any> = await this.query.list();
    return list.map((item:any) => {
      const result = {};
      _.forEach(item,  (value: any, key: string) => _.set(result, key, value));
      return result;
    });
  }


}