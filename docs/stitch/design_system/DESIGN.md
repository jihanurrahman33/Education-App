---
name: Academic Modernist
colors:
  surface: '#f9f9ff'
  surface-dim: '#d3daea'
  surface-bright: '#f9f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f0f3ff'
  surface-container: '#e7eefe'
  surface-container-high: '#e2e8f8'
  surface-container-highest: '#dce2f3'
  on-surface: '#151c27'
  on-surface-variant: '#434654'
  inverse-surface: '#2a313d'
  inverse-on-surface: '#ebf1ff'
  outline: '#737686'
  outline-variant: '#c3c5d7'
  surface-tint: '#1353d8'
  primary: '#003fb1'
  on-primary: '#ffffff'
  primary-container: '#1a56db'
  on-primary-container: '#d4dcff'
  inverse-primary: '#b5c4ff'
  secondary: '#006c4a'
  on-secondary: '#ffffff'
  secondary-container: '#82f5c1'
  on-secondary-container: '#00714e'
  tertiary: '#694100'
  on-tertiary: '#ffffff'
  tertiary-container: '#895600'
  on-tertiary-container: '#ffd6a8'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dbe1ff'
  primary-fixed-dim: '#b5c4ff'
  on-primary-fixed: '#00174d'
  on-primary-fixed-variant: '#003dab'
  secondary-fixed: '#85f8c4'
  secondary-fixed-dim: '#68dba9'
  on-secondary-fixed: '#002114'
  on-secondary-fixed-variant: '#005137'
  tertiary-fixed: '#ffddb8'
  tertiary-fixed-dim: '#ffb95f'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#f9f9ff'
  on-background: '#151c27'
  surface-variant: '#dce2f3'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  container-padding-mobile: 16px
  container-padding-desktop: 32px
  gutter: 24px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 32px
---

## Brand & Style

The design system is built on a foundation of **Modern Corporate** aesthetics, blending institutional reliability with contemporary EdTech fluidity. The brand personality is authoritative yet encouraging, designed to foster a focused learning environment that feels both high-stakes and highly achievable.

The visual style prioritizes **Minimalism** and **Structured Clarity**. By utilizing ample whitespace and a rigorous grid, the interface reduces cognitive load, allowing educational content to remain the primary focus. Subtle use of soft shadows and generous radius values prevents the UI from feeling overly rigid or intimidating, maintaining an approachable "academic mentor" vibe.

## Colors

The palette is strategically weighted to drive focus and reward progress:

- **Primary (Deep Academic Blue):** Used for core navigation, primary actions, and branding. It signals stability and formal education.
- **Secondary (Success Green):** Reserved exclusively for positive reinforcement—completion states, passing grades, and progress bars.
- **Accent (Bright Orange):** A high-visibility color used sparingly for "active" learning moments, notifications, and time-sensitive reminders.
- **Neutral/Surface:** A range of soft grays starting from `#F9FAFB` for backgrounds to provide a canvas that reduces eye strain during long study sessions. Text utilizes high-contrast dark grays rather than pure black to maintain readability without harshness.

## Typography

This design system uses **Inter** for its exceptional legibility and systematic weight distribution. 

- **Headlines:** Use Bold (700) and SemiBold (600) weights with slight negative letter-spacing to create a compact, authoritative look for course titles and module headers.
- **Body:** Standardized at 16px (Medium) and 18px (Large) for lesson content to ensure accessibility across all age groups. 
- **Labels:** Utilized for metadata (e.g., "15 mins left", "Level 2"). These often use a slightly heavier weight (500-600) at smaller sizes to maintain clarity.
- **Mobile Scaling:** Headline sizes automatically downscale on mobile devices to prevent excessive line-wrapping in tight dashboard views.

## Layout & Spacing

The system follows an **8px linear scale** to ensure mathematical harmony across all components.

- **Grid:** A 12-column fluid grid is used for desktop dashboards, collapsing to a single-column layout for mobile. 
- **Card Spacing:** Internal padding for course cards is set to 24px to provide a premium, breathable feel. 
- **Vertical Rhythm:** A "Stack" philosophy is applied; 16px between related elements (title and description) and 32px between distinct sections (Current Courses and Recommended).
- **Safe Areas:** On mobile, a 16px horizontal margin is enforced to prevent content from touching the screen edges.

## Elevation & Depth

Hierarchy is established through **Tonal Layering** and **Ambient Shadows**:

- **Level 0 (Background):** `#F9FAFB` – The base canvas.
- **Level 1 (Cards/Surface):** Pure `#FFFFFF` with a very soft, diffused shadow (10% opacity, 12px blur, 4px Y-offset). This makes course modules appear to float slightly above the canvas.
- **Level 2 (Interactive/Floating):** Higher contrast shadows (15% opacity, 20px blur) used for active state cards or dropdown menus to signify immediate priority.
- **Outlines:** Subtle 1px borders in `#E5E7EB` are used on non-elevated elements like input fields and inactive progress track containers to maintain structure without adding visual weight.

## Shapes

The shape language is defined by **Rounded (2)** settings, favoring soft, approachable geometry:

- **Standard Components:** Buttons, Input fields, and small UI widgets use a **0.5rem (8px)** radius.
- **Containers:** Course cards and large dashboard panels use **1rem (16px)** to create a distinct "pod" look that feels modern and organized.
- **Progress Bars:** These should always use fully rounded (pill) caps to signify fluidity and continuous movement.

## Components

### Buttons
- **Primary:** Solid Deep Academic Blue with white text. High-contrast, 48px height for mobile touch targets.
- **Secondary:** Success Green background for "Complete Lesson" or "Submit Quiz" actions.
- **Ghost:** Transparent background with Primary Blue border for "Save for Later" or "View Syllabus."

### Course Cards
- High-contrast white containers.
- Feature a 16:9 aspect ratio thumbnail at the top.
- Include a persistent progress bar at the bottom edge.

### Progress Bars
- 8px height. 
- Background: `#E5E7EB` (Light Gray).
- Fill: `#059669` (Success Green).
- Animation: Smooth ease-in-out transition when the percentage updates.

### Inputs & Selection
- **Inputs:** 1px `#D1D5DB` border, turning Primary Blue on focus.
- **Checkboxes:** Rounded (4px) to match the overall shape language; using Secondary Green for "Correct" feedback in quizzes.

### Mobile Bottom Navigation
- Fixed at the bottom with a background blur (Glassmorphism effect).
- Active states indicated by a Primary Blue icon and a small 4px dot indicator underneath.

### Dashboard Stats
- Utilizes "Data Pills" (small chips) with the Accent Orange for highlighting streaks or upcoming deadlines.
