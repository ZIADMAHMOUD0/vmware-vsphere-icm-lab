# 🚀 VMware vSphere ICM Project — Fresh Start Guide (v5 — VCSA 6.7, Error-Proof)

> **COMPLETE FRESH START — Delete everything and redo with correct settings.**
> Advisor (Yara Ashraf) confirmed: VCSA approach is correct. NO Windows Server needed.
> Version: **vSphere 6.7** (ESXi 6.7.1 + VCSA 6.7)
> **Follow every step. Do not skip.**

---

## 🎯 Why Fresh Start?

Previous attempt had:
- ESXi disks created at 40 GB → datastore too small (32.5 GB)
- VMFS partition stuck in middle → can't expand
- Ubuntu VMs failing to install due to space

**Fix:** Create ESXi hosts with **100 GB disks from the beginning** — no expansion needed, no partition games, no space issues.

---

## 🎯 Target Architecture

```
┌─────────────────────────────────────────────────────────┐
│           vSphere Client UI (Chrome Browser)            │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │   VCSA 6.7 (Linux)  │
              │   192.168.147.100   │
              └─────────┬───────────┘
                        │ Manages
          ┌─────────────┴─────────────┐
          ▼                           ▼
    ┌──────────┐                ┌──────────┐
    │  ESXi-1  │                │  ESXi-2  │
    │  .101    │                │  .102    │
    │ 100 GB   │                │ 100 GB   │
    │          │                │          │
    │ Ubuntu   │                │ Ubuntu   │
    │ VM1 .10  │                │ VM2 .20  │
    │ (API)    │                │ (Test)   │
    └──────────┘                └──────────┘
```

---

## 🔧 All Errors Fixed in This Version

| Past Error | Fix Applied |
|---|---|
| Datastore too small (32.5 GB) | **ESXi disk = 100 GB from start** ✅ |
| VMFS partition stuck | **Avoided — no expansion needed** ✅ |
| VM disk = 1 GB by accident | **Explicit verify 20 GB + unit GB** ✅ |
| Install crashed — no space | **Thin Provisioning always** ✅ |
| PXE boot error | **✅ "Connect At Power On" for CD/DVD** ✅ |
| Wrong credentials | **`ziad` / `<YOUR_PASSWORD>` everywhere** ✅ |

---

## 📁 ISOs (Already Downloaded)

```
D:\VMware ISOs\
├── VMware_ESXi_6.7.1.iso                     ✅
├── VMware-VCSA-all-6.7.0-16708996.iso        ✅
└── ubuntu-22.04.5-live-server-amd64.iso      ✅
```

---

## 🔑 Credentials (Use Everywhere)

| Component | IP | Username | Password |
|---|---|---|---|
| ESXi Host 1 | `192.168.147.101` | `root` | `<YOUR_PASSWORD>` |
| ESXi Host 2 | `192.168.147.102` | `root` | `<YOUR_PASSWORD>` |
| vCenter (VCSA) | `192.168.147.100` | `administrator@vsphere.local` | `<YOUR_PASSWORD>` |
| VM 1 (API) | `192.168.147.10` | `ziad` | `<YOUR_PASSWORD>` |
| VM 2 (Test) | `192.168.147.20` | `ziad` | `<YOUR_PASSWORD>` |

---

# 🗑️ STEP 0 — Delete Everything (Fresh Start)

### 0.1 — Delete VMs from VMware Workstation

1. Open **VMware Workstation Pro**
2. In **Library** panel on the left, you'll see:
   - `ESXi-Host-01`
   - `ESXi-Host-02`
   - Maybe others

3. For **ESXi-Host-01**:
   - Right-click → **Power** → **Power Off** (if running; skip if already off)
   - Right-click → **Manage** → **Delete from Disk**
   - Confirm: Yes

4. For **ESXi-Host-02**:
   - Same as above: Power Off → Delete from Disk

5. If you see any other VMs in the library (old attempts), delete them too.

6. **Close VMware Workstation completely**.

### 0.2 — Delete leftover files

7. Open **File Explorer**
8. Check these folders and delete any leftover VM files:
   - `C:\VMs\` — delete entire folder if exists
   - `D:\VMs\` — delete entire folder if exists (from old attempts)
   - `C:\Users\HP\OneDrive\Documents\Virtual Machines\` — delete any `ESXi-Host-*` folders
9. Empty Recycle Bin

### 0.3 — Verify disk space

10. `C:\` drive should have **at least 80 GB free** (you have 127 GB — OK ✅):
    - ESXi Host 1 (thin disk): ~15 GB initial → grows to ~45 GB (vCenter + VM 1)
    - ESXi Host 2 (thin disk): ~15 GB initial → grows to ~25 GB (VM 2)
    - Buffer: 20 GB
11. ISOs stay on `D:\VMware ISOs\` (no change)

> **⚠️ CRITICAL:** Because C:\ space is limited, make sure you **ALWAYS use Thin Provisioning** everywhere. Thick provisioning will fail.

---

# 💻 STEP 1 — Install ESXi Host 1 (100 GB disk!)

### 1.1 — Create the VM

1. Open **VMware Workstation Pro**
2. **File** → **New Virtual Machine** (or `Ctrl+N`)
3. Select **"Typical (recommended)"** → **Next**
4. Select **"Installer disc image file (iso)"** → click **Browse**
5. Go to `D:\VMware ISOs\` → select **`VMware_ESXi_6.7.1.iso`** → **Open**
6. Click **Next**
7. **Virtual machine name**: type `ESXi-Host-01`
8. **Location**: click Browse → `C:\VMs\ESXi-Host-01` (create the folder if needed)
9. Click **Next**
10. **⚠️ CRITICAL — Disk size**: type `100` (you MUST change this from default!)
11. Select **"Store virtual disk as a single file"**
12. Click **Next**
13. Click **"Customize Hardware..."** (don't skip!)

### 1.2 — Configure Hardware

14. Click **Memory** on left → set to `12288` MB (12 GB) ⚠️ **vCenter needs 10 GB minimum!**
15. Click **Processors** → set:
    - Number of processors: `1`
    - Cores per processor: `2`
    - ✅ Check **"Virtualize Intel VT-x/EPT or AMD-V/RVI"**
16. Click **Network Adapter** → select **"NAT"**
17. Click **Close**
18. Click **Finish**

### 1.3 — Install ESXi 6.7

19. VM powers on automatically, boots from ESXi ISO
20. Yellow loading screen → wait 1–2 minutes
21. At installer menu → press **Enter**
22. Press **F11** (accept EULA)
23. Installer shows disks → select the **100 GB VMware Virtual disk** → press **Enter**
24. Select keyboard layout (US Default usually) → **Enter**
25. Root password: type `<YOUR_PASSWORD>`, confirm `<YOUR_PASSWORD>` → **Enter**
26. Press **F11** to install
27. Wait 2–5 minutes
28. "Installation Complete" → press **Enter** to reboot

### 1.4 — Configure Static IP

After reboot, the gray/yellow welcome screen appears.

29. Press **F2**
30. Enter password `<YOUR_PASSWORD>` → **Enter**
31. Select **"Configure Management Network"** → **Enter**
32. Select **"IPv4 Configuration"** → **Enter**
33. Select **"Set static IPv4 address..."** → press **SPACE** to choose
34. Fill in:
    - IPv4 Address: `192.168.147.101`
    - Subnet Mask: `255.255.255.0`
    - Default Gateway: `192.168.147.2`
35. Press **Enter** to save
36. Select **"DNS Configuration"** → **Enter**
37. Set:
    - Primary DNS: `8.8.8.8`
    - Hostname: `esxi-host-01`
38. Press **Enter**
39. Press **Esc** → press **Y** to apply network changes

### 1.5 — Verify in Browser

40. On your Windows PC → open Chrome
41. Go to: `https://192.168.147.101/`
42. Certificate warning → click **Advanced** → **Proceed to 192.168.147.101 (unsafe)**
43. Login: `root` / `<YOUR_PASSWORD>`
44. ✅ ESXi Host 1 web UI loads

---

# 💻 STEP 2 — Install ESXi Host 2 (100 GB disk!)

**Repeat Steps 1.1 → 1.5** with these changes:

| Setting | Host 1 (done) | Host 2 (now) |
|---|---|---|
| VM Name | `ESXi-Host-01` | **`ESXi-Host-02`** |
| Location | `C:\VMs\ESXi-Host-01` | **`C:\VMs\ESXi-Host-02`** |
| Disk Size | `100` GB | **`100` GB** |
| Memory | `12288` MB (12 GB) | **`4096` MB** (4 GB) |
| IP | `192.168.147.101` | **`192.168.147.102`** |
| Hostname | `esxi-host-01` | **`esxi-host-02`** |

Everything else (password `<YOUR_PASSWORD>`, gateway, DNS, etc.) stays the same.

**Verify:** `https://192.168.147.102/` loads, you can login.

---

# 💻 STEP 3 — Deploy vCenter Server (VCSA)

### 3.1 — Mount the VCSA ISO

1. In **File Explorer** → go to `D:\VMware ISOs\`
2. Double-click `VMware-VCSA-all-6.7.0-16708996.iso`
3. Windows mounts it as a new drive (e.g., `E:\` or `F:\`)

### 3.2 — Launch Installer

4. Open the mounted drive
5. Navigate: `vcsa-ui-installer` → `win32`
6. Right-click `installer.exe` → **Run as administrator**
7. In the window → click **"Install"**

### 3.3 — Stage 1: Deploy Appliance

8. Click **Next** on Introduction
9. Accept EULA → **Next**
10. Deployment type: select **"Embedded Platform Services Controller"** → **Next**
11. **Deployment target**:
    - ESXi host: `192.168.147.101`
    - Port: `443`
    - User: `root`
    - Password: `<YOUR_PASSWORD>`
    - **Next**
12. Certificate warning → **Yes**
13. **VM settings**:
    - VM name: `vCenter-Server`
    - Root password: `<YOUR_PASSWORD>` (confirm)
    - **Next**
14. Deployment size: **Tiny** → **Next**
15. **Datastore**:
    - Select `datastore1` on Host 1
    - ✅ **Enable Thin Disk Mode**
    - **Next**
16. **Network settings**:
    - Network: `VM Network`
    - IP version: IPv4
    - IP assignment: **static**
    - System name: `192.168.147.100`
    - IP: `192.168.147.100`
    - Subnet: `255.255.255.0`
    - Gateway: `192.168.147.2`
    - DNS: `8.8.8.8`
    - **Next**
17. Review → **Finish**
18. **Wait 15–30 minutes** — DO NOT CLOSE THE WINDOW

### 3.4 — Stage 2: Setup

19. When Stage 1 says "Complete" → **Continue**
20. **Next** on Introduction
21. **vCenter Configuration**:
    - Time sync: **Synchronize with ESXi host**
    - SSH access: **Enabled**
    - **Next**
22. **SSO**:
    - New SSO domain: `vsphere.local`
    - Username: `administrator` (auto)
    - Password: `<YOUR_PASSWORD>` (confirm)
    - Site: `ICM-Site`
    - **Next**
23. CEIP → uncheck → **Next**
24. Review → **Finish** → **OK**
25. Wait 5–10 minutes
26. Complete → **Close**

### 3.5 — Login to vCenter

27. Chrome → `https://192.168.147.100/ui`
28. If "vSphere Client web server is initializing" → wait 5–10 min, refresh
29. Login:
    - User: `administrator@vsphere.local`
    - Password: `<YOUR_PASSWORD>`
30. ✅ vSphere Client loads

---

# 🏗️ STEP 4 — Add Hosts to vCenter

### 4.1 — Create Datacenter

1. In vSphere Client → left panel (Navigator)
2. Right-click `192.168.147.100` (vCenter root) → **New Datacenter...**
3. Name: `ICM-Datacenter` → **OK**

### 4.2 — Add Host 1

4. Right-click **ICM-Datacenter** → **Add Host...**
5. Host name/IP: `192.168.147.101` → **Next**
6. User: `root`, Password: `<YOUR_PASSWORD>` → **Next**
7. Certificate → **Yes**
8. Summary → **Next**
9. License → evaluation → **Next**
10. Lockdown → **Disabled** → **Next**
11. VM location → **Next**
12. **Finish**
13. Wait for task to complete (bottom panel Recent Tasks)

### 4.3 — Add Host 2

14. Right-click **ICM-Datacenter** → **Add Host...**
15. Host: `192.168.147.102` → **Next**
16. `root` / `<YOUR_PASSWORD>` → **Next**
17. Certificate → **Yes** → **Next** → **Next** → **Next** → **Finish**

### 4.4 — Verify

✅ Both hosts show green status under `ICM-Datacenter`.

---

# 📤 STEP 5 — Upload Ubuntu ISO to Both Datastores

### 5.1 — Upload to Host 1 datastore

1. Left panel → click **192.168.147.101** → **Datastores** tab
2. Click `datastore1`
3. Click **Files** tab
4. Click **Upload Files** button
5. Browse → `D:\VMware ISOs\` → `ubuntu-22.04.5-live-server-amd64.iso` → **Open**
6. Wait ~2 min for upload

### 5.2 — Upload to Host 2 datastore

7. Left panel → click **192.168.147.102** → **Datastores** → `datastore1` → **Files**
8. **Upload Files** → same Ubuntu ISO → **Open**
9. Wait

---

# 🐧 STEP 6 — Create Ubuntu-VM-01 on Host 1

### 6.1 — Check datastore space

1. Click **192.168.147.101** → **Datastores** → `datastore1`
2. Should have **~60+ GB free** after vCenter uses ~23 GB

### 6.2 — Create VM

3. Right-click **192.168.147.101** → **New Virtual Machine...**
4. Select **"Create a new virtual machine"** → **Next**
5. Name: `Ubuntu-VM-01`, Location: `ICM-Datacenter` → **Next**
6. Compute: **192.168.147.101** → **Next**
7. Storage: `datastore1` → **Next**
8. Compatibility: default → **Next**
9. Guest OS: **Linux** / **Ubuntu Linux (64-bit)** → **Next**

### 6.3 — Customize Hardware ⚠️ CRITICAL

#### CPU
- **CPU**: `1`

#### Memory
- **Memory**: `2048 MB`

#### Hard disk — TRIPLE-CHECK!
- Click arrow ▶ next to **New Hard disk** to expand
- **Size**: type `20` — verify dropdown shows **GB** (not MB!)
- **Disk Provisioning**: click dropdown → select **Thin Provision** ⚠️

#### CD/DVD Drive — THIS PREVENTS PXE BOOT ERROR!
- Click arrow ▶ next to **New CD/DVD Drive** to expand
- Dropdown → **Datastore ISO File**
- Browse → `datastore1` → select Ubuntu ISO → **OK**
- **✅ CHECK "Connect At Power On"** ⚠️ CRITICAL!

#### Network
- Network: VM Network
- ✅ Check **Connect At Power On**

10. Click **Next**
11. Review — verify:
    - Hard disk = **20 GB** ✅
    - Provisioning = **Thin** ✅
    - CD/DVD = Ubuntu ISO ✅
    - Connect At Power On = ✅
12. Click **Finish**

### 6.4 — Install Ubuntu

13. Right-click **Ubuntu-VM-01** → **Power On**
14. Right-click → **Launch Web Console**
15. GRUB menu appears → press **Enter** on **"Try or Install Ubuntu Server"**
16. Follow installer:

| Screen | Action |
|---|---|
| Language | English → Enter |
| Installer update | **Continue without updating** |
| Keyboard | Your layout → Done |
| Install type | Ubuntu Server → Done |
| **Network** | Select `ens160` → Enter → **Edit IPv4** |
| → Method | **Manual** |
| → Subnet | `192.168.147.0/24` |
| → Address | **`192.168.147.10`** |
| → Gateway | `192.168.147.2` |
| → DNS | `8.8.8.8` |
| → Search domains | blank → **Save** |
| Back to Network | Done |
| Proxy | blank → Done |
| Mirror | default → Done |
| Storage | **Use an entire disk** → Done → Continue |
| **Profile** | |
| → Your name | `ziad` |
| → Server name | `vm1` |
| → Username | `ziad` |
| → Password | `<YOUR_PASSWORD>` |
| → Confirm | `<YOUR_PASSWORD>` |
| Ubuntu Pro | Skip → Continue |
| **SSH** | ✅ **Install OpenSSH server** ⚠️ |
| Featured snaps | Skip all → Done |

17. Wait 5–10 min for install
18. **BEFORE rebooting** — in vSphere:
    - Right-click **Ubuntu-VM-01** → **Edit Settings**
    - Expand CD/DVD drive 1 → **UNCHECK "Connect At Power On"**
    - **OK**
19. Back in console → **Reboot Now** → Enter
20. Login: `ziad` / `<YOUR_PASSWORD>`

### 6.5 — Verify VM 1

```bash
ip a                       # Shows 192.168.147.10
ip route | grep default    # Shows via 192.168.147.2
ping -c 4 8.8.8.8
ping -c 4 192.168.147.102  # Reach Host 2
```

---

# 🐧 STEP 7 — Create Ubuntu-VM-02 on Host 2

### 7.1 — Create VM (same process as VM 1)

1. Right-click **192.168.147.102** → **New Virtual Machine...**
2. "Create a new virtual machine" → **Next**
3. Name: **`Ubuntu-VM-02`**, Location: `ICM-Datacenter` → **Next**
4. Compute: **192.168.147.102** → **Next**
5. Storage: Host 2's `datastore1` → **Next**
6. Compatibility → **Next**
7. Guest OS: Linux / Ubuntu Linux (64-bit) → **Next**
8. **Customize hardware** (SAME as VM 1):
   - CPU: `1`
   - Memory: `2048 MB`
   - **Hard disk**: **20 GB**, **Thin Provision** ⚠️
   - **CD/DVD**: Ubuntu ISO on Host 2's datastore, **✅ Connect At Power On** ⚠️
   - Network: VM Network
9. **Next** → Review (verify 20 GB Thin + ISO + Connect At Power On) → **Finish**

### 7.2 — Install Ubuntu (same as VM 1, but different IP + name)

10. Power On → Launch Web Console
11. Follow installer — SAME answers as VM 1 EXCEPT:

| Setting | VM 2 |
|---|---|
| Address | **`192.168.147.20`** ← different! |
| Server name | **`vm2`** |
| (everything else same) | |

12. Before reboot → **uncheck Connect At Power On** for CD/DVD
13. Login: `ziad` / `<YOUR_PASSWORD>`

### 7.3 — Verify

```bash
ip a                       # 192.168.147.20
ping -c 4 192.168.147.10   # Reach VM 1
```

---

# 🌐 STEP 8 — Deploy API on VM 1

### 8.1 — Transfer API files (Windows PowerShell)

```powershell
scp -r "D:\ICM project\api" ziad@192.168.147.10:~/
```
- Type `yes` (accept host key)
- Password: `<YOUR_PASSWORD>`

### 8.2 — SSH to VM 1

```powershell
ssh ziad@192.168.147.10
```
Password: `<YOUR_PASSWORD>`

### 8.3 — Install Node.js + run API

```bash
sudo apt update
sudo apt install -y nodejs npm
cd ~/api
node server.js

```

Expected:
```
ICM API listening at http://0.0.0.0:3000
```

**⚠️ LEAVE THIS TERMINAL RUNNING!**

### 8.4 — If firewall blocks (optional)

2nd SSH session to VM 1:
```bash
sudo ufw allow 3000
```

---

# 🧪 STEP 9 — Test from VM 2

### 9.1 — Transfer test script (NEW PowerShell window!)

```powershell
scp "D:\ICM project\tests\test_api.sh" ziad@192.168.147.20:~/
```
Password: `<YOUR_PASSWORD>`

### 9.2 — SSH to VM 2 and run

```powershell
ssh ziad@192.168.147.20
```
```bash
chmod +x ~/test_api.sh
./test_api.sh 192.168.147.10
```

**Expected:**
```
--- VMware vSphere ICM Project: API Test ---
[SUCCESS] Ping to VM 1 successful.
[SUCCESS] Received valid API response from VM 1.
Response Data: {"message":"VMware vSphere ICM Project: API Test Successful!"...}
```

📸 **SCREENSHOT!**

---

# 📸 STEP 10 — Snapshot VM 1

1. vSphere → right-click **Ubuntu-VM-01**
2. **Snapshots** → **Take Snapshot...**
3. Name: `Before-API-Update`
4. ✅ Check **"Snapshot the VM memory"**
5. **Create**
6. Verify: right-click VM 1 → Snapshots → **Manage Snapshots**

📸 **SCREENSHOT the Manage Snapshots window!**

---

# 🚀 STEP 11 — vMotion Demo

### 11.1 — Migrate VM 1 to Host 2

1. Ensure VM 1 API still running
2. Right-click **Ubuntu-VM-01** → **Migrate...**
3. **Change compute resource only** → Next
4. Destination: **192.168.147.102** → Next
5. Network → default → Next
6. Priority: **Schedule vMotion with high priority** → Next
7. **Finish**
8. Watch Recent Tasks — 1–2 min

### 11.2 — Test zero downtime

From VM 2 SSH:
```bash
./test_api.sh 192.168.147.10
```
Still `[SUCCESS]` ✅

📸 **SCREENSHOT!**

### 11.3 — Migrate VM 1 BACK to Host 1 (required final state)

9. Right-click **Ubuntu-VM-01** → **Migrate...**
10. Change compute resource only → Next
11. Destination: **192.168.147.101** → Next → Next → **Finish**
12. Wait for migration

### 11.4 — Final verification

📸 **SCREENSHOT vSphere inventory** showing:
- ✅ Ubuntu-VM-01 under **192.168.147.101** (Host 1)
- ✅ Ubuntu-VM-02 under **192.168.147.102** (Host 2)

---

# 🧬 STEP 12 — Clone VM (Required for Grading)

> Grading sheet requires "use snapshots **& clones**" — this gives those marks.

### 12.1 — Clone Ubuntu-VM-02

1. vSphere Client → left panel → right-click **Ubuntu-VM-02**
2. Select **Clone** → **Clone to Virtual Machine...**
3. **Name**: `Ubuntu-VM-02-Clone`
4. Location: `ICM-Datacenter` → **Next**
5. Compute resource: **192.168.147.102** (Host 2) → **Next**
6. Storage: select Host 2's `datastore1` → **Thin Provision** → **Next**
7. Clone options: leave defaults (do NOT power on, do NOT customize) → **Next**
8. Review → **Finish**
9. Wait for "Clone virtual machine" task to complete in Recent Tasks (~2–5 min)

### 12.2 — Verify clone

10. Left panel under **192.168.147.102** should now show:
    - Ubuntu-VM-02
    - **Ubuntu-VM-02-Clone** ✅

📸 **SCREENSHOT** the inventory showing the clone next to the original.

---

# 💾 STEP 13 — Basic Backup (Export OVF)

> Grading sheet requires "implement **basic backups**" — OVF export is the simplest, official backup method.

### 13.1 — Power off VM-01 first ⚠️

> Export OVF is **grayed out** if the VM is powered on. Must shut down first.

1. Right-click **Ubuntu-VM-01** → **Power** → **Shut Down Guest OS** → **Yes**
2. Wait ~30 seconds until VM icon turns gray (powered off)

### 13.2 — Export Ubuntu-VM-01 as OVF

1. vSphere → right-click **Ubuntu-VM-01**
2. Select **Template** → **Export OVF Template...**
3. **Name**: `Ubuntu-VM-01-Backup`
4. Leave other options at defaults → click **OK**
5. Browser will download multiple files (`.ovf`, `.vmdk`, `.mf`) to your Windows `Downloads` folder
6. Wait until all files finish downloading (~5–10 min depending on disk size)

### 13.2 — Move backup to project folder

7. Open File Explorer → `C:\Users\HP\Downloads\`
8. Find the files starting with `Ubuntu-VM-01-Backup`
9. Create folder: `D:\ICM project\backup\`
10. **Move** all the backup files there

### 13.3 — Verify backup

11. Open `D:\ICM project\backup\` in File Explorer
12. Should see at least:
    - `Ubuntu-VM-01-Backup.ovf` (the descriptor)
    - `Ubuntu-VM-01-Backup-disk-0.vmdk` (the disk image)
    - `Ubuntu-VM-01-Backup.mf` (the manifest)

📸 **SCREENSHOT** the File Explorer window showing the backup files.

---

# 📝 STEP 14 — Lab Report

1. Open `D:\ICM project\LabReport_Template.md`
2. Fill every section with screenshots:

| Section | Content |
|---|---|
| Installation | ESXi 6.7 hosts (.101, .102), **100 GB disks** |
| vCenter | VCSA 6.7 at .100, managing both hosts |
| VMs | VM1 .10 on Host1, VM2 .20 on Host2 |
| API | `http://192.168.147.10:3000`, test output screenshot |
| Migration | vMotion screenshots, 0s downtime |
| Snapshot | Before-API-Update screenshot |
| Clone | Ubuntu-VM-02-Clone screenshot |
| Backup | OVF export files in `D:\ICM project\backup\` |
| Conclusion | Challenges + solutions |

---

## 📋 Master Checklist

```
[ ] Step 0:  Delete all old VMs and files
[ ] Step 1:  ESXi Host 1 installed (100 GB!) → 192.168.147.101
[ ] Step 2:  ESXi Host 2 installed (100 GB!) → 192.168.147.102
[ ] Step 3:  VCSA deployed → 192.168.147.100
[ ] Step 4:  Datacenter + both hosts added
[ ] Step 5:  Ubuntu ISO on BOTH datastores
[ ] Step 6:  Ubuntu-VM-01 (20 GB Thin, ISO connected) → 192.168.147.10
[ ] Step 7:  Ubuntu-VM-02 (20 GB Thin, ISO connected) → 192.168.147.20
[ ] Step 8:  API running on VM 1
[ ] Step 9:  Test from VM 2 → [SUCCESS]
[ ] Step 10: Snapshot on VM 1
[ ] Step 11: vMotion demoed, VM 1 final on Host 1
[ ] Step 12: Clone Ubuntu-VM-02 created
[ ] Step 13: OVF backup of Ubuntu-VM-01 saved
[ ] Step 14: Lab Report done
```

---

## 🚨 Troubleshooting

| Error | Cause | Fix |
|---|---|---|
| `PXE-E53: No boot filename` | CD/DVD not connected | Edit Settings → ✅ Connect At Power On |
| Install crash (curtin) | Disk too small | Use 20 GB (not 1 or 7) |
| `Cannot change host configuration` | Managed by vCenter | Use vCenter UI, not ESXi direct |
| vSphere initializing | vCenter starting | Wait 5–10 min |
| SSH refused | No OpenSSH | Reinstall with ✅ Install OpenSSH |
| "Disk capacity > datastore" warning | Thin overcommit (fine) | Click X → OK |

---

**START NOW — Step 0 below. Estimated total time: 4–5 hours.**
