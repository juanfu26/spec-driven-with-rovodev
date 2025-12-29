#!/usr/bin/env bash
set -euo pipefail

# RovoDev: Script de construcción de imagen Docker
# Objetivo: construir (y opcionalmente publicar) la imagen base que será usada por run-rovodev.sh
# Uso básico:
#   scripts/build-image.sh
# Opciones:
#   --image-name <name>     Nombre del repositorio de la imagen (por defecto: juanfu26/spec-driven-with-rovodev)
#   --tag <tag>             Tag de la imagen (por defecto: latest)
#   --platform <list>       Plataformas para buildx (p.ej. linux/amd64,linux/arm64)
#   --push                  Publica la imagen (requiere login a Docker Hub)
#   --no-cache              Construye sin cache
#   --load                  Carga la imagen en el docker local (solo buildx sin --push)
#   --builder <name>        Nombre del builder buildx (se crea si no existe)
#   --help                  Muestra ayuda
# Ejemplos:
#   scripts/build-image.sh --tag dev-$(date +%Y%m%d) \
#       --platform linux/amd64,linux/arm64 --push
#   scripts/build-image.sh --image-name juanfu26/spec-driven-with-rovodev --tag latest

DEFAULT_IMAGE_NAME="juanfu26/spec-driven-with-rovodev"
IMAGE_NAME="$DEFAULT_IMAGE_NAME"
TAG="latest"
PLATFORM=""
PUSH=false
NO_CACHE=false
LOAD=false
BUILDER_NAME="rovodev-builder"
AUTO_TAG=false

print_help() {
  sed -n '1,40p' "$0" | sed 's/^# \{0,1\}//'
}

log() { echo -e "[build-image] $*"; }
err() { echo -e "[build-image][ERROR] $*" >&2; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || { err "Comando requerido no encontrado: $1"; exit 1; }
}

parse_args() {
  while [[ ${1:-} ]]; do
    case "$1" in
      --image-name)
        IMAGE_NAME="$2"; shift 2;;
      --tag)
        TAG="$2"; shift 2;;
      --platform)
        PLATFORM="$2"; shift 2;;
      --push)
        PUSH=true; shift;;
      --no-cache)
        NO_CACHE=true; shift;;
      --load)
        LOAD=true; shift;;
      --builder)
        BUILDER_NAME="$2"; shift 2;;
      --help|-h)
        print_help; exit 0;;
      *)
        err "Opción desconocida: $1"; print_help; exit 1;;
    esac
  done
}

ensure_buildx() {
  if ! docker buildx version >/dev/null 2>&1; then
    err "docker buildx no está disponible. Instala el plugin de buildx o Docker Desktop reciente.";
    exit 1
  fi
  if ! docker buildx ls | grep -q "^$BUILDER_NAME\b"; then
    log "Creando builder buildx: $BUILDER_NAME"
    docker buildx create --name "$BUILDER_NAME" --use >/dev/null
  else
    log "Usando builder existente: $BUILDER_NAME"
    docker buildx use "$BUILDER_NAME" >/dev/null
  fi
}

resolve_tag_from_git() {
  # Si el usuario pide --tag auto, derivar uno informativo desde git
  if [[ "$TAG" == "auto" ]]; then
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      local short_sha; short_sha=$(git rev-parse --short HEAD 2>/dev/null || echo "nogit")
      local ts; ts=$(date +%Y%m%d)
      TAG="dev-${ts}-${short_sha}"
      log "Usando tag derivado: $TAG (puedes sobreescribir con --tag)"
    else
      TAG="dev-$(date +%Y%m%d)"
      log "Repo git no detectado; usando tag derivado por fecha: $TAG"
    fi
  fi
}

build_local() {
  local full_tag="${IMAGE_NAME}:${TAG}"
  log "Construyendo imagen local: ${full_tag}"
  local cache_flag=()
  $NO_CACHE && cache_flag+=("--no-cache")
  docker build "${cache_flag[@]}" -t "$full_tag" .
  log "Imagen construida: ${full_tag}"
}

build_with_buildx() {
  ensure_buildx
  local full_tag="${IMAGE_NAME}:${TAG}"
  local args=(buildx build -t "$full_tag" .)
  [[ -n "$PLATFORM" ]] && args+=(--platform "$PLATFORM")
  $NO_CACHE && args+=(--no-cache)
  if $PUSH; then
    args+=(--push)
  elif $LOAD; then
    args+=(--load)
  else
    # Si no se indica --push ni --load, usar --load por defecto para single-arch
    if [[ -z "$PLATFORM" || "$PLATFORM" != *","* ]]; then
      args+=(--load)
    fi
  fi
  log "Ejecutando: docker ${args[*]}"
  docker "${args[@]}"
  log "Build finalizado: ${full_tag}"
}

main() {
  require_cmd docker
  parse_args "$@"

  # Si el usuario no pasó --tag, intenta generar uno informativo desde git
  resolve_tag_from_git || true

  if [[ -n "$PLATFORM" || $PUSH == true || $LOAD == true ]]; then
    build_with_buildx
  else
    build_local
  fi

  log "Sugerencias de uso:"
  log "- Para multi-arquitectura y publicar: \n  scripts/build-image.sh --platform linux/amd64,linux/arm64 --tag $TAG --push"
  log "- Para cambiar el nombre de imagen: \n  scripts/build-image.sh --image-name $IMAGE_NAME --tag $TAG"
  log "- Para usar desde run-rovodev.sh: el compose y script esperan ${DEFAULT_IMAGE_NAME}:latest por defecto"
}

main "$@"
