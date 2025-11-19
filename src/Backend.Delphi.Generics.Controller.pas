unit Backend.Delphi.Generics.Controller;

interface

uses Horse;

type
  IGenericController<T: class, constructor> = interface
    ['{9974AE6E-64C6-400E-ABC8-6D70EA743796}']
    procedure Registry(const AResource: String);
  end;

  TGenericController<T: class, constructor> = class(TInterfacedObject, IGenericController<T>)
  private const
    NOT_FOUND = 'Registro não cadastrado';
  private
    procedure DoListAll(Req: THorseRequest; Res: THorseResponse);
    procedure DoGetById(Req: THorseRequest; Res: THorseResponse);
    procedure DoAppend(Req: THorseRequest; Res: THorseResponse);
    procedure DoUpdate(Req: THorseRequest; Res: THorseResponse);
    procedure DoDelete(Req: THorseRequest; Res: THorseResponse);
    procedure Registry(const AResource: String);
  public
    class function New: IGenericController<T>;
  end;

implementation

uses Backend.Delphi.Cadastro, System.JSON, DataSet.Serialize, System.SysUtils, Data.DB;

procedure TGenericController<T>.DoAppend(Req: THorseRequest;
  Res: THorseResponse);
begin
  var LService := TBackendDelphiCadastro(T.Create);
  try
    if LService.Append(Req.Body<TJSONObject>) then
      Res.Status(THTTPStatus.Created).Send<TJSONObject>(LService.qryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;

end;

procedure TGenericController<T>.DoDelete(Req: THorseRequest;
  Res: THorseResponse);
begin
  var LService := TBackendDelphiCadastro(T.Create);
  try
    if LService.GetById(Req.Params['id'].ToInt64).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error(NOT_FOUND);
    if LService.Delete then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure TGenericController<T>.DoGetById(Req: THorseRequest;
  Res: THorseResponse);
begin
  var LService := TBackendDelphiCadastro(T.Create);
  try
    if LService.GetById(Req.Params['id'].ToInt64).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error(NOT_FOUND);
    Res.Send<TJSONObject>(LService.qryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;
end;

procedure TGenericController<T>.DoListAll(Req: THorseRequest;
  Res: THorseResponse);
begin
  var LService := TBackendDelphiCadastro(T.Create);
  try
    var LJSONObject := TJSONObject.Create;
    LJSONObject.AddPair('data', LService.ListAll(Req.Query.Dictionary).ToJSONArray());
    LJSONObject.AddPair('records', LService.GetRecordCount);
    Res.Send<TJSONObject>(LJSONObject);
  finally
    LService.Free;
  end;
end;

procedure TGenericController<T>.DoUpdate(Req: THorseRequest;
  Res: THorseResponse);
begin
  var LService := TBackendDelphiCadastro(T.Create);
  try
    if LService.GetById(Req.Params['id'].ToInt64).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error(NOT_FOUND);
    if LService.Update(Req.Body<TJSONObject>) then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;

end;

class function TGenericController<T>.New: IGenericController<T>;
begin
  Result := TGenericController<T>.Create;
end;

procedure TGenericController<T>.Registry(const AResource: String);
begin
  var LResourceId := AResource + '/:id';

  THorse.Get(AResource, DoListAll);
  THorse.Get(LResourceId, DoGetById);
  THorse.Post(AResource, DoAppend);
  THorse.Put(LResourceId, DoUpdate);
  THorse.Delete(LResourceId, DoDelete);
end;

end.
