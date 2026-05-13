# Sitecore XM Cloud PowerShell Scripts

A collection of PowerShell scripts for Sitecore developers to automate content operations and migrations.

## Overview

This repository contains production-ready PowerShell scripts designed for Sitecore content management tasks. 
These scripts are particularly useful when working with Sitecore XM Cloud and handling complex content migration scenarios.

### What's Inside

**Content Migration Scripts** - Automate the migration of pages and content between Sitecore instances when:
- Migrating from legacy Sitecore (XM On-Premise) to modern Sitecore (XM Cloud)
- Content structures and templates differ between source and target
- Standard package installation cannot handle structural differences
- Multi-language content needs to be migrated efficiently

**General Content Operations** - PowerShell scripts for common Sitecore development tasks and content management workflows.

## Why These Scripts?

When migrating content between Sitecore instances with different structures, traditional package installation fails because:
- Templates are different between environments
- Field names and types have changed
- Content architecture has been redesigned
- Item paths and hierarchies don't match

These scripts handle template mapping, field transformations, and structural differences automatically, saving months of manual work.

## Available Scripts

### 📁 [Migrating-Page-And-Its-Content](./Migrating-Page-And-Its-Content)
Migrate pages and their content from XM On-Premise to XM Cloud with different content structures.

**Features:**
- Handles different template structures
- Maps fields between source and target
- Supports multiple languages (10+)
- Preserves item IDs and relationships

[View Documentation](./Migrating-Page-And-Its-Content/README.md)

## Getting Started

1. **Prerequisites**: Sitecore PowerShell Extensions (SPE) installed
2. **Choose a script**: Browse the folders for your use case
3. **Follow the README**: Each script folder has detailed instructions

## Time Savings Example

Manual migration of 2,500 pages across 10 languages: **3-4 months**  
With these scripts: **8 hours**

## Repository Structure
