# Senior DevOps Engineer - Technical Assessment

## Overview

This assessment evaluates your ability to containerize an application, build a CI/CD pipeline, and structure a Helm chart for Kubernetes deployment. You have **5 days** to complete it, though we expect it to take roughly **1 day** of focused work.

## What You Need to Do

1. Create a **public** GitHub repository on your own GitHub account
2. Use the contents of this zip as your starting point
3. Complete the tasks below
4. Send us the link to your repository when you're done

---

## Task 1: Dockerfile

A simple Go "Hello World" web server is provided in the `app/` directory.

Write a **production-ready Dockerfile** for this application. Place it at the root of the repository.

Things we look for:
- Multi-stage build
- Minimal final image
- Runs as a non-root user
- Proper use of build cache

---

## Task 2: GitHub Actions Pipeline

Create a GitHub Actions workflow (`.github/workflows/ci.yml`) that triggers on pushes to `main` and on pull requests.

The pipeline should have **3 jobs**:

**Job 1 - Lint Helm Chart:**
- Build the lib-common dependency (`helm dependency build`)
- Lint the chart (`helm lint`)
- Render the chart (`helm template`) to verify it produces valid output

**Job 2 - Lint Dockerfile:**
- Lint the Dockerfile using [hadolint](https://github.com/hadolint/hadolint)

**Job 3 - Build Docker Image:**
- Should only run after the linting jobs pass
- Build the Docker image using Docker Buildx
- Tag the image with the **git short SHA**
- The image does not need to be pushed to a registry

---

## Task 3: Helm Chart

Create a Helm chart in `helm/hello-world/` that deploys the application to Kubernetes.

Your chart **must** use the provided library chart located in `helm/lib-common/` as a dependency. The library chart provides common templates for Deployments and Services that you should reference in your chart's templates.

Your chart should include:
- `Chart.yaml` (with lib-common as a local dependency)
- `values.yaml` with sensible defaults
- Templates for a Deployment and a Service (using the library helpers)
- Resource requests and limits
- Health check probes (the app exposes `/healthz`)

> **Note:** Review the library chart carefully. If you find any issues, fix them and document what you changed and why in your README.

---

## Deliverables

Your submitted repository should contain:

```
.
├── Dockerfile
├── .github/
│   └── workflows/
│       └── ci.yml
├── app/
│   ├── main.go
│   └── go.mod
├── helm/
│   ├── hello-world/          (you create this)
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/
│   │       ├── deployment.yaml
│   │       └── service.yaml
│   └── lib-common/           (provided - fix any issues you find)
│       ├── Chart.yaml
│       └── templates/
│           ├── _helpers.tpl
│           ├── _deployment.tpl
│           └── _service.tpl
└── README.md                 (your notes, decisions, and any issues found)
```

---

## Bonus: Local Deployment

For bonus points, deploy the application to a local Kubernetes cluster (e.g. Docker Desktop with Kubernetes enabled):

1. Build the Docker image locally
2. Install the Helm chart into your cluster
3. Port-forward the service to `localhost:8081`
4. Include screenshots in your README showing:
   - The app running at `http://localhost:8081/`
   - The health check at `http://localhost:8081/healthz`
   - `kubectl get pods` and `kubectl get svc` output showing healthy resources

This is not required but demonstrates hands-on Kubernetes experience.

---

## Evaluation Criteria

| Area                    | What we're looking at                              |
|-------------------------|----------------------------------------------------|
| Dockerfile              | Build stages, security, image size, caching        |
| GitHub Actions          | Pipeline structure, linting, build steps           |
| Helm chart              | Clean structure, proper use of library, values     |
| Library chart bug       | Did you find it? How did you fix it?               |
| Documentation           | Clear reasoning and trade-off awareness            |
| Local deployment (bonus)| Screenshots of app running in a local k8s cluster  |

Good luck!
