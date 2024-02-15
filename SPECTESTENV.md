# Especificações do Ambiente de Testes

Abaixo estão os detalhes do servidor (mentira, é meu note mesmo) que rodará os testes. 


Docker
``` 
$ docker --version
Docker version 25.0.2, build 29cf629
```

Gatling
``` 
# gatling versão 3.10.3
$ java --version
openjdk 21.0.1 2023-10-17
OpenJDK Runtime Environment (build 21.0.1+12-Ubuntu-223.04)
OpenJDK 64-Bit Server VM (build 21.0.1+12-Ubuntu-223.04, mixed mode, sharing)

```

CPU
``` 
$ lscpu                          
Architecture:            x86_64
  CPU op-mode(s):        32-bit, 64-bit
  Address sizes:         39 bits physical, 48 bits virtual
  Byte Order:            Little Endian
CPU(s):                  4
  On-line CPU(s) list:   0-3
Vendor ID:               GenuineIntel
  Model name:            Intel(R) Core(TM) i7-6500U CPU @ 2.50GHz
    CPU family:          6
    Model:               78
    Thread(s) per core:  2
    Core(s) per socket:  2
    Socket(s):           1
    Stepping:            3
    CPU(s) scaling MHz:  94%
    CPU max MHz:         3100,0000
    CPU min MHz:         400,0000
    BogoMIPS:            5199,98
    Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss 
                         ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nonstop_
                         tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1
                          sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault
                          epb invpcid_single pti ssbd ibrs ibpb stibp tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust 
                         bmi1 avx2 smep bmi2 erms invpcid mpx rdseed adx smap clflushopt intel_pt xsaveopt xsavec xgetbv1 xsaves dtherm
                          ida arat pln pts hwp hwp_notify hwp_act_window hwp_epp md_clear flush_l1d arch_capabilities
Virtualisation features: 
  Virtualisation:        VT-x
Caches (sum of all):     
  L1d:                   64 KiB (2 instances)
  L1i:                   64 KiB (2 instances)
  L2:                    512 KiB (2 instances)
  L3:                    4 MiB (1 instance)
NUMA:                    
  NUMA node(s):          1
  NUMA node0 CPU(s):     0-3
Vulnerabilities:         
  Gather data sampling:  Not affected
  Itlb multihit:         KVM: Mitigation: VMX disabled
  L1tf:                  Mitigation; PTE Inversion; VMX conditional cache flushes, SMT vulnerable
  Mds:                   Mitigation; Clear CPU buffers; SMT vulnerable
  Meltdown:              Mitigation; PTI
  Mmio stale data:       Mitigation; Clear CPU buffers; SMT vulnerable
  Retbleed:              Mitigation; IBRS
  Spec rstack overflow:  Not affected
  Spec store bypass:     Mitigation; Speculative Store Bypass disabled via prctl
  Spectre v1:            Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  Spectre v2:            Mitigation; IBRS, IBPB conditional, STIBP conditional, RSB filling, PBRSB-eIBRS Not affected
  Srbds:                 Mitigation; Microcode
  Tsx async abort:       Not affected

```

Memória
```
$ free -h
               total        used        free      shared  buff/cache   available
Mem:            15Gi       4,4Gi       8,7Gi       754Mi       3,4Gi        11Gi
Swap:          2,0Gi          0B       2,0Gi
```

SO (Ubuntu 23.04)
```
$ uname -a
Linux 6.2.0-39-generic #40-Ubuntu SMP PREEMPT_DYNAMIC Tue Nov 14 14:18:00 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
```