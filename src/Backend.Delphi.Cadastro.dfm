inherited BackendDelphiCadastro: TBackendDelphiCadastro
  Width = 403
  object qryPesquisa: TFDQuery
    Connection = Connection
    Left = 232
    Top = 88
  end
  object qryRecordCount: TFDQuery
    Connection = Connection
    Left = 232
    Top = 152
    object qryRecordCountCOUNT: TLargeintField
      FieldName = 'COUNT'
    end
  end
  object qryCadastro: TFDQuery
    Connection = Connection
    Left = 232
    Top = 232
  end
end
