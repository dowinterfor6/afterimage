Name: "Afterimage"
RootId: 10440700068942667087
Objects {
  Id: 8794158245681669788
  Name: "Ability Display"
  Transform {
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 10440700068942667087
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  TemplateInstance {
    ParameterOverrideMap {
      key: 1197405803885299036
      value {
        Overrides {
          Name: "Name"
          String: "Ability Display"
        }
        Overrides {
          Name: "Scale"
          Vector {
            X: 1
            Y: 1
            Z: 1
          }
        }
        Overrides {
          Name: "cs:Binding"
          String: "ability_extra_20"
        }
        Overrides {
          Name: "cs:BindingHint"
          String: "Q"
        }
        Overrides {
          Name: "cs:ShowAbilityName"
          Bool: true
        }
        Overrides {
          Name: "Position"
          Vector {
          }
        }
        Overrides {
          Name: "Rotation"
          Rotator {
          }
        }
      }
    }
    ParameterOverrideMap {
      key: 13280367607995188053
      value {
        Overrides {
          Name: "Anchor"
          Enum {
            Value: "mc:euianchor:bottomright"
          }
        }
        Overrides {
          Name: "Dock"
          Enum {
            Value: "mc:euianchor:bottomright"
          }
        }
        Overrides {
          Name: "UIX"
          Float: -110
        }
        Overrides {
          Name: "UIY"
          Float: -10
        }
      }
    }
    ParameterOverrideMap {
      key: 14155720757392291425
      value {
        Overrides {
          Name: "Image"
          AssetReference {
            Id: 15038246918448350817
          }
        }
        Overrides {
          Name: "Color"
          Color {
            R: 1
            G: 1
            B: 1
            A: 0.400000036
          }
        }
      }
    }
    TemplateAsset {
      Id: 6237983238508793007
    }
  }
}
