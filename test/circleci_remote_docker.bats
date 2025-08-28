#!/usr/bin/env bats

@test "git version" {
  run bash -c "docker exec container-test git --help"
  [[ "${output}" =~ "usage: git" ]]
}

@test "openssh version" {
  run bash -c "docker exec container-test ssh --help"
  [[ "${output}" =~ "usage: ssh" ]]
}

@test "tar version" {
  run bash -c "docker exec container-test tar --help"
  [[ "${output}" =~ "Usage: tar" ]]
}

@test "gzip version" {
  run bash -c "docker exec container-test gzip --help"
  [[ "${output}" =~ "Usage: gzip" ]]
}

@test "ca-certificates installed" {
  run bash -c "docker exec container-test ls /etc/ssl/certs/"
  [[ "${output}" =~ "DigiCert_Assured_ID_Root_CA" ]]
}
