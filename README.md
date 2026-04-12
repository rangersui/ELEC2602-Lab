# ELEC2602 Lab

FPGA lab projects using Verilog. Quartus Prime for synthesis, QuestaSim/Iverilog for simulation.

## Getting Started

### 1. Clone the repo

```bash
git clone <repo-url>
cd ELEC2602-Lab
```

### 2. Create your own branch

**Never commit directly to `main`.** Always create a branch for your work:

```bash
git checkout -b your-name/lab3    # create and switch to your branch
```

Branch naming convention: `yourname/description`, e.g. `alice/lab4-part2`.

### 3. Work, commit, push

```bash
git add .
git commit -m "finish lab3 part1"
git push -u origin your-name/lab3
```

### 4. Stay updated with main

Before starting new work, pull the latest changes:

```bash
git checkout main
git pull origin main
git checkout -b your-name/new-task    # create new branch from updated main
```

If you need to update your existing branch with latest main:

```bash
git checkout your-branch
git merge main
```

### 5. Merge back to main

When your work is done and tested, create a **Pull Request** on GitHub, or merge locally:

```bash
git checkout main
git merge your-name/lab3
git push origin main
```

## Simulation

### Windows (QuestaSim / ModelSim)

Make sure QuestaSim (or ModelSim) is installed and added to PATH.

Each lab folder has `run.bat` and `run.do`. To run simulation:

```bash
cd "Lab 3 Part 1"
vsim -do run.do
```

Or double-click `run.bat`.

The `run.do` script does:
1. `vlib work` - create work library
2. `vlog *.v` - compile all Verilog files
3. `vsim ...` - launch simulation with the testbench
4. `add wave` + `run` - add signals and run

### macOS / Linux (Iverilog + GTKWave)

Install:

```bash
# macOS
brew install icarus-verilog gtkwave

# Ubuntu/Debian
sudo apt install iverilog gtkwave
```

Run simulation (example for Lab 3 Part 1):

```bash
cd "Lab 3 Part 1"
iverilog -o sim.out *.v
vvp sim.out
```

To view waveforms, add `$dumpfile` and `$dumpvars` to your testbench:

```verilog
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, your_testbench_name);
end
```

Then:

```bash
vvp sim.out
gtkwave wave.vcd
```

## Project Structure

```
ELEC2602-Lab/
  Lab 3 Part 1/        # Lab 3 - 7-seg decoder, mux
  Lab 3 Part 3/        # Lab 3 - Board implementation
  Lab 4 Part 2 templates/  # Lab 4 - Comparator, circuits
  Lab 4 Part 3 templates/  # Lab 4 - Full adder
  .gitignore            # Ignores Quartus/ModelSim build artifacts
```

## Git Quick Reference

| Command | What it does |
|---|---|
| `git clone <url>` | Download the repo |
| `git checkout -b name` | Create + switch to new branch |
| `git add .` | Stage all changes |
| `git commit -m "msg"` | Commit with message |
| `git push` | Push to GitHub |
| `git pull origin main` | Get latest from main |
| `git merge main` | Merge main into your branch |
| `git status` | See what's changed |
| `git log --oneline` | See commit history |
