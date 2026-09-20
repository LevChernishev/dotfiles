#include <mach/mach.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    mach_port_t host = mach_host_self();

    // 1. CPU Load (100ms sample)
    host_cpu_load_info_data_t prev, curr;
    mach_msg_type_number_t count = HOST_CPU_LOAD_INFO_COUNT;
    host_statistics(host, HOST_CPU_LOAD_INFO, (host_info_t)&prev, &count);
    usleep(100000); // 100ms
    count = HOST_CPU_LOAD_INFO_COUNT;
    host_statistics(host, HOST_CPU_LOAD_INFO, (host_info_t)&curr, &count);

    uint64_t user = curr.cpu_ticks[CPU_STATE_USER] - prev.cpu_ticks[CPU_STATE_USER];
    uint64_t sys  = curr.cpu_ticks[CPU_STATE_SYSTEM] - prev.cpu_ticks[CPU_STATE_SYSTEM];
    uint64_t idle = curr.cpu_ticks[CPU_STATE_IDLE] - prev.cpu_ticks[CPU_STATE_IDLE];
    uint64_t total = user + sys + idle;
    int cpu = (total > 0) ? (int)((user + sys) * 100 / total) : 0;

    // 2. RAM Usage
    mach_msg_type_number_t vm_count = HOST_VM_INFO64_COUNT;
    vm_statistics64_data_t vm_stat;
    vm_size_t page_size = 16384;
    host_page_size(host, &page_size);

    int used_gb = 0, used_dec = 0;
    if (host_statistics64(host, HOST_VM_INFO64, (host_info64_t)&vm_stat, &vm_count) == KERN_SUCCESS) {
        uint64_t used_bytes = ((uint64_t)vm_stat.active_count + (uint64_t)vm_stat.wire_count + (uint64_t)vm_stat.compressor_page_count) * page_size;
        used_gb = (int)(used_bytes / (1024ULL * 1024 * 1024));
        used_dec = (int)((used_bytes % (1024ULL * 1024 * 1024)) / (1024ULL * 1024 * 100));
    }

    printf("%d %d.%dG\n", cpu, used_gb, used_dec);
    return 0;
}
