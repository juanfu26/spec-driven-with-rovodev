# Development Guide

Audiencia: desarrolladores y mantenedores de este repositorio.

## Project Structure
```
.
├── Dockerfile              # Multi-stage Docker build
├── entrypoint.sh           # Container initialization script
├── run-rovodev.sh          # User-facing launcher script
├── .github/workflows/      # CI/CD automation
├── .rovodev/               # RovoDev commands, subagents y prompts
└── openspec/               # Estándares y plantillas OpenSpec
```

## Build y pruebas locales
- Construir la imagen:
  ```bash
  docker build -t rovodev-local .
  ```
- Ejecutar el entorno en un proyecto:
  ```bash
  ./run-rovodev.sh
  ```
- Ver logs del contenedor (diagnóstico de montajes y bootstrap):
  ```bash
  ./run-rovodev.sh
  ```

## Contributing
1. Crea una rama desde main
2. Realiza cambios atómicos y con convenciones de commit (conventional commits)
3. Prueba localmente (build de imagen si tocas Dockerfile/entrypoint)
4. Abre un Pull Request

Cambios en `Dockerfile` o `entrypoint.sh` pueden requerir rebuilds y verificación en plataformas (macOS/Linux/Windows).

## Estándares y guías
- Reglas operativas y defaults: `.agent.md`
- Guías clave: `docs/WORKFLOW-GUIDE.md`, `docs/README-ROVODEV.md`, `docs/QUICK-START.md`
- Catálogo de comandos: `.rovodev/commands/` (ver secciones por dominio)
- Subagentes/skills: `.rovodev/subagents/`

## Notas de CI/CD
- Workflows en `.github/workflows/`.
- Alinear instrucciones para GitHub Copilot en `.github/copilot-instructions.md`.
- Mantener consistencia multi‑IA reforzando convenciones en `.agent.md` y docs/.

## Resolución de problemas
- Permisos en Linux (UID/GID): ver `docs/TECHNICAL.md#host-uidgid-linux`.
- Acceso a Docker: ver Troubleshooting en README.
- Ver más en `docs/TECHNICAL.md`.
