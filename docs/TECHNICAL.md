# Technical Overview

Este documento resume conceptos y mecanismos técnicos implementados por este repositorio (cómo funciona). Mantiene un nivel alto y enlaza a la documentación fuente para detalles.

## Imagen y runtime

### Docker Image Structure
```
/opt/templates/             # Template content in image
└── openspec/              # Default OpenSpec standards
/home/rovodev/.rovodev      # Default RovoDev configuration (seed source)

/workspace/                # Aggregate workspace inside container
/workspace/code            # Mounted project directory (host)
/workspace/wiki            # Mounted wiki directory (host, optional)
/home/rovodev/.rovodev     # Config base incluida en la imagen (no editar en repo)
/home/rovodev/             # User home directory
```

- Montajes y estructura de trabajo (en runtime):
  - `/workspace/code` → repo de código (bind mount a carpeta actual por defecto)
  - `/workspace/wiki` → repo de wiki (bind mount al repo hermano `<repo>-wiki` si existe; si no, usa `./wiki`)
  - `/home/rovodev/.rovodev` → configuración base de la imagen (config y memoria del agente por defecto)
- Directorio de trabajo por defecto: `/workspace` (visibilidad de code + wiki)
- Detección automática de wiki y fallback a `./wiki`; bootstrap mínimo si está vacía
- Diagnóstico al iniciar: estado de montajes y variables clave
- Base Ubuntu 22.04 con toolchain de desarrollo
- Base Ubuntu 22.04 con toolchain de desarrollo
- Node 20.x, NPM, Python3, Docker CLI y buildx (sin Go en la imagen final)
- run-rovodev.sh normaliza el nombre del contenedor para cumplir con las reglas de Docker ([a-zA-Z0-9][a-zA-Z0-9_.-]) y avisa si lo ha modificado.
- Instalación de OpenSpec CLI (@fission-ai/openspec). Playwright: se recomienda servidor externo `@playwright/mcp` (no incluido en la imagen).
- Usuario no root (rovodev), sudo sin contraseña y pertenencia a grupo docker
- Referencia: Dockerfile, scripts/build-image.sh

## Entrypoint y bootstrap
- Detección de montajes (code, wiki, volumen privado /.rovodev)
- Siembra de plantillas y estructura mínima (templates/openspec/standards en imagen; wiki/openspec/standards en destino)
- Configuración de permisos y acceso a Docker socket
- Diagnóstico de entorno al iniciar
- Referencia: entrypoint.sh

## Estructura de workspace
- /workspace como cwd con vistas a:
  - /workspace/code → repo de código (bind mount)
  - /workspace/wiki → repo de wiki (bind mount o ./wiki)
  - /home/rovodev/.rovodev → configuración base (config y memoria del agente)
- Referencia: README.md

## Comandos RovoDev (CLI)
- Organización de `prompts.yml` y comandos por dominio:
  - commands/code: commit, develop-backend, develop-trying
  - commands/pr: commit-and-pr, generate-pr
  - commands/openspec: draft, validate, finalize, bootstrap-wiki, audit-wiki
  - comando independiente: complete-jira-ticket
- Descripciones concisas (< 50 caracteres) para menú interactivo
- Subagentes directos sin subcarpetas innecesarias
- Organización por dominios:
  - code: commit, develop-backend, develop-trying
  - pr: commit-and-pr, generate-pr
  - openspec: openspec-draft/validate/finalize/bootstrap-wiki/audit-wiki
  - generales: implement-from-jira, implement-ticket, plan-ticket, evolve-project, update-docs, complete-jira-ticket, initialize-project
- Cada comando define proceso, entradas/salidas y artefactos generados
- Referencia: .rovodev/commands/**/*.md, README-ROVODEV.md

## Subagentes (MCP/agents)
- Especialistas consumidos por los comandos para decisiones de calidad:
  - commit-expert, pullrequest-expert, openspec-expert, architecture-expert,
    testing-expert, security-expert, performance-expert, devops-automation, portainer-expert
- Incorporan checklists, estilos, convenciones y heurísticas por dominio
- Referencia: .rovodev/subagents/*.md, SUBAGENTS-GUIDE.md

## OpenSpec: organización y convenciones
- Integración con CLI de `@fission-ai/openspec`:
  - Lint: `openspec lint`
  - Índices: `openspec index build`
  - Scaffold: `openspec scaffold` (si está disponible en la versión instalada)
  - Audit: salida JSON y rebuild de índice
- Bloque standards: plantillas y reglas (spec-minima, spec-modelo-central, documentation.mdc)
- Bloque changes: historial de especificaciones por ticket y contenido de PR (en repo de código)
- Convenciones de nombres y estados (draft → validated → finalized)
- Índices y lint con CLI de OpenSpec
- Referencia: openspec/standards/*, .rovodev/subagents/openspec-expert.md

## Integraciones Atlassian
- acli disponible en PATH, uso opcional vía variables en .env.template
- Reglas de seguridad para Jira (no mutaciones sin permiso explícito)
- Posibles flujos: lectura de tickets, generación de artefactos, enlace a PRs
- Referencia: .env.template, .agent.md, .rovodev/commands/complete-jira-ticket.md

## Seguridad y buenas prácticas
- Persistencia antigua eliminada en favor de la wiki y PRs en Git (sin `/persistence`)

## Host UID/GID (Linux)
- Problema: en Linux, los archivos creados por el contenedor pueden quedar con propietario root en el host, impidiendo su edición desde el IDE.
- Solución implementada: `run-rovodev.sh` pasa `HOST_UID/HOST_GID` y el entrypoint ajusta el usuario del contenedor (rovodev) para igualar los IDs del host.
- Resultado: los archivos creados dentro del contenedor mantienen el UID/GID del usuario host, evitando problemas de permisos.
- Notas:
  - En macOS/Windows normalmente no se requiere ajuste.
  - En Linux esto previene ficheros root-owned en el workspace.

## Modos de persistencia (opcional)
- Objetivo: controlar cómo se persisten configuraciones y artefactos entre ejecuciones.
- Flags de ejecución:
  ```bash
  ./run-rovodev.sh --persistence=shared
  ./run-rovodev.sh --persistence=instance --instance-id=my-project
  ```
- shared: comparte un volumen común entre ejecuciones/proyectos compatibles.
- instance: aísla por instancia usando `--instance-id`.
- Recomendación: usar `instance` para aislar pruebas; `shared` para entornos estables.

- Persistencia antigua eliminada en favor de la wiki y PRs en Git (sin `/persistence`)
- Usuario no root, principle of least privilege
- No almacenar secretos en el repo; usar .env local y volumen privado
- Validación y estándares de documentación; quality gates por subagentes
- Referencia: .agent.md, .rovodev/subagents/security-expert.md

## Limitaciones conocidas
- No se automatiza la creación de PRs real en plataformas VCS desde aquí; se genera contenido para PR (openspec/changes/pr-*.md)
- Dependencia de wiki externa o ./wiki para OpenSpec
- Requiere Docker y buildx para builds multi-arquitectura

Para guías operativas completas ver: WORKFLOW-GUIDE.md, README-ROVODEV.md y SUBAGENTS-GUIDE.md.
