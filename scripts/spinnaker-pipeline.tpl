{
  "keepWaitingPipelines": false,
  "lastModifiedBy": "anonymous",
  "limitConcurrent": true,
  "spelEvaluator": "v4",
  "stages": [
    {
      "continuePipeline": false,
      "failPipeline": true,
      "job": "python-flask-microservice-build",
      "master": "k8s-jenkins",
      "name": "Jenkins Build",
      "parameters": {},
      "refId": "1",
      "requisiteStageRefIds": [],
      "type": "jenkins"
    },
    {
      "account": "default",
      "app": "${jenkins_job_name}",
      "cloudProvider": "kubernetes",
      "cluster": "deployment python-flask-microservice-template",
      "completeOtherBranchesThenFail": false,
      "continuePipeline": true,
      "criteria": "oldest",
      "failPipeline": false,
      "kind": "deployment",
      "location": "default",
      "mode": "dynamic",
      "name": "Delete (Manifest)",
      "options": {
        "cascading": true
      },
      "refId": "2",
      "requisiteStageRefIds": [
        "1"
      ],
      "type": "deleteManifest"
    },
    {
      "account": "default",
      "cloudProvider": "kubernetes",
      "manifests": [
        {
          "apiVersion": "v1",
          "kind": "Service",
          "metadata": {
            "annotations": {
              "artifact.spinnaker.io/location": "opencloudcx-tracer-round",
              "artifact.spinnaker.io/name": "opencloudcx-tracer-round",
              "artifact.spinnaker.io/type": "kubernetes/service",
              "moniker.spinnaker.io/application": "python-flask-microservice-template",
              "moniker.spinnaker.io/cluster": "service opencloudcx-tracer-round"
            },
            "labels": {
              "app.kubernetes.io/instance": "opencloudcx-tracer-round",
              "app.kubernetes.io/managed-by": "spinnaker",
              "app.kubernetes.io/name": "opencloudcx-tracer-round",
              "app.kubernetes.io/version": "2.0.0",
              "io.portainer.kubernetes.application.stack": "opencloudcx-tracer-round"
            },
            "name": "python-flask-microservice-template",
            "namespace": "default"
          },
          "spec": {
            "ports": [
              {
                "name": "http",
                "port": 5000,
                "protocol": "TCP",
                "targetPort": 5000
              }
            ],
            "selector": {
              "app.kubernetes.io/instance": "opencloudcx-tracer-round",
              "app.kubernetes.io/name": "opencloudcx-tracer-round"
            },
            "type": "LoadBalancer"
          }
        }
      ],
      "moniker": {
        "app": "python-flask-microservice-template"
      },
      "name": "Deploy Load Balancer",
      "refId": "3",
      "requisiteStageRefIds": [
        "2"
      ],
      "skipExpressionEvaluation": false,
      "source": "text",
      "trafficManagement": {
        "enabled": false,
        "options": {
          "enableTraffic": false,
          "services": []
        }
      },
      "type": "deployManifest"
    },
    {
      "account": "default",
      "cloudProvider": "kubernetes",
      "manifests": [
        {
          "apiVersion": "apps/v1",
          "kind": "Deployment",
          "metadata": {
            "annotations": {
              "artifact.spinnaker.io/location": "opencloudcx-tracer-round",
              "artifact.spinnaker.io/name": "opencloudcx-tracer-round",
              "artifact.spinnaker.io/type": "kubernetes/deployment",
              "moniker.spinnaker.io/application": "python-flask-microservice-template",
              "moniker.spinnaker.io/cluster": "deployment python-flask-microservice-template"
            },
            "labels": {
              "app.kubernetes.io/instance": "opencloudcx-tracer-round",
              "app.kubernetes.io/managed-by": "spinnaker",
              "app.kubernetes.io/name": "opencloudcx-tracer-round",
              "app.kubernetes.io/version": "2.0.0",
              "io.opencloudcx.kubernetes.application.stack": "opencloudcx-tracer-round"
            },
            "name": "python-flask-microservice-template",
            "namespace": "default"
          },
          "spec": {
            "replicas": 1,
            "selector": {
              "matchLabels": {
                "app.kubernetes.io/instance": "opencloudcx-tracer-round",
                "app.kubernetes.io/name": "opencloudcx-tracer-round"
              }
            },
            "strategy": {
              "type": "Recreate"
            },
            "template": {
              "metadata": {
                "annotations": {
                  "artifact.spinnaker.io/location": "opencloudcx-tracer-round",
                  "artifact.spinnaker.io/name": "opencloudcx-tracer-round",
                  "artifact.spinnaker.io/type": "kubernetes/deployment",
                  "moniker.spinnaker.io/application": "python-flask-microservice-template",
                  "moniker.spinnaker.io/cluster": "deployment opencloudcx-tracer-round"
                },
                "labels": {
                  "app.kubernetes.io/instance": "opencloudcx-tracer-round",
                  "app.kubernetes.io/managed-by": "spinnaker",
                  "app.kubernetes.io/name": "opencloudcx-tracer-round"
                }
              },
              "spec": {
                "containers": [
                  {
                    "image": "rivasolutionsinc/python-flask-microservice-template-app:1.0",
                    "imagePullPolicy": "Always",
                    "livenessProbe": {
                      "httpGet": {
                        "path": "/status",
                        "port": 5000
                      }
                    },
                    "name": "python-flask-microservice-template",
                    "ports": [
                      {
                        "containerPort": 5000,
                        "name": "http",
                        "protocol": "TCP"
                      }
                    ],
                    "readinessProbe": {
                      "httpGet": {
                        "path": "/status",
                        "port": 5000
                      }
                    },
                    "resources": {}
                  }
                ]
              }
            }
          }
        }
      ],
      "moniker": {
        "app": "python-flask-microservice-template"
      },
      "name": "Deploy Application",
      "refId": "4",
      "requisiteStageRefIds": [
        "3"
      ],
      "skipExpressionEvaluation": false,
      "source": "text",
      "trafficManagement": {
        "enabled": false,
        "options": {
          "enableTraffic": false,
          "services": []
        }
      },
      "type": "deployManifest"
    }
  ],
  "triggers": [
    {
      "branch": "main",
      "enabled": true,
      "project": "OpenCloudCX",
      "secret": "${github_hook_pw}",
      "slug": "python-flask-microservice-template",
      "source": "github",
      "type": "git"
    }
  ],
  "updateTs": "1637258469000"
}
