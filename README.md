# README #

A fully-functional standalone Xcode project written in Swift. Run the code in the Simulator to verify the result, test using our own input files. The solution accommodates any number of workouts, exercises, and sets/reps/weight.

See [project worksheet](https://docs.google.com/document/d/1RButyoizIcClYc-ngLZYFI84cQw1B2Tjf3U8D7O1-78/edit) for details.

### Issues ###

I wasn't sure how to get daily one rep max for single-day workouts, or how to get overall one rep max from the entire data set. I computed the mean of all single-set values, and mean of all daily values, respectively.

### How do I get set up? ###

Existing workoutData.txt is included in Data folder. To input other data, drag text file to the project navigation bar to include it in the build. Modify the workoutDataFileName string to point to it on line 11 of the ExerciseManager (located in the tools folder).

### Who do I talk to? ###

alexandre.laurin@snacktimedevelopment.com