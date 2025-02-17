# **ResVi Plasma Widget**  
**A Resource Monitoring Widget Command Set for KDE Plasma**  

## **Introduction**  

![Introduction](/images/1--intro.webp)

**ResVi Plasma Widget** is a widget designed for KDE Plasma to monitor system resources such as **CPU, RAM, Disk, SWAP, ZRAM, and Temperature**. It works with **Zren's CommandOutput**, allowing dynamic information display with customizable appearance.

### **Main File Structure in ResVi:**  
📂 **resvi/**  
 ┣ 📂 **config/** → Stores configuration files (e.g., `cpu.conf`, `ram.conf`)  
 ┣ 📂 **scripts/** → Stores resource data retrieval scripts (e.g., `cpu.sh`, `ram.sh`)  
 ┗ 📂 **loaders/** → Stores processing & display scripts (e.g., `cpu-loader.sh`, `ram-loader.sh`)  

## **Features**  
- **Flexible & Customizable** – Labels, indicators, and display format can be adjusted  
- **Icon & Label Support** – Use text or Nerd Fonts icons  
- **Supports Various Units** – Percentage, size (MB, GB, etc.), and temperature (°C/°F)  
- **Supports Multiple Monitoring Targets** – CPU, RAM, disk, temperature, SWAP, and ZRAM  
- **Compatible with CommandOutput** – Uses KDE Plasma widget to read system command output  

## **Preparation & Installation**  

![Preparations](/images/2--preparations.webp)

### **Requirements**  
✔ **Git** must be installed  
✔ **Nerd Fonts** (optional but recommended)  
✔ **Command Output Widget** must be available in KDE Plasma  

### **Installation Steps**  
1. Clone this repository and place it in your desired location.  
2. Grant execution permissions for all files in **config, scripts, and loaders**:  
   ```bash
   chmod +x config/*.conf scripts/*.sh loaders/*.sh
   ```  
3. Add the **Command Output** widget in KDE Plasma and configure it.  
4. Run using the following command:  
   ```bash
   bash loaders/cpu-loader.sh
   ```  

## **Basic Configuration**  
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

## **Example Output & Inspirations**  

![Example Appearance](/images/11--example.webp)

---

### **Conclusion**  
**ResVi Plasma Widget** provides KDE Plasma users with full flexibility in configuring system resource monitoring displays. With customizable settings, adaptable icons, and support for various data units, this widget is an excellent solution for those looking to tailor their monitoring interface to their personal preferences.  
