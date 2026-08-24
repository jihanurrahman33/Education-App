# EduFlow — Design System & UI Specifications

EduFlow features a sleek, dark-themed UI with ambient gold accents, high contrast typography, and responsive layouts.

---

## 1. Color Palette Tokens (`AppColors`)

All color values are defined centrally in [`lib/core/constants/app_colors.dart`](file:///c:/Users/jihan/Documents/projects/education_app/lib/core/constants/app_colors.dart). Ad-hoc color hex codes in presentation widgets are strictly prohibited.

| Token | Hex Value | Description | Usage |
| :--- | :--- | :--- | :--- |
| `primary` | `#F59E0B` | Warm Amber / Gold | Primary brand accent, selected highlights, active icons |
| `onPrimary` | `#000000` | Pure Black | Text and icons on primary buttons |
| `secondary` | `#10B981` | Emerald Green | Completed states, success toasts, verified badges |
| `background` | `#121414` | Midnight Dark Canvas | Application-wide scaffold background |
| `surface` | `#1A1D1D` | Deep Slate Surface | Cards, dialogs, modals, bottom sheets |
| `surfaceDark` | `#0E1010` | Dark Charcoal | Certificate viewer, immersive player backgrounds |
| `surfaceContainerLow` | `#222626` | Elevated Slate | Unselected choice pills, lesson list tiles |
| `surfaceContainerHigh`| `#2C3131` | High Elevation Surface| Active search bars, input backgrounds |
| `textPrimary` | `#FFFFFF` | Crisp White | Headings, titles, high-emphasis text |
| `textSecondary` | `#94A3B8` | Slate Grey | Subtitles, body text, secondary labels |
| `textMuted` | `#64748B` | Muted Grey | Timestamps, placeholder text, locked states |
| `border` | `#2D3748` | Dark Slate Border | Card outlines, dividers, input borders |
| `error` | `#EF4444` | Crimson Red | Error views, destructive actions, failed badges |
| `roleStudent` | `#3B82F6` | Electric Blue | Student role badge |
| `roleTeacher` | `#8B5CF6` | Royal Violet | Teacher role badge, course builder actions |
| `roleAdmin` | `#EF4444` | Crimson Red | Admin role badge, moderation hub |

---

## 2. Typography & Fonts

EduFlow uses **Outfit** / **Inter** from `google_fonts` configured in [`lib/core/constants/app_theme.dart`](file:///c:/Users/jihan/Documents/projects/education_app/lib/core/constants/app_theme.dart):
- **Display / Headers (18px - 24px):** Bold (`FontWeight.w700` / `FontWeight.w800`), `AppColors.textPrimary`.
- **Subheadings (14px - 16px):** Semi-bold (`FontWeight.w600`), `AppColors.textPrimary`.
- **Body Text (13px - 14px):** Regular (`FontWeight.w400` / `FontWeight.w500`), `AppColors.textSecondary`, height 1.4 - 1.6.
- **Badges & Overlines (10px - 12px):** Extra-bold (`FontWeight.w800`), letter-spacing 0.5px.

---

## 3. Global Reusable Custom Widgets

All cross-feature reusable widgets reside in [`lib/core/widgets/`](file:///c:/Users/jihan/Documents/projects/education_app/lib/core/widgets/):

1. **`CustomButton`:** Primary, outlined, and text button with built-in loading indicator (`isLoading: true`).
2. **`CustomTextField`:** Form input with label, hint, prefix icon, password toggle, and validation error styling.
3. **`ConfirmationDialog`:** Modal dialog for destructive or critical state changes (Delete, Publish, Logout, Submit Quiz).
4. **`ErrorView`:** Error display with custom retry callback (`onRetry`).
5. **`EmptyStateWidget`:** Visual empty state card with icon, title, description, and action button.
6. **`LoadingSkeletonCard` & `LoadingView`:** Shimmer and animated loading indicators.

---

## 4. Responsiveness & Accessibility

- **Max Width Constraints:** Content views are centered and constrained using `ConstrainedBox(maxWidth: 800 - 900)` to ensure optimal layout on tablets, desktop, and web viewports.
- **Touch Targets:** All interactive icons and buttons meet the minimum 48x48 dp accessibility standard.
- **High Contrast:** All card surfaces, list tiles, and quiz choices maintain minimum WCAG AA contrast against their text contents.
