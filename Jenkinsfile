pipeline {
    agent any
    environment {
        // 自定义变量：镜像地址、新版本标签、命名空间
        IMAGE_REG = "harbor.example.com/demo/app"
        IMAGE_TAG = "${BUILD_NUMBER}"  // 用构建号作为镜像tag，也可手动输入
        NAMESPACE = "app-demo"
    }
    stages {
        stage('1. 拉取配置文件') {
            steps {
                git url: 'https://git.example.com/k8s-yaml.git', branch: 'main'
                sh 'ls -l'
            }
        }

        stage('2. 判断当前在线环境') {
            steps {
                script {
                    // 获取 Service 当前选中的环境 blue/green
                    def currentEnv = sh(
                        script: "kubectl get svc app-svc -n ${NAMESPACE} -o jsonpath='{.spec.selector.env}'",
                        returnStdout: true
                    ).trim()
                    echo "当前线上环境：${currentEnv}"
                    
                    // 确定待发布环境
                    if (currentEnv == "blue") {
                        env.DEPLOY_TARGET = "green"
                        env.OLD_ENV = "blue"
                    } else {
                        env.DEPLOY_TARGET = "blue"
                        env.OLD_ENV = "green"
                    }
                    echo "本次待发布环境：${DEPLOY_TARGET}"
                }
            }
        }

        stage('3. 更新待机环境镜像') {
            steps {
                script {
                    // 替换 YAML 中的镜像标签，部署对应 Deployment
                    sh """
                    sed -i "s|\${IMAGE_TAG}|${IMAGE_TAG}|g" deployment-${DEPLOY_TARGET}.yaml
                    kubectl apply -f deployment-${DEPLOY_TARGET}.yaml -n ${NAMESPACE}
                    """
                    // 等待 Deployment 就绪
                    sh "kubectl rollout status deployment/app-deploy-${DEPLOY_TARGET} -n ${NAMESPACE} --timeout=180s"
                }
            }
        }

        stage('4. 新版本健康检查') {
            steps {
                // 自定义健康检查：接口探测、日志检查、端口检测
                sh """
                # 示例：调用应用健康接口
                curl -I http://app-svc.${NAMESPACE}.svc.cluster.local/health
                """
            }
        }

        stage('5. 切换流量（蓝绿切换）') {
            steps {
                // 修改 Service 标签，切到新版本环境
                sh """
                kubectl patch svc app-svc -n ${NAMESPACE} -p '{"spec":{"selector":{"env":"${DEPLOY_TARGET}"}}}'
                """
                echo "流量已切换至 ${DEPLOY_TARGET} 环境"
            }
        }
    }

    post {
        success {
            echo "蓝绿发布完成，旧环境 ${OLD_ENV} 保留用于回滚"
        }
        failure {
            echo "发布失败，流量保持原环境 ${OLD_ENV}"
        }
    }
}
