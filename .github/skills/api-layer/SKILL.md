---
name: api-layer
description: Build API-specific architecture and implementation using industry standards, including request and response modeling from JSON examples or Swagger/OpenAPI specs.
---

# API Layer

This skill defines how to design and implement a production-grade API layer for Swift and SwiftUI apps.

## What This Skill Should Do

When invoked, this skill should:
- Parse API contracts from one of the following sources:
	- raw request and response JSON samples
	- Swagger or OpenAPI (2.0/3.x) specification files
	- endpoint documentation in markdown
- Generate or refine API layer components:
	- endpoint definitions (path, method, headers, query, body)
	- request and response DTOs
	- domain model mapping
	- repository interfaces and concrete implementations
	- API client abstractions and service adapters
	- consistent error models and retry strategy
- Keep UI code clean by preventing networking logic inside views or view models.

## Inputs Accepted

Provide at least one of these:
- JSON request and response examples
- Swagger or OpenAPI yaml/json file content
- endpoint docs with method, path, request, and response details

Optional but recommended:
- auth type (Bearer, API key, OAuth)
- environment URLs (dev, qa, prod)
- pagination style (page, cursor, offset)
- existing model naming conventions

## Architecture Standards

Follow these standards by default:
- Use repository pattern between app features and API services.
- Use protocol-first design for testability.
- Keep DTOs separate from domain entities.
- Use async/await for asynchronous APIs.
- Centralize HTTP and decoding error handling.
- Use dependency injection for API clients and repositories.
- Support mock implementations for unit tests and previews.
- Maintain single responsibility per layer:
	- API client: request execution and transport
	- service: endpoint-specific request composition
	- repository: orchestration and domain mapping

## Suggested Layer Structure

- APIClient
	- sends requests
	- validates status codes
	- decodes response payloads
- Endpoint
	- owns path, method, headers, query, body
- DTOs
	- Codable request and response structs
- Mappers
	- transform DTOs into domain models
- Repositories
	- expose domain-friendly methods to features
- Error Model
	- ApiError enum with transport, decoding, http, and business failures

## Implementation Rules

- Do not call URLSession directly from UI code.
- Do not expose DTOs outside data layer.
- Validate required fields during mapping.
- Handle empty, partial, and malformed payloads safely.
- Add timeout configuration and request cancellation support where applicable.
- Prefer deterministic decoding with explicit CodingKeys when payload keys are unstable.

## Request/Response and Swagger Handling

When JSON examples are provided:
- infer data types conservatively
- make optional only fields that are truly optional in examples or docs
- generate request and response DTOs with clear naming

When Swagger/OpenAPI is provided:
- extract base path, operations, parameters, and schemas
- generate one endpoint definition per operationId or method+path
- map schema types to Swift types with Codable conformance
- include auth headers and required query/path parameters

If schema is ambiguous:
- keep mapping strict
- add clear TODO comments where contract clarification is required

## Testing Requirements

- Provide protocol-based mocks for APIClient and repositories.
- Include at least:
	- one success parsing test
	- one error decoding or transport test
	- one repository mapping test

## Output Expectations

For each API feature request, the skill should produce:
- list of endpoints implemented
- DTO files and domain mapping summary
- repository interface and implementation details
- error-handling strategy used
- testability notes and mock strategy

## How To Use This Skill

Use prompts like:
- "Use api-layer skill to implement login API from this request and response JSON."
- "Use api-layer skill to create service and repository from this Swagger spec."
- "Use api-layer skill to generate DTO mapping and error handling for these endpoints."

Recommended invocation format:
- Goal: what endpoint or API feature to implement
- Input: paste JSON or Swagger/OpenAPI fragment
- Constraints: auth, timeout, naming, and environment requirements
- Output needed: files/classes/interfaces/tests expected

Example request:

"Use api-layer skill.
Build account profile API integration.
Here is response JSON: { ... }
Here is request JSON: { ... }
Use repository pattern, async/await, and centralized ApiError handling.
Generate DTOs, mapper, service, repository protocol, repository implementation, and mock repository for tests."

