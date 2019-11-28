---
id: building
title: Building for Production
sidebar_label: Building for Production
---

There are two ways to build your application for production. One is with Docker and the other is with Serverless.

## Building for Docker

If you take the Example project, there is already one Dockerfile present in the root folder.

This Dockerfile will build the application and generate an image with only the files and production dependencies.

So, all you need to do is build your docker image:

```
$ docker build -t myapplication:1.0.0 .
```

## Building for Serverless

Serverless does not come with the project, you will need to configure your serverless application like any other Typescript project. 

> This section needs to be updated.

While this section isn't update, please refer to this page to get more details: https://serverless.com/plugins/serverless-plugin-typescript/