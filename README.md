# Provisioning and Deploying Cloud Native Systems in AWS with Terraform and Shell Scripts.

A 1-day hands-on training class in which participants will learn:

* AWS guest network architecture: regions, availability zones, VPCs, subnets, security groups, routes, gateways.
* Some elements of AWS identity and access management: roles, policies.
* How to configure a simple, highly available AWS application environment with AWS autoscaling groups, load balancers, RDS, and CloudWatch.
* Infrastructure-as-Code with AWS and Terraform: How to configure and manage AWS infrastructure using Terraform.
* Very simple automated deployment using shell scripts and an S3 bucket.
* Why building distributed systems motivates the [12-factor app](https://12factor.net/) pattern.

### Prerequisites

* You must bring a laptop with support for bash. Linux, MacOS, or Windows 10 with Windows Subsystem for Linux installed are all fine. Alternatively, you can stand up a virtual linux box using a tool such as [VirtualBox](https://www.virtualbox.org/).
* You must be comfortable using the shell / command-line.
* Please install the [AWS CLI](https://aws.amazon.com/cli/), [Terraform](https://www.terraform.io/) BEFORE coming to class.
* Note, you may also be interested in installing [Vagrant](https://www.vagrantup.com/) but this is *optional.*

### Running the slides locally

The workshop is run as a series of slide decks. The decks are written in HTML, and use [reveal.js](http://lab.hakim.se/reveal-js/#/). To view the slides on your local machine, first cd to [facilitation/presentations](facilitation/presentations). Then install `npm` if you don't already have it, and run the following commands:

```npm install
grunt serve```

This should run an http server locally and spawn a browser window with the first slide of the workshop. Check out the [reveal.js documentation](https://github.com/hakimel/reveal.js) for more on using reveal.js.

### Instructor Preparation

This workshop is designed to be scheduled as an 8h class, including a 1h lunch break and two further 20m breaks (in other words, if you ran the material without a break, it would take you about 6-7h).

Because the class requires hands-on coding, we recommend a maximum of 16 participants per instructor, assuming participants who are comfortable with shell scripting and a text editor. If participants aren't familiar editing and running commands at the shell, you will need a lower ratio of students to instructors, and more time.

We recommend using an empty AWS account for this workshop. Each participant will set up their own VPC in the course of the workshop, and if you've created a new AWS account you will need to submit a request to raise [the default VPC limit of 5 VPCs per region](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Appendix_Limits.html). This should be done several days in advance of delivering the class.

The instructor should upload the contents of the [code/scripts](code/scripts) directory to an S3 bucket. The code and slides assume that the S3 bucket is called `18f-terraform-workshop`, but if you're not running this at 18F, you'll want to upload to your own bucket, and you should change all the references to this S3 bucket in the repo. Find them using `grep -R "18f-terraform-bucket" *`

### Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated
in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright
> and related rights in the work worldwide are waived through the [CC0 1.0
> Universal public domain
> dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication.
> By submitting a pull request, you are agreeing to comply with this waiver of
> copyright interest.

Note that parts of this project have been taken from the [reveal.js][]
repository, and are Copyright (C) 2016 Hakim El Hattab.

[reveal.js]: https://github.com/hakimel/reveal.js
[18F branding]: https://pages-staging.18f.gov/brand/
[visual style guide]: https://pages-staging.18f.gov/brand/visual-style/
