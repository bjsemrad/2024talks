author: Brian Semrad
date: MMMM dd, YYYY
paging: Slide %d / %d
---

# Reproducable Dev Env's and Builds with Nix

Because it works on my machine is not an excuse!

---

# What is Nix?

## Package Management
Nix is a powerful package manager that allows developers to install, update, and manage packages across multiple platforms and languages in a consistent way.
## Isolation
Nix provides isolation by creating a separate environment for each package and its dependencies, ensuring that different versions of the same package can coexist without conflicts.
## Language
Domain specific language for reproducible builds, environments, and systems

The nix language is a functional delcaritive programming language with lazy evaluation. (order doesn't matter).
---

# Can Nix do?

## Infrastructure as Code
This laptop I'm presenting from is running NixOS, the entire system is declared in a configuration file.

Moving the configuration file to another machine will result in the same system.

## Reproducibility
Nix provides reproducibility by allowing developers to create and share exact dependencies that are used for building and testing an application, avoiding issues caused by version conflicts or machine specific differences. Nix is a functional build system, if you specify your inputs exactly and not introduce variation (like pulling files from the internet without verifying byte-for-byte same content), the same inputs will products the same output exactly.


## Dependency Management
Nix provides easy and reliable dependency management by allowing developers to specify and manage package dependencies for their applications, ensuring that all required dependencies are present and up-to-date.

## Software Supply Chain Security
Allows you to be able to understand the supply chain, audit it and build a Software Bill of Materials.

## Build source code
Nix has built in language functions to compile code, build containers and more.
---

# Let's talk Nix Flakes quickly...

## What are they?
Feature of the Nix package manager that aims to improve reproducibility, composability, and usability.

It allows you to declare project dependencies in a lock file, ensuring that you get the same development environment and dependencies every time you build your project, across different machines.

This feature is particularly useful for managing complex systems and ensuring consistent builds.

We will use flakes for the rest of this demo...
---

# This is a demo so let's demo
```bash
cat ./dev1/flake.nix
cd ./dev1/
nix flake show
```
## What is happening here?
1. We are delcaring some inputs in this case packages from the nix package repository.
2. Outputs, which in this case is a shell with 2 packages installed.
---

# Let's do some development
What does my current shell have?
```bash
echo 'Java: '
java --version
echo 'Node: '
node --version
```
---
# Let's do some development
What happens now when we enter the shell?
```bash
cd dev1/
nix develop
java --version
node --version
```
---

# Cool, so now my dev environment has all the languages...but we use Gradle!
Let's add it to our flake
```bash
cat ./dev2/flake.nix
cd ./dev2/
nix flake show
```
---
# Let's do some development in dev2
```bash
cd dev2/
nix develop
java --version
node --version
gradle --version
```
---
# Can I build my gradle project with Nix?
Gradle is not a functional build system. Gradle produces highly variable output because there is variation on:

* JVM
* Gradle version
* Dynamic dependencies (ie latest version)
* Environment variables
* Cached packages
* Repository may allow overrides
---

# But...we can cheat a bit!

We can enable "impure" derivations, which I have done on this system.
There are projects underway to build tooling to make them "pure".
However, they rely on an extra lock file and pre-deriving all the dependencies and all but one is mostly abandonded.

```bash
cd dev3/
nix flake show
cat ./flake.nix
```
---

# Let's build it!
```bach
cd dev3/
nix build
./result/bin/app
```
---

# But But But I need to build continers!

There's a function for that.

```bash
cd docker/
cat flake.nix
nix flake show
```
We can put any of the 80,000+ packages from Nixpkgs we want to build the container.

---

# Let's build and run it

```bash
cd docker/
nix build .#cowsay
ls -lah result
docker load < result
docker run cowsay
```

---

# Why?
Docker is repeatable, but not reproducible. It defines instructions, but trusts
the internet unconditionally, without performing any hashing. Dockerfiles do not
provide you with a toolset for performing reproducible builds.

---

# What does Nix guarantee?

## Same inputs, same outputs! (Hopefully)

Nix guarantees that all of the inputs for a build will be gathered reproducibly,
and that the build process will be performed offline, in a sandbox, meaning the
output should be the same every time.

# What does Nix not guarantee?

## Sometimes, build processes are not deterministic despite everything

Nix cannot force the build process to be deterministic, but it does more than
most tools, by implementing a methodology for performing reproducible builds and
providing you with an expression language to define the build.

---

# What else?

Direnv is a tool that alot of you might use to setup your path in the shell, we can make it flake away on a system with nix.
```bash
cd dev4/
```
---

# How about compling other cpu architecture formats?
Nix can do that too!

Cross compilation for any architecture using pkgsCross
```bash
cd cross
nix build nixpkgs\#pkgsCross.riscv64.cowsay --rebuild

file ./result/bin/cowsay
./result/bin/cowsay "I'm a Riscv Binary"
```
---
# Thats about all I have time for....Questions?
Find me after!

If there is extra time, we can take some questions.
