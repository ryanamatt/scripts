#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/sysinfo.h>
#include <unistd.h>

void print_bar(const char* label, long current, long total, const char* unit) {
    int width = 20;
    int filled = (total > 0) ? (int)((double)current / total * width) : 0;
    printf("%-8s [", label);
    for (int i = 0; i < width; i++) {
        if (i < filled) printf("#");
        else printf("-");
    }
    printf("] %ld/%ld %s\n", current, total, unit);
}

void get_distro(char* buffer, size_t size) {
    FILE* fp = fopen("/etc/os-release", "r");
    if (fp) {
        char line[256];
        while (fgets(line, sizeof(line), fp)) {
            if (strncmp(line, "PRETTY_NAME=", 12) == 0) {
                char* name = line + 13; // Skip PRETTY_NAME="
                name[strcspn(name, "\"")] = 0; // Remove trailing quote
                strncpy(buffer, name, size);
                fclose(fp);
                return;
            }
        }
        fclose(fp);
    }
    strncpy(buffer, "Linux", size);
}

double get_cpu_usage() {
    long double a[4], b[4];
    FILE* fp = fopen("/proc/stat", "r");
    fscanf(fp, "%*s %Lf %Lf %Lf %Lf", &a[0], &a[1], &a[2], &a[3]);
    fclose(fp);
    usleep(100000); // 100ms sample
    fp = fopen("/proc/stat", "r");
    fscanf(fp, "%*s %Lf %Lf %Lf %Lf", &b[0], &b[1], &b[2], &b[3]);
    fclose(fp);

    double loadavg = ((b[0]+b[1]+b[2]) - (a[0]+a[1]+a[2])) / ((b[0]+b[1]+b[2]+b[3]) - (a[0]+a[1]+a[2]+a[3]));
    return loadavg * 100;
}

int main() {
    struct sysinfo info;
    char distro[64];
    if (sysinfo(&info) != 0) return 1;

    get_distro(distro, sizeof(distro));
    long total_ram = info.totalram * info.mem_unit / 1024 / 1024;
    long used_ram = total_ram - (info.freeram * info.mem_unit / 1024 / 1024);

    printf("\033[1;36m--- PULSE DASHBOARD ---\033[0m\n");
    printf("Distro:   %s\n", distro);
    printf("Uptime:   %ldh %ldm\n", info.uptime / 3600, (info.uptime % 3600) / 60);
    printf("CPU:      %.1f%%\n", get_cpu_usage());
    print_bar("Memory", used_ram, total_ram, "MB");
    printf("Processes: %d running\n", info.procs);

    return 0;
}