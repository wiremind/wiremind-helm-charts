## SSHd

Allows to deploy a ssh server.

After having deployed a Helm Release, you can access to ssh by doing:

    kubectl port-forward -n wiremind-cayzn-cm-production deployment/sshd 2222:22

Then, you can access ssh to localhost:2222.

