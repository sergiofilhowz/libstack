import { ModelCtor } from 'sequelize-typescript';
import { QueryBuilder } from './query/query.builder';
import { Page } from './query/query';

export interface CriteriaRequest<T> {
  reference: { new(): T; };
  query: T
}

export interface SingleOptions<P, C> {
  projection: { new(): P; };
  criteria?: CriteriaRequest<C>;
}

export interface ListOptions<P, C> extends SingleOptions<P, C> {
  sort?: string;
  pageSize?: number;
}

export interface PageOptions<P, C> extends ListOptions<P, C> {
  page: number;
}

export class Model {
  constructor(private model:ModelCtor) {}

  async list<P, C>(options:ListOptions<P, C>):Promise<Array<P>> {
    const queryBuilder = new QueryBuilder<P>(this.model, options.projection);
    if (options.pageSize !== null && options.pageSize !== undefined) {
      queryBuilder.query.size(options.pageSize);
    }
    if (options.criteria && options.criteria.query) {
      queryBuilder.criteria(options.criteria);
    }
    return queryBuilder.list();
  }
  async page<P, C>(options:PageOptions<P, C>):Promise<Page<P>> {
    const queryBuilder = new QueryBuilder<P>(this.model, options.projection);
    if (options.criteria) {
      queryBuilder.criteria(options.criteria);
    }
    queryBuilder.query.page(options.page, options.pageSize);
    return queryBuilder.getPage();
  }
  async single<P, C>(options:SingleOptions<P, C>):Promise<P> {
    const queryBuilder = new QueryBuilder<P>(this.model, options.projection);
    if (options.criteria) {
      queryBuilder.criteria(options.criteria);
    }
    return queryBuilder.single();
  }
}