Mobilize-Server
============

Mobilize-Server includes deployment scripts and scheduling via whenever.
* Deploy your selected mobilize configuration and modules to your server

Table Of Contents
-----------------
* [Overview](#section_Overview)
* [Configure](#section_Configure)
  * [Mobilize Modules](#section_Configure_Mobilize_Modules)
  * [Capistrano](#section_Configure_Capistrano)
  * [Whenever](#section_Configure_Whenever)
* [Deploy](#section_Deploy)
  * [Commands](#section_Deploy_Commands)
* [Meta](#section_Meta)
* [Author](#section_Author)

<a name='section_Overview'></a>
Overview
-----------

* Mobilize-ssh adds capistrano deploys and whenever cron scripts to
Mobilize.

<a name='section_Configure'></a>
Configure
------------

<a name='section_Configure_Mobilize_Modules'></a>

Make sure you go through the configuration options for any Mobilize
modules you are interested in including in your instance. For reference,
please see [mobilize_base][mobilize_base], [mobilize_ssh][mobilize_ssh],
[mobilize_hadoop][mobilize_hadoop].

Mobilize-server expects your config files to be in the config/mobilize
folder relative to the project root (where the Capfile, Rakefile etc.
live).

<a name='section_Configure_Capistrano'></a>

The repo ships with a deploy.rb and deploy/production.rb and
deploy/staging.rb scripts, which should be copied into you config folder
as well.

Capistrano has many awesome options etc. but to get up and running you
need only to define the server you want to deploy to, with a gateway
server if you have one. These are in the first couple of lines in the
production/staging.rb scripts.

<a name='section_Configure_Whenever'></a>

The repo ships with a whenever script to keep your Mobilize server
running smoothly. It does these things:

* every hour, it checks workers to be sure they are 

<a name='section_Start'></a>
Start
-----

<a name='section_Start_Create_Job'></a>
### Create Job

* For mobilize-ssh, the following task is available:
  * ssh.run `<node_alias>,<command>,*<gsheet_full_paths>`, which reads
all gsheets, copies them to a temporary folder on the selected node, and
runs the command inside that folder. 
  * The test uses `ssh.run "test_node", "ruby code.rb", "Runner_mobilize(test)/code.rb", "Runner_mobilize(test)/code.sh"`

<a name='section_Start_Run_Test'></a>
### Run Test

To run tests, you will need to 

1) go through the [mobilize-base][mobilize-base] test first

2) clone the mobilize-ssh repository 

From the project folder, run

3) $ rake mobilize_ssh:setup

Copy over the config files from the mobilize-base project into the
config dir, and populate the values in the ssh.yml file, esp. the
test_node item.

You should also copy the ssh private key you wish to use into your
desired path (by default: config/mobilize/ssh_private.key), and make sure it is referenced in ssh.yml

3) $ rake test

This will populate your test Runner from mobilize-base with a sample ssh job.

The purpose of the test will be to deploy two code files, have the first
execute the second, which is a "tail /var/log/syslog" command, and write the resulting output to a gsheet.

<a name='section_Meta'></a>
Meta
----

* Code: `git clone git://github.com/ngmoco/mobilize-ssh.git`
* Home: <https://github.com/ngmoco/mobilize-ssh>
* Bugs: <https://github.com/ngmoco/mobilize-ssh/issues>
* Gems: <http://rubygems.org/gems/mobilize-ssh>

<a name='section_Author'></a>
Author
------

Cassio Paes-Leme :: cpaesleme@ngmoco.com :: @cpaesleme

[mobilize-base]: https://github.com/ngmoco/mobilize-base

