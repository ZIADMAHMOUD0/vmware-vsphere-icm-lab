# VMware vSphere ICM Setup Guide

This guide will walk you through the entire process of setting up your VMware environment from scratch within **VMware Workstation**.

## 🛠️ Prerequisites

- **VMware Workstation Pro/Player** installed.
- **ESXi ISO Image** (v7.0 or v8.0 recommended).
- **vCenter Server Appliance (vCSA) ISO**.
- **Ubuntu Server ISO** (for VM 1 and VM 2).

---

## 1️⃣ Phase 1: Install ESXi Hosts (2 Hosts)

You need to create **two** virtual machines in VMware Workstation to act as your physical servers.

### Steps for Host 1 & Host 2:
1.  **Create New VM**: Select `Typical (Recommended)`.
2.  **Select ISO**: Browse to your **ESXi ISO**.
3.  **VM Name**: Name them `ESXi-Host-01` and `ESXi-Host-02`.
4.  **Hardware Requirements (Minimum)**:
    - **RAM**: 4 GB (8 GB recommended).
    - **CPU**: 2 Cores.
    - **Network**: Set to `Bridged` (or `NAT` if you want a private lab).
5.  **Finish & Power On**: Follow the on-screen prompts (Accept EULA, select disk, set Root password).
6.  **Configuration**: Once installed, press **F2** -> `Configure Management Network`.
    - Set static IPs (e.g., `192.168.1.101` and `192.168.1.102`).
    - Note down these IPs for vCenter access.

---

## 2️⃣ Phase 2: Deploy vCenter Server

vCenter is the management "brain" that connects your hosts.

1.  **Mount vCSA ISO**: Double-click the vCenter ISO on your Windows machine.
2.  **Run Installer**: Go to `vcsa-ui-installer` -> `win32` -> **installer.exe**.
3.  **Choose "Install"**: Follow the Stage 1 wizard.
    - **Target**: Enter the IP of `ESXi-Host-01`.
    - **VM Name**: `vCenter-Server`.
4.  **Stage 2**: Set up the **SSO Domain** (Usually `vsphere.local`).
5.  **Access**: Once finished, log in to `https://<vcenter-ip>/ui`.

---

## 3️⃣ Phase 3: vCenter Integration

Now you must "centralize" your hosts:
1.  **Login**: Open vSphere Client (Chrome/Browser).
2.  **Create Datacenter**: Right-click the vCenter name -> `New Datacenter`.
3.  **Add Hosts**: Right-click the Datacenter -> `Add Host`.
    - Enter the IPs of **ESXi-Host-01** and **ESXi-Host-02**.
    - Enter the `root` username and password you set in Phase 1.

---

## 4️⃣ Phase 4: Create Guest VMs (VM 1 & VM 2)

1.  **Create VM 1 (on Host 1)**:
    - Right-click **ESXi-Host-01** -> `New Virtual Machine`.
    - Install **Ubuntu Server**.
    - IP: `192.168.1.10`
2.  **Create VM 2 (on Host 2)**:
    - Right-click **ESXi-Host-02** -> `New Virtual Machine`.
    - Install **Ubuntu Server**.
    - IP: `192.168.1.20`

---

## 5️⃣ Phase 5: Deploy the API & Test

Once the Ubuntu VMs are running:
1.  **Transfer Files**: Use `WinSCP` or `SCP` to move the `api/` folder to VM 1.
2.  **Install API**: Run `npm install` and `node server.js` in VM 1.
3.  **Transfer Test Script**: Move `tests/test_api.sh` to VM 2.
4.  **Run Test**:
    ```bash
    chmod +x test_api.sh
    ./test_api.sh <VM1-IP>
    ```

---

## 6️⃣ Phase 6: Migration & Backup

To complete the project, you must demonstrate stateful backups and live migration.

### 1. Snapshots (Stateful Backup)
1.  In vSphere Client, right-click **VM 1**.
2.  Select `Snapshots` -> `Take Snapshot`.
3.  Name it `Before-API-Update` and click **Create**.
4.  To verify, right-click **VM 1** -> `Snapshots` -> `Manage Snapshots` to see your save point.

### 2. Live Migration (vMotion)
vMotion allows you to move a running VM between hosts with zero downtime.
1.  Ensure **VM 1** is powered on.
2.  Right-click **VM 1** -> `Migrate`.
3.  Select **"Change compute resource only"**.
4.  Select **ESXi-Host-02** as the target.
5.  Follow the wizard (keep network/priority as default) and click **Finish**.
6.  Monitor the progress in the `Recent Tasks` pane. Once finished, **VM 1** will be running on **Host 02**.
