object Form18: TForm18
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Mikser'
  ClientHeight = 334
  ClientWidth = 870
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnShow = FormShow
  TextHeight = 15
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 858
    Height = 289
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 82
      Top = 8
      Width = 759
      Height = 265
      Caption = 'Mikser kana'#322#243'w MIDI'
      TabOrder = 0
      object Edit2: TEdit
        Left = 59
        Top = 30
        Width = 24
        Height = 20
        Alignment = taCenter
        AutoSize = False
        TabOrder = 0
        Text = '0'
        OnChange = Edit2Change
      end
      object Edit3: TEdit
        Left = 105
        Top = 30
        Width = 24
        Height = 20
        Alignment = taCenter
        AutoSize = False
        TabOrder = 1
        Text = '0'
        OnChange = Edit3Change
      end
      object Edit4: TEdit
        Left = 151
        Top = 30
        Width = 24
        Height = 20
        Alignment = taCenter
        AutoSize = False
        TabOrder = 2
        Text = '0'
        OnChange = Edit4Change
      end
      object Edit5: TEdit
        Left = 197
        Top = 30
        Width = 24
        Height = 20
        Alignment = taCenter
        AutoSize = False
        TabOrder = 3
        Text = '0'
        OnChange = Edit5Change
      end
      object Edit6: TEdit
        Left = 243
        Top = 30
        Width = 24
        Height = 20
        Alignment = taCenter
        AutoSize = False
        TabOrder = 4
        Text = '0'
        OnChange = Edit6Change
      end
      object Edit7: TEdit
        Left = 289
        Top = 30
        Width = 24
        Height = 20
        Alignment = taCenter
        AutoSize = False
        TabOrder = 5
        Text = '0'
        OnChange = Edit7Change
      end
      object Edit8: TEdit
        Left = 335
        Top = 30
        Width = 24
        Height = 20
        Alignment = taCenter
        AutoSize = False
        TabOrder = 6
        Text = '0'
        OnChange = Edit8Change
      end
      object Edit9: TEdit
        Left = 381
        Top = 30
        Width = 24
        Height = 20
        Alignment = taCenter
        AutoSize = False
        TabOrder = 7
        Text = '0'
        OnChange = Edit9Change
      end
      object Edit10: TEdit
        Left = 427
        Top = 30
        Width = 24
        Height = 20
        Alignment = taCenter
        AutoSize = False
        TabOrder = 8
        Text = '0'
        OnChange = Edit10Change
      end
      object Edit11: TEdit
        Left = 473
        Top = 30
        Width = 24
        Height = 20
        Alignment = taCenter
        AutoSize = False
        TabOrder = 9
        Text = '0'
        OnChange = Edit11Change
      end
      object Edit12: TEdit
        Left = 519
        Top = 30
        Width = 24
        Height = 20
        Alignment = taCenter
        AutoSize = False
        TabOrder = 10
        Text = '0'
        OnChange = Edit12Change
      end
      object Edit13: TEdit
        Left = 565
        Top = 30
        Width = 24
        Height = 20
        Alignment = taCenter
        AutoSize = False
        TabOrder = 11
        Text = '0'
        OnChange = Edit13Change
      end
      object Edit14: TEdit
        Left = 611
        Top = 30
        Width = 24
        Height = 20
        Alignment = taCenter
        AutoSize = False
        TabOrder = 12
        Text = '0'
        OnChange = Edit14Change
      end
      object Edit15: TEdit
        Left = 657
        Top = 30
        Width = 24
        Height = 20
        Alignment = taCenter
        AutoSize = False
        TabOrder = 13
        Text = '0'
        OnChange = Edit15Change
      end
      object Edit16: TEdit
        Left = 703
        Top = 30
        Width = 24
        Height = 20
        Alignment = taCenter
        AutoSize = False
        TabOrder = 14
        Text = '0'
        OnChange = Edit16Change
      end
      object Edit1: TEdit
        Left = 13
        Top = 32
        Width = 24
        Height = 20
        Alignment = taCenter
        AutoSize = False
        TabOrder = 15
        Text = '0'
        OnChange = Edit1Change
      end
      object ProgressBar1: TProgressBar
        Left = 13
        Top = 56
        Width = 40
        Height = 177
        Max = 127
        Orientation = pbVertical
        TabOrder = 16
      end
      object UpDown1: TUpDown
        Left = 37
        Top = 32
        Width = 16
        Height = 20
        Associate = Edit1
        Max = 127
        TabOrder = 17
      end
      object CheckBox1: TCheckBox
        Left = 19
        Top = 239
        Width = 32
        Height = 17
        Caption = '1'
        Checked = True
        State = cbChecked
        TabOrder = 18
      end
      object CheckBox2: TCheckBox
        Left = 65
        Top = 239
        Width = 32
        Height = 17
        Caption = '2'
        Checked = True
        State = cbChecked
        TabOrder = 19
      end
      object CheckBox3: TCheckBox
        Left = 111
        Top = 239
        Width = 32
        Height = 17
        Caption = '3'
        Checked = True
        State = cbChecked
        TabOrder = 20
      end
      object CheckBox4: TCheckBox
        Left = 157
        Top = 239
        Width = 32
        Height = 17
        Caption = '4'
        Checked = True
        State = cbChecked
        TabOrder = 21
      end
      object CheckBox5: TCheckBox
        Left = 203
        Top = 239
        Width = 32
        Height = 17
        Caption = '5'
        Checked = True
        State = cbChecked
        TabOrder = 22
      end
      object CheckBox6: TCheckBox
        Left = 249
        Top = 239
        Width = 32
        Height = 17
        Caption = '6'
        Checked = True
        State = cbChecked
        TabOrder = 23
      end
      object CheckBox7: TCheckBox
        Left = 295
        Top = 239
        Width = 32
        Height = 17
        Caption = '7'
        Checked = True
        State = cbChecked
        TabOrder = 24
      end
      object CheckBox8: TCheckBox
        Left = 341
        Top = 239
        Width = 32
        Height = 17
        Caption = '8'
        Checked = True
        State = cbChecked
        TabOrder = 25
      end
      object CheckBox9: TCheckBox
        Left = 387
        Top = 239
        Width = 32
        Height = 17
        Caption = '9'
        Checked = True
        State = cbChecked
        TabOrder = 26
      end
      object CheckBox10: TCheckBox
        Left = 433
        Top = 239
        Width = 32
        Height = 17
        Caption = '10'
        Checked = True
        State = cbChecked
        TabOrder = 27
      end
      object CheckBox11: TCheckBox
        Left = 479
        Top = 239
        Width = 32
        Height = 17
        Caption = '11'
        Checked = True
        State = cbChecked
        TabOrder = 28
      end
      object CheckBox12: TCheckBox
        Left = 525
        Top = 239
        Width = 32
        Height = 17
        Caption = '12'
        Checked = True
        State = cbChecked
        TabOrder = 29
      end
      object CheckBox13: TCheckBox
        Left = 571
        Top = 239
        Width = 32
        Height = 17
        Caption = '13'
        Checked = True
        State = cbChecked
        TabOrder = 30
      end
      object CheckBox14: TCheckBox
        Left = 617
        Top = 239
        Width = 32
        Height = 17
        Caption = '14'
        Checked = True
        State = cbChecked
        TabOrder = 31
      end
      object CheckBox15: TCheckBox
        Left = 663
        Top = 239
        Width = 32
        Height = 17
        Caption = '15'
        Checked = True
        State = cbChecked
        TabOrder = 32
      end
      object CheckBox16: TCheckBox
        Left = 709
        Top = 239
        Width = 32
        Height = 17
        Caption = '16'
        Checked = True
        State = cbChecked
        TabOrder = 33
      end
      object ProgressBar2: TProgressBar
        Left = 59
        Top = 56
        Width = 40
        Height = 177
        Max = 127
        Orientation = pbVertical
        TabOrder = 34
      end
      object ProgressBar3: TProgressBar
        Left = 105
        Top = 56
        Width = 40
        Height = 177
        Max = 127
        Orientation = pbVertical
        TabOrder = 35
      end
      object ProgressBar4: TProgressBar
        Left = 151
        Top = 56
        Width = 40
        Height = 177
        Max = 127
        Orientation = pbVertical
        TabOrder = 36
      end
      object ProgressBar5: TProgressBar
        Left = 197
        Top = 56
        Width = 40
        Height = 177
        Max = 127
        Orientation = pbVertical
        TabOrder = 37
      end
      object ProgressBar6: TProgressBar
        Left = 243
        Top = 56
        Width = 40
        Height = 177
        Max = 127
        Orientation = pbVertical
        TabOrder = 38
      end
      object ProgressBar7: TProgressBar
        Left = 289
        Top = 56
        Width = 40
        Height = 177
        Max = 127
        Orientation = pbVertical
        TabOrder = 39
      end
      object ProgressBar8: TProgressBar
        Left = 335
        Top = 56
        Width = 40
        Height = 177
        Max = 127
        Orientation = pbVertical
        TabOrder = 40
      end
      object ProgressBar9: TProgressBar
        Left = 381
        Top = 56
        Width = 40
        Height = 177
        Max = 127
        Orientation = pbVertical
        TabOrder = 41
      end
      object ProgressBar10: TProgressBar
        Left = 427
        Top = 56
        Width = 40
        Height = 177
        Max = 127
        Orientation = pbVertical
        TabOrder = 42
      end
      object ProgressBar11: TProgressBar
        Left = 473
        Top = 56
        Width = 40
        Height = 177
        Max = 127
        Orientation = pbVertical
        TabOrder = 43
      end
      object ProgressBar12: TProgressBar
        Left = 519
        Top = 56
        Width = 40
        Height = 177
        Max = 127
        Orientation = pbVertical
        TabOrder = 44
      end
      object ProgressBar13: TProgressBar
        Left = 565
        Top = 56
        Width = 40
        Height = 177
        Max = 127
        Orientation = pbVertical
        TabOrder = 45
      end
      object ProgressBar14: TProgressBar
        Left = 611
        Top = 56
        Width = 40
        Height = 177
        Max = 127
        Orientation = pbVertical
        TabOrder = 46
      end
      object ProgressBar15: TProgressBar
        Left = 657
        Top = 56
        Width = 40
        Height = 177
        Max = 127
        Orientation = pbVertical
        TabOrder = 47
      end
      object ProgressBar16: TProgressBar
        Left = 703
        Top = 56
        Width = 40
        Height = 177
        Max = 127
        Orientation = pbVertical
        TabOrder = 48
      end
      object UpDown2: TUpDown
        Left = 83
        Top = 30
        Width = 16
        Height = 20
        Associate = Edit2
        Max = 127
        TabOrder = 49
      end
      object UpDown3: TUpDown
        Left = 129
        Top = 30
        Width = 16
        Height = 20
        Associate = Edit3
        Max = 127
        TabOrder = 50
      end
      object UpDown4: TUpDown
        Left = 175
        Top = 30
        Width = 16
        Height = 20
        Associate = Edit4
        Max = 127
        TabOrder = 51
      end
      object UpDown5: TUpDown
        Left = 221
        Top = 30
        Width = 16
        Height = 20
        Associate = Edit5
        Max = 127
        TabOrder = 52
      end
      object UpDown6: TUpDown
        Left = 267
        Top = 30
        Width = 16
        Height = 20
        Associate = Edit6
        Max = 127
        TabOrder = 53
      end
      object UpDown7: TUpDown
        Left = 313
        Top = 30
        Width = 16
        Height = 20
        Associate = Edit7
        Max = 127
        TabOrder = 54
      end
      object UpDown8: TUpDown
        Left = 359
        Top = 30
        Width = 16
        Height = 20
        Associate = Edit8
        Max = 127
        TabOrder = 55
      end
      object UpDown9: TUpDown
        Left = 405
        Top = 30
        Width = 16
        Height = 20
        Associate = Edit9
        Max = 127
        TabOrder = 56
      end
      object UpDown10: TUpDown
        Left = 451
        Top = 30
        Width = 16
        Height = 20
        Associate = Edit10
        Max = 127
        TabOrder = 57
      end
      object UpDown11: TUpDown
        Left = 497
        Top = 30
        Width = 16
        Height = 20
        Associate = Edit11
        Max = 127
        TabOrder = 58
      end
      object UpDown12: TUpDown
        Left = 543
        Top = 30
        Width = 16
        Height = 20
        Associate = Edit12
        Max = 127
        TabOrder = 59
      end
      object UpDown13: TUpDown
        Left = 589
        Top = 30
        Width = 16
        Height = 20
        Associate = Edit13
        Max = 127
        TabOrder = 60
      end
      object UpDown14: TUpDown
        Left = 635
        Top = 30
        Width = 16
        Height = 20
        Associate = Edit14
        Max = 127
        TabOrder = 61
      end
      object UpDown15: TUpDown
        Left = 681
        Top = 30
        Width = 16
        Height = 20
        Associate = Edit15
        Max = 127
        TabOrder = 62
      end
      object UpDown16: TUpDown
        Left = 727
        Top = 30
        Width = 16
        Height = 20
        Associate = Edit16
        Max = 127
        TabOrder = 63
      end
    end
    object GroupBox2: TGroupBox
      Left = 15
      Top = 8
      Width = 61
      Height = 265
      Caption = 'Master'
      TabOrder = 1
      object UpDown17: TUpDown
        Left = 10
        Top = 32
        Width = 39
        Height = 201
        Min = -30000
        Max = 30000
        TabOrder = 0
        OnClick = UpDown17Click
      end
    end
  end
  object Button2: TButton
    Left = 787
    Top = 303
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = Button2Click
  end
end
