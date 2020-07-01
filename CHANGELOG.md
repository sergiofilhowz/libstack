# CHANGELOG

## @libstack/data

### 1.2.0
[FEATURE] Now possible to sort on multiple properties at the same time

### 1.1.0
[FEATURE] Added a way to retrieve removed data by using the options on list or single

### 1.0.2
[FIX] Fixed an issue that was causing on association with custom field (Was trying to resolve with the actual fieldName, not the sequelize field).

### 1.0.1 
[FIX] Fixed an issue with projection @Property with subproperties.
[FIX] Fixed an issue that was causing with IN with empty array on PostgreSQL.
[FIX] Fixed an issue where Projections on entities with custom fields weren't being properly resolved.

## @libstack/keycloak

### 1.1.0
[FEATURE] Added an userService to be able to manage keycloak users.
[FEATURE] Added an groupService to be able to manage keycloak groups.

## @libstack/sequel

### 1.1.0
[FEATURE] Added the separateStatements mode on migrations

### 1.0.1
[FIX] Enabling VERBOSE flag to log SQL