#!/usr/bin/env bats

@test "gcc available" {
  run bash -c "docker exec container-test gcc --help"
  [[ "${output}" =~ "Usage: gcc" ]]
}

@test "cmake available" {
  run bash -c "docker exec container-test cmake --help"
  [[ "${output}" =~ "cmake [options]" ]]
}

@test "make available" {
  run bash -c "docker exec container-test make --help"
  [[ "${output}" =~ "Usage: make" ]]
}

@test "curl available" {
  run bash -c "docker exec container-test curl --help"
  [[ "${output}" =~ "Usage: curl" ]]
}

@test "wget available" {
  run bash -c "docker exec container-test wget --help"
  [[ "${output}" =~ "Usage: wget" ]]
}

@test "tar available" {
  run bash -c "docker exec container-test tar --help"
  [[ "${output}" =~ "Usage: tar" ]]
}

@test "gzip available" {
  run bash -c "docker exec container-test gzip --help"
  [[ "${output}" =~ "Usage: gzip" ]]
}

@test "unzip available" {
  run bash -c "docker exec container-test unzip --help"
  [[ "${output}" =~ "Usage: unzip" ]]
}

@test "zip available" {
  run bash -c "docker exec container-test zip --help"
  [[ "${output}" =~ "zip [-options]" ]]
}

@test "bzip2 available" {
  run bash -c "docker exec container-test bzip2 --help"
  [[ "${output}" =~ "usage: bzip2" ]]
}

@test "sudo available" {
  run bash -c "docker exec container-test sudo --help"
  [[ "${output}" =~ "usage: sudo" ]]
}

@test "github-cli available" {
  run bash -c "docker exec container-test gh --help"
  [[ "${output}" =~ "GitHub from the command line" ]]
}

@test "jq available" {
  run bash -c "docker exec container-test jq --help"
  [[ "${output}" =~ "Usage:	jq" ]]
}

@test "gnupg available" {
  run bash -c "docker exec container-test gpg --help"
  [[ "${output}" =~ "Syntax: gpg" ]]
}

@test "bash available" {
  run bash -c "docker exec container-test bash --help"
  [[ "${output}" =~ "Usage:	bash" ]]
}

@test "check locale" {
  run bash -c "docker exec container-test locale"
  [[ "${output}" =~ "LC_ALL=en_US.UTF-8" ]]
}

@test "describe user jumppod" {
  run bash -c "docker exec container-test getent passwd | grep jumppod"
  [[ "${output}" =~ "jumppod:x:3434:3434" ]]
  [[ "${output}" =~ "/home/jumppod" ]]
}

@test "describe /home/jumppod" {
  run bash -c "docker exec container-test ls -la /home/jumppod"
  [[ "${output}" =~ "jumppod jumppod" ]]
}

@test "describe /home/jumppod/.gnupg" {
  run bash -c "docker exec container-test ls -la /home/jumppod/.gnupg"
  [[ "${output}" =~ "gpg.conf" ]]
}

@test "git available" {
  run bash -c "docker exec container-test git --help"
  [[ "${output}" =~ "usage: git" ]]
}

@test "openssh available" {
  run bash -c "docker exec container-test ssh --help"
  [[ "${output}" =~ "usage: ssh" ]]
}

@test "nmap available" {
  run bash -c "docker exec container-test nmap --help"
  [[ "${output}" =~ "Usage: nmap" ]]
}

@test "ping available" {
  run bash -c "docker exec container-test ping -help"
  [[ "${output}" =~ "Options:" ]]
}

@test "traceroute available" {
  run bash -c "docker exec container-test traceroute --help"
  [[ "${output}" =~ "Usage:" ]]
}

@test "etcdctl available" {
  run bash -c "docker exec container-test etcdctl --help"
  [[ "${output}" =~ "command line client for etcd3" ]]
}

@test "istioctl available" {
  run bash -c "docker exec container-test istioctl --help"
  [[ "${output}" =~ "Istio configuration command line utility" ]]
}

@test "ca-certificates installed" {
  run bash -c "docker exec container-test ls /etc/ssl/certs/"
  [[ "${output}" =~ "DigiCert_Assured_ID_Root_CA" ]]
}
