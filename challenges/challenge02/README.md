## 🔐 Challenge 02: "Shadow Puppet"

### 📖 Scenario

You've gained access to a Compute Engine virtual machine `c02-vm` running in `Challenge 02 - Project A`. This VM operates under a service account named `c02-vm-sa`, which appears to have limited privileges at first glance.

As you explore, you uncover that `Challenge 02 - Project B` contains a Cloud Storage bucket holding a sensitive file. However, your current access does not include direct permissions on this project or its resources.

### 🎯 Mission

Your objective is to:
* Leverage the compromised service account in `Challenge 02 - Project A`.
* Pivot across any available trust relationships or IAM bindings.
* Access the sensitive Cloud Storage bucket in `Challenge 02 - Project B`.
* Read and enumerate the contents of the confidential file stored there.
