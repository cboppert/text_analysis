PROJECT = text_analysis
PROJECT_DESCRIPTION = New project
PROJECT_VERSION = 0.1.0

DEPS = cowboy sync jsx shotgun
dep_cowboy_commit = master
dep_sync_commit = master
dep_jsx_commit = master
dep_shotgun_commit = master
DEP_PLUGINS = cowboy sync jsx shotgun

include erlang.mk
