unit PlayerWorkflow;
interface
  uses Models, FuncModel, StdCtrls, ClubWorkflow, RegExpr, UnitLog;
  
  procedure plShowInBox(start: PModel; lb: TListBox);
  function plSearch(start: PModel; term: string): PModel;
  procedure plAdd(club: Club; name: string);
  procedure plDelete(var start: PModel; index: integer);
    
implementation

    type
    ShowDisp = class(FoldDispatcher)
      procedure dispatch(pins: PModel; var acc: FoldAcc); override;
    end;
    SearchDisp = class(SearchDispatcher)
      function dispatch(pins: PModel): string; override;
    end;


  { plSearch }
  function SearchDisp.dispatch(pins: PModel): string; begin
    result := (pins^ as Player).name;
  end;
  function plSearch(start: PModel; term: string): PModel; begin
    result := search(start, term, SearchDisp.Create);
  end;
   
  { plShowListInBox }
  procedure ShowDisp.dispatch(pins: PModel; var acc: FoldAcc); begin
    (acc.tobject[0] as TListBox).Items.Append(
      (pins^ as Player).str()
    );
    
  end;
  procedure plShowInBox(start: PModel; lb: TListBox); var
    acc: FoldAcc;
  begin
    lb.Clear();
    acc.tobject[0] := lb;
    foldl(start, showDisp.Create, acc);
  end;

  { plAdd }
  procedure plAdd(club: Club; name: string); var
    pl: Player;
    p: PModel;
  begin
    pl := Player.new(name, Club);
    if (empty(club.players)) then begin
      new(p);
      p^ := pl;
      club.players := p;
    end else 
      add(last(club.players), pl);
  end;


  { plDelete }
  procedure plDelete(var start: PModel; index: integer); begin
    delete(start, index);
  end;
end.