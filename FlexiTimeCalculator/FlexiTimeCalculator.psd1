@{
    # Version number of this module.
    ModuleVersion = '0.0.1'

    # ID used to uniquely identify this module
    GUID = 'd50a2aa8-2a71-4ff8-a48a-3b8e5dbdf19a'

    # Author of this module
    Author = 'Simon Wallace'

    # Description of the functionality provided by this module
    Description = 'Helps to manage flexible working times.'

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules = @(
        "Get-FlexiTime.psm1"
        "Get-FlexiTimeDefaults.psm1"
        "Set-FlexiTime.psm1"
        "Set-FlexiTimeDefaults.psm1"
    )
}
