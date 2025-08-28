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
-

_See the build.log for a full list_



**signature**. Images are signed using `cosign`. Verify images using the twplatformlabs [public key](https://raw.githubusercontent.com/twplatformlabs/static/master/cosign.pub).  
```bash
cosign verify --key cosign.pub ghcr.io/twplatformlabs/jumppod:2025.04
```  
**software bill of materials**. For each published image, a _Software Bill of Materials_ is generated using [syft](https://github.com/anchore/syft) and added as an attestation.  

validate attestation:  
```bash
cosign verify-attestation --type https://spdx.dev/Document --key cosign.pub ghcr.io/twplatformlabs/jumppod:2025.04
```
download manifest and extract bill of materials (sbom.spdx.json):  
```
cosign download attestation ghcr.io/twplatformlabs/jumppod:2025.04 > attestation.json  
jq -r '.payload' attestation.json | base64 -d > envelope.json
jq '.predicate' envelope.json > sbom.spdx.json
```
_Note. Dockerhub Scout does not appear to support non-docker attestations_  

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
