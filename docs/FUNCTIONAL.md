# Functional Overview

Este documento lista, de forma simplificada, las funcionalidades que provee este repositorio (lo que el sistema hace). Para detalles operativos y guías completas, ver los enlaces referenciados.

## Funcionalidades principales
- Contenedor de desarrollo RovoDev listo para usar
  - Imagen Docker con toolchain para desarrollo asistido por agentes
  - Script de build multi-arquitectura y publicación (scripts/build-image.sh)
  - docker-compose con múltiples workspaces de ejemplo
  - Entrypoint con diagnósticos y bootstrap automático
  - run-rovodev.sh genera por defecto el nombre del contenedor a partir del nombre de la carpeta actual (p. ej., carpeta 'miapp' → contenedor 'miapp'). Se puede sobreescribir con --container-name o en .env (CONTAINER_NAME)
  - Referencia: README.md, Dockerfile, docker-compose.yml, entrypoint.sh, run-rovodev.sh

- Workflow spec-driven end-to-end
  - Ciclo Draft Plan → Validate → Implementación/PR → Finalize
  - Integración con OpenSpec CLI (@fission-ai/openspec)
  - Estructura de carpetas para specs y cambios (openspec/*) a generar como parte de la wiki
  - Referencia: WORKFLOW-GUIDE.md, openspec/standards/*, .rovodev/subagents/openspec-expert.md

- Automatización con comandos RovoDev
  - Planificación y análisis de tickets: plan-ticket
  - Implementación guiada desde Jira: implement-from-jira
  - Evolución de proyectos: evolve-project
  - Commits organizados y PRs: commit, commit-and-pr, generate-pr
  - Actualización de documentación: update-docs
  - Otros: initialize-project, implement-ticket, generate-code-guardian, comandos OpenSpec (draft/validate/finalize/bootstrap/audit)
  - Referencia: .rovodev/commands/**/*.md, README-ROVODEV.md

- Subagentes expertos (asistentes especializados)
  - Commits y PRs: commit-expert, pullrequest-expert
  - Arquitectura, testing, seguridad, performance, DevOps, OpenSpec, Portainer
  - Cada subagente encapsula criterios y checklists de su dominio
  - Referencia: SUBAGENTS-GUIDE.md, .rovodev/subagents/*.md

- Gestión de documentación y estándares
  - Estándares de documentación (OpenSpec): documentation.mdc, plantillas de specs
  - Generación de contenido de PR dentro del repo (openspec/changes/pr-*.md)
  - Sin duplicar Confluence (se enlaza cuando aplique)
  - Referencia: openspec/standards/*, .rovodev/commands/pr/generate-pr.md

- Integración con Atlassian
  - Atlassian CLI (acli) preinstalado en la imagen
  - Variables de entorno templadas (.env.template) y reglas de seguridad (no secretos en repo)
  - Reglas de seguridad para Jira (no modificar sin permiso explícito)
  - Referencia: README.md, .env.template, .agent.md

## Flujo operativo recomendado (resumen)
1) Redactar spec mínima (openspec-draft) en la wiki
2) Validar spec (openspec-validate)
3) Implementar y versionar: commit / commit-and-pr / generate-pr
4) Finalizar y enlazar: openspec-finalize

Para pasos y comandos detallados: WORKFLOW-GUIDE.md y README-ROVODEV.md.

---

A continuación se describen las funcionalidades en lenguaje tipo Gherkin (legible por humanos). Estas historias y escenarios sirven como especificación funcional y guía de prueba manual. No están pensadas para ejecutarse automáticamente con Cucumber.

```gherkin
Feature: Entorno de desarrollo RovoDev en contenedor
  Como desarrollador
  Quiero ejecutar un contenedor con tooling de RovoDev
  Para trabajar de forma estandarizada con asistencia de agentes

  Background:
    Given Docker está instalado y en ejecución en el host
    And dispongo de credenciales Atlassian válidas
    And estoy situado en el directorio de mi proyecto (WORKSPACE_DIR)

  Scenario: Primer arranque sin .env
    When ejecuto ./run-rovodev.sh por primera vez
    Then se genera un archivo .env.template en el directorio del proyecto
    And el script muestra instrucciones para crear y completar .env
    And el proceso termina hasta que complete la configuración

  Scenario: Arranque con .env válido
    Given existe un archivo .env con ATLASSIAN_USERNAME y ATLASSIAN_API_TOKEN
    When ejecuto ./run-rovodev.sh
    Then se inicia un contenedor basado en la imagen configurada
    And el código se monta en /workspace/code
    And el directorio de trabajo por defecto es /workspace/code (aquí se generará AGENTS.md y se puede usar "/memory init")
    And la configuración base está disponible en /home/rovodev/.rovodev
    And si existe CODE_ROOT/.rovodev, sus contenidos actúan como overrides de proyecto
    And existe un enlace simbólico /workspace/.rovodev apuntando a la configuración efectiva

  Scenario: Nombre de contenedor por defecto según carpeta
    Given estoy en el proyecto "miapp"
    When ejecuto ./run-rovodev.sh sin parámetros
    Then el contenedor se crea con el nombre "miapp"

  Scenario: Normalización del nombre de contenedor
    Given el nombre de carpeta es "mi app (dev)"
    When ejecuto ./run-rovodev.sh
    Then el sistema normaliza el nombre a "mi-app-dev"
    And muestra un aviso indicando el cambio de nombre

  Scenario: Sobrescribir nombre de contenedor por flag
    Given deseo un nombre personalizado
    When ejecuto ./run-rovodev.sh --container-name=custom
    Then el contenedor se crea con el nombre "custom"

  Scenario: Sobrescribir nombre de contenedor por .env
    Given defino CONTAINER_NAME=custom en .env
    When ejecuto ./run-rovodev.sh sin parámetros
    Then el contenedor se crea con el nombre "custom"

  Scenario: Detección automática de wiki
    Given el repositorio de wiki existe como carpeta hermana con sufijo "-wiki"
    When ejecuto ./run-rovodev.sh
    Then la wiki se monta en /workspace/wiki desde la carpeta hermana

  Scenario: Creación de wiki local por defecto
    Given no existe carpeta hermana con sufijo "-wiki"
    When ejecuto ./run-rovodev.sh
    Then se crea (si no existe) la carpeta ./wiki en el proyecto
    And se monta en /workspace/wiki

  Scenario: Integración con Docker del host
    Given estoy en macOS con Docker Desktop
    When ejecuto ./run-rovodev.sh
    Then se monta el socket de Docker con los ajustes apropiados para macOS

  Scenario: Integración con Docker en Linux
    Given estoy en Linux y existe /var/run/docker.sock
    When ejecuto ./run-rovodev.sh
    Then se monta el socket de Docker del host dentro del contenedor

  Scenario: Integración con Docker en Windows
    Given uso Docker Desktop en Windows
    And he habilitado "Expose daemon on tcp://localhost:2375 without TLS" en Docker Desktop
    When ejecuto ./run-rovodev.sh
    Then el contenedor puede usar docker-cli vía DOCKER_HOST=tcp://host.docker.internal:2375
```

```gherkin
Feature: Workflows con OpenSpec
  Como desarrollador
  Quiero gestionar specs de cambios con OpenSpec
  Para alinear el desarrollo con especificaciones versionadas en la wiki

  Background:
    Given la imagen incluye OpenSpec CLI
    And la wiki se monta en /workspace/wiki

  Scenario: Crear draft mínimo
    When ejecuto el comando de draft (p. ej., "rovodev openspec-draft JIRA \"slug\"")
    Then se genera una spec mínima en /workspace/wiki/openspec/changes

  Scenario: Validar spec
    Given existe una spec en /workspace/wiki/openspec/changes
    When ejecuto el comando de validación
    Then el sistema valida estructura y convenciones de la spec

  Scenario: Finalizar spec
    Given una spec validada
    When ejecuto el comando de finalize
    Then la spec se marca como final y lista para referencia
```

```gherkin
Feature: Integraciones y seguridad Atlassian
  Como responsable de integraciones
  Quiero operar con Atlassian de forma segura
  Para cumplir políticas y evitar cambios no autorizados

  Background:
    Given configuro credenciales Atlassian en .env

  Scenario: Reglas de seguridad en Jira
    When un agente o workflow intenta modificar un issue
    Then debe existir permiso explícito del usuario antes de crear/editar/transicionar/comentar

  Scenario: Uso de acli
    When utilizo acli en el contenedor
    Then puedo consultar datos de Jira/Confluence
    And no se realizarán modificaciones sin confirmación explícita
```

```gherkin
Feature: MCP y Playwright externos (imagen lite)
  Como usuario que necesita automatización de navegador
  Quiero conectarme a un servidor MCP de Playwright externo
  Para evitar peso adicional en la imagen base

  Background:
    Given la imagen "lite" no incluye Playwright ni @playwright/mcp

  Scenario: Conexión a MCP Playwright externo
    When levanto un servidor externo @playwright/mcp en otra máquina o contenedor
    And configuro mi cliente MCP para conectarse por WebSocket/stdio
    Then puedo ejecutar automatizaciones de navegador sin instalar Playwright dentro de esta imagen
```

```gherkin
Feature: Política EOL (LF)
  Como desarrollador
  Quiero consistencia en fin de línea
  Para evitar diffs y problemas entre plataformas

  Background:
    Given el repositorio tiene .gitattributes y .editorconfig con EOL=LF

  Scenario: Ficheros generados por RovoDev
    When arranco el contenedor y se generan/actualizan ficheros de configuración
    Then las líneas terminan en LF
    And git está configurado con core.autocrlf=input y core.eol=lf

Feature: Diagnósticos y experiencia de uso
  Como desarrollador
  Quiero mensajes claros y diagnósticos útiles
  Para resolver rápido problemas de configuración

  Scenario: Faltan credenciales en .env
    When ejecuto ./run-rovodev.sh sin ATLASSIAN_USERNAME o ATLASSIAN_API_TOKEN válidos
    Then el script detiene la ejecución y muestra instrucciones para completar .env

  Scenario: Mensajes de arranque
    When inicio el contenedor
    Then se muestran rutas de montajes, imagen, nombre de contenedor y volumen utilizado
```

