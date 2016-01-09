unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, types, math;

type
  TForm1 = class(TForm)
    plotImage: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure plotImageClick(Sender: TObject);
  private
    { Private declarations }
  public
    casteljau_points: array [0 .. 2] of TPoint;
    casteljau_array_index: byte; // set on canvas click!
    /// <remarks>
    /// Casteljau algorithm
    /// </remarks>
    function Casteljau(t: single): TPoint;
    procedure drawGrid;
    procedure plot;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
{ TForm1 }

function TForm1.Casteljau(t: single): TPoint;
begin
  result.X := round(math.Power(1 - t, 2) * self.casteljau_points[0].X + (2 * t) * (1 - t) * self.casteljau_points[1].X +
    math.Power(t, 2) * self.casteljau_points[2].X);

  result.Y := round(math.Power(1 - t, 2) * self.casteljau_points[0].Y + (2 * t) * (1 - t) * self.casteljau_points[1].Y +
    math.Power(t, 2) * self.casteljau_points[2].Y);

end;

procedure TForm1.drawGrid;
begin
  plotImage.Picture.Bitmap.Width := plotImage.Width;
  plotImage.Picture.Bitmap.Height := plotImage.Height;
  plotImage.Canvas.Brush.Color := clSkyBlue;
  plotImage.Canvas.Rectangle(0, 0, plotImage.Width, plotImage.Height);

  // put coordinates on our grid
  plotImage.Canvas.TextOut(plotImage.Width div 2 - 15, 2, 'Y');
  plotImage.Canvas.TextOut(plotImage.Width div 2 + 15, plotImage.Height - 15, '-Y');
  plotImage.Canvas.TextOut(15, plotImage.Height div 2 + 15, '-X');
  plotImage.Canvas.TextOut(plotImage.Width - 15, plotImage.Height div 2 - 15, 'X');

  // draw graph lines
  plotImage.Canvas.MoveTo(plotImage.Width div 2, 0);
  plotImage.Canvas.LineTo(plotImage.Width div 2, plotImage.Height);
  // x
  plotImage.Canvas.MoveTo(0, plotImage.Height div 2);
  plotImage.Canvas.LineTo(plotImage.Width, plotImage.Height div 2);

  // add help text.
  plotImage.Canvas.TextOut(5, 5, 'Click 3 mal irgendwo hin!');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  self.drawGrid;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  self.drawGrid;
end;

procedure TForm1.plot;
var
  i: Integer;
  p: TPoint;
begin
  self.plotImage.Canvas.Pen.Color := clRed;

  for i := 0 to plotImage.Width - 1 do
  begin
    p := self.Casteljau(i / plotImage.Width);

    self.plotImage.Canvas.Rectangle(p.X, p.Y, p.X + 2, p.Y + 2);
  end;

  self.plotImage.Canvas.Pen.Color := clNone;
end;

procedure TForm1.plotImageClick(Sender: TObject);
var
  p: TPoint;
begin
  GetCursorPos(p);
  p := ScreenToClient(p);
  if (self.casteljau_array_index > 2) then
  begin
    self.casteljau_array_index := 0;
    self.drawGrid;
  end;

  self.casteljau_points[self.casteljau_array_index] := p;

  self.plotImage.Canvas.Pen.Color := clMaroon;
  self.plotImage.Canvas.Pen.Width := 4;
  self.plotImage.Canvas.Rectangle(p.X, p.Y, p.X + 5, p.Y + 5);
  self.plotImage.Canvas.Pen.Width := 1;
  self.plotImage.Canvas.Pen.Color := clNone;
  // add text information about clicked coordinate.
  self.plotImage.Canvas.TextOut(self.plotImage.Width - 100, self.plotImage.Height + (self.casteljau_array_index * 20) -
    70, inttostr(self.casteljau_array_index) + ') X: ' + inttostr(self.casteljau_points[self.casteljau_array_index].X) +
    ', Y: ' + inttostr(self.casteljau_points[self.casteljau_array_index].Y));

  if (self.casteljau_array_index = 2) then
    self.plot;

  inc(self.casteljau_array_index);

end;

end.
