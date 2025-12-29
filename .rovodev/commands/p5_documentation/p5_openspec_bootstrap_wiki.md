# OpenSpec: Bootstrap Wiki

Prepara una wiki existente (Diátaxis) para integrar OpenSpec sin romper su estructura. Crea la jerarquía `openspec/` con standards, changes e índices, y enlaza desde `Home.md`.

## Objetivo
- Añadir la estructura OpenSpec a una wiki existente
- Mantener Diátaxis intacto
- Crear enlaces de descubrimiento desde Home.md

## Uso
```bash
rovodev openspec-bootstrap-wiki
```
Precondiciones:
- `WIKI_ROOT=/wiki` montado (auto-detectado por run-rovodev.sh).
- Archivo `Home.md` en la raíz de la wiki.

## Acciones
1) Crear rutas:
- `/wiki/openspec/standards` (con `.keep`)
- `/wiki/openspec/changes` (con `.keep`)
- `/wiki/openspec/index.md`
2) Sembrar plantillas:
- Crear `openspec/standards/spec-minima.md`
- Crear `openspec/standards/spec-modelo-central.md`
3) Enlazar desde Home.md:
- Añadir sección "OpenSpec" con enlace a `openspec/index.md`

## Índice inicial (`openspec/index.md`)
- Introducción al propósito de OpenSpec
- Enlaces a standards y a la carpeta changes
- Cómo nombrar archivos: `YYYY-MM-DD_[JIRA]_[slug].md`
- Estados: draft → validated → finalized

## Notas
- No se elimina contenido existente
- Idempotente: puede ejecutarse varias veces sin romper la estructura

## CLI OpenSpec (opcional y recomendado)
```bash
# Construir o reconstruir el índice
openspec index build --root openspec --out openspec/index.md || true

# Lint de estándares y cambios
openspec lint --path openspec/standards || true
openspec lint --path openspec/changes || true
```
