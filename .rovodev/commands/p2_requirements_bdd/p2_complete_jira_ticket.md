# Complete Jira Ticket

Please analyze and complete the Jira ticket: $ARGUMENTS.

## Instructions

1) Use Jira MCP to get the ticket details, whether it is the ticket id/number, keywords referring to the ticket or indicating status, like "the one in progress"
2) You will act as a product expert with technical knowledge
3) Understand the problem described in the ticket
4) Decide whether or not the User Story is completely detailed according to product's best practices: Include a full description of the functionality, a comprehensive list of fields to be updated, the structure and URLs of the necessary endpoints, the files to be modified according to the architecture and best practices, the steps required for the task to be considered complete, how to update any relevant documentation or create unit tests, and non-functional requirements related to security, performance, etc
5) If the user story lacks the technical and specific detail necessary to allow the developer to be fully autonomous when completing it, provide an improved story that is clearer, more specific, and more concise in line with product best practices described in step 4. Use the technical context you will find in @documentation. Return it in markdown format.
6) Update ticket in Jira, adding the new content after the old one and marking each section with the h2 tags [original] and [enhanced]. Apply proper formatting to make it readable and visually clear, using appropriate text types (lists, code snippets...).
7) Optionally consult specialized subagents depending on ticket type to strengthen requirement definition (linking to their specs):
   - Architecture and endpoints/design decisions → [Architecture Expert](../../subagents/architecture-expert.md)
   - CI/CD, infrastructure, containerization or deployment implications → [DevOps Automation](../../subagents/devops-automation.md)
   - Security-sensitive requirements (authN/authZ, data protection, compliance) → [Security Expert](../../subagents/security-expert.md)
   - Performance constraints or SLOs (latency, throughput, memory) → [Performance Expert](../../subagents/performance-expert.md)
   - Testing strategy, acceptance criteria testability, coverage goals → [Testing Expert](../../subagents/testing-expert.md)
   - Documentation structure/placement in OpenSpec (standards/changes) → [Openspec Expert](../../subagents/openspec-expert.md)

Guidance:
- Feature/epic/architecture change → Architecture Expert first; then Testing/Security/Performance as applicable.
- Infra/tooling/pipeline tickets → DevOps Automation; add Testing/Security considerations if they affect delivery.
- Bugfix tickets → Testing Expert for reproducibility and acceptance tests; involve Architecture/Security/Performance based on scope.
- Documentation-focused tickets → Openspec Expert para ubicación y frontmatter en wiki/openspec.

Subagent invocation cheat sheet (P2)
- Diseño/arquitectura/endpoints: ver [Architecture Expert](../../subagents/architecture-expert.md)
- CI/CD/infra/deploy: ver [DevOps Automation](../../subagents/devops-automation.md)
- Seguridad/compliance/auth: ver [Security Expert](../../subagents/security-expert.md)
- Rendimiento/SLOs: ver [Performance Expert](../../subagents/performance-expert.md)
- Testing/AC testables/cobertura: ver [Testing Expert](../../subagents/testing-expert.md)
- Documentación/wiki OpenSpec: ver [Openspec Expert](../../subagents/openspec-expert.md)

Enhanced section example

## [original]
As a user, I need to export reports to CSV.

Acceptance criteria:
- Export button in reports screen
- Downloads a CSV

## [enhanced]
Title: Report export to CSV with filters and pagination awareness

Functional description
- Allow users to export the current result set in the Reports view to CSV, preserving active filters and date range.
- Export is asynchronous for large datasets and returns a downloadable link when ready.

Endpoints and contracts
- POST /api/reports/export
  - Body: { filters: {..}, date_range: {from, to}, format: "csv" }
  - Response: { export_id, status: "queued" }
- GET /api/reports/export/{export_id}
  - Response: { status: "ready"|"processing"|"error", download_url? }

Data and fields
- Include columns: id, created_at, user, type, status, amount
- CSV charset: UTF-8 with header row

Files to modify (example)
- backend: src/api/reports_export.py, src/services/report_export_service.py
- frontend: src/views/Reports.vue (trigger and feedback)

Definition of Done (steps)
- Backend endpoint and service implemented with pagination-aware queries
- Job queue in place for large exports; status polling implemented
- Tests (unit + integration) added and passing
- Documentation updated in wiki/openspec/specs/api-specifications.md

Testing strategy
- Unit: service generates CSV with correct headers and encoding
- Integration: export with filters returns only matching rows
- E2E: user flows for small and large exports (queued)

Non-functional requirements
- Security: only authorized roles; PII masked when applicable
- Performance: p95 export init < 200ms; background processing scalable

Risks and mitigations
- Large datasets → use streaming writer and background job

Acceptance Criteria (Gherkin)
- Given I am on Reports with filters applied
  When I click Export CSV
  Then a CSV is generated with the filtered data and a download link is provided

Enhanced template (copy/paste)

## [enhanced]
Title: <short, action-oriented title>

Functional description
- <what and why succinctly>

Endpoints and contracts
- <method> <path>
  - Body: <schema>
  - Response: <schema>

Data and fields
- <list of fields/columns with brief notes>

Files to modify
- <area>: <paths>

Definition of Done
- <ordered checklist>

Testing strategy
- Unit: <cases>
- Integration: <cases>
- E2E: <flows>

Non-functional requirements
- Security: <requirements>
- Performance: <targets>

Risks and mitigations
- <risk> → <mitigation>

Acceptance Criteria (Gherkin)
- Given <context>
  When <action>
  Then <outcome>
