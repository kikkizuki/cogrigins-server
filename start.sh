#!/bin/bash
cd "$(dirname "$0")"
java -Xmx10G -Xms10G \
     -XX:+UseG1GC \
     -XX:+UnlockExperimentalVMOptions \
     -XX:MaxGCPauseMillis=50 \
     -XX:+UnlockDiagnosticVMOptions \
     -XX:+ParallelRefProcEnabled \
     -XX:+DisableExplicitGC \
     -XX:+AlwaysPreTouch \
     -XX:ParallelGCThreads=8 \
     -XX:ConcGCThreads=2 \
     -XX:G1HeapRegionSize=16M \
     -XX:G1NewSizePercent=30 \
     -XX:G1MaxNewSizePercent=40 \
     -XX:G1HeapWastePercent=5 \
     -XX:G1MixedGCCountTarget=4 \
     -XX:G1MixedGCLiveThresholdPercent=90 \
     -XX:G1RSetUpdatingPauseTimePercent=5 \
     -XX:SurvivorRatio=32 \
     -XX:+PerfDisableSharedMem \
     -XX:MaxTenuringThreshold=1 \
     -XX:G1ReservePercent=20 \
     -XX:InitiatingHeapOccupancyPercent=15 \
     -XX:+UseStringDeduplication \
     -jar fabric-server-launch.jar nogui