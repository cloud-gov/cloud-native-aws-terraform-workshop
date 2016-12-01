## 0. Preparation

* Ensure the AWS account has IAM users with console access and keys set up for all participants.
* Increase quotas on relevant resources (e.g. VPCs)
* Email everyone with the prerequisites and their creds

## 1. Introduction to the concepts

* Present learning objectives

* What is a public cloud?
** Like having your own datacenter, but:
*** with an API (and if you can't do everything through an API, it's not a real cloud)
*** the appearance of infinite resources
*** no capital costs and you only pay for what you use

* What is infrastructure as code?
** Keep desired state in version control
** Some way to transform actual state to make it conform to desired state. We're going to use Terraform
** TDD for your infrastructure
** Refactoring for your infrastructure

## 2. Guest networking basics

* Let's spin up an EC2 instance!
** Create the world's simplest terraform config to spin up a single host: vpc, subnet
** Dry run it (plan)
** Run it
** See it in the console
** Destroy it in terraform
** See it disappear
** Sidebar: terraform state
*** Terraform keeps state locally - y'all don't know about each other's stuff
*** Talk about S3 bucket state so we can have a shared view of desired state
*** Talk about multiple S3 buckets so we can't screw everything up at once and reference mipsytipsy blogs
** Start it again
** Try to connect to it
** Oh noes!

* Guest networking in AWS
** Regions and availability zones
** VPCs (sidebar on classic, but whatevs) and subnets
** Routes and gateways

* Let's make our bastion host accessible to the world!
** Add internet gateway and route
** Hmmm, still not working
** Security groups!
** Talk about security groups
** Implement it
** Yay, we can ping
** How do we ssh?
** Create a key, and then destroy / relaunch

* Review
** We have a VPC, subnet in an AZ, a gateway, a route table, security group, and an EC2 box. We totally clouded!
** However clouds stuff is ephemeral. Show AWS email "your underlying hardware has failed, bye!"
** AWS provides tools to help you with this, like attaching persistent block storage (EBS volumes)
** A lot of people stop here. And if you can cope with your systems dying arbitratily, or it's OK to spend a lot of money on mainframes, do it. Distribution adds complexity.

## 3. A Brief Primer on Distributed systems

* Jesse Robbins: "Operations at web scale is the ability to consistently create and deploy reliable software to an unreliable platform that scales horizontally." (http://oreil.ly/1HRKUVE)
* What happens when we assume the platform is unreliable?
** No "snowflakes". Must be able to reproduce the state of any box in a deterministic, automated fashion.
** Whole AZs can die. Whole regions can die (as happened in 2011). Network partitions are inevitable (see CAP theorem). So we want to be living in at least multiple AZs (multiple regions, if we want > 99.95% uptime).
* This introduces complexity. However there are patterns to deal with this:
** Make apps stateless so they can scale horizontally and fail arbitrarily.
** Make apps disposable - we should be able to start them up fast, automatically.
** Treat all resources - whether attached or remote - in the same way, so that if an app or resource dies we can easily reconnect.
** Treat logs as streams - send all your app events to the OS logging, and then send that to a remote service.
** Instrument everything! In distributed systems it can be very hard to localize the source of problems, and some problems (such as weird latency distributions) are emergent.
* The Heroku folks came up with the idea of the "12-factor app" - basically a set of patterns that allow you to follow Robbins' dictum, a mash-up of building distributed systems with continuous delivery.
** Introduce 12-factor app
** Some of them are more important than others - for example, we're going to skip 7 because for (say) PHP it doesn't really make sense. It's trivial to implement this using the practices we'll be covering today though.

## 4. Autoscaling groups

* Introduce the architecture of an autoscaling group: a load balancer attached to multiple AZs, and then some magic that can create or kill EC2 instances attached to the LB.
** Autoscaling groups can be used to scale groups up and down in response to specified stimuli (CloudWatch events, increased demand, etc.) but for right now we're just going to use it to keep up 1 box per AZ.

* Set up a basic ALB. No SSL.
** Create a 2nd subnet in a different AZ, with associated route table
** Define ALB, listener, target group
** Define autoscaling group
** Create launch configuration
** Launch!

* Talk about launch configurations, and in particular user data.
** Let's set up an httpd

* Try killing a box directly. Watch what happens.

## 5. Monitoring

* Let's set up CloudWatch
** Let's get alerted when http goes down.
** Destroy everything in terraform!
** Now we have a red bar!
** Ideally we should have started with this...

* Let's refactor
** Now we have tests in place, we can refactor!
** Move network config, bastion definition, and our autoscale group into separate files

## 6. Deployment

* Hello world web app
** Stick it into S3

* How do we get the creds to our box?
** Instance profile and roles! No creds required. I <3 instance profiles.

## 7. Databases

* Introduce RDS
** It's a nice wrapper that configures your DB hosts for you, provides multi-AZ deployments and replication, automates backups, and generally saves a lot of work
** Not cheap, but totally worth it (I'd argue)

* Let's set it up. Single AZ for now.
** Create subnet, security group, route table, RDS
 
* How do we pass in creds? Use our S3 bucket

## 8. Continuous deployment

* How do we deploy new versions of the app?
** We could reboot. That would be slow.
** We could use ECS. That would be cool. But it's not in the IT Standards Profile ;P
** Easiest thing that could possibly work: a shell script.

* The world's easiest CD
** A deploy script in our S3 bucket that gets pulled down and put into a cron job.
** Check the MD5 of the local version against the remote version and pull it out of S3 if it's different

* Set up CI with Snap
** You have to give Snap the S3 creds, but that's it
