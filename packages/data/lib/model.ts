import { ModelCtor } from 'sequelize-typescript';
import { QueryBuilder } from './query/query.builder';

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

export class Page<T> {
  list: Array<T>;
  count: number;

  constructor(list: Array<T>, count:number) {
    this.list = list;
    this.count = count;
  }
}

export class Model {
  constructor(private model:ModelCtor) {}

  async list<P, C>(options:ListOptions<P, C>):Promise<Array<P>> {
    const queryBuilder = new QueryBuilder<P>(this.model, options.projection);
    return queryBuilder.list();
  }
  async page<P, C>(options:PageOptions<P, C>):Promise<Page<P>> {
    return new Page([], 0);
  }
  async single<P, C>(options:SingleOptions<P, C>):Promise<P> {
    return null;
  }
}