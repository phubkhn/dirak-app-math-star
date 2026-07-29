# Component Inventory

Status: starter. Claude Code must maintain states and usage while building the prototype.

| Component | Required states |
|---|---|
| PrimaryButton | default, pressed, focused, disabled |
| IconButton | default, pressed, focused, muted/on where relevant |
| LevelNode | locked, current, available, completed 0–3 stars |
| StarCounter | 0, one digit, two digits, three digits |
| QuizProgress | question 1–10, answered/current/upcoming |
| AnswerField | empty, typing, correct, incorrect, revealed |
| NumericKeypad | enabled, temporarily locked, submit enabled/disabled |
| FeedbackBand | correct, first retry, answer revealed |
| ResultSummary | pass, retry |
| VolumeControl | music, effects, voice; 0–100% |
| ConfirmationModal | restart level, abandon quiz, reset progress |
| Toast/Announcement | unlocked, saved, data restored |
