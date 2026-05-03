# plsft/rehearse-images

Source for the 10 Rehearse Pro CI base images. Built and signed via GitHub
Actions on a weekly cron (Mondays 06:00 UTC) plus on every push that affects
an image directory.

> **Move to its own repo before launch:** this folder is colocated under
> `rehearse-pro/images/` for scaffolding speed. When you're ready, extract
> via `git subtree split --prefix=images -b images-extract` and push that
> branch to `github.com/plsft/rehearse-images`.

## Layout

```
images/
├── matrix.yaml                # source-of-truth list of images to build
├── shared/
│   ├── warm-npm.sh            # warming helper: pre-pull top-N npm packages
│   ├── warm-pip.sh
│   ├── warm-cargo.sh          # (when rust comes back to the catalog)
│   ├── warm-go.sh
│   ├── top-npm.txt            # curated package list (regenerated quarterly)
│   ├── top-pypi.txt
│   ├── top-go.txt
│   ├── postgres-init.sh
│   └── runner-user.sh         # adds non-root `runner` (uid 1000) to any base
├── node/
│   ├── 20/Dockerfile
│   └── 20/smoke.sh
├── python/
│   ├── 3.12/Dockerfile
│   └── 3.12/smoke.sh
├── bun/1/{Dockerfile,smoke.sh}
├── go/1.23/{Dockerfile,smoke.sh}
├── java/21/{Dockerfile,smoke.sh}
├── dotnet/8/{Dockerfile,smoke.sh}
├── ruby/3.3/{Dockerfile,smoke.sh}
├── php/8.3/{Dockerfile,smoke.sh}
├── combos/
│   ├── node-20-postgres/{Dockerfile,smoke.sh}
│   └── python-3.12-postgres/{Dockerfile,smoke.sh}
└── .github/workflows/
    ├── pr-validate.yml         # build + smoke + Trivy on PRs (no push)
    └── publish.yml             # weekly + on-push: build + smoke + Trivy + cosign + push
```

## Build contract

Every image:

1. Starts from a slim official base.
2. Installs the toolchain at the exact version named in the directory.
3. Installs the top-3 package managers for the ecosystem.
4. Runs `shared/warm-<ecosystem>.sh` to pre-populate the package-manager cache.
5. Adds non-root `runner` user (UID/GID 1000), `WORKDIR /workspace`.
6. Includes `/smoke.sh` exit-0-when-healthy.
7. Trivy-scanned (HIGH/CRITICAL fixed → fail).
8. Cosign-signed via Sigstore keyless OIDC.
9. Pushed to `ghcr.io/plsft/<id>` (and mirrored to `registry.rehearse.sh`
   via the proxy).
10. POST `/v1/internal/catalog` to update the live catalog row.

## Local development

```bash
docker buildx build --platform linux/amd64 --tag rehearse-test/node-20-warm node/20
docker run --rm rehearse-test/node-20-warm sh /smoke.sh
```
