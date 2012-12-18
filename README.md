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
    * [Tasks](#Section_Configure_Capistrano_Tasks)
  * [Whenever](#section_Configure_Whenever)
* [Deploy](#section_Deploy)
  * [Commands](#section_Deploy_Commands)
* [Administration](#Section_Administration)
  * [Console](#Section_Administration_Console)
  * [Log](#Section_Administration_Log)
  * [Resque](#Section_Administration_Resque)
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
please see [mobilize-base][mobilize-base], [mobilize-ssh][mobilize-ssh].

Mobilize-server expects your config files to be in the config/mobilize
folder relative to the project root (where the Capfile, Rakefile etc.
live).

<a name='section_Configure_Capistrano'></a>
Capistrano
--------------

Capistrano has many awesome options, of which the following are
included in this package:

* gateway -- This repo assumes no gateway, but leaves the option
available for uncommenting.

* rvm -- This repo uses system RVM and allows you to specify a gemset.
It's recommended that you create and specify a gemset so you can be sure
your ruby and gems are the version as you expect.

* keep_releases: 5 releases are kept in your release directory.

* multistage -- the repo ships with a staging and production script.
In this repo, both are identical with the exception of the host. These
are specified in the config/deploy/`<environment>`.rb files.

<a name='section_Configure_Capistrano_Tasks'></a>
Tasks
------------

The deploy.rb script itself defines these tasks, which are executed in
the "after update" step as specified in the deploy/`<environment>`.rb
files.

* bundler.bundle_new_release
  * runs bundle install on the project folder without the "test" and
"development" group gems.

* config.populate_dirs
  * uploads the config folder and all its subdirectories to the remote.

* whenever.update_crontab
  * updates the crontab with scripts defined in config/schedule.rb

* resque.restart_resque_web
  * restarts resque-web on the port specified in
resque.yml/`<environment>`/web_port.

<a name='section_Configure_Whenever'></a>
Whenever
---------

The repo ships with the below whenever scripts to keep your Mobilize server
running smoothly. The scripts invoke mobilize_base rake tasks.

Every 10 minutes:

* kill_idle_and_stale_workers: Any workers who started prior to the
latest deploy are killed, unless they are processing a job currently.

* start: ensures the Jobtracker is running.

Every 1 hour:

* kill_idle_workers: ensures that idle workers are killed.

* prep_workers: ensures the appropriate number of workers are working,
and kills any over the limit, idle ones first.

* restart: restarts the jobtracker. This is to ensure that the process
is always live, fresh, and not consuming too many resources.

<a name='section_Administration'></a>
Administration
--------------

<a name='section_Administration_Console'></a>
Console
--------------
The current mobilize-server console uses bundle console:
  $ (cd `<release_path>` && MOBILIZE_ENV=`<environment>` bundle console)

Once inside the console, use irb Mobilize to get into the proper
namespace:

irb> irb Mobilize

* Create User:
  * irb> User.find_or_create_by_name(<username>)

* Start Jobtracker:
  * irb> Jobtracker.start

The Jobtracker will create your Runner and give edit permissions to the admins
and owner. From there it's a matter of updating your Runner from Google
Docs.

<a name='section_Administration_Log'></a>
Log
--------------

Watching the logs is easy enough:

$ tail -f `<release_dir>`/log/mobilize-resque-`<environment>`.log

As the name suggests, this outputs logs from all Resque processes. If
you don't have any Jobs due, you will see the Jobtracker checking
Runners to see if they are ready to be queued, according to the
runner_read_freq specified in jobtracker.yml.

<a name='section_Administration_Resque'></a>
Resque
--------------

The resque-web UI is accessible from `<host>:<web_port>` as defined in
resque.yml. You can run 

$ rake mobilize_base:resque_web

to restart the web UI if it's not running.

Much as you would expect, the resque web UI keeps track of all processes
currently running.

<a name='section_Meta'></a>
Meta
----

* Code: `git clone git://github.com/ngmoco/mobilize-server.git`
* Home: <https://github.com/ngmoco/mobilize-server>
* Bugs: <https://github.com/ngmoco/mobilize-server/issues>

<a name='section_Author'></a>
Author
------

Cassio Paes-Leme :: cpaesleme@ngmoco.com :: @cpaesleme

[mobilize-base]: https://github.com/ngmoco/mobilize-base
[mobilize-ssh]: https://github.com/ngmoco/mobilize-ssh
