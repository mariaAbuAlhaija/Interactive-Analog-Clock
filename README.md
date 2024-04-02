# Interactive Analog Clock
This project is an interactive analog clock developed with Qt Quick (QML). It features a customizable clock face that displays hour, minute, and second hands, which users can interact with to set the time manually. The clock also includes hour marks and numerical indicators for a classic analog look.

# Features
Dynamic Time Adjustment: Users can click and drag the clock hands to set the desired time, making the clock not just a visual element but an interactive tool.
Customizable Appearance: The clock face, hands, and numerical indicators' colors, sizes, and styles are customizable, allowing for a personalized appearance.
Auto-Updating Time: Apart from manual adjustments, the clock hands automatically update to reflect the current time, with a smooth second-hand movement.
Edit Mode Toggle: Includes buttons to reset the clock to the current time or to enter edit mode, pausing the automatic time update for manual adjustment.
# Implementation
The implementation utilizes Qt Quick for a fluid and responsive user interface, leveraging Canvas for drawing static elements like hour marks, and Repeater for dynamic elements like numerical hour indicators. Timer is used for real-time updates, and MouseArea handles user interactions for time adjustments.

# Usage
This clock can serve as a standalone application or be integrated into larger Qt Quick projects requiring time display or input functionality. It's perfect for applications needing a visually appealing, interactive time picker or simply a decorative clock element.
