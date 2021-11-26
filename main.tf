terraform {
  required_providers {
    kubernetes = {}
    jenkins = {
      source  = "taiidani/jenkins"
      version = "~> 0.9.0"
    }
    spinnaker = {
      source  = "tidal-engineering/spinnaker"
      version = "1.0.6"
    }
  }
}

locals {
  name = "python-flask-microservice-build"
  jenkins_microservice_build_job = templatefile("${path.module}/scripts/python-flask-microservice.tpl", {
    kubectl_version  = var.kubectl_version
    jenkins_job_name = local.name
    }
  )
}

resource "jenkins_job" "microservice-build" {
  name     = local.name
  template = local.jenkins_microservice_build_job
}

resource "spinnaker_application" "application" {
  application = "python-flask-microservice-template"
  email       = "anorris@rivasolutionsinc.com"
}

resource "spinnaker_pipeline" "pipeline" {
  application = spinnaker_application.application.application
  name        = "build and deploy"
  pipeline    = file("${path.module}/scripts/spinnaker-pipeline.tpl")
}
