<div align="center">
	<p>
		<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/twplatformlabs/static/master/psk_banner.png" width=800 />
	</p>
  <h1>psk-jumppod</h1>
  <h3>Kubectl exec target for Kubernetes investigations</h3>
  <a href="https://app.circleci.com/pipelines/github/twplatformlabs/psk-jumppod"><img src="https://circleci.com/gh/twplatformlabs/psk-jumppod.svg?style=shield"></a> <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/twplatformlabs/psk-jumppod"></a>
</div>
<br />

Based on Ubuntu:24.04, with many useful packages already installed, such as:
- build-essentials, gcc, cmake, make
- curl, wget, gnupg
- tar, gzip, unzip, zip, bzip2
- git, git-lfs, gh (github cli)
- python3, jq
- dnsutils, nmap, iputil-ping, apt-utils
- kubectl, etcdctl, istioctl
- trivy

_See the build.log for a full list_

You can launch directly onto a particular node using the kubectl debug command.  
Example on EKS:  
```bash
kubectl get nodes

NAME                                           STATUS   ROLES    AGE   VERSION
ip-192-168-51-15.us-east-2.compute.internal    Ready    <none>   20m   v1.29.3-eks-810597c
ip-192-168-64-199.us-east-2.compute.internal   Ready    <none>   20m   v1.29.3-eks-810597c

k debug node/ip-192-168-51-15.us-east-2.compute.internal -it \
  --profile=general \
  --name=jumppod \
  --image=ghcr.io/twplatformlabs/jumppod:stable
```
You will need to delete the resulting pod to clean up.  

Can be deployed as simple pod resource:  
```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: jumppod
  namespace: default
spec:
  containers:
    - name: jumppod
      image: ghcr.io/twplatformlabs/jumppod:edge
      command: ["sleep", "3600"]
      imagePullPolicy: Always
```
Then access a shell using:  
```bash
kubectl exec -it jumppod -- /bin/bash
```
The example folder has some other configurations that can provide more access.  

**signature**. The jumppod is signed using `cosign`. Verify images using the twplatformlabs [public key](https://raw.githubusercontent.com/twplatformlabs/static/master/cosign.pub).  
```bash
cosign verify --key cosign.pub ghcr.io/twplatformlabs/jumppod:2025.04
```  
**software bill of materials**. For each published image, a _Software Bill of Materials_ is generated using [syft](https://github.com/anchore/syft) and added as an attestation.  

validate attestation:  
```bash
cosign verify-attestation --type https://spdx.dev/Document --key cosign.pub ghcr.io/twplatformlabs/jumppod:2025.04
```
download manifest and extract bill of materials (sbom.spdx.json):  
```bash
cosign download attestation ghcr.io/twplatformlabs/jumppod:2025.04 > attestation.json  
jq -r '.payload' attestation.json | base64 -d > envelope.json
jq '.predicate' envelope.json > sbom.spdx.json
```

### Tagging Scheme

This image has the following tagging scheme:

```
twdps/circleci-remote-docker:<YYYY.MM>
twdps/circleci-remote-docker:stable
twdps/circleci-remote-docker:edge
```

`<YYYY.MM>` - Release version of the image, referred to by the four-digit year and two-digit month. For example, `2025.04` would be the April 2025 build. This image is generated on the 5th day of each month, pulling the current release of the base image and related packages and provides a predictable fixed point for use. Review the build log in the pipeline artifacts for the specific image and package versions. Occasionally, there will be interim patch released and you may see `YYYY.MM.1` or additional further numbered versions.  

`stable` - generic tag that always points to the latest, monthly release image.  

`edge` - is the latest development of the Base image. Built from the `HEAD` of the `main` branch as part of continuous integration testing.  
