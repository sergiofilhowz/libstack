import { Arg, Args, Mutation, Query, Resolver } from 'type-graphql';
import personService, { PersonRequest } from '../services/PersonService';
import { PersonQuery, Person } from '../models/PersonModel';

@Resolver()
export class PersonResolver {

  @Query(returns => [Person])
  async people(@Args() query: PersonQuery): Promise<Person []> {
    return personService.list(query);
  }

  async person(@Arg('id') id: string): Promise<Person> {
    return personService.get(id);
  }

  @Mutation(returns => Person)
  async createPerson(@Arg('data') body: PersonRequest): Promise<Person> {
    return personService.create(body);
  }

  @Mutation(returns => Person)
  async updatePerson(@Arg('id') id: string, @Arg('data') body: PersonRequest): Promise<Person> {
    return personService.update(id, body);
  }

  @Mutation(returns => Person)
  async deletePerson(@Arg('id') id: string): Promise<Person> {
    return personService.deletePerson(id);
  }

}
