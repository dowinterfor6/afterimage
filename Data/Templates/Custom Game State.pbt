Assets {
  Id: 9172431743131946957
  Name: "Custom Game State"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 8993584527061449296
      Objects {
        Id: 8993584527061449296
        Name: "Custom Game State"
        Transform {
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 5876826362897621181
        ChildIds: 908117060022133475
        ChildIds: 552831423455895822
        ChildIds: 4735105264975760198
        ChildIds: 14755300117222277179
        ChildIds: 6846619435588619015
        ChildIds: 11134597440092639695
        ChildIds: 9963899895398258474
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        Folder {
          IsFilePartition: true
        }
      }
      Objects {
        Id: 908117060022133475
        Name: "CustomGameStateApi"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 8993584527061449296
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        Script {
          ScriptAsset {
            Id: 16810247064803141527
          }
        }
      }
      Objects {
        Id: 552831423455895822
        Name: "GameStateManager"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 8993584527061449296
        ChildIds: 14546697241204752388
        ChildIds: 4354609451184551541
        UnregisteredParameters {
          Overrides {
            Name: "cs:LobbyHasDuration"
            Bool: true
          }
          Overrides {
            Name: "cs:LobbyDuration"
            Float: 60
          }
          Overrides {
            Name: "cs:RoundHasDuration"
            Bool: true
          }
          Overrides {
            Name: "cs:RoundDuration"
            Float: 30
          }
          Overrides {
            Name: "cs:RoundEndHasDuration"
            Bool: true
          }
          Overrides {
            Name: "cs:RoundEndDuration"
            Float: 5
          }
          Overrides {
            Name: "cs:GameEndHasDuration"
            Bool: false
          }
          Overrides {
            Name: "cs:GameEndDuration"
            Float: 5
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        Folder {
          IsFilePartition: true
        }
      }
      Objects {
        Id: 14546697241204752388
        Name: "GameStateManagerServer"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 552831423455895822
        UnregisteredParameters {
          Overrides {
            Name: "cs:CustomApi"
            AssetReference {
              Id: 16810247064803141527
            }
          }
          Overrides {
            Name: "cs:ComponentRoot"
            ObjectReference {
              SubObjectId: 552831423455895822
            }
          }
          Overrides {
            Name: "cs:State"
            Int: 0
          }
          Overrides {
            Name: "cs:StateHasDuration"
            Bool: false
          }
          Overrides {
            Name: "cs:StateEndTime"
            Float: 0
          }
          Overrides {
            Name: "cs:State:isrep"
            Bool: true
          }
          Overrides {
            Name: "cs:StateHasDuration:isrep"
            Bool: true
          }
          Overrides {
            Name: "cs:StateEndTime:isrep"
            Bool: true
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        Script {
          ScriptAsset {
            Id: 13874413543894935855
          }
        }
      }
      Objects {
        Id: 4354609451184551541
        Name: "ClientContext"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 552831423455895822
        ChildIds: 15734037887421071995
        Collidable_v2 {
          Value: "mc:ecollisionsetting:forceoff"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        NetworkContext {
        }
      }
      Objects {
        Id: 15734037887421071995
        Name: "GameStateManagerClient"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 4354609451184551541
        UnregisteredParameters {
          Overrides {
            Name: "cs:CustomApi"
            AssetReference {
              Id: 16810247064803141527
            }
          }
          Overrides {
            Name: "cs:GameStateManagerServer"
            ObjectReference {
              SubObjectId: 14546697241204752388
            }
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        Script {
          ScriptAsset {
            Id: 10968385785327175662
          }
        }
      }
      Objects {
        Id: 4735105264975760198
        Name: "GameStateMessage"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 8993584527061449296
        ChildIds: 5740603064091500255
        UnregisteredParameters {
          Overrides {
            Name: "cs:ShowLobbyMessage"
            Bool: true
          }
          Overrides {
            Name: "cs:LobbyMessage"
            String: "Lobby"
          }
          Overrides {
            Name: "cs:ShowRoundMessage"
            Bool: true
          }
          Overrides {
            Name: "cs:RoundMessage"
            String: "Eliminate the opponent"
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        Folder {
          IsFilePartition: true
        }
      }
      Objects {
        Id: 5740603064091500255
        Name: "GameMessageServer"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 4735105264975760198
        UnregisteredParameters {
          Overrides {
            Name: "cs:CustomApi"
            AssetReference {
              Id: 16810247064803141527
            }
          }
          Overrides {
            Name: "cs:ComponentRoot"
            ObjectReference {
              SubObjectId: 4735105264975760198
            }
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        Script {
          ScriptAsset {
            Id: 14262580277414766150
          }
        }
      }
      Objects {
        Id: 14755300117222277179
        Name: "LobbyStartRespawnPlayers"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 8993584527061449296
        ChildIds: 2896189778716659637
        UnregisteredParameters {
          Overrides {
            Name: "cs:Period"
            Float: 0.5
          }
          Overrides {
            Name: "cs:RespawnOnRoundStart"
            Bool: true
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        Folder {
          IsFilePartition: true
        }
      }
      Objects {
        Id: 2896189778716659637
        Name: "RespawnPlayersServer"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 14755300117222277179
        UnregisteredParameters {
          Overrides {
            Name: "cs:CustomApi"
            AssetReference {
              Id: 16810247064803141527
            }
          }
          Overrides {
            Name: "cs:ComponentRoot"
            ObjectReference {
              SubObjectId: 14755300117222277179
            }
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        Script {
          ScriptAsset {
            Id: 8198940882131116491
          }
        }
      }
      Objects {
        Id: 6846619435588619015
        Name: "LobbyRequiredPlayers"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 8993584527061449296
        ChildIds: 3163616384048317475
        UnregisteredParameters {
          Overrides {
            Name: "cs:RequiredPlayers"
            Int: 2
          }
          Overrides {
            Name: "cs:CountdownTime"
            Float: 5
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        Folder {
          IsFilePartition: true
        }
      }
      Objects {
        Id: 3163616384048317475
        Name: "RequiredPlayersServer"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 6846619435588619015
        UnregisteredParameters {
          Overrides {
            Name: "cs:CustomApi"
            AssetReference {
              Id: 16810247064803141527
            }
          }
          Overrides {
            Name: "cs:ComponentRoot"
            ObjectReference {
              SubObjectId: 6846619435588619015
            }
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        Script {
          ScriptAsset {
            Id: 17760124207851104170
          }
        }
      }
      Objects {
        Id: 11134597440092639695
        Name: "LobbyReset"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 8993584527061449296
        ChildIds: 12391154424774378017
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        Folder {
          IsFilePartition: true
        }
      }
      Objects {
        Id: 12391154424774378017
        Name: "LobbyResetServer"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 11134597440092639695
        UnregisteredParameters {
          Overrides {
            Name: "cs:CustomApi"
            AssetReference {
              Id: 16810247064803141527
            }
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        Script {
          ScriptAsset {
            Id: 497151181606139854
          }
        }
      }
      Objects {
        Id: 9963899895398258474
        Name: "RoundKillLimit"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 8993584527061449296
        ChildIds: 9941727267055469674
        UnregisteredParameters {
          Overrides {
            Name: "cs:KillLimit"
            Int: 1
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        Folder {
          IsFilePartition: true
        }
      }
      Objects {
        Id: 9941727267055469674
        Name: "KillLimitServer"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 9963899895398258474
        UnregisteredParameters {
          Overrides {
            Name: "cs:CustomApi"
            AssetReference {
              Id: 16810247064803141527
            }
          }
          Overrides {
            Name: "cs:ComponentRoot"
            ObjectReference {
              SubObjectId: 9963899895398258474
            }
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        Script {
          ScriptAsset {
            Id: 4844470940752866059
          }
        }
      }
    }
    PrimaryAssetId {
      AssetType: "None"
      AssetId: "None"
    }
  }
  SerializationVersion: 89
}
