#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>

#define WIDTH 60
#define HEIGHT 30

// ANSI Color Codes
#define COLOR_CELL  "\x1b[32m" // Green
#define COLOR_RESET "\x1b[0m"
#define CLEAR_SCREEN "\x1b[H\x1b[J"
#define HIDE_CURSOR "\x1b[?25l"

void draw(int grid[HEIGHT][WIDTH]) {
    printf(CLEAR_SCREEN);
    for (int y = 0; y < HEIGHT; y++) {
        for (int x = 0; x < WIDTH; x++) {
            if (grid[y][x]) 
                printf(COLOR_CELL "█" COLOR_RESET);
            else 
                printf(" ");
        }
        printf("\n");
    }
}

int count_neighbors(int grid[HEIGHT][WIDTH], int y, int x) {
    int count = 0;
    for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
            if (i == 0 && j == 0) continue;
            int ny = (y + i + HEIGHT) % HEIGHT; 
            int nx = (x + j + WIDTH) % WIDTH;
            if (grid[ny][nx]) count++;
        }
    }
    return count;
}

void update(int grid[HEIGHT][WIDTH]) {
    int next[HEIGHT][WIDTH];
    for (int y = 0; y < HEIGHT; y++) {
        for (int x = 0; x < WIDTH; x++) {
            int neighbors = count_neighbors(grid, y, x);
            if (grid[y][x])
                next[y][x] = (neighbors == 2 || neighbors == 3);
            else
                next[y][x] = (neighbors == 3);
        }
    }
    for (int y = 0; y < HEIGHT; y++)
        for (int x = 0; x < WIDTH; x++)
            grid[y][x] = next[y][x];
}

int main() {
    int grid[HEIGHT][WIDTH] = {0};

    // Seed the random number generator with the current time
    srand(time(NULL));

    // Randomly populate the grid
    for (int y = 0; y < HEIGHT; y++) {
        for (int x = 0; x < WIDTH; x++) {
            // Roughly 25% of cells will start alive
            grid[y][x] = (rand() % 4 == 0);
        }
    }
    
    printf(HIDE_CURSOR);

    while (1) {
        draw(grid);
        update(grid);
        usleep(100000); // 100ms delay
    }
    return 0;
}