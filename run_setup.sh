#!/bin/bash

# VARIABLES DEFINITION
GIT_MONITORING_TEMPLATES="https://github.com/zampat/icinga2-monitoring-templates.git"

ICINGA2_AGENT_VERSION="2.10.5"
# Define in file directly! SAFED_WIN_VERSION="1_10_1-1"
ITOA_TELEGRAF_AGENT_VERSION="1.10.2"

NETEYESHARE_ROOT_PATH="/neteye/shared/httpd/neteyeshare"
NETEYESHARE_MONITORING="${NETEYESHARE_ROOT_PATH}/monitoring"
NETEYESHARE_ITOA="${NETEYESHARE_ROOT_PATH}/itoa"
NETEYESHARE_LOG="${NETEYESHARE_ROOT_PATH}/log"

ICINGA2_LIB_HOME_DIR="/usr/share/icingaweb2"
ICINGA2_CONF_HOME_DIR="/neteye/shared/icingaweb2/conf"

MONITORING_PLUGINS_CONTRIB_DIR="/neteye/shared/monitoring/plugins"
MONITORING_PLUGINS_CACHE_CONTRIB_DIR="/neteye/shared/monitoring/cache"
MONITORING_PLUGINS_CONTRIB_CONFIG_DIR="/neteye/shared/monitoring/configs"


# Init submodules
./scripts/005_git_submodules_init.sh
./scripts/006_icinga_setup_configurations.sh

# Init share folder structure and WEB link
#
./scripts/010_init_neteyeshare.sh ${NETEYESHARE_MONITORING} ${NETEYESHARE_ITOA}
./scripts/011_init_neteyeshare_weblink.sh


# Icinga2 Agents
#
./scripts/020_get_icinga2_agents.sh ${NETEYESHARE_MONITORING} ${ICINGA2_AGENT_VERSION}
./scripts/021_get_icinga2_agent_nix.sh ${NETEYESHARE_MONITORING} ${ICINGA2_AGENT_VERSION}
./scripts/022_get_icinga2_agent_rhel7.sh ${NETEYESHARE_MONITORING} ${ICINGA2_AGENT_VERSION}


# NetEye 4 default configurations
# - Ressources
#
# LDAP Ressource
./scripts/030_ressources_init.sh ${ICINGA2_CONF_HOME_DIR}
./scripts/031_root_navigation_sample.sh ${ICINGA2_CONF_HOME_DIR}
./scripts/032_role_init.sh ${ICINGA2_CONF_HOME_DIR}
./scripts/033_authentication_init.sh ${ICINGA2_CONF_HOME_DIR}
./scripts/034_auth_groups_init.sh ${ICINGA2_CONF_HOME_DIR}


# Monitoring Templates Import
# - Icinga2 Templates
# - Icingaweb2 Icons: Host icions
#
./scripts/040_monitoring_templates_init.sh ${NETEYESHARE_ROOT_PATH} ${GIT_MONITORING_TEMPLATES}
./scripts/041_icingaweb2_icons_init.sh ${ICINGA2_LIB_HOME_DIR}


# Monitoring Plugins Import
#
# Only copy contents to neteyeshare/
./scripts/051_copy_nonproduct_monitoring_git_plugins.sh $NETEYESHARE_MONITORING
# Activate Plugins in PluginsContribDir/
./scripts/052_install_nonproduct_monitoring_plugins.sh ${MONITORING_PLUGINS_CONTRIB_DIR}
./scripts/053_install_product_monitoring_plugins_before_release.sh ${MONITORING_PLUGINS_CONTRIB_DIR}
#Create configuration files for monitoring plugins
./scripts/055_install_monitoring_plugin_configs.sh ${MONITORING_PLUGINS_CONTRIB_CONFIG_DIR}

# Synchronize content for neteyeshare
./scripts/060_synch_monitoring_plugins.sh $NETEYESHARE_MONITORING
# - Monitoring configuration samples
./scripts/061_sync_monitoring_configurations.sh ${NETEYESHARE_MONITORING}
./scripts/062_sync_monitoring_analytics.sh ${NETEYESHARE_MONITORING}

# Synchronize contents for itoa
./scripts/070_synch_itoa.sh ${NETEYESHARE_ITOA} 
./scripts/071_get_telegraf_agents.sh ${NETEYESHARE_ITOA} ${ITOA_TELEGRAF_AGENT_VERSION}

# Cluster Synchronizations
# -Synchronize /neteye/shared/monitoring/plugins
# -Synchronize various monititroing configuration files and folders 
./scripts/090_clusterSynch_PluginContribDir.sh ${MONITORING_PLUGINS_CONTRIB_DIR}
./scripts/090_clusterSynch_PluginContribDir.sh ${MONITORING_PLUGINS_CONTRIB_CONFIG_DIR}
./scripts/091_clusterSynch_monitoringConfigs.sh

# Log Manager setup
# ./scripts/101_synch_log.sh ${NETEYESHARE_LOG}
./scripts/102_get_log_agents.sh ${NETEYESHARE_LOG}
