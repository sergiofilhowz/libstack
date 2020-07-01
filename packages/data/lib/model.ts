import { ModelCtor } from 'sequelize-typescript';
import { QueryBuilder, QueryOptions } from './query/query.builder';

export interface Page<T> {
  list: Array<T>;
  count: number;
  page: number;
  pages: number;
}

/**
 * This object represents a request with criteria
 */
export interface CriteriaRequest<T> {
  /**
   * The criteria object to use
   */
  reference: { new(): T; };

  /**
   * The values to be used on the criteria
   */
  query: T
}

export interface SingleOptions<P, C> {
  /**
   * The projection object to use
   */
  projection: { new(): P; };

  /**
   * The criteria request if necessary
   */
  criteria?: CriteriaRequest<C>;

  options?: QueryOptions
}

export interface ListOptions<P, C> extends SingleOptions<P, C> {
  sort?: string | string[];
  pageSize?: number;
}

export interface PageOptions<P, C> extends ListOptions<P, C> {
  pageSize: number;
  page: number;
}

/**
 * The model is the main part of the Data project.
 * You can create projections and criterias
 */
export class DataModel {
  constructor(private model:ModelCtor) {}

  /**
   * Requests a list
   * @param options
   */
  async list<P, C>(options:ListOptions<P, C>):Promise<Array<P>> {
    const queryBuilder = new QueryBuilder<P>(this.model, options.projection, options.options);
    queryBuilder.query.size(options.pageSize);
    queryBuilder.criteria(options.criteria);
    queryBuilder.sort(options.sort);
    return queryBuilder.list();
  }

  /**
   * Requests a page object
   * @param options
   */
  async page<P, C>(options:PageOptions<P, C>):Promise<Page<P>> {
    const queryBuilder = new QueryBuilder<P>(this.model, options.projection, options.options);
    queryBuilder.criteria(options.criteria);
    queryBuilder.query.page(options.page, options.pageSize);
    queryBuilder.sort(options.sort);
    return queryBuilder.getPage();
  }

  /**
   * Requests a single row based on a criteria.
   * The row returned will be the first.
   * @param options
   */
  async single<P, C>(options:SingleOptions<P, C>):Promise<P> {
    const queryBuilder = new QueryBuilder<P>(this.model, options.projection, options.options);
    queryBuilder.criteria(options.criteria);
    return queryBuilder.single();
  }
}