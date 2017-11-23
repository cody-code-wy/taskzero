# Models

---

### User

- First_name
- Last_name
- Email
- password_digest

#### Relations

- Has Tasks
- Has Projects
- Has Contexts

### Task

- Name
- TimeStamps
- kind (enum {:normal, :appointment, :chore})
- description
- defered_date ( text )
- delegation ( text )
- complete
- project_id
- context_id
- user_id

#### Relations

- Belong to project
- Belong to Context
- Belong to User

#### Recurring

See (Schedulable)[https://github.com/benignware/schedulable]

### Project

- Name
- TimeStamps
- on_hold ( bool )
- kind (enum {:group, :linear})
- user_id

#### Relations

- Have Projects
- Have Tasks

### Context

- Name
- TimeStamps
- context_id (parrent)
- user_id

#### Relations

- Have Context (parrent)
- Belong to User
