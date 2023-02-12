@Echo off
schtasks /change /TN "NvTmMon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /disable
schtasks /change /TN "NvTmRep_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /disable
schtasks /change /TN "NvTmRepOnLogon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /disable