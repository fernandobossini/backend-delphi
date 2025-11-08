object BackendDelphiConnection: TBackendDelphiConnection
  Height = 370
  Width = 305
  object Connection: TFDConnection
    Params.Strings = (
      'Pooled=False'
      'ConnectionDef=Shopping_Pooled')
    ConnectedStoredUsage = []
    LoginPrompt = False
    Left = 120
    Top = 80
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorLib = 'D:\clones\curso-backend-delphi\projeto\product-api\libpq.dll'
    Left = 120
    Top = 152
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Console'
    Left = 120
    Top = 232
  end
end
