# Messenger Module

This folder contains all the files required for the chat/messenger functionality in the TaskMate app.  
It enables real-time communication between employees and admins using Firestore as the backend.

---

## Files Overview

### 1. **chat_page.dart**
- Displays the 1-on-1 chat interface between two users.
- Features:
  - Shows messages in real-time from Firestore.
  - Differentiates between sender and receiver using message bubbles.
  - Supports sending text messages (and can be extended for file/image attachments).
  - Auto-scrolls to the latest message.

---

### 2. **inbox_page.dart**
- The main screen showing all recent conversations for the logged-in user.
- Features:
  - Lists all chat threads where the current user is a participant.
  - Displays last message preview and timestamp.
  - Allows quick access to individual chats by tapping on a conversation.
  - Updates in real-time as new messages arrive.

---

### 3. **user_list.dart**
- Shows a list of all available users for starting new conversations.
- Features:
  - Displays each user's name, role, and profile avatar.
  - Allows tapping on a user to initiate a new chat.
  - Prevents duplicate chat threads from being created.

---

## Usage Flow
1. **User opens Inbox** → sees all existing chats.  
2. **Selects a conversation** → navigates to `chat_page.dart`.  
3. **Wants to start new chat** → opens `user_list.dart`, picks a user, and begins messaging.

---

## Firestore Structure (Simplified)
