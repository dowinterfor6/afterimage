Assets {
  Id: 10991131027609015275
  Name: "Custom Terrain - Grass Cliffs"
  PlatformAssetType: 13
  SerializationVersion: 89
  CustomMaterialAsset {
    BaseMaterialId: 6293171627245844021
    ParameterOverrides {
      Overrides {
        Name: "direction"
        Bool: false
      }
      Overrides {
        Name: "density"
        Float: 0.166832551
      }
      Overrides {
        Name: "color_top"
        Color {
          R: 0.3150855
          G: 0.358
          B: 0.00932273176
          A: 1
        }
      }
      Overrides {
        Name: "splotchiness"
        Float: 0.832973421
      }
    }
    Assets {
      Id: 6293171627245844021
      Name: "Terrain - Moss"
      PlatformAssetType: 2
      PrimaryAsset {
        AssetType: "MaterialAssetRef"
        AssetId: "mi_terrain_rock-moss_001_wa"
      }
    }
  }
}
