# VMware vSphere ICM Project Lab Report?

**Student Name**: [Your Name]
**Date**: [Current Date]
**Environment**: VMware Workstation

---

## 1. Installation & Configuration results

### ESXi Host 1
- **IP Address**: `[192.168.147.101]`
- **Hostname**: `ESXi-01`
- **CPU/RAM**: `[10]`
- **Screenshot**: `[Attach screenshot of ESXi login page or console]`

### ESXi Host 2
- **IP Address**: `[192.168.147.102]`
- **Hostname**: `ESXi-Host-02`
- **CPU/RAM**: `[10]`

---

## 2. vCenter Integration

### vCenter Details
- **vCenter IP**: `[192.168.147.100]`
- **SSO Domain**: `vsphere.local`
- **Inventory Overview**:
  - Datacenter Name: `[icm-datacenter]`
  - Number of Hosts: 2
  - **Screenshot**: `[Attach screenshot of vSphere Client showing both hosts online]`

---

## 3. Virtual Machine Management (Guest VMs)

### VM 1 (on Host 1)
- **Guest OS**:Ubuntu-VM-01
- **IP Address**: `[192.168.147.10]`
- **Role**: API Server

### VM 2 (on Host 2)
- **Guest OS**: Ubuntu-VM-02
- **IP Address**: `[192.168.147.20]`
- **Role**: Test Client

---

## 4. Application Deployment & Connectivity Testing

### RESTful API Deployment
- **API URL**: `http://[VM 1 IP]:3000`
- **Status**: [Operational / Failed]

### Cross-Host Connectivity Test
- **Command Used**: `./test_api.sh [VM 1 IP]`
- **Results**:
  - Ping Success: [Yes/No]
  - API Response: `[Paste output here]`

---

## 5. Migration & Backup (vMotion)

### vMotion Test
- **Action**: Migrated VM 1 from Host 1 to Host 2.
- **Downtime**: [0 seconds / Other]
- **Screenshot**: `[Attach screenshot of VM 1 running on Host 2]`

---

## 6. Conclusion & Troubleshooting
[Describe any challenges you faced and how you solved them.]
