# Especificações do Ambiente de Testes

Abaixo estão os detalhes do servidor (gentilmente concedido pelo Giovanni Bassi) que rodará os testes. 


Docker
``` 
$ docker --version
Docker version 25.0.3, build 4debf41
```

Gatling
``` 
# gatling versão 3.10.3
$ java --version
openjdk 21.0.1 2023-10-17
OpenJDK Runtime Environment (build 21.0.1+12-Ubuntu-222.04)
OpenJDK 64-Bit Server VM (build 21.0.1+12-Ubuntu-222.04, mixed mode, sharing)
```

CPU
``` 
$ lscpu                          
Architecture:            x86_64
  CPU op-mode(s):        32-bit, 64-bit
  Address sizes:         46 bits physical, 57 bits virtual
  Byte Order:            Little Endian
CPU(s):                  4
  On-line CPU(s) list:   0-3
Vendor ID:               GenuineIntel
  Model name:            Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz
    CPU family:          6
    Model:               106
    Thread(s) per core:  2
    Core(s) per socket:  2
    Socket(s):           1
    Stepping:            6
    CPU max MHz:         2800.0000
    CPU min MHz:         800.0000
    BogoMIPS:            5586.87
    Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss ht syscall nx pdpe1gb rdtscp lm constant_tsc rep_good nopl xtopology tsc_reliable nonstop_tsc cpuid aperfmperf pni pclmulqdq vmx ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hyp
                         ervisor lahf_lm abm 3dnowprefetch invpcid_single tpr_shadow vnmi ept vpid ept_ad fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm avx512f avx512dq rdseed adx smap avx512ifma clflushopt clwb avx512cd sha_ni avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves avx512vbmi umip avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni avx
                         512_bitalg avx512_vpopcntdq la57 rdpid fsrm arch_capabilities
Virtualization features: 
  Virtualization:        VT-x
  Hypervisor vendor:     Microsoft
  Virtualization type:   full
Caches (sum of all):     
  L1d:                   96 KiB (2 instances)
  L1i:                   64 KiB (2 instances)
  L2:                    2.5 MiB (2 instances)
  L3:                    48 MiB (1 instance)
NUMA:                    
  NUMA node(s):          1
  NUMA node0 CPU(s):     0-3
Vulnerabilities:         
  Gather data sampling:  Unknown: Dependent on hypervisor status
  Itlb multihit:         Not affected
  L1tf:                  Not affected
  Mds:                   Not affected
  Meltdown:              Not affected
  Mmio stale data:       Vulnerable: Clear CPU buffers attempted, no microcode; SMT Host state unknown
  Retbleed:              Vulnerable
  Spec rstack overflow:  Not affected
  Spec store bypass:     Vulnerable
  Spectre v1:            Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  Spectre v2:            Mitigation; Retpolines, STIBP disabled, RSB filling, PBRSB-eIBRS Not affected
  Srbds:                 Not affected
  Tsx async abort:       Not affected
```

Memória
```
$ free -h
               total        used        free      shared  buff/cache   available
Mem:            15Gi       1.0Gi       9.4Gi       3.0Mi       5.2Gi        14Gi
Swap:             0B          0B          0B
```

SO (Ubuntu 23.04)
```
$ uname -a
Linux rinha 6.2.0-1019-azure #19~22.04.1-Ubuntu SMP Wed Jan 10 22:57:03 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
```