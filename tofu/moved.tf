# State migration for the for_each refactor. Safe to delete once applied.

moved {
  from = module.iam_acme_homeassistant
  to   = module.iam["acme-homeassistant"]
}

moved {
  from = module.iam_tem_authelia
  to   = module.iam["tem-authelia"]
}

moved {
  from = module.iam_tem_homeassistant
  to   = module.iam["tem-homeassistant"]
}

moved {
  from = module.iam_tem_immich
  to   = module.iam["tem-immich"]
}

moved {
  from = module.iam_tem_lldap
  to   = module.iam["tem-lldap"]
}

moved {
  from = module.iam_tem_loki
  to   = module.iam["tem-loki"]
}

moved {
  from = module.iam_tem_mimir
  to   = module.iam["tem-mimir"]
}

moved {
  from = module.iam_tem_nextcloud
  to   = module.iam["tem-nextcloud"]
}

moved {
  from = module.iam_tem_prowlarr
  to   = module.iam["tem-prowlarr"]
}

moved {
  from = module.iam_tem_radarr
  to   = module.iam["tem-radarr"]
}

moved {
  from = module.iam_tem_sabnzbd
  to   = module.iam["tem-sabnzbd"]
}

moved {
  from = module.iam_tem_seer
  to   = module.iam["tem-seer"]
}

moved {
  from = module.iam_tem_sonarr
  to   = module.iam["tem-sonarr"]
}

moved {
  from = module.iam_tem_tyr
  to   = module.iam["tem-tyr"]
}
