# Gym

A simple training system for a gym class.

### Specifications

There are multiple trainers experts in different areas and they are preparing the best
workouts based on their expertise. A workout consists of multiple exercises.

A trainer can train multiple trainees and in order to do that they have a list of exercises to
choose from. Based on them, they create multiple workouts for different needs. An
exercise can be part of multiple workouts and a workout consist of multiple exercises.

The trainer is selected by a trainee based on their area of expertise. The trainer can work
with multiple people while a trainee can choose to be trained by different trainers.

Based on their needs, a trainer assigns multiple workouts for a trainee and in order to
follow their progress, the trainer has access to their results and can check it for a certain
period. 

Each trainee wears a fitness bracelet that provides the medium value of pulse
after each exercise is finished.
Each trainer has access to a list of exercises that is common to everyone, we provide the
list as a CSV file.

### Modeling

Trainer
 - first_name
 - last_name
 - area of expertise eg. [yoga, fitness, strength]

Exercise
 - name
 - duration(seconds)

Workout
- name
- creator
- list of exercises
- total duration (computed based on exercises duration)
- state - can be draft or published
 
Trainee
- first name
- last name
- email

### Use cases (endpoints)

- As a trainer, you can:
1. create, update, delete or check a specific workout.
2. see all your trainees.
3. assign a workout for a trainee.
- As a trainee, you can:
1. choose a trainer based on your desired expertise 
2. overview all your workouts in a specific
   time period.
   
## Implementation Assumptions and Considerations

### Authentication and Authorization

In a ready for production application I would take into consideration authorization and authentication as well,
but since requirements didn't specify it and already looked like it's already gonna take
a considerable amount of time I decided to leave it out for now and use the modeling given above for the four entities.

I'm used to using devise so that would have been my option for authentication. 
That would have meant having a User model with multiple profiles and roles. 
All trainers and trainees would be users with two separate roles. 
For simple authorization we could just use enum roles, 
but if we would like to have trainers also be trainees at the same time we should probably consider Pundit.

### Testing
For testing I used minitest. RSpec was suggested but since I'm just more familiar with minitest
I decided to use that instead to save me some time this time.

The specifications suggests that each trainer has access to a list of exercises that is common to everyone
provided as a CSV file. I also skipped this part since it was not directly impacting the endpoints specified
and used the factory bot factories to generate them for testing purposes. Of course, if the goal was to see
how I can read out of a CSV file I could still implement that.

### Logging, Serializers, Caching
I set myself a limit of how much I can do within 8 hours
with a focus on data validation, error handling and testing.
That means some important production ready concerns are not included,
although can add them if you would like to evaluate that as well.

There is no logging which is really important for a production ready code.

Also, for production ready code I'd use serializers for controller action responses.

There is also no caching of controller actions, but at this stage with 0 users so far
would not be a main concern along with other optimizations that come with having a growing user base.

### Workout Assumptions

I assumed the creator of a workout is just a string representing the full name of the trainer.
This makes sense to me since, a trainer might leave the system and it would still be nice to give that person
credit if for whatever reason that workout survives them.

I made some assumptions regarding the way workouts are being published. They are created in a draft state.
On update they can be set to published, assuming the frontend would use that action to publish a workout.

### Trainer Assumptions

I also assumed that a trainer has only one expertise for now, also for time consideration.
More expertise tags can be added later.

### Trainee Assumptions

For the trainee endpoint action of choosing a trainer based on the desired expertise.
I found it to be unclear how that would work in one action. I'm thinking it requires two actions,
one to get all trainers with desired expertise and then a second action choosing one among those.

The specifications imply that the trainees are wearing a fitness bracelet that provides readings
after each exercise is finished. That would also have to be modeled through a ExerciseResult table
connecting an exercise of a specific workout assigned to the trainee through a results table. 
I have also skipped implementing this since there's no endpoint mentioned that would use this feature.





