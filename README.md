# StarGaze

StarGaze is a modular UI framework for Roblox built by Starlight Solutions, Inc.

It is meant to give Roblox developers a solid visual foundation without forcing every project into the same layout. The framework separates runtime behavior, themes, styles, templates, presets, interactions and components so projects can keep their own visual identity.

## What is included

- Modular Luau architecture
- Built-in dark themes
- Custom themes
- Built-in styles and custom styles
- Templates for common application layouts
- Reusable presets
- Runtime settings
- Responsive scale-based layout helpers
- Animation and interaction controls
- Buttons
- Windows
- Toggles
- Checkboxes
- Radio controls
- Sliders
- Progress bars
- Inputs
- Dropdowns
- Tabs
- Segmented controls
- Accordions
- Keybind controls
- Color picker palettes
- Notifications
- Confirmation dialogs
- Context menus
- Command palette
- Tooltips
- Badges
- Dividers
- Plugin lifecycle support
- Runtime theme switching
- No external runtime dependencies

## Installation

StarGaze can be installed from the GitHub repository with the included Studio bootstrap.

The bootstrap is intentionally small. It downloads the current `tools/InstallInStudio.lua` file from GitHub and passes the installation settings to it. The installer then downloads the framework source and creates or replaces the ModuleScript hierarchy.

### Requirements

Use the installer in Roblox Studio while editing the place. It is not intended to modify ModuleScript source from a live published server.

Enable HTTP requests in:

```text
Game Settings
└── Security
    └── Allow HTTP Requests = ON
```

The bootstrap also uses `loadstring` to execute the installer returned by GitHub. Run it from the Studio Command Bar or another Studio environment where `loadstring` is available.

### Full bootstrap

Open **View → Command Bar** in Roblox Studio and paste this entire script:

```lua
local HttpService = game:GetService("HttpService")

local CONFIG = {
	InstallPath = "ReplicatedStorage.StarGaze",
	Mode = "Auto",
	InstallerUrl = "https://raw.githubusercontent.com/Starlight-Solutions-Inc/StarGaze/main/tools/InstallInStudio.lua",
}

if not HttpService.HttpEnabled then
	error("[StarGaze Bootstrap] HTTP requests are disabled. Enable Game Settings > Security > Allow HTTP Requests.")
end

local success, source = pcall(function()
	return HttpService:GetAsync(CONFIG.InstallerUrl, false)
end)

if not success then
	error("[StarGaze Bootstrap] Could not download the installer:\n" .. tostring(source))
end

if type(source) ~= "string" or source == "" then
	error("[StarGaze Bootstrap] GitHub returned an empty installer.")
end

if type(loadstring) ~= "function" then
	error("[StarGaze Bootstrap] loadstring is unavailable in this Studio environment.")
end

local installer, compileError = loadstring(source)
if not installer then
	error("[StarGaze Bootstrap] The GitHub installer could not be compiled:\n" .. tostring(compileError))
end

local ran, runtimeError = pcall(installer, {
	InstallPath = CONFIG.InstallPath,
	Mode = CONFIG.Mode,
})

if not ran then
	error("[StarGaze Bootstrap] The installer failed:\n" .. tostring(runtimeError))
end

print("[StarGaze Bootstrap] StarGaze installation/update completed.")
```

### Installation modes

`Auto` installs when StarGaze is missing and replaces the existing installation when it is present.

```lua
Mode = "Auto"
```

`Install` refuses to overwrite an existing installation.

```lua
Mode = "Install"
```

`Update` requires an existing StarGaze installation.

```lua
Mode = "Update"
```

### Installation location

The default is:

```lua
InstallPath = "ReplicatedStorage.StarGaze"
```

You can change it without changing the installer itself.

```lua
InstallPath = "ReplicatedStorage.UI.StarGaze"
```

This creates:

```text
ReplicatedStorage
└── UI
    └── StarGaze
```

The final object is always a `ModuleScript`, so the normal usage is:

```lua
local StarGaze = require(game.ReplicatedStorage.StarGaze)
```

## Basic usage

```lua
local StarGaze = require(game.ReplicatedStorage.StarGaze)

local UI = StarGaze.create({
	Theme = "Obsidian",
})

local window = UI:window({
	Title = "My Interface",
	Subtitle = "Powered by StarGaze",
	Size = UDim2.fromScale(0.64, 0.72),
	Position = UDim2.fromScale(0.5, 0.5),
})

UI:button(window.Content, {
	Text = "Save",
	OnClick = function()
		UI:notify({
			Title = "Saved",
			Text = "Your changes have been saved.",
			Type = "Success",
		})
	end,
})
```

## Themes

Built-in themes:

- `Obsidian`
- `Midnight`
- `Carbon`
- `Violet`

Switch themes at runtime:

```lua
UI:setTheme("Midnight")
```

Register a custom theme:

```lua
StarGaze.Themes.register("Studio", {
	Background = Color3.fromRGB(9, 10, 13),
	Surface = Color3.fromRGB(16, 17, 21),
	SurfaceAlt = Color3.fromRGB(24, 25, 30),
	Glass = Color3.fromRGB(24, 25, 30),
	Card = Color3.fromRGB(19, 20, 25),
	Border = Color3.fromRGB(52, 54, 62),
	Text = Color3.fromRGB(245, 246, 249),
	Subtext = Color3.fromRGB(151, 154, 164),
	Accent = Color3.fromRGB(145, 96, 255),
	AccentAlt = Color3.fromRGB(188, 149, 255),
	Success = Color3.fromRGB(74, 208, 128),
	Warning = Color3.fromRGB(245, 182, 66),
	Danger = Color3.fromRGB(239, 82, 88),
	Info = Color3.fromRGB(83, 157, 255),
})

UI:setTheme("Studio")
```

## Styles

Built-in styles are intended to control the shape and interaction language of components.

```text
Soft
Sharp
Glass
Dense
```

Use a style globally:

```lua
UI:configure({
	Style = "Glass",
})
```

Register your own:

```lua
UI:registerStyle("Studio", {
	Radius = 8,
	StrokeTransparency = 0.2,
	HoverStrength = 0.04,
	PressScale = 0.985,
	Shadow = false,
})
```

## Runtime settings

The runtime exposes settings that can be used to keep a complete project visually consistent.

```lua
UI:configure({
	Density = "Compact",
	Style = "Glass",
	Template = "Dashboard",
	Animation = true,
	AnimationSpeed = 0.14,
	Hover = true,
	Press = true,
	FocusRing = true,
	Tooltips = true,
	Glassmorphism = true,
	Shadows = false,
	Outline = true,
	OutlineTransparency = 0.3,
	ModalOpacity = 0.42,
	NotificationDuration = 4,
	NotificationPosition = "TopRight",
	Responsive = true,
	ScaleMin = 0.78,
	ScaleMax = 1.08,
	TextScale = 1,
	IconStyle = "Solid",
	IconSize = 18,
	SidebarWidth = 0.18,
	SectionSpacing = 0.014,
	ComponentSpacing = 0.012,
	PagePadding = 0.022,
})
```

Individual values can also be read or changed:

```lua
local density = UI:setting("Density")
UI:setting("Density", "Comfortable")
```

## Templates

Built-in layout templates include:

- `MinimalWindow`
- `Dashboard`
- `CompactPanel`
- `Inspector`

Retrieve one as a configuration table:

```lua
local template = UI:template("Dashboard")
```

Register your own:

```lua
UI:registerTemplate("Inventory", {
	Window = {
		Size = UDim2.fromScale(0.7, 0.78),
		CornerRadius = 14,
		Stroke = true,
	},
	Content = {
		Padding = 0.02,
	},
})
```

## Plugins

Plugins can add behavior without modifying StarGaze's core modules.

```lua
local plugin = UI:registerPlugin({
	Name = "DeveloperTools",

	Setup = function(context)
		context.Runtime:notify({
			Title = "Developer Tools",
			Text = "Plugin loaded.",
			Type = "Info",
		})
	end,

	Destroy = function(context)
	end,
})
```

Plugin lifecycle methods are `Setup` and `Destroy`.

```lua
UI:unregisterPlugin("DeveloperTools")
```

## Components

StarGaze currently includes:

```text
Window
Button
Toggle
Checkbox
Radio
Slider
Progress
Input
Dropdown
Tabs
Segmented
Accordion
Keybind
ColorPicker
Badge
Divider
Notification
Tooltip
Confirm
ContextMenu
CommandPalette
```

Every component is a separate module, while the runtime exposes a consistent API for creating them.

## Responsive layouts

StarGaze is designed to favor proportional sizing. The built-in responsive helper adds a controlled `UIScale` and reacts to viewport changes.

```lua
UI:responsive(window.Instance, {
	BaseWidth = 1440,
	Min = 0.78,
	Max = 1.04,
})
```

For reusable application layouts, prefer `UDim2.fromScale` and scale-based padding where possible.

## Example project

`example/Example.client.lua` contains a complete showcase designed to demonstrate StarGaze as an actual interface rather than a grid of isolated component samples.

The example includes:

- Sidebar navigation
- Overview page
- Live component preview
- Runtime settings
- Theme switching
- Component inventory
- Command palette
- Notifications
- Responsive scaling

## Repository structure

```text
StarGaze/
├── src/
│   └── StarGaze/
│       ├── Core/
│       │   ├── Interaction.lua
│       │   ├── Plugins.lua
│       │   ├── Presets.lua
│       │   ├── Responsive.lua
│       │   ├── Runtime.lua
│       │   ├── Settings.lua
│       │   ├── Styles.lua
│       │   ├── Templates.lua
│       │   ├── Themes.lua
│       │   └── Utils.lua
│       ├── Components/
│       ├── Elements.lua
│       └── init.lua
├── example/
├── docs/
├── tools/
├── default.project.json
├── LICENSE
└── README.md
```

## Updating StarGaze

The bootstrap always downloads the installer from:

```text
https://raw.githubusercontent.com/Starlight-Solutions-Inc/StarGaze/main/tools/InstallInStudio.lua
```

The installer then discovers the current Lua files in `src/StarGaze`, downloads the complete set first, and only replaces the existing installation after every download succeeds.

For production projects, pinning StarGaze to a release tag or commit is safer than automatically following `main`.

## License

StarGaze is released under the MIT License.

Copyright (c) 2026 Starlight Solutions, Inc.


## Executor Edition (fork)

The original `src/StarGaze` is preserved. `dist/StarGaze.lua` is a single-file bundling of the original modules, replacing Roblox Studio `require(script.Parent...)` references with an in-memory module loader.

### Usage after pushing `dist/StarGaze.lua` to your fork

```lua
local StarGaze = assert(loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/caraqualquer/StarGaze-Executor/main/dist/StarGaze.lua"
)))()

local ui = StarGaze.create({Name = "EB_AI", Theme = "Obsidian"})
```

For a complete original-layout demonstration, run `examples/ExecutorShowcase.lua`. For a small smoke test, run `examples/ExecutorSmokeTest.lua`.

`tools/build_executor.py` regenerates the distribution from the source tree. This is a static compatibility adaptation, **not verified against any particular executor**. Not all executor HTTP or GUI environments behave identically. Preserve the original LICENSE file.


## Executor Edition (fork)

The original `src/StarGaze` is preserved. `dist/StarGaze.lua` is a single-file bundling of the original modules, replacing Roblox Studio `require(script.Parent...)` references with an in-memory module loader.

### Usage after pushing `dist/StarGaze.lua` to your fork

```lua
local StarGaze = assert(loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/caraqualquer/StarGaze-Executor/main/dist/StarGaze.lua"
)))()

local ui = StarGaze.create({Name = "EB_AI", Theme = "Obsidian"})
```

For a complete original-layout demonstration, run `examples/ExecutorShowcase.lua`. For a small smoke test, run `examples/ExecutorSmokeTest.lua`.

`tools/build_executor.py` regenerates the distribution from the source tree. This is a static compatibility adaptation, **not verified against any particular executor**. Not all executor HTTP or GUI environments behave identically. Preserve the original LICENSE file.
