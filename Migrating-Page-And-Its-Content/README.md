# Sitecore XM On-Premise to XM Cloud Migration Scripts

## Overview

Automate the migration of pages and content from **Sitecore XM On-Premise** to **Sitecore XM Cloud** when structures and templates differ between environments.

### Why Use These Scripts?

- ⏱️ **Save Months of Work**: Manual migration of 10 languages for thousands of items could take months - these scripts reduce it to hours
- 🎯 **Handle Complexity**: Automatically maps different templates and field structures between environments
- 🌍 **Multi-Language Support**: Migrate all language versions (10+) in one execution
- ✅ **Preserve Integrity**: Maintains item IDs and relationships
- 🔄 **Safe & Repeatable**: Incremental migration support - safely re-run without duplicates

---

## How It Works

### Two-Step Process

**Step 1: Export from XM On-Premise**
- Excute the script - "Step#1-Get-Page-and-Its-SubContent.ps1" by updating the parameter - `$pagePath` to the page you want to export (e.g. `/sitecore/content/Home/Products`)
- Excute the script in sitecore instance from where you want to migrate the content, example : XM On-Premise 
- The script will export the page and its subcontent to a CSV file, which will be used in the next step for importing to XM Cloud.

**Step 2: Import to XM Cloud**
- Upload the output CSV from Step #1 to the XM Cloud environments Media Library
- Update the field mapping CSV file with the correct template and field mappings for your XM Cloud environment, sample CSV file is provided in the repository - "Field-And-Template-Mappings.csv"
- Upload the updated "Field-And-Template-Mappings.csv" to the XM Cloud environments Media Library
- Execute the script - "Step#2-Create-Page-and-Its-SubContent.ps1" by updating the parameters - `$pagesAndsubContentItems_CSVPath` and `$fieldTemplateMappings_CSVPath` to the paths of the exported CSV and the field mapping CSV respectively
- Also, update the parameter - `$parentPath` to the path where you want to create the page and its subcontent in XM Cloud (e.g. `/sitecore/content/Home/Products`)

---

## Prerequisites

- Sitecore PowerShell Extensions (SPE) installed on both environments
- Administrator access to both Sitecore instances
- CSV mapping file prepared (template and field mappings)

---

## Configuration Required

### 1. Create Field and Template Mapping CSV - Sample mapping CSV file is provided in repository.

Create a CSV file with these columns:

| Column Name | Description | Example |
|------------|-------------|---------|
| **OldTemplateId** | Template GUID from On-Premise | `{76036F5E-CBCE-46D1-AF0A-4143F9B557AA}` |
| **NewTemplateId** | Corresponding template GUID in XM Cloud | `{1930BBEB-7805-471A-A3BE-4858AC7CF696}` |
| **OldFieldName** | Field name in source that is On-Premise  | `Title` |
| **NewFieldName** | Corresponding Field name in target that is XM Cloud | `PageTitle` |
| **DirectValue** | Use literal value? (`yes`/`no`) | `no` |

Note :- Other two columns - OldTemplateName and NewTemplateName are just for informative and not being used in Script execution.

**Example CSV Content:**
Sample mapping CSV file is provided in repository.