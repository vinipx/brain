---
type: guide
tags: [guide, use-cases]
---

# Use Cases

Real-world scenarios for using this vault.

## Scenario 1: Tracking a University Semester

You're enrolled in four courses this semester and need to stay organized.

```
1. /new-course Calculus II
   --> Creates courses/calculus-ii.md with module tracking
   --> Updates Courses MOC

2. /new-course Organic Chemistry
   /new-course Data Structures
   /new-course World History
   --> Repeat for each course

3. /new-study Integral Techniques
   --> Deep-dive study notes linked to [[Calculus II]]

4. /daily --> Log study sessions, homework deadlines, exam prep
   /weekly-review --> Track progress across all courses
```

## Scenario 2: Starting a Fitness Routine

You want to begin a structured exercise program and track progress.

```
1. /new-hobby Running
   --> Creates hobbies/running.md with goals and progress tracking

2. /log-health Ran 2 miles, felt good
   --> Appends to daily note under Health
   --> Links to [[Running]] hobby

3. (Daily)
   /log-health --> Track workouts, sleep, nutrition
   /daily --> Note how you feel, energy levels

4. /weekly-review --> See exercise frequency, mood patterns
   /drift --> Discover if fitness is connecting to other life areas
```

## Scenario 3: Managing a Household Budget

You want to track spending and save toward a goal.

```
1. /new-finance Monthly Budget March
   --> Creates finances/monthly-budget-march.md with category breakdown

2. /new-finance Emergency Fund Goal
   --> Creates a savings goal with target amount and timeline

3. (Throughout the month)
   /new-finance Grocery Run March 15
   --> Log individual expenses linked to budget categories

4. /weekly-review --> See spending patterns
   /vault-status --> Check budget vs. actual
```

## Scenario 4: Picking Up a New Hobby

You've decided to learn watercolor painting.

```
1. /new-hobby Watercolor Painting
   --> Creates hobbies/watercolor-painting.md
   --> Asks for skill level, goals, resources

2. /new-course Watercolor Fundamentals on Skillshare
   --> Track structured lessons linked to [[Watercolor Painting]]

3. /daily --> Log practice sessions, techniques tried, progress photos
   /log-health --> Note how creative time affects mood

4. /emerge --> See if watercolor connects to other interests
```

## Scenario 5: Planning Family Events

Organizing a family reunion and tracking milestones.

```
1. /new-family-event Annual Family Reunion 2026
   --> Creates family/annual-family-reunion-2026.md
   --> Creates people/ notes for family members

2. /daily --> Track planning tasks: venue, food, invitations
   "Add a task: Confirm venue by April 15"

3. /new-family-event Grandma's 80th Birthday
   --> Separate event linked to [[Annual Family Reunion 2026]]

4. /vault-status --> Check open tasks for all events
```

## Scenario 6: Tracking Online Courses

You're taking several MOOCs simultaneously across different platforms.

```
1. /new-course Machine Learning on Coursera
   --> Creates courses/machine-learning-on-coursera.md
   --> Tracks modules, assignments, deadlines

2. /new-course Spanish A1 on Duolingo
   --> Different format, same tracking structure

3. /daily --> Log study time per course
   "Completed Module 3 of [[Machine Learning on Coursera]]"

4. /weekly-review --> See total study hours, completion rates
   /schedule --> Balance course time across the week
```

## Scenario 7: Building Study Habits

You want to establish a consistent study routine.

```
1. /new-study Deep Work Practice
   --> Creates studies/deep-work-practice.md
   --> Track daily focus sessions

2. /log-health --> Note sleep quality and energy (affects focus)
   /daily --> Log study blocks, distractions, achievements

3. /trace deep focus
   --> See how your relationship with focused work evolved

4. /drift --> Discover patterns in when you study best
   /challenge my study approach --> Pressure-test your methods
```

## Scenario 8: Health Appointment Tracking

Managing ongoing health care and appointments.

```
1. /log-health Annual checkup scheduled for April 10
   --> Creates health tracking entry

2. /daily --> Note symptoms, medications, questions for doctor
   /log-health --> Track blood pressure, weight, or other metrics over time

3. "Show me all health entries from the last 3 months"
   --> Claude aggregates data for your appointment

4. /log-health Checkup results: all clear, vitamin D low
   --> Record outcomes and action items
```

## Scenario 9: Personal Project Management

You're renovating your kitchen on weekends.

```
1. /new-personal-project Kitchen Renovation
   --> Creates projects/kitchen-renovation.md
   --> Asks for timeline, budget, phases

2. /new-finance Kitchen Renovation Budget
   --> Track spending linked to [[Kitchen Renovation]]

3. /daily --> Log weekend progress, decisions, contractor notes
   "Add task: Order countertop samples by Friday"

4. /weekly-review --> Track progress across weeks
   /vault-status --> See open tasks and timeline
```

## Scenario 10: Financial Goal Tracking

Saving for a specific goal like a vacation or down payment.

```
1. /new-finance Down Payment Savings Goal
   --> Creates finances/down-payment-savings-goal.md
   --> Sets target amount, monthly contribution, timeline

2. /new-finance Monthly Savings March
   --> Track actual contributions

3. /weekly-review --> Check savings rate
   /trace down payment --> See how the goal evolved over time

4. /challenge my financial plan
   --> Pressure-test assumptions about timeline and spending
```

## Scenario 11: Learning a Musical Instrument

You're teaching yourself guitar.

```
1. /new-hobby Guitar
   --> Creates hobbies/guitar.md with skill tracking

2. /new-course Justin Guitar Beginner Course
   --> Track structured lessons

3. /daily --> Log practice sessions: "Practiced chord transitions 20 min"
   /log-health --> Note hand strain or fatigue

4. /drift --> See if music connects to other interests
   /graduate --> Promote "write a song" from daily note idea to project
```

## Scenario 12: Meal Planning and Nutrition

Tracking what you eat and planning meals.

```
1. /new-study Nutrition Basics
   --> Research notes on macros, meal timing, recipes

2. /log-health Breakfast: oatmeal with berries, 400 cal
   --> Track daily nutrition in health logs

3. /new-finance Grocery Budget
   --> Link food spending to nutrition goals

4. /weekly-review --> See nutrition patterns, spending on food
   /connect nutrition and energy --> Find correlations
```

## Scenario 13: Reading List and Book Notes

Tracking books you read and capturing insights.

```
1. /new-study Atomic Habits by James Clear
   --> Creates studies/atomic-habits.md with chapter notes

2. /daily --> Log reading sessions: "Read chapters 5-6, key insight on habit stacking"

3. /graduate --> Promote book insights into actionable project notes
   /ideas --> Generate ideas inspired by recent reading

4. /trace habit formation --> See how the concept appears across your vault
```

## Scenario 14: Mental Health and Journaling

Using the vault as a structured journaling practice.

```
1. /daily --> Write morning reflections, gratitude, intentions
   /log-health Mood: 7/10, slept well, feeling motivated

2. /closeday --> End-of-day reflection on what went well and what didn't

3. /drift --> Surface emotional patterns you might not notice
   /ghost What makes me happiest? --> Reflect based on your own writing

4. /weekly-review --> See mood trends, gratitude patterns, growth areas
```

## Scenario 15: Travel Planning

Organizing an upcoming trip.

```
1. /new-personal-project Japan Trip October 2026
   --> Creates projects/japan-trip-october-2026.md
   --> Tracks itinerary, bookings, packing list

2. /new-finance Japan Trip Budget
   --> Track flights, hotels, activities spending

3. /new-study Japanese Basics
   --> Study language fundamentals before the trip

4. /daily --> Research and plan day-by-day itinerary
   /vault-status --> Check all open tasks before departure
```

## Scenario 16: Pet Care Tracking

Managing veterinary care and routines for a pet.

```
1. /log-health Buddy: annual vet visit, vaccines up to date
   --> Track pet health alongside personal health

2. /new-finance Pet Care Budget
   --> Track vet bills, food, supplies

3. /daily --> Note feeding schedule changes, behavior observations
   /new-family-event Adopted Buddy --> Record the milestone

4. /trace Buddy --> See all pet-related entries over time
```

## Scenario 17: Home Maintenance Schedule

Tracking recurring home maintenance tasks.

```
1. /new-personal-project Home Maintenance 2026
   --> Creates projects/home-maintenance-2026.md
   --> Track seasonal tasks: HVAC, gutters, plumbing

2. /daily --> Log completed maintenance, issues found
   /new-finance Home Repairs --> Track spending

3. /schedule --> Plan maintenance into weekly schedule
   /vault-status --> See overdue maintenance tasks

4. /weekly-review --> Track what got done vs. planned
```

## Scenario 18: Volunteering and Community Involvement

Tracking volunteer work and community activities.

```
1. /new-personal-project Food Bank Volunteering
   --> Track shifts, hours, contacts

2. /new-family-event Community Cleanup Day
   --> Record events and participation

3. /daily --> Log volunteer hours and experiences
   "Add task: Sign up for Saturday shift"

4. /connect volunteering and wellbeing
   --> Discover how community work affects your life
```

## Scenario 19: Career Development (Personal Side)

Personal career planning and skill development.

```
1. /new-study Interview Preparation
   --> Track practice problems, mock interviews

2. /new-course AWS Solutions Architect Certification
   --> Track certification progress

3. /ghost What kind of role do I really want?
   --> Reflect based on your own writing patterns

4. /challenge my career direction
   --> Pressure-test your career assumptions
   /ideas --> Generate career-related ideas from vault patterns
```

## Scenario 20: Habit Tracking and Personal Goals

Setting and tracking New Year's resolutions or quarterly goals.

```
1. /new-personal-project Q2 2026 Goals
   --> Track 3-5 goals with measurable outcomes

2. /log-health --> Daily habit check-ins (exercise, meditation, reading)
   /daily --> Note progress, obstacles, adjustments

3. /weekly-review --> See habit streaks and completion rates
   /drift --> Surface which goals you naturally gravitate toward

4. /emerge --> Find goal clusters that reinforce each other
   /trace meditation --> See how a specific habit evolved
```
