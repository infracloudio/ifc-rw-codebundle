<p align="center">
  <a href="https://discord.gg/Ut7Ws4rm8Q">
    <img src="https://img.shields.io/discord/1131539039665791077?label=Join%20Discord&logo=discord&logoColor=white&style=for-the-badge" alt="Join Discord">
  </a>
  <a href="https://runwhen.slack.com/join/shared_invite/zt-1l7t3tdzl-IzB8gXDsWtHkT8C5nufm2A">
    <img src="https://img.shields.io/badge/Join%20Slack-%23E01563.svg?&style=for-the-badge&logo=slack&logoColor=white" alt="Join Slack">
  </a>
</p>
<a href='https://codespaces.new/runwhen-contrib/codecollection-template?quickstart=1'><img src='https://github.com/codespaces/badge.svg' alt='Open in GitHub Codespaces' style='max-width: 100%;'></a>

[![Build](https://github.com/runwhen-contrib/codecollection-template/actions/workflows/build.yaml/badge.svg)](https://github.com/runwhen-contrib/codecollection-template/actions/workflows/build.yaml)


[Upstream Docs - CodeCollection Template](https://github.com/runwhen-contrib/codecollection-template/blob/main/README.md)

# InfraCloud RunWhen CodeCollection

This CodeCollection aims to create a repository of CodeBundles that can address the various reproducible incident scenarios at [Infracloud/sre-stack](https://github.com/infracloudio/sre-stack/)

- Set meaningful SLOs on Services and their dependencies
  - DBs
  - Queues
  - Caches
  - Gateways and proxies
- Create SLIs to continuosly monitor the health of services and dependencies
- Create mitigation runbooks in some scenarios where root-cause can be deterministically attested to

## Additional Docs
- [RunWhen Concepts](docs/runwhen/concepts.md)
- [Contributing to CodeCollections/CodeBundles](docs/runwhen/contrib.md)