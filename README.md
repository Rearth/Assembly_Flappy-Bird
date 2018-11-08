# Assembly_Flappy-Bird
Flappy Bird on the MCU 8051 using an 8x8 led matrix and 2 buttons. Part of a Project for the DHBW.

##Intro 1
##Pinout 1.1
- Interrupt Ports:
    - 3.2
    - 3.3
- Matrix X:
    - P0 B0-7
- Matrix Y:
    - P1 B0-7

Example Table:
|   |   | x |   |   |   |   | x |
|   |   | x |   |   |   |   | x |
|   |   | x |   |   | x |   |   |
| x |   |   |   |   | x |   |   |
|   |   |   |   |   | x |   |   |
|   |   |   |   |   | x |   |   |
|   |   |   |   |   | x |   |   |
|   |   |   |   |   | x |   |   |

In the first column is the bird, which can move up and down
In the other columns are the "pillars" which move towards the bird
