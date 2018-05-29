@Library('libpipelines@master') _

hose {
    EMAIL = 'qa'
    DEVTIMEOUT = 20
    RELEASETIMEOUT = 20
    PKGMODULESNAMES = ['marathon-lb-sec']
    BUILDTOOL = 'make'
    INSTALLTIMEOUT = 20

    INSTALLSERVICES = [
            ['DCOSCLI':   ['image': 'stratio/dcos-cli:0.6.1-SNAPSHOT',
			   'volumes': ['stratio/paasintegrationpem:0.1.0'],
                           'env':     ['DCOS_IP=10.200.0.156',
                                      'SSL=true',
				      'SSH=true',
                                      'TOKEN_AUTHENTICATION=true',
                                      'DCOS_USER=admin@demo.stratio.com',
                                      'DCOS_PASSWORD=1234',
                                      'BOOTSTRAP_USER=operador',
                                      'PEM_FILE_PATH=/paascerts/PaasIntegration.pem'],
                           'sleep':  120,
			   'healthcheck': 5000]]
        ]

    INSTALLPARAMETERS = """
                    | -DDCOS_CLI_HOST=%%DCOSCLI#0
                    | -DBOOTSTRAP_IP=10.200.0.155
		    | -DDCOS_IP=10.200.0.156
		    | -DINSTALL_MARATHON=false
		    | """.stripMargin().stripIndent()
                    


    DEV = { config ->
        doDocker(config)
    }

    INSTALL = { config ->
        doAT(conf: config, groups: ['nightly'])
    }
}
