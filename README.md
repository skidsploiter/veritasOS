# VeritasOS 💻🔥

![image](https://github.com/user-attachments/assets/a32d294b-ad01-4c6b-852d-5e4199c15d76)

Welcome to **VeritasOS** — a tiny dumbass bootable OS written entirely in 16-bit x86 Assembly because why not. This project does absolutely nothing useful and that's exactly the point.

> *You ever wanted an OS that just prints stuff, accepts fake commands, and lets you feel powerful? Yeah, this is it.*

---

## 🧠 What it does

- Boots from a floppy image like it's 1993.
- Shows a "Welcome" message that screams *trust me bro* energy.
- Accepts fake commands like `ver`, `cls`, `help`, and `echo`.
- Pretends it's a real OS.
- Respects you enough to clear the screen when told.
- Absolutely **no** multitasking, file system, mouse support, or sanity.

---

## 💬 Supported Commands

| Command | What it "does" |
|--------|----------------|
| `ver`  | Shows a fake version string. |
| `cls`  | Clears the screen like a boss. |
| `help` | Lists commands in case you forgot (you will). |
| `echo [text]` | Repeats what you say like a dumb parrot. |

---

## 🛠️ Building It

### 🔧 Requirements

- [NASM](https://www.nasm.us/) (the nerd assembler)
- [QEMU](https://www.qemu.org/) (to boot it without crying over real hardware)
- Windows (for the `.bat` file, but you're smart enough to port it if not)

### 📦 Build Steps

Run this in your terminal like the giga chad you are:

```bash
build.bat
````

This will:

1. Assemble the bootloader and kernel.
2. Slap them into a 1.44MB floppy image.
3. Boot it in QEMU and pray.

---

## 🧾 File Structure

| File             | Description                                    |
| ---------------- | ---------------------------------------------- |
| `bootloader.asm` | Bootloader. Loads the kernel. Minimalist hell. |
| `kernel.asm`     | Main code. Fake shell. Real vibes.             |
| `build.bat`      | The dumbass batch script that builds it.       |
| `floppy.img`     | The cursed floppy image output.                |

---

## 😎 Credits

* You, for wasting your time here.
* NASM, for letting us play god.
* BIOS, for still working in 2025.

---

## 🧨 Disclaimer

> This project is for **educational purposes only**. If you actually try to use this as a real OS... what are you doing with your life.

---

## 💡 Future Ideas (Maybe, Never)

* Add a fake `crash` command.
* Print a BSOD for the memes.
* Add `format c:` just to scare people.
* Make `sudo` respond with "no."

---

## 🖕 Final Words

Built for chaos, by chaos.
Have fun. Break stuff. Boot floppies.
