Assets {
  Id: 907668013652772312
  Name: "Pondwater"
  PlatformAssetType: 13
  SerializationVersion: 89
  CustomMaterialAsset {
    BaseMaterialId: 6339793752492826231
    ParameterOverrides {
      Overrides {
        Name: "object displacement amount"
        Float: 0
      }
      Overrides {
        Name: "speed"
        Float: 0.01
      }
      Overrides {
        Name: "wind speed"
        Float: 0.166832551
      }
      Overrides {
        Name: "deep color"
        Color {
          R: 0.0235894043
          G: 0.026
          A: 1
        }
      }
    }
    Assets {
      Id: 6339793752492826231
      Name: "Generic Water - No Distortion"
      PlatformAssetType: 2
      PrimaryAsset {
        AssetType: "MaterialAssetRef"
        AssetId: "fxma_parameter_driven_water_nodistortion"
      }
    }
  }
}
