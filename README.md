# MaximusLab — OG Edition

> *"The adventure starts now. No map. No ceiling. No excuses."*

Cinematic, full-bleed landing page for MaximusLab. Designed for home lab deployment on **Kubernetes** via **Docker + Nginx**.

---

## Project Structure

```
maximuslab-og/
├── index.html           # Website (HTML + CSS + JS, zero dependencies)
├── hero.jpeg            # Full-bleed hero image
├── nginx.conf           # Nginx config (gzip, caching, health probe)
├── Dockerfile           # FROM nginx:latest
├── k8s-deployment.yaml  # Kubernetes Namespace + Deployment + Service + Ingress
└── README.md            # This file
```

---

## Quick Start — Docker

```bash
# 1. Build
docker build -t maximuslab .

# 2. Run
docker run -d -p 80:80 --name maximuslab maximuslab

# 3. Open
open http://localhost
```

---

## Kubernetes Deployment

### Step 1 — Build & push your image

```bash
# Build
docker build -t maximuslab:latest .

# Tag for your registry (e.g. local registry or Docker Hub)
docker tag maximuslab:latest <your-registry>/maximuslab:latest

# Push
docker push <your-registry>/maximuslab:latest
```

> **Home lab tip:** If using a local registry (e.g. `registry.local:5000`):
> ```bash
> docker tag maximuslab:latest registry.local:5000/maximuslab:latest
> docker push registry.local:5000/maximuslab:latest
> ```

### Step 2 — Update the image reference

Edit `k8s-deployment.yaml` and update:
```yaml
image: maximuslab:latest   # → your-registry/maximuslab:latest
```

Set `imagePullPolicy: Always` if pulling from a remote registry.

### Step 3 — Apply the manifests

```bash
kubectl apply -f k8s-deployment.yaml
```

This creates:
- **Namespace:** `maximuslab`
- **Deployment:** 2 replicas, rolling update strategy
- **Service:** ClusterIP on port 80
- **Ingress:** Routes `maximuslab.local` → Service

### Step 4 — Access the site

**Option A — Ingress (recommended)**

Add to your `/etc/hosts` (or configure DNS):
```
<ingress-controller-IP>   maximuslab.local
```
Then open: `http://maximuslab.local`

**Option B — Port forward (quick test)**
```bash
kubectl port-forward -n maximuslab svc/maximuslab-web 8080:80
open http://localhost:8080
```

**Option C — NodePort**

In `k8s-deployment.yaml`, change the Service type:
```yaml
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080   # Access via <NodeIP>:30080
```

---

## Kubernetes Commands Reference

| Action | Command |
|---|---|
| Apply all manifests | `kubectl apply -f k8s-deployment.yaml` |
| Check pods | `kubectl get pods -n maximuslab` |
| Check service | `kubectl get svc -n maximuslab` |
| Check ingress | `kubectl get ingress -n maximuslab` |
| View pod logs | `kubectl logs -n maximuslab deploy/maximuslab-web` |
| Restart deployment | `kubectl rollout restart -n maximuslab deploy/maximuslab-web` |
| Scale replicas | `kubectl scale deploy maximuslab-web -n maximuslab --replicas=3` |
| Delete all resources | `kubectl delete namespace maximuslab` |

---

## Nginx Features

- **Gzip** compression (HTML, CSS, JS, SVG)
- **Cache-Control** headers — images cached 365d, CSS/JS 30d
- **Security headers** — X-Frame-Options, X-Content-Type-Options, XSS-Protection
- **`/healthz` endpoint** — returns `200 OK` for Kubernetes liveness/readiness probes
- **SPA routing** — `try_files` fallback to `index.html`

---

## TLS / HTTPS (Optional)

If using [cert-manager](https://cert-manager.io/) with Let's Encrypt, uncomment these lines in `k8s-deployment.yaml`:

```yaml
annotations:
  cert-manager.io/cluster-issuer: "letsencrypt-prod"
...
tls:
  - hosts:
      - maximuslab.local
    secretName: maximuslab-tls
```

---

## Customization

| What | Where |
|---|---|
| Main headline / tagline | `index.html` → `.hero__brand`, `.hero__tagline` |
| Ticker messages | `index.html` → `.ticker__item` elements |
| Colors | `index.html` → `:root` CSS variables |
| Nav links | `index.html` → `.nav__right` and `.mobile-menu` |
| Replicas | `k8s-deployment.yaml` → `spec.replicas` |
| Domain | `k8s-deployment.yaml` → `spec.rules[0].host` |

---

## Site Features

- Full-bleed cinematic layout — desktop split, mobile full-bleed overlay
- Custom animated cursor with magnetic ring (desktop only)
- Film-grain noise overlay + scanline effect
- Cinematic loader sequence on page load
- Staggered reveal animations (CSS keyframes)
- Scrolling ticker bar with OG manifesto phrases
- Mobile hamburger menu with full-screen overlay
- Bebas Neue + Barlow Condensed typography
- Zero JavaScript dependencies

---

© 2025 MaximusLab. Built for the home lab. Deployed for the mission.
