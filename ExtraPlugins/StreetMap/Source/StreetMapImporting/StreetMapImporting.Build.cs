// Copyright 2017 Mike Fricker. All Rights Reserved.

namespace UnrealBuildTool.Rules
{
  public class StreetMapImporting : ModuleRules
  {
    public StreetMapImporting(ReadOnlyTargetRules Target)
    : base(Target)
    {
      PCHUsage = ModuleRules.PCHUsageMode.UseExplicitOrSharedPCHs;

      PrivateDependencyModuleNames.AddRange(
        new string[] {
          "Core",
          "CoreUObject",
          "Engine",
          "UnrealEd",
          "XmlParser",
          "AssetTools",
          "Projects",
          "Slate",
          "EditorStyle",
          "SlateCore",
          "PropertyEditor",
          "Blutility",
          "UnrealEd",
          "EditorScriptingUtilities",
          "RenderCore",
          "RHI",
          "RawMesh",
          "AssetTools",
          "AssetRegistry",
          "StreetMapRuntime"
        }
      );

      PrivateIncludePaths.AddRange(new string[]{"StreetMapImporting/Private"});
    }
  }
}
