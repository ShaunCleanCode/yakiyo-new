# Yakiyo Error & Issue Report

This document tracks major bugs, errors, and issues encountered during the development of Yakiyo, along with their solutions or workarounds. Use this as a reference for future debugging and team knowledge sharing.

---

## Table of Contents
1. [Evening Time Slot Not Showing on Card](#evening-time-slot-not-showing-on-card)
2. [Duplicate Schedule on Edit](#duplicate-schedule-on-edit)
3. [GitHub Push Permission Denied (403 Error)](#github-push-permission-denied-403-error)
4. [Device Status Provider/Test Issues](#device-status-providertest-issues)
5. [Intake Log/Calendar Widget Test Failures](#intake-logcalendar-widget-test-failures)

---

## 1. Evening Time Slot Not Showing on Card
**Description:**
- Medication scheduled for 21:24 or 21:30 was not displayed as "evening" on the card.
- The time slot boundary for "evening" was set to `< 21` instead of `< 24` in multiple places.

**Cause:**
- Inconsistent or incorrect time slot boundary logic in getTimeLabel and schedule conversion code.

**Solution:**
- Updated all relevant logic to use `hour >= 15 && hour < 24` for "evening".
- Fixed in: `lib/features/home/presentation/screens/home_screen.dart`, `lib/features/pill_schedule/domain/use_cases/get_pill_schedules.dart`, and others.
- Related commit: `feat: Improve evening time slot logic and prevent duplicate schedules`

---

## 2. Duplicate Schedule on Edit
**Description:**
- Editing a schedule sometimes resulted in a new schedule being added instead of updating the existing one.

**Cause:**
- addPillSchedule was called with an existing id, leading to duplicates in the mock repository.
- updatePillSchedule and addPillSchedule logic was not mutually exclusive.

**Solution:**
- Modified addPillSchedule in MockPillScheduleRepository to overwrite if id exists.
- Ensured update only is called on edit, and add only on new schedule.
- Added debug print logs to verify flow.
- Related commit: `feat: Improve evening time slot logic and prevent duplicate schedules`

---

## 3. GitHub Push Permission Denied (403 Error)
**Description:**
- `git push` failed with 403 error: Permission denied to techn-on.

**Cause:**
- Wrong GitHub account (techn-on) used, lacking push rights to ShaunCleanCode/yakiyo-new.

**Solution:**
- Cleared credential cache and switched to ShaunCleanCode account.
- Used Personal Access Token for authentication.
- Related steps: `git credential-cache exit`, `git remote set-url ...`, PAT setup.

---

## 4. Device Status Provider/Test Issues
**Description:**
- Linter errors and test failures due to missing or misconfigured device status provider.

**Cause:**
- deviceStatusProvider was not implemented or imported in some test files.

**Solution:**
- Created deviceStatusProvider and ensured correct overrides in tests.
- Commented out device status tests when not needed.
- Related commit: `test: Add/fix device status provider and test overrides`

---

## 5. Intake Log/Calendar Widget Test Failures
**Description:**
- Widget test for calendar failed to find expected date text (e.g., '2024.06.06').

**Cause:**
- Mock data did not match the expected format or provider overrides were missing.
- Model field names mismatched (e.g., IntakeLogModel vs PillIntakeLogModel).

**Solution:**
- Updated test to use correct model and field names.
- Provided necessary provider overrides and mock data.
- Related commit: `test: Fix intake log/calendar widget test with correct model and data`

---

## How to Use
- Add new issues as they are encountered.
- For each, include: title, description, cause, solution, and related commit/PR if possible. 