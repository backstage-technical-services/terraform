<div align="center">

### Backstage Terraform

---

This repository contains all the infrastructure-as-code for our systems.

</div>

## 🧐 About

Our new infrastructure is configured using [Terraform][terraform], which is a tool used to provision and manage
infrastructure using declarative code ("infrastructure-as-code"). This increases visibility of how things are configured
and enables the rest of the society to make changes without needing direct access to all the underlying systems.

We make use of a pseudo-"[Terraservices][terraservices]" pattern to organise code into separate, independent
configurations in the `configs` directory:

- `databases`: The configuration for our databases (mariadb and postgres).
- `domains`: DNS configuration for the `bts-crew.com` and `bts-finance.co.uk` domains.
- `k3s`: The configuration for our K3S node (VM).
- `kubernetes`: Any global Kubernetes objects that do not have their own repo in the GitHub organisation.
- `sites`: Any configuration (eg, SSM parameters for sensitive values) for our each of our sites.

[terraform]: https://www.terraform.io/
[terraservices]: https://www.hashicorp.com/resources/evolving-infrastructure-terraform-opencredo

## 🏁 Getting Started

### Pre-requisites

Anyone wanting to make changes will need to be a member of the GitHub organisation as forking is not allowed.

Additionally, if you want to plan/test changes locally you will also need:

- [tfswitch][tfswitch]: Used to automatically install the correct version of Terraform
- [AWS CLI][aws-cli] with the below config
  <details>
  <summary>~/.aws/config</summary>

  ```
  [profile backstage]
  sso_start_url = https://bnjns.awsapps.com/start
  sso_region = eu-west-1
  sso_registration_scopes = sso:account:access
  sso_account_id = 685624812686
  sso_role_name = BackstageDev
  region = eu-west-1
  ```
  </details>
- [Granted][granted]: Provides an improved user experience for authenticating with AWS (uses AWS SSO)

> [!IMPORTANT]  
> You will need to reach out to the `#website-general` Discord channel to get access to the AWS account.

[tfswitch]: https://tfswitch.warrensbox.com/Install/
[aws-cli]: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
[granted]: https://docs.commonfate.io/granted/getting-started

### Installing

Simply clone the repository:

```sh
git clone git@github.com:backstage-technical-services/terraform.git
```

## 🎈 Usage

### Making changes

To make changes to Terraform, follow the standard workflow:

1. Check out a new branch.
2. Make the changes, and push to the new branch.
3. Open a Pull Request.

   GitHub Actions will run some basic checks to ensure the Terraform is valid. It will also plan the changes of all
   configuration and post the result of each plan to the PR as a comment.

   You should review the planned changes for all configurations to ensure they contain, and only contain, the changes
   you expect. If there are unexpected changes, or you are not sure what changes you should expect, you should reach out
   to the `#website-general` channel in Discord.

   You can fix any issues raised by these checks, or continue to work on the changes, by pushing new commits to the
   branch. The original plan comment will be updated with any changes.
4. Request a review from the `#website-general` Discord channel.

   You can address any review comments simply by pushing new commits to the branch, but you will need to re-request a
   review.

Once the PR has been approved:

1. The reviewer will apply the changes by commenting `/apply configs/<config>` for each of the affected configurations.
2. If an apply fails you should address the issue by pushing a fix to the branch, wait for the new plan(s), and then
   review and apply as above. You will likely need a new review.
3. Once all the changes have been applied you can merge the PR (usually handled by the person who applies the changes).

> [!IMPORTANT]
> If a plan or apply fails, you can simply push a commit to fix the issue and try again.

### Running Terraform manually

1. Log into AWS using Granted

   ```sh
   assume --export backstage
   ```

2. Navigate to the desired config and install Terraform

   ```sh
   cd configs/<config> # eg, `cd configs/domain`
   tfswitch
   ```

3. Initialise the Terraform config

   ```shell
   terraform init
   ```

4. Plan the Terraform changes

   ```shell
   terraform plan
   ```

## 📝 Additional Documentation

None.

## 🚀 CI/CD

This repository uses GitHub Actions (see [above](#making-changes)).
