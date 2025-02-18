# **ResVi Plasma Widget**  
**A Resource Monitoring Widget Command Set for KDE Plasma**  

## 📕 **Introduction**  

![Introduction](/images/1--intro.webp)

**ResVi Plasma Widget** is a widget designed for KDE Plasma to monitor system resources such as **CPU, RAM, Disk, SWAP, ZRAM, and Temperature**. It works with **Zren's CommandOutput**, allowing dynamic information display with customizable appearance.

### **Main File Structure in ResVi:**  
📂 **resvi/**  
 ┣ 📂 **config/** → Stores configuration files (e.g., `cpu.conf`, `ram.conf`)  
 ┣ 📂 **scripts/** → Stores resource data retrieval scripts (e.g., `cpu.sh`, `ram.sh`)  
 ┗ 📂 **loaders/** → Stores processing & display scripts (e.g., `cpu-loader.sh`, `ram-loader.sh`)  

## ⚡ **Features**  
- **Flexible & Customizable** – Labels, indicators, and display format can be adjusted  
- **Icon & Label Support** – Use text or Nerd Fonts icons  
- **Supports Various Units** – Percentage, size (MB, GB, etc.), and temperature (°C/°F)  
- **Supports Multiple Monitoring Targets** – CPU, RAM, disk, temperature, SWAP, and ZRAM  
- **Compatible with CommandOutput** – Uses KDE Plasma widget to read system command output  

## 📋 **Preparations**  

![Preparations](/images/2--preparations.webp)

Some of the ones on this list should at least be installed on your system:
- `git` (Recommended. If not installed, you can download this repo via Release)
- `bc` (Optional, only for arithmetic tools)
- `top` (CPU)
- `free` (RAM & SWAP Memory)
- `df` (Disk Storage)
- `sensors` (Temperature)
- `zramctl` (ZRAM)
- Monospace Font (Recommended, for width stability while changes)
- Nerd Fonts (Optional, only for Icons)
- CommandOutput Widget must be availabe in KDE Plasma

> [!NOTE]
> Make sure the CommandOutput Widget is installed because this widget repo has a Command Set form for it.
> 
> Nerd Fonts doesn't have to be installed if you don't want to use icons, only use text, or prefer to use emotes/emojis.

## 🔨 **Installation Steps** (Simple but Complex)  

### 1. Clone this repository and place it in your desired location.
If you are confused, try running this command to save it in `~/cli-widget/resvi-plasma-applet`:
```bash
mkdir ~/cli-widget
git clone https://github.com/yoelwep13578/resvi-plasma-applet.git ~/cli-widget/resvi-plasma-applet
cd ~/cli-widget/resvi-plasma-applet
```
or you can also download it directly and save it manually in Release

### 2. Grant execution permissions for all files in `config`, `scripts`, and `loader`.  
This command will allow the execution of `.sh` within the `config`, `scripts`, and `loader` folders
```bash
cd ./config && chmod +x -R * && cd ../scripts && chmod +x -R * && cd ../loader && chmod +x -R * && cd ../
```
or this
```bash
chmod +x config/*.conf scripts/*.sh loader/*.sh
```

### 3. Add the **Command Output** widget in KDE Plasma and configure it.  
Install it anywhere and adjust the size according to your wishes. 

> [!TIP]
> It's no problem to **install it on a panel** if you only want to display 1 or 2 resources. But if you want to display more than that, it is recommended to **just install the widget on the desktop.**

### 4. Load Command Set to Widget  
Fill in the command section in the CommandOutput Widget with `bash /path/to/loader/file.sh`. For example, if the repo is stored in `~/cli-widget/...`:
```bash
bash ~/cli-widget/resvi-plasma-applet/loader/cpu-loader.sh &&
bash ~/cli-widget/resvi-plasma-applet/loader/temp-loader.sh &&
bash ~/cli-widget/resvi-plasma-applet/loader/ram-loader.sh &&
bash ~/cli-widget/resvi-plasma-applet/loader/disk-loader.sh &&
bash ~/cli-widget/resvi-plasma-applet/loader/swap-loader.sh &&
bash ~/cli-widget/resvi-plasma-applet/loader/zram-loader.sh
```

> [!NOTE]
> If you want to display only a few, just delete the ones that are not needed in this command. If you only want to display 1, just copy one of the lines without the `&&`

```bash
bash ~/cli-widget/resvi-plasma-applet/loader/cpu-loader.sh
```  

## ⚙️ **Basic Configuration**  
Users can modify the widget's appearance by editing configuration files inside **config/**.  

---

### **1. Display Configuration** (example: `config/cpu.conf`)  

![display-as Config](/images/3--display-as-config.webp)

| Configuration | Display Output |
|--------------|---------------|
| `display-as="label,load,max,bar"` | `[CPU][ 50%][100%] ///////////_________` |
| `display-as="load,bar,max,label"` | `[ 50%] ///////////_________ [100%][CPU]` |
| `display-as="load,bar"` | `[ 50%] ///////////_________` |

---

### **2. Label Configuration** (example: `config/cpu.conf`)  

![label Config](/images/4--label-config.webp)

| Configuration | Display Output |
|--------------|---------------|
| `label_type="text"`<br>`label_text="CPU"` | `[CPU]` |
| `label_type="icon"`<br>`label_icon="⚙"` | `[⚙]` |
| `label_left_sign="["`<br>`label_right_sign="}"` | `[CPU}` |

---

### **3. Load/Current Configuration** (example: `config/cpu.conf`)  

![load/current Config #1](/images/5--load-config1.webp)

| Configuration | Display Output |
|--------------|---------------|
| `loadinfo_left_sign="{"`<br>`loadinfo_right_sign="}"` | `{50%}` |
| `loadinfo_text_align="right"` | `{ 50%}` |
| `loadinfo_decimal="2"` | `{50.00%}` |

#### **Resource Value Format Configuration:**  

![load/current Config #2](/images/6--load-config2.webp)

| Configuration | Display Output |
|--------------|---------------|
| `loadinfo_type="percentage"` | `{ 24%}` |
| `loadinfo_type="size"` | `{954M}` |
| `loadinfo_type="temperature"` | `{ 71°C}` |

#### **Data Unit Configuration (Decimal vs Binary):**  

![load/current Config #3](/images/7--load-config3.webp)

| Configuration | Display Output |
|--------------|---------------|
| `loadinfo_data_unit="GB"` | `{512GB}` |
| `loadinfo_data_unit="GiB"` | `{512GiB}` |
| `loadinfo_data_unit="GiB-hide-B"` | `{512Gi}` |

---

### **4. Bar Indicator Configuration** (example: `config/cpu.conf`)  

![bar Config](/images/8--bar-config.webp)

| Configuration | Display Output |
|--------------|---------------|
| `bar_length="short"` | `[//////____]` |
| `bar_length="long"` | `[//////////////////____________]` |
| `bar_fill_character=">"`<br>`bar_empty_character="-"` | `[>>>>>>>>>>>---------]` |
| `bar_left_sign="("`<br>`bar_right_sign=")"` | `(////////)` |

---

### **5. Maximum Capacity Configuration** (example: `config/cpu.conf`)  

![max/capacity Config](/images/9--max-config.webp)

| Configuration | Display Output |
|--------------|---------------|
| `maxcap_left_sign="{"`<br>`maxcap_right_sign="}"` | `{100%}` |
| `maxcap_fixed_width="5"` | `{  59G}` |
| `maxcap_text_align="right"` | `{ 59G}` |
| `maxcap_decimal="2"` | `{50.00G}` |

---

### **6. Monitoring Target Selection** (`config/disk.conf`, `config/temp.conf`, etc.)  

![Target Selections](/images/10--target-config.webp)

| Target | Example Configuration |
|--------|------------------------|
| **Disk** | `disk_target="/dev/sda6"` |
| **Temperature** | `temp_target="Package id 0"` |
| **ZRAM** | `zram_target="/dev/zram0"` |

---

### **Example Output & Inspirations**  

![Example Appearance](/images/11--example.webp)

---

## 🪶 **Conclusion**  
**ResVi Plasma Widget** provides KDE Plasma users with full flexibility in configuring system resource monitoring displays. With customizable settings, adaptable icons, and support for various data units, this widget is an excellent solution for those looking to tailor their monitoring interface to their personal preferences.  
