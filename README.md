# 🚀 RovoDev Docker Container

This repository contains everything needed to create a portable AI-powered development environment using Docker and RovoDev.

## 🎯 Objective

Proveer un entorno de desarrollo asistido por IA, portable y de un solo comando, que estandarice el SDLC en cualquier repositorio.

Qué hace este proyecto cuando ejecutas `./run-rovodev.sh` en un repo:
- Descarga y arranca la imagen Docker de RovoDev.
- Genera `.env` desde `.env.template` (sin secretos en el repositorio).
- Auto‑detecta la wiki hermana `../*-wiki/` o usa `./wiki` si no existe, y siembra `openspec/` con estándares mínimos.
- Expone la CLI de RovoDev con comandos organizados por fase del SDLC.
- Unifica el comportamiento entre distintas IAs (Claude/Copilot) usando `.agent.md`, `docs/` y `.rovodev/` como fuente de verdad.
- Aplica reglas de seguridad: nunca modifica Jira sin permiso; no crea PRs remotas automáticamente (genera contenido listo para copiar/pegar).
- Funciona de forma consistente en macOS/Linux/Windows (Docker Desktop/Engine).

Resultado: un flujo reproducible para planificar, especificar (OpenSpec), implementar, commitear, preparar PRs y actualizar documentación con calidad enterprise por defecto.


## 🔄 SDLC potenciado por RovoDev

Esta herramienta potencia varias fases del ciclo de desarrollo. Los comandos están en `.rovodev/commands` y activan subagentes especializados automáticamente (sin preguntar), aplicando estándares definidos en `.agent.md` de este proyecto, los estándares definidos en `.agent.md` del usuario (si está vinculado por volumen) y la wiki del proyecto sobre el que se esté desarrollando.

- Planificación y Análisis
  - Commands: `plan-ticket`, `implement-from-jira --plan-only`, `implement-ticket --plan-only`, `meta-prompt`
  - Subagentes: architecture-expert, openspec-expert
  - Resultado: plan de trabajo, alcance, riesgos y estimación inicial

- Especificación técnica (OpenSpec)
  - Commands: `openspec-draft`, `openspec-validate`, `openspec-audit-wiki`, `openspec-bootstrap-wiki`
  - Subagentes: openspec-expert
  - Resultado: spec mínima en wiki (draft → validated), índices y lint de estándares

- Implementación
  - Commands: `develop-backend`, `develop-trying`, `implement-from-jira`, `implement-ticket`, `evolve-project`
  - Subagentes: architecture-expert, testing-expert, security-expert, performance-expert, devops-automation
  - Resultado: cambios implementados siguiendo patrones del repo, con tests y consideraciones de calidad

- Commits profesionales
  - Commands: `commit`
  - Subagentes: commit-expert
  - Resultado: commits atómicos y consistentes (conventional commits), trazables al ticket

- Pull Requests (contenido listo para copiar/pegar)
  - Commands: `commit-and-pr`, `generate-pr`
  - Subagentes: pullrequest-expert, commit-expert
  - Resultado: archivo `openspec/changes/pr-[TICKET].md` con descripción completa, lista para PR web

- Documentación y cierre
  - Commands: `update-docs`, `openspec-finalize`
  - Subagentes: openspec-expert
  - Resultado: documentación actualizada según `wiki/openspec/standards`, spec finalizada con PRs relacionadas

- Calidad continua y estandarización
  - Commands: `generate-code-guardian`, `evolve-project`
  - Subagentes: testing-expert, security-expert, performance-expert, devops-automation
  - Resultado: quality gates, refactors guiados y patrones aplicados a proyectos existentes

Notas
- Jira Safety: nunca se crean/actualizan tickets sin tu permiso explícito.
- PRs no se crean automáticamente; se genera el contenido para copiar en tu plataforma (Bitbucket/GitHub).



## 🚀 Quick Start

### For End Users

1. **Navigate to your project directory:**
   ```bash
   cd /path/to/your/project
   ```

2. **Download the script:**
   ```bash
   curl -O https://raw.githubusercontent.com/juanfu26/spec-driven-with-rovodev/refs/heads/main/run-rovodev.sh
   chmod +x run-rovodev.sh
   ```

3. **Run RovoDev (first time):**
   ```bash
   ./run-rovodev.sh
   ```
   This will create `.env.template` with configuration instructions.

4. **Configure your credentials:**
   ```bash
   cp .env.template .env
   nano .env  # Edit with your credentials and enable configurations
   ```

5. **Run RovoDev again:**
   ```bash
   ./run-rovodev.sh
   ```

## 📁 Project Structure Created

When running on a new project, the following structure is automatically created:

```
your-project/
├── .env.template          # Configuration template (safe for git)
├── .env                   # Your credentials (add to .gitignore)
your-project-wiki/
└── openspec/             # Development standards
    └── specs/
        └── standards/
            ├── base.mdc           # Core development standards
            └── documentation.mdc  # Documentation guidelines
```

## 🤖 Available RovoDev Commands

Comandos disponibles agrupados por fase del ciclo de desarrollo. Ejecuta dentro del entorno de RovoDev tras `./run-rovodev.sh`.

- Planificación y análisis
  - plan-ticket: genera plan de trabajo a partir de un ticket
  - implement-from-jira --plan-only: analiza ticket y produce plan/estimación
  - implement-ticket --plan-only: plan técnico sin ejecución
  - meta-prompt: asistente para tareas personalizadas

- Especificación técnica (OpenSpec)
  - openspec-bootstrap-wiki: prepara la wiki para OpenSpec
  - openspec-audit-wiki: audita estándares y cambios en la wiki
  - openspec-draft: crea spec mínima (draft) para un ticket
  - openspec-validate: marca la spec como validated

- Implementación
  - initialize-project: inicializa un proyecto con configuración recomendada
  - develop-backend: implementa cambios backend guiados por ticket
  - develop-trying: modo de prueba y error controlado
  - implement-from-jira: implementación completa guiada por ticket Jira
  - implement-ticket: implementación a partir de ticket local
  - evolve-project: aplica refactors y patrones al proyecto
  - complete-jira-ticket: completar ticket con guía del agente

- Commits y Pull Requests
  - commit: crea commits atómicos y convencionales
  - commit-and-pr: commits + genera archivo de PR listo para copiar
  - generate-pr: genera solo el archivo de PR a partir de diffs

- Documentación y cierre
  - update-docs: actualiza documentación afectada por cambios
  - openspec-finalize: finaliza la spec (estado finalized, enlaza PRs)

- Calidad continua
  - generate-code-guardian: genera guardian de calidad personalizado

## 📂 Estructura y notas del repositorio

- .claude/: prompts, comandos y skills orientados a Claude Desktop/Server. Sirve como catálogo portable de capacidades (prompts, commands, skills) que este repo reutiliza para estandarizar flujos entre IAs.
- .github/: workflows de CI/CD y configuraciones de GitHub (incluyendo copilot-instructions.md) para guiar a GitHub Copilot sobre convenciones y estándares del proyecto.
- docs/: documentación funcional, técnica y guías (Quick Start, Workflow, Subagentes, RovoDev overview).
- openspec/: estándares y plantillas de documentación técnica, más carpeta changes para artefactos de PR/specs.

### Estrategia multi‑IA (Claude y Copilot)
- Objetivo: unificar el comportamiento entre distintas IAs (Claude, GitHub Copilot) asegurando consistencia por medio de documentación, comandos y subagentes comunes.
- Cómo lo logramos: centralizamos reglas en .agent.md, comandos en .rovodev/commands y guías en docs/, para que tanto Claude como Copilot sigan las mismas convenciones.
- Diferencias a considerar: contexto y longitud, prompts system vs inline, herramientas disponibles. Este repo lo abstrae con instrucciones claras y archivos canónicos.
- Más detalles: ver NOTAS (sección Integración Claude/Copilot).

## ⚙️ Configuration

The `.env` file contains essential configuration:

```bash
# Atlassian CLI Authentication (Required)
ATLASSIAN_USERNAME=your.email@company.com
ATLASSIAN_API_TOKEN=your_api_token_here

# Container Settings
# Puedes sobrescribir el nombre del contenedor (se normalizará si contiene caracteres no válidos)
CONTAINER_NAME=rovodev-workspace

# Git credentials (Optional)
GIT_USERNAME=your_git_username
GIT_PASSWORD=your_personal_access_token
GIT_USER_NAME=Your Full Name
GIT_USER_EMAIL=your.email@company.com

```

Get your Atlassian API token from: https://id.atlassian.com/manage-profile/security/api-tokens

## 🏗️ For Repository Maintainers

### Prerequisites

To build and deploy the Docker image, you need:

1. **DockerHub Account** with username and access token
2. **GitHub Repository Secrets**:
   - `DOCKERHUB_USERNAME`: Your DockerHub username
   - `DOCKERHUB_TOKEN`: Your DockerHub access token

### Automatic Build & Deploy

The repository includes a GitHub Actions workflow (`.github/workflows/docker-build.yml`) that automatically:

- Builds multi-platform Docker images (AMD64 + ARM64)
- Pushes to DockerHub when changes are made to `Dockerfile` or `entrypoint.sh`
- Creates tagged versions for different architectures

### Manual Build

To build locally:

```bash
# Build for current platform
docker build -t juanfu26/rovodev:latest .

# Build for multiple platforms
docker buildx build --platform linux/amd64,linux/arm64 -t juanfu26/rovodev:latest --push .
```

## 🔧 Features

### Multi-Platform Support
- **AMD64** (Intel/AMD processors)
- **ARM64** (Apple Silicon, ARM processors)

### Development Tools Included
- **acli** (Atlassian CLI) for RovoDev integration
- **Node.js 20.19+** with npm
- **OpenSpec** for API documentation
- **Playwright** for browser automation
- **Docker-in-Docker** support
- **Git** with credential management

## 📋 Usage Examples

### Basic Usage
```bash
### Multi-instance containers
- Ejecuta múltiples contenedores con la misma imagen, pero con workspaces distintos.
- Usa run-rovodev.sh con flags:
  - `--workspace=/ruta/al/workspace`
  - `--container-name=rovodev-<proyecto>`
  - `--wiki=/ruta/al/wiki` (opcional). Si no lo pasas, se auto-detecta un repo hermano llamado `<repo>-wiki`.

Ejemplos:
- `./run-rovodev.sh --workspace /abs/path/projectA --container-name rovodev-projectA`
- `./run-rovodev.sh --workspace /abs/path/projectB --container-name rovodev-projectB --wiki /abs/path/projectB-wiki`

### Wiki integration (WIKI_ROOT)

### OpenSpec workflow (end-to-end)
1) Jira → disparador
- Crear spec mínima en /workspace/wiki/openspec/changes con OpenSpec Draft

2) OpenSpec → planificación formal (rápida)
- Completar secciones mínimas (10–20 min)

3) Validación por referente (humano)
- Marcar status: validated con OpenSpec Validate

4) Ejecución automática por IA
- Implementar por dominio, commits organizados, generar PR

5) Merge → core funcional
- OpenSpec Finalize: status finalized y PRs fusionadas

Reglas clave:
- Specs pequeñas, 1 tarea = 1 spec
- OpenSpec = intención técnica, Confluence = visión funcional
- Modelo central usa plantilla propia con impact list
- Sin spec validada → no IA

- Si montas un repo de wiki, se expone en `/workspace/wiki` dentro del contenedor y se exporta `WIKI_ROOT=/workspace/wiki`.
- Si no existe repositorio hermano `<repo>-wiki`, se montará por defecto la carpeta `./wiki` del proyecto como `/workspace/wiki`. Si está vacía, el contenedor bootstrapea la estructura mínima de OpenSpec automáticamente (no crea drafts por ticket, sólo plantillas e índice).
- El entrypoint prepara `/wiki/openspec/changes` automáticamente.
- Los comandos de RovoDev que generan documentación pueden escribir en `$WIKI_ROOT/openspec/changes` cuando está disponible.

./run-rovodev.sh
```

### Help
```bash
./run-rovodev.sh --help
```

## 🛠️ Architecture

Nota: Las plantillas de OpenSpec viven en `templates/openspec/` dentro de la imagen y se materializan en `wiki/openspec/` en el proyecto/wikis al iniciar.

Playwright: esta imagen 'lite' NO incluye Playwright. Para escenarios que requieran Playwright, ejecuta un servidor externo `@playwright/mcp` y conéctate a él desde tu cliente MCP.

Ver `docs/TECHNICAL.md#docker-image-structure` para detalles de la estructura de la imagen y del workspace.

### Docker Image Structure
```
/opt/templates/             # Template content in image
└── openspec/               # Default OpenSpec standards (copied to wiki at runtime)

/home/rovodev/.rovodev      # Default RovoDev configuration (seed source)

/workspace/                # Aggregate workspace inside container
/workspace/code            # Mounted project directory (host)
/workspace/wiki            # Mounted wiki directory (host, optional)
/home/rovodev/.rovodev     # Base config included in image (do not edit in repo)
/home/rovodev/             # User home directory
```

### Initialization Flow
1. **Environment Setup**: Create `.env.template` if `.env` doesn't exist
2. **Template Copy**: Copy `openspec/` into wiki if empty; config base is available at `/home/rovodev/.rovodev` and can be overridden by `CODE_ROOT/.rovodev`
3. **Authentication**: Setup Atlassian and Jira authentication
4. **Docker**: Configure Docker-in-Docker access
6. **Git**: Configure Git credentials and user info
7. **Launch**: Start RovoDev AI assistant

## 🔍 Troubleshooting

### Common Issues

Authentication Failed
- Verify `ATLASSIAN_API_TOKEN` and `ATLASSIAN_USERNAME` in `.env`
- Generate new API token at: https://id.atlassian.com/manage-profile/security/api-tokens

Docker Access Issues
- On macOS: Ensure Docker Desktop is running
- On Linux: Check Docker socket permissions
- Try running with `--privileged` flag

Permission Issues
- Ensure the script has execute permissions: `chmod +x run-rovodev.sh`
- Check that current user can write to the project directory

### Debug Mode
For detailed logging, examine container output:
```bash
./run-rovodev.sh
# Container will show detailed setup information
```

## 📈 Development

Para información detallada para desarrolladores y mantenedores, consulta `docs/DEVELOPMENT.md`.

## 🙏 Thanks

Special thanks to these amazing projects that inspired and contributed to this work:

- **[AI Specs by LIDR Academy](https://github.com/LIDR-academy/ai-specs/)** - For the innovative approach to AI-driven specification management and development standards.
- **[ACLI RovoDev Sandbox by MayankTahil](https://github.com/MayankTahil/acli-rovodev-sandbox)** - For the foundational work on Atlassian CLI integration and Docker containerization patterns.

## 🤝 Support

For issues and questions:
- GitHub Issues: [Repository Issues](https://github.com/juanfu26/spec-driven-with-rovodev/issues)
- Documentation: [RovoDev Documentation](https://developer.atlassian.com/platform/rovo/)