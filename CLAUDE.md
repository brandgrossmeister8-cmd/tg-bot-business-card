# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Telegram bot business card for Margarita Osmaeva, a marketing expert. The bot provides information about services, collects leads through an interactive quiz, and handles booking requests for consultations.

## Running the Bot

```bash
# Install dependencies
npm install

# Run in production
npm start

# Run in development (with auto-reload)
npm run dev
```

## Environment Configuration

The bot requires a [.env](.env) file with:
- `TELEGRAM_BOT_TOKEN` - Get from @BotFather in Telegram
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_KEY` - Supabase anonymous key

See [.env.example](.env.example) for template.

## Architecture

### Single-File Structure

The entire bot logic is in [bot.js](bot.js) (~929 lines). This is intentional for simplicity and is appropriate for a business card bot.

### State Management

The bot uses **in-memory state** for temporary data:
- `quizAnswers` object tracks quiz progress and booking flow per user
- `greetedUsers` Set prevents duplicate welcome messages

**Important**: In-memory state is lost on restart. Long-term data is persisted to Supabase.

### Database Schema

Three main tables in Supabase (see [supabase_schema.sql](supabase_schema.sql)):

1. **users** - Telegram user info (id, first_name, username, timestamps)
2. **quiz_results** - Quiz answers (user_id, question_1, question_2, question_3)
3. **booking_requests** - Lead capture (user_id, name, phone, quiz_result_id, status)

### User Flow States

The bot tracks user state in `quizAnswers[chatId]`:

```javascript
{
  answers: [],           // Quiz responses (q1_a, q2_b, etc.)
  step: 0,              // Current quiz question (0-2)
  stage: 'waiting_name', // Booking flow stage
  name: 'John',
  phone: '+7 (XXX) XXX-XX-XX',
  quizResultId: 'uuid',
  username: 'telegram_username'
}
```

**Stages**: `'waiting_name'` → `'waiting_phone'` → confirmation

### Message Handling Logic

The [bot.js](bot.js) message handler has layered conditions:

1. Ignores messages without text
2. Auto-greets new users (before first /start)
3. Skips command messages (handled by `bot.onText()`)
4. **Blocks menu buttons during quiz/booking flow** to prevent state confusion
5. Processes booking flow inputs (name, phone)
6. Falls back to menu button handlers or general responses

This prevents users from triggering menu actions mid-quiz.

### Phone Number Handling

- `formatPhoneNumber()` - Normalizes to `+7 (XXX) XXX-XX-XX` format
- `isValidPhoneNumber()` - Validates 11-digit Russian numbers (7XXXXXXXXXX or 8XXXXXXXXXX)
- Accepts both text input and contact button sharing

## Bot Commands

- `/start` - Welcome message with photo, prompts user to type "СТАРТ"
- `/about` - Expert bio and experience
- `/programs` - Six service offerings with descriptions
- `/contact` - Contact information (email, VK link)
- `/quiz` - Three-question quiz with inline keyboard buttons

## Inline Keyboards

Callback query data patterns:
- `q1_a`, `q1_b`, `q1_c` - Quiz question 1 answers
- `q2_a`, `q2_b`, `q2_c` - Quiz question 2 answers
- `q3_a`, `q3_b`, `q3_c` - Quiz question 3 answers
- `book_diagnostic` - Starts booking flow
- `back_to_menu` - Returns to main menu

## Database Functions

Located in [bot.js](bot.js:65-145):

- `saveUser(userId, firstName, username)` - Upserts user on interaction
- `saveQuizResult(userId, answers)` - Stores quiz responses, returns UUID
- `saveBookingRequest(userId, name, phone, quizResultId)` - Creates lead with status 'новая'

All functions handle errors gracefully and log to console.

## Images

Bot uses images from [./images/](./images/) directory:
- `photo_5440443823147844586_y.jpg` - /start greeting photo
- `foto5.png` - "СТАРТ" response photo

Images are sent via `bot.sendPhoto()` with text captions. Falls back to text-only if image fails to load.

## Russian Language

All user-facing text is in Russian. Keep this consistent when modifying messages or adding features.

## Modifying the Bot

### Adding New Commands

1. Add `bot.onText(/\/newcommand/, (msg) => {...})` handler
2. Update welcome/menu messages to reference new command
3. Optionally add to `getMainMenuKeyboard()` button array

### Adding Quiz Questions

1. Update `sendQuizQuestion()` questions array
2. Adjust `if (currentStep < 3)` condition to new total
3. Add new question field to quiz_results table schema
4. Update `saveQuizResult()` to include new answer

### Modifying Database

1. Update corresponding SQL in [supabase_schema.sql](supabase_schema.sql)
2. Run updated SQL in Supabase SQL Editor
3. Update database function in [bot.js](bot.js) (saveUser, saveQuizResult, saveBookingRequest)

## Deployment Notes

The bot uses long polling (`polling: true`), not webhooks. This works well for low-traffic bots but requires the process to stay running. Consider:

- PM2 for process management: `pm2 start bot.js --name marketing-bot`
- Docker container with restart policy
- systemd service on Linux servers

The bot logs key events to console (user saves, quiz completions, booking requests). Redirect stdout for persistent logs.
