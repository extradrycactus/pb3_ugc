using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEditor.AddressableAssets;
using UnityEditor.AddressableAssets.Settings;
using UnityEditor.Compilation;
using UnityEngine;
using System.IO;
 
public class BuildScriptsAddressables
{
    [MenuItem("Tools/PB3 - Build Addressables")]
    public static void BuildAll()
    {
        if (EditorUserBuildSettings.selectedStandaloneTarget == BuildTarget.StandaloneWindows64) {
            BuildAddressables();
            SetPlatformMacOS();
            BuildAddressables();
            SetPlatformWindows();
        } else if (EditorUserBuildSettings.selectedStandaloneTarget == BuildTarget.StandaloneOSX) {
            BuildAddressables();
            SetPlatformWindows();
            BuildAddressables();
            SetPlatformMacOS();
        }
        DirectoryInfo dir = new DirectoryInfo(UnityEngine.AddressableAssets.Addressables.RuntimePath);
        string modDirPath = EditorUtility.OpenFolderPanel("Select Mod Directory", Application.dataPath, "");
        if (!string.IsNullOrEmpty(modDirPath)) {
            CopyDirectory(dir.Parent.FullName, Path.Combine(modDirPath, "aa"), true);
        }
    }
 
    public static void SetPlatformWindows()
    {
        EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTargetGroup.Standalone, BuildTarget.StandaloneWindows);
        EditorUserBuildSettings.selectedStandaloneTarget = BuildTarget.StandaloneWindows64;
    }
 
    public static void SetPlatformMacOS()
    {
        EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTargetGroup.Standalone, BuildTarget.StandaloneOSX);
        EditorUserBuildSettings.selectedStandaloneTarget = BuildTarget.StandaloneOSX;
    }
 
    public static void BuildAddressables(object o = null)
    {
        AddressableAssetSettings.CleanPlayerContent();
        AddressableAssetSettings.BuildPlayerContent();
    }

    static void CopyDirectory(string sourceDir, string destinationDir, bool recursive)
    {
        DirectoryInfo dir = new DirectoryInfo(sourceDir);
        if (dir == null) {
            Debug.LogError($"COPY ERROR: Source directory not found: {dir.FullName}");
            return;
        }

        if (Directory.Exists(destinationDir)) {
            Directory.Delete(destinationDir, true);
        }
        Directory.CreateDirectory(destinationDir);

        foreach (FileInfo file in dir.GetFiles()) {
            string targetFilePath = Path.Combine(destinationDir, file.Name);
            file.CopyTo(targetFilePath);
        }

        foreach (DirectoryInfo subDir in dir.GetDirectories()) {
            string newDestinationDir = Path.Combine(destinationDir, subDir.Name);
            CopyDirectory(subDir.FullName, newDestinationDir, true);
        }
    }
}