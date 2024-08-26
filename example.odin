package main

import "core:fmt"
import "core:time"
import "core:math/rand"
import jps "jps"
import rl "vendor:raylib"



GRID_SIZE :: 25
CELL_SIZE :: 50


grid := [GRID_SIZE*GRID_SIZE]int{}

generate_grid :: proc() {
    for i in 0..<GRID_SIZE {
        for j in 0..<GRID_SIZE {
            size := j * GRID_SIZE + i
            if i == 1 && j == 1 {
                grid[size] = 0
            } else if i == 23 && j == 23 {
                grid[size] = 0
            } else {
                // Generate a random number between 0 and 1
                random_value := rand.float32()
                
                // Set the cell to 1 with a 20% probability, otherwise 0
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

    start_pos := [2]int{1,1}
    end_pos := [2]int{23,23}

    generate_grid()  

    start := time.now()
    man := jps.jps(grid[:], start_pos, end_pos, true)
    duration := time.since(start)

    seconds := f64(duration) / f64(time.Second)
    fmt.printf("Manhatten execution time: %v\n", seconds)

    start = time.now()
    euc := jps.jps(grid[:], start_pos, end_pos, false)    
    
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

        rl.DrawRectangle(i32(start_pos[0])*CELL_SIZE, i32(start_pos[1])*CELL_SIZE, CELL_SIZE, CELL_SIZE, rl.RED)
        rl.DrawRectangle(i32(end_pos[0])*CELL_SIZE, i32(end_pos[1])*CELL_SIZE, CELL_SIZE, CELL_SIZE, rl.GREEN)

        for i in 0..<len(man)-1 {
            next := i + 1
            start := [2]f32{f32(man[i][0]*CELL_SIZE+25), f32(man[i][1]*CELL_SIZE+25)}
            end := [2]f32{f32(man[next][0]*CELL_SIZE+25), f32(man[next][1]*CELL_SIZE+25)}
            rl.DrawLineEx(start, end, 10, rl.PURPLE)
        }

        for i in 0..<len(euc)-1 {
            next := i + 1
            start := [2]f32{f32(euc[i][0]*CELL_SIZE+25), f32(euc[i][1]*CELL_SIZE+25)}
            end := [2]f32{f32(euc[next][0]*CELL_SIZE+25), f32(euc[next][1]*CELL_SIZE+25)}
            rl.DrawLineEx(start, end, 10, rl.BLUE)
        }


        rl.EndDrawing()
    }

    rl.CloseWindow()
}