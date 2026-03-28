---
type: guide
tags: [guide, use-cases]
---

# Use Cases

Real-world scenarios for using this combined vault to manage both professional and personal life.

## Scenario 1: Balancing a Product Launch with Family Commitments

A major release is coming up the same week as your kid's school play.

```
1. /new-project Product Launch v2.0
   --> Creates projects/product-launch-v2.md with timeline

2. /new-family-event School Play Friday
   --> Creates family/school-play-friday.md
   --> Blocks Friday evening

3. /schedule
   --> Builds a week plan that protects Friday evening
   --> Suggests front-loading launch tasks Mon-Thu

4. /today --> Each morning, see both work deadlines and family prep tasks
   /closeday --> Track progress on both fronts
```

## Scenario 2: Using a Work Certification to Advance Your Career

Studying for a professional certification while managing active projects.

```
1. /new-course AWS Solutions Architect
   --> Creates courses/aws-solutions-architect.md

2. /new-project Cloud Migration
   --> Work project that directly benefits from certification study

3. /connect AWS certification and cloud migration
   --> Surfaces how study topics apply to your real project

4. /schedule --> Balance study blocks with project deadlines
   /weekly-review --> Track both certification progress and project milestones
```

## Scenario 3: Client Dinner Meets Personal Networking

A commercial engagement leads to a dinner where you meet someone interesting.

```
1. /new-commercial Globex Partnership
   --> Creates commercials/globex-partnership.md

2. /add-meeting Globex Dinner
   --> Records attendees, discussion, next steps
   --> Creates people/ notes for new contacts

3. One contact shares a hobby interest:
   /new-hobby Rock Climbing
   --> Links to [[John Smith]] from the dinner

4. /ideas --> Surfaces connections between new contacts and personal interests
```

## Scenario 4: Health Affecting Work Performance

Tracking how fitness and sleep correlate with productivity.

```
1. /log-health Slept 5 hours, stressed about deadline
   --> Health log linked to today's daily note

2. /daily --> Note that morning standup was rough, low energy
   /add-meeting Sprint Planning --> Record that you deferred two tasks

3. /drift --> Over weeks, surfaces pattern: poor sleep correlates with task deferrals

4. /challenge my work schedule
   --> Finds contradiction: you say health is a priority but schedule doesn't reflect it
   /schedule --> Builds a plan with sleep-friendly work hours
```

## Scenario 5: Side Project Becoming a Business

A personal hobby project starts showing commercial potential.

```
1. /new-hobby Woodworking
   --> Track craft sessions and creations

2. /new-personal-project Custom Furniture Etsy Shop
   --> Evolves from hobby to project

3. /new-commercial First Custom Order
   --> A friend wants to pay for a piece
   --> Links to [[Woodworking]] and [[Custom Furniture Etsy Shop]]

4. /link-coding etsy-inventory-tracker
   --> Build a simple tool, reference it in the vault

5. /emerge --> Spots the cluster: hobby + project + commercial + code
   --> Suggests formalizing as a business
```

## Scenario 6: Onboarding at a New Job While Settling Into a New City

Starting fresh on both fronts simultaneously.

```
1. Work onboarding:
   /new-project Onboarding at NewCo
   /link-coding main-service
   /add-meeting Team Introduction

2. Personal settling:
   /new-personal-project Apartment Setup
   /new-finance Moving Expenses Budget
   /new-family-event Housewarming Party

3. /today --> Balanced priorities: work ramp-up + apartment tasks
   /weekly-review --> Track progress on both transitions

4. /context --> Give Claude full picture when asking for advice
```

## Scenario 7: Preparing for a Performance Review

Gathering evidence from both work achievements and professional development.

```
1. "Show me all completed projects from Q1"
   --> Claude lists work projects with outcomes

2. "What courses and certifications did I complete?"
   --> Study and course notes with completion dates

3. /trace leadership
   --> See how your leadership involvement evolved

4. /ghost What are my biggest achievements this quarter?
   --> Claude drafts a self-assessment from your own notes
   --> Includes both project wins and skills developed
```

## Scenario 8: Managing Finances Across Work and Personal

Tracking a work reimbursement alongside personal budgeting.

```
1. /new-finance Conference Travel Expenses
   --> Work expense tracking for reimbursement

2. /new-finance Monthly Personal Budget April
   --> Personal budget including the trip's personal spending

3. /add-meeting Team Offsite Planning
   --> Meeting notes reference conference logistics

4. /weekly-review --> See spending across both categories
   /vault-status --> Check which expenses need reimbursement
```

## Scenario 9: Mentoring a Junior Developer While Teaching Your Kids to Code

Teaching at work and at home.

```
1. /add-meeting Mentoring Session with Alex
   --> Track mentoring topics, code reviews, growth areas

2. /new-study Teaching Kids Python
   --> Personal study notes on pedagogy for children

3. /connect mentoring and teaching kids
   --> Discover that explaining concepts simply helps at both levels

4. /ideas --> Generate teaching resources that work for both audiences
   /ghost How do I explain recursion? --> Based on your teaching notes
```

## Scenario 10: Conference Trip Combining Work and Personal Travel

Attending a work conference in a city you want to explore.

```
1. /new-project DevConf 2026 Presentation
   --> Track talk preparation, slides, demo

2. /new-personal-project Barcelona Vacation Extension
   --> Plan personal days after the conference

3. /new-finance Conference Plus Vacation Budget
   --> Split expenses: work-reimbursable vs. personal

4. /daily --> Log conference talks, networking, sightseeing
   /add-meeting Hallway Chat with CTO of StartupX
   --> Capture unexpected networking moments
```

## Scenario 11: Seasonal Planning -- Q2 Goals

Setting quarterly goals that span work and personal life.

```
1. /new-project Q2 OKRs
   --> Work objectives and key results

2. /new-personal-project Q2 Personal Goals
   --> Health, learning, family goals

3. /schedule --> Build a weekly template balancing all goals
   /today --> Daily alignment check

4. /weekly-review --> Track both sets of goals
   /challenge my Q2 priorities --> Ensure goals are realistic together
```

## Scenario 12: Building a Morning Routine Around Work Schedule

Designing a routine that supports both productivity and wellness.

```
1. /log-health --> Track wake time, exercise, breakfast quality
   /daily --> Note work start time and first-hour productivity

2. /new-study Morning Routine Optimization
   --> Research on circadian rhythms, deep work scheduling

3. /drift --> After 30 days, surface which routine elements stuck
   /trace morning routine --> See the evolution of your experiments

4. /schedule --> Build a schedule with protected morning blocks
   /connect sleep quality and meeting performance --> Find correlations
```

## Scenario 13: Codebase Exploration Informing Personal Projects

Skills from work feeding into personal technical projects.

```
1. /link-coding work-api-service
   --> Reference work codebase patterns

2. /new-hobby Home Automation
   --> Personal project using similar tech stack

3. /link-coding home-assistant-config
   --> Reference personal repo

4. /connect work API patterns and home automation
   --> Discover reusable patterns
   /ideas --> Generate project ideas that bridge work skills and personal interests
```

## Scenario 14: Managing a Chronic Health Condition While Working

Tracking treatments and their impact on work capacity.

```
1. /log-health --> Daily symptom tracking, medication log
   /daily --> Note energy levels and work capacity

2. /add-meeting Neurology Follow-up
   --> Track in both meetings/ and health/

3. /trace migraines --> See frequency patterns over months
   /connect migraines and meeting load --> Discover triggers

4. /schedule --> Plan demanding work for high-energy days
   /weekly-review --> Correlate health data with productivity
```

## Scenario 15: Learning a Language for Both Work and Travel

Studying Spanish for a client engagement and a vacation.

```
1. /new-course Spanish B1 on italki
   --> Track lessons and homework

2. /new-commercial LatAm Market Expansion
   --> Client engagement where Spanish helps

3. /new-personal-project Costa Rica Trip
   --> Vacation where you'll use Spanish

4. /connect Spanish and client communication
   --> See how language study supports work
   /weekly-review --> Track study hours and fluency milestones
```

## Scenario 16: Burnout Prevention Through Pattern Recognition

Using vault data to catch early warning signs.

```
1. /log-health --> Daily mood, energy, stress ratings
   /daily --> Note overtime hours, skipped meals, cancelled plans

2. /drift --> Surfaces "exhaustion" or "overwhelm" appearing across contexts
   /trace burnout --> See if warning signs are escalating

3. /challenge my current workload
   --> Forces honest assessment of sustainability

4. /schedule --> Rebuild schedule with recovery time
   /new-hobby --> Deliberately add non-work activities
```

## Scenario 17: Wedding Planning While Managing Work Projects

A major personal event requiring months of coordination.

```
1. /new-personal-project Wedding Planning
   --> Master project with timeline and checklist

2. /new-finance Wedding Budget
   --> Track vendors, deposits, payments

3. /new-family-event Engagement Party
   /new-family-event Rehearsal Dinner
   --> Individual events linked to main project

4. /schedule --> Protect wedding task time in work weeks
   /vault-status --> See both work deadlines and wedding milestones
   /weekly-review --> Track progress on all fronts
```

## Scenario 18: Open Source Contribution Bridging Work and Personal Growth

Contributing to a project used at work and growing your reputation.

```
1. /link-coding oss-framework
   --> Reference the open source project

2. /new-project OSS Contribution Sprint
   --> Work project to upstream internal improvements

3. /new-study Framework Internals
   --> Deep learning that benefits both work and community

4. /add-meeting Maintainer Call
   --> Track decisions with open source community
   /ideas --> Generate contribution ideas from work pain points
```

## Scenario 19: Relocating for Work While Managing Personal Transition

International transfer requiring coordination across all life areas.

```
1. Work:
   /new-project London Office Transfer
   /new-commercial UK Client Onboarding
   /add-meeting HR Relocation Planning

2. Personal:
   /new-personal-project London Apartment Search
   /new-finance Relocation Budget
   /new-study UK Driving License
   /new-family-event Farewell Dinner

3. /context --> Give Claude the full picture for any decision
   /today --> Manage parallel work and personal relocation tasks
   /challenge my relocation timeline --> Pressure-test feasibility
```

## Scenario 20: Year in Review -- Professional and Personal

Creating a comprehensive annual reflection.

```
1. "Summarize all weekly reviews from this year"
   --> Claude aggregates work and personal accomplishments

2. "List all projects completed, courses finished, and goals achieved"
   --> Structured review across all domains

3. /trace work-life balance --> See how the theme evolved over 12 months
   /drift --> Surface the year's dominant themes

4. /ghost What defined my year?
   --> Claude drafts a reflection in your voice
   /emerge --> Identify seeds planted this year that could bloom next year
```
