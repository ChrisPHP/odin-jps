package main

import "core:fmt"
import "core:time"
import "core:math/rand"
import jps "jps"
import rl "vendor:raylib"



GRID_SIZE :: 25
CELL_SIZE :: 25

START_POS := [2]int{1,1}
END_POS := [2]int{23,23}

grid := [GRID_SIZE*GRID_SIZE]int{}


//Generate a grid of random 0s and 1s
generate_grid :: proc() {
    for i in 0..<GRID_SIZE {
        for j in 0..<GRID_SIZE {
            size := j * GRID_SIZE + i
            if i == START_POS[0] && j == START_POS[1] {
                grid[size] = 0
            } else if i == END_POS[0] && j == END_POS[1] {
                grid[size] = 0
            } else {
                random_value := rand.float32()
                
                if random_value < 0.2 {
                    grid[size] = 1
                } else {
                    grid[size] = 0
                }
            }
        }
    }
}

main :: proc() {

    generate_grid()  

    start := time.now()
    jps.jps_init(GRID_SIZE, GRID_SIZE, .manhatten)
    man := jps.jps(grid[:], START_POS, END_POS)
    duration := time.since(start)

    seconds := f64(duration) / f64(time.Second)
    fmt.printf("Manhatten execution time: %v\n", seconds)

    start = time.now()
    jps.jps_init(GRID_SIZE, GRID_SIZE, .euclidean)
    euc := jps.jps(grid[:], START_POS, END_POS)    
    
    duration = time.since(start)
    seconds = f64(duration) / f64(time.Second)
    fmt.printf("Euclidean execution time: %v\n", seconds)

    rl.InitWindow(GRID_SIZE * CELL_SIZE, GRID_SIZE * CELL_SIZE, "2D Grid")
    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)

        for i in 0..<GRID_SIZE {
            for j in 0..<GRID_SIZE {
                x := i32(i * CELL_SIZE)
                y := i32(j * CELL_SIZE)
                
                size := j * GRID_SIZE + i

                if grid[size] == 0 {
                    rl.DrawRectangle(x, y, CELL_SIZE, CELL_SIZE, rl.WHITE)
                } else {
                    rl.DrawRectangle(x, y, CELL_SIZE, CELL_SIZE, rl.LIGHTGRAY)
                }
                
                rl.DrawRectangleLines(x, y, CELL_SIZE, CELL_SIZE, rl.DARKGRAY)
            }
        }

        rl.DrawRectangle(i32(START_POS[0])*CELL_SIZE, i32(START_POS[1])*CELL_SIZE, CELL_SIZE, CELL_SIZE, rl.RED)
        rl.DrawRectangle(i32(END_POS[0])*CELL_SIZE, i32(END_POS[1])*CELL_SIZE, CELL_SIZE, CELL_SIZE, rl.GREEN)
    
        cent := CELL_SIZE/2

        for i in 0..<len(man)-1 {
            next := i + 1
            start := [2]f32{f32(man[i][0]*CELL_SIZE+cent), f32(man[i][1]*CELL_SIZE+cent)}
            end := [2]f32{f32(man[next][0]*CELL_SIZE+cent), f32(man[next][1]*CELL_SIZE+cent)}
            rl.DrawLineEx(start, end, 10, rl.PURPLE)
        }

        for i in 0..<len(euc)-1 {
            next := i + 1
            start := [2]f32{f32(euc[i][0]*CELL_SIZE+cent), f32(euc[i][1]*CELL_SIZE+cent)}
            end := [2]f32{f32(euc[next][0]*CELL_SIZE+cent), f32(euc[next][1]*CELL_SIZE+cent)}
            rl.DrawLineEx(start, end, 10, rl.BLUE)
        }


        rl.EndDrawing()
    }

    rl.CloseWindow()
}