# Preparing the OpenWrt contribution

The package reflects the working controls1 state. Nothing has been published automatically. The code belongs in [openwrt/openwrt](https://github.com/openwrt/openwrt), not the packages feed.

1. Reproduce or review the pinned build described in BUILD.md.
2. Check the intended upstream development branch for an existing device definition and intervening changes. The supplied patch is against the tested pinned commit, not claimed to be current HEAD.
3. Apply/adapt the patch on that branch, inspect the diff, run git diff --check and applicable repository checks, then rebuild. Retest material changes to drivers, partitions, image format or defaults.
4. Use COMMIT_MESSAGE.txt and PR_DESCRIPTION.md for the contribution. Provide genuine author identity and Signed-off-by; none is invented in this archive. Preserve appropriate source attribution.
5. Submit the source commit via a pull request or development mailing list following the project's current contribution instructions.

The upstream code change is the DTS plus image profile. These companion documents are for reviewers/testers and a public project page; do not add the entire archive or firmware binaries to the source tree unless requested.

## Community publication

FORUM_POST.md is a posting draft. Attach this source archive or link a public repository containing it. If distributing compiled images, also publish their corresponding source/configuration, license/source information and exact hashes. RELEASE.md identifies the final local files, not arbitrary rebuilds.

Keep stock dumps, private backups and network configuration private. Do not label community builds as official releases or claim upstream acceptance before it occurs. A device wiki page can use README.md, INSTALL.md and TESTING.md after a stable public project link exists.

## References

- [Submitting patches](https://openwrt.org/submitting-patches)
- [Device support policies](https://openwrt.org/docs/guide-developer/device-support-policies)
- [Source repository](https://github.com/openwrt/openwrt)

Check the current project instructions when submitting.
