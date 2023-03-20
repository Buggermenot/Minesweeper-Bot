# Minesweeper-Bot
I created a bot to solve Minesweeper. This is how it works:
Details on how to recreate the error in the end. Do read before attempting.

## Flow Diagram:
![Flow diagram](https://i.stack.imgur.com/J95FK.png)

## Working:
![Working](https://i.stack.imgur.com/x81qu.gif)

## Known Error:
There is a synchornization issue when the program runs at higher framerates. (Do not understand why). Uploaded Stack Overflow question [here](https://stackoverflow.com/questions/75741577/code-malfunctions-in-processing-at-higher-framerates)

Working and Failed side by side. Both have the same logic and are working with the same seed. Only their framerates differ.

![Working](https://i.stack.imgur.com/x81qu.gif) ![Failed](https://i.stack.imgur.com/sE3CI.gif)

## How to recreate error:
 - The seed value is randomised every time the code is run. You can press 'r' to reset the program during its run.
 - The 2nd line in ```reset()``` asigns a random value to the seed every reset.
 - The framerate is limited by ```if(frameCount % n == 0)``` where n is the factor of reduction of framerate. Increasing n lowers framerate.
 - To recreate; set ```n = 1``` Run the run.pde file and let seed be randomly generated every step. Press 'r' to reset until you get a run that is sufficiently long. It will most likely fail.
 - Note the seed value and manually assign the same seed value in ```setup()``` and comment ```seed = int(random(10000));``` in ```reset()```.
 - Compare the difference by setting ```n = 1``` and ```n = 3```.
 - ***Point to notice***: The program logs each step into the terminal. (Can not necessarily make sense). It either takes a calculated step where it is guaranteed to right click a cell with bomb or left click a safe cell. Otherwise the log states "Guess Around". If the program fails on a guess it is okay and expected. However, if the program fails during a calculated step there is a problem. So while choosing a seed make sure that the program has failed on a calculated step.
 
 Please do let me know if you find the problem.
 
 Thank you.
 Buggermenot.
